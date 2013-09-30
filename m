Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3I3TFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:05:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755665Ab3I3TFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:05:42 -0400
Date: Mon, 30 Sep 2013 15:04:59 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>
Subject: Re: [PATCH] anon_vmas: Convert the rwsem to an rwlock_t
Message-ID: <20130930190459.GA7047@redhat.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <20130928193739.GA8642@gmail.com>
 <20130930085243.GA25685@redhat.com>
 <20130930182112.GA6931@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130930182112.GA6931@two.firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 08:21:12PM +0200, Andi Kleen wrote:
> > Nvidia is now also going to use mmu notifier to allow the GPU (acting
> > as a secondary MMU with pagetables) to access main memory without
> 
> That's a good point. iirc AMD GPUs are also going into 
> the same direction, and likely more. So we probably need
> to support that usage.
> 
> Too bad :-/
> 
> -Andi

In all fairness, current AMD solution is hardware only, you can see the
code in drivers/iommu/amd_iommu_v2.c but they might be interested in
the software solution for added features like abilities to move process
memory to video memory and migrating it back when CPU access it.

Others too might be interested (Intel, infiniband, or any driver with
an mmu that can do pagefault and has couple others features).

Cheers,
Jerome
