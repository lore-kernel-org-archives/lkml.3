Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3ILUtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:49:16 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:54736 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198Ab3ILUtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:49:14 -0400
Date: Thu, 12 Sep 2013 22:49:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912204910.GB3262@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <CA+55aFxbjX6T2L2LRfdCVDznjtJTMJAz3QCVyMWXH0y6c=S2kQ@mail.gmail.com>
 <20130912203358.GE32644@gmail.com>
 <CA+55aFwwO3+-EndiLxO+2cmpYGvt_R7vbOBbFvELsmDcWDGdAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwwO3+-EndiLxO+2cmpYGvt_R7vbOBbFvELsmDcWDGdAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Sep 12, 2013 at 1:33 PM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > Hm, just to make sure, are you running a (very fresh) kernel that has this
> > fix included:
> >
> > d008d5258e9c perf: Fix up MMAP2 buffer space reservation
> 
> I've rebooted about five times since that report, so I'm not sure..
> 
> [ Short time passes ]
> 
> Hmm. That "reproducible" error is no longer reproducible for me on 
> current git (68f0d9d92e54). So if you fixed something recently, it's 
> possible I was running a pre-perf-pull kernel and an after-perf-pull 
> "perf" binary.

Yeah, so I think prior merging d008d5258e9c you'd see those artifacts with 
new, MMAP2-aware perf tooling. Both older kernels would work fine with any 
version of the tooling, and old tooling would work fine. Only new tooling 
used on a kernel within the breakage window would be exposed to this.

I think the window of breakage is relatively small (you managed to hit 
it), but should we add a quirk for this?

Thanks,

	Ingo
