Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309AbaF3Phr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 11:37:47 -0400
Received: from 8bytes.org ([85.214.48.195]:34619 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbaF3Phe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 11:37:34 -0400
Date: Mon, 30 Jun 2014 17:37:26 +0200
From: Joerg Roedel <joro@8bytes.org>
To: =?iso-8859-1?B?Suly9G1l?= Glisse <j.glisse@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mgorman@suse.de, hpa@zytor.com,
        peterz@infraread.org, aarcange@redhat.com, riel@redhat.com,
        jweiner@redhat.com, torvalds@linux-foundation.org,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Jatin Kumar <jakumar@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>, Sherry Cheung <SCheung@nvidia.com>,
        Duncan Poole <dpoole@nvidia.com>, Oded Gabbay <Oded.Gabbay@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 1/6] mmput: use notifier chain to call subsystem exit
 handler.
Message-ID: <20140630153726.GC26537@8bytes.org>
References: <1403920822-14488-1-git-send-email-j.glisse@gmail.com>
 <1403920822-14488-2-git-send-email-j.glisse@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403920822-14488-2-git-send-email-j.glisse@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Jun 30 17:37:32 2014
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 53b1843c20868981876322
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 10:00:19PM -0400, Jérôme Glisse wrote:
> Note that this patch also move the call to cleanup functions after
> exit_mmap so that new call back can assume that mmu_notifier_release
> have already been call. This does not impact existing cleanup functions
> as they do not rely on anything that exit_mmap is freeing. Also moved
> khugepaged_exit to exit_mmap so that ordering is preserved for that
> function.

What this patch does is duplicating the functionality of the
mmu_notifier_release call-back. Why is it needed?


	Joerg


