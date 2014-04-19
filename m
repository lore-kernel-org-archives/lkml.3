Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161085AbaDSSOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 14:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051AbaDSSOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 14:14:30 -0400
Date: Sat, 19 Apr 2014 20:14:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
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
Message-ID: <20140419181407.GB982@redhat.com>
References: <1397617379-26895-1-git-send-email-pchiang@nvidia.com> <80341664FB79C2419999599F48F738410227327881@HKMAIL01.nvidia.com> <80341664FB79C2419999599F48F738410227327888@HKMAIL01.nvidia.com> <20140416135741.GA9407@redhat.com> <80341664FB79C2419999599F48F7384102273279C3@HKMAIL01.nvidia.com> <20140418162359.GA4398@redhat.com> <20140418172631.GA13323@redhat.com> <20140419083455.GA17601@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140419083455.GA17601@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/19, Pavel Machek wrote:
>
> > > Hmm. I seem to see a bug in this function, it can be fulled by use_mm,
> > > but I am not sure this can explain the problem. I'll send a patch.
> >
> > Untested, please review. But it really looks "obviously wrong", and note
> > that unuse_mm() doesn't do mm_update_next_owner(). (just in case, do not
> > confuse it with unuse_mm() in mm/swapfile.c).
>
> Having two functions, one exported, one static with same name -- that
> sounds quite evil, right?

Yes, agreed.

> mmu_context.c: * unuse_mm
> mmu_context.c:void unuse_mm(struct mm_struct *mm)
> mmu_context.c:EXPORT_SYMBOL_GPL(unuse_mm);
> swapfile.c:static int unuse_mm(struct mm_struct *mm,

Yes, I was thinking about s/unuse_mm/unswap_mm/ change in swapfile.c,
but then we should probaly rename other "unuse" functions there, and
shmem_unuse/try_to_unuse are not static.

Oleg.

