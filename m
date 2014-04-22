Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932141AbaDVKzv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 06:55:51 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:37830 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403AbaDVKzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 06:55:47 -0400
Message-ID: <53564AA9.3060905@de.ibm.com>
Date: Tue, 22 Apr 2014 12:55:37 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Suleiman Souhlal <suleiman@google.com>, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
        KVM list <kvm@vger.kernel.org>
Subject: commit 0bf1457f0cfca7b  " mm: vmscan: do not swap anon pages just
 because free+file is low" causes heavy performance regression on paging
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042210-4966-0000-0000-000009248979
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While preparing/testing some KVM on s390 patches for the next merge window (target is kvm/next which is based on 3.15-rc1) I faced a very severe performance hickup on guest paging (all anonymous memory).

All memory bound guests are in "D" state now and the system is barely unusable.

Reverting commit 0bf1457f0cfca7bc026a82323ad34bcf58ad035d
"mm: vmscan: do not swap anon pages just because free+file is low" makes the problem go away.

According to /proc/vmstat the system is now in direct reclaim almost all the time for every page fault (more than 10x more direct reclaims than kswap reclaims)
With the patch being reverted everything is fine again.

Any ideas?

Christian

