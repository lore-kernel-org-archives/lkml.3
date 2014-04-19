Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbaDSIfB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 04:35:01 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49035 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaDSIe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 04:34:57 -0400
Date: Sat, 19 Apr 2014 10:34:55 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Peter Chiang <pchiang@nvidia.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "ccross@android.com" <ccross@android.com>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "ebiederm@xmission.com" <ebiederm@xmission.com>,
        "guillaume@morinfr.org" <guillaume@morinfr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] memcg: mm_update_next_owner() should skip kthreads
Message-ID: <20140419083455.GA17601@amd.pavel.ucw.cz>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com>
 <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com>
 <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com>
 <20140416135741.GA9407@redhat.com>
 <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com>
 <20140418162359.GA4398@redhat.com>
 <20140418172631.GA13323@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140418172631.GA13323@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Hmm. I seem to see a bug in this function, it can be fulled by use_mm,
> > but I am not sure this can explain the problem. I'll send a patch.
> 
> Untested, please review. But it really looks "obviously wrong", and note
> that unuse_mm() doesn't do mm_update_next_owner(). (just in case, do not
> confuse it with unuse_mm() in mm/swapfile.c).

Having two functions, one exported, one static with same name -- that
sounds quite evil, right?

mmu_context.c: * unuse_mm
mmu_context.c:void unuse_mm(struct mm_struct *mm)
mmu_context.c:EXPORT_SYMBOL_GPL(unuse_mm);
swapfile.c:static int unuse_mm(struct mm_struct *mm,
swapfile.c:	      		      retval = unuse_mm(start_mm,
entry, page);
swapfile.c:					retval = unuse_mm(mm,
entry, page);
swapfile.c:		 * or while we dropped it in unuse_mm().  The
page might even

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
