Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753677AbaF1CAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 22:00:48 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:63918 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaF1CAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 22:00:47 -0400
From: =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <j.glisse@gmail.com>
To: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: mgorman@suse.de, hpa@zytor.com, peterz@infraread.org, aarcange@redhat.com,
        riel@redhat.com, jweiner@redhat.com, torvalds@linux-foundation.org,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Jatin Kumar <jakumar@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Duncan Poole <dpoole@nvidia.com>, Oded Gabbay <Oded.Gabbay@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>
Subject: mm preparatory patches for HMM and IOMMUv2
Date: Fri, 27 Jun 2014 22:00:18 -0400
Message-Id: <1403920822-14488-1-git-send-email-j.glisse@gmail.com>
X-Mailer: git-send-email 1.9.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew so here are a set of mm patch that do some ground modification to core
mm code. They apply on top of today's linux-next and they pass checkpatch.pl
with flying color (except patch 4 but i did not wanted to be a nazi about 80
char line).

Patch 1 is the mmput notifier call chain we discussed with AMD.

Patch 2, 3 and 4 are so far only useful to HMM but i am discussing with AMD and
i believe it will be useful to them to (in the context of IOMMUv2).

Patch 2 allows to differentiate page unmap for vmscan reason or for poisoning.

Patch 3 associate mmu_notifier with an event type allowing to take different code
path inside mmu_notifier callback depending on what is currently happening to the
cpu page table. There is no functional change, it just add a new argument to the
various mmu_notifier calls and callback.

Patch 4 pass along the vma into which the range invalidation is happening. There
is few functional changes in place where mmu_notifier_range_invalidate_start/end
used [0, -1] as range, instead now those place call the notifier once for each
vma. This might prove to add unwanted overhead hence why i did it as a separate
patch.

I did not include the core hmm patch but i intend to send a v4 next week. So i
really would like to see those included for next release.

As usual comments welcome.

Cheers,
Jérôme Glisse

