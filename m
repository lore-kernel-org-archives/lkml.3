Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab3ILUeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:34:06 -0400
Received: from mail-ee0-f42.google.com ([74.125.83.42]:62565 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab3ILUeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:34:01 -0400
Date: Thu, 12 Sep 2013 22:33:58 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130912203358.GE32644@gmail.com>
References: <20130912133855.GA23780@gmail.com>
 <CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
 <CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
 <CA+55aFxbjX6T2L2LRfdCVDznjtJTMJAz3QCVyMWXH0y6c=S2kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxbjX6T2L2LRfdCVDznjtJTMJAz3QCVyMWXH0y6c=S2kQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Sep 12, 2013 at 11:10 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > But at least the "make install" problem is repeatable, though.
> 
> And now this new problem is repeatable too:
> 
>   # On a fully built kernel tree
>   perf record -g -e cycles:pp make -j
> 
> results in
> 
>   [ perf record: Woken up 27 times to write data ]
>   [ perf record: Captured and wrote 7.980 MB perf.data (~348659 samples) ]
>   0x1b4e0 [0]: failed to process type: -1970637019
> 
> where that number changes randomly, ie I get
> 
>   0x28dc58 [0]: failed to process type: 99257493
>   0x4100 [0]: failed to process type: -1144359783
>   0x29050 [0]: failed to process type: -972156963
>   ..
> 
> looks like perhaps some uninitialized variable somewhere?
> 
> Recording performance profiles of other (simpler?) loads still seems to 
> work. So it's something about that "make -j" that makes it crap out 
> (note that the tree is fully built, so not a lot actually gets *done*, 
> and the thing only takes a few seconds)

Hm, just to make sure, are you running a (very fresh) kernel that has this 
fix included:

d008d5258e9c perf: Fix up MMAP2 buffer space reservation

?

Thanks,

	Ingo
