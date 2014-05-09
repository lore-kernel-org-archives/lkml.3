Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756227AbaEIHjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 03:39:22 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41680 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041AbaEIHjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 03:39:18 -0400
Date: Fri, 9 May 2014 09:39:09 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Tom Zanussi <tom.zanussi@linux.intel.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        Andi Kleen <andi@firstfloor.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RFC: A reduced Linux network stack for small systems
Message-ID: <20140509073909.GE4965@xo-6d-61-c0.localdomain>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <CAFLxGvww8t-PpuS3B=dFvn8k3xBydk3CgA=qoLyEbkKJZJ0xhQ@mail.gmail.com>
 <1399383246.8767.99.camel@empanada>
 <CAADnVQLYiNfXRrXc=VZkGEFDbNhF63AzPg6Gyu6P1SF=6AiO7g@mail.gmail.com>
 <1399390490.8767.122.camel@empanada>
 <CAADnVQ+nCtshedoDWN+QgiKzsCzBcojZOzrhkfzsqyXTpi4L=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQ+nCtshedoDWN+QgiKzsCzBcojZOzrhkfzsqyXTpi4L=w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> that is likely working only for the given very limited set of applications.
> >> Kernel function profiling can potentially achieve the same thing.
> >> Profile the kernel with the set of apps and then prune all cold
> >> functions out of kernel.
> >
> > Right, and are Profile-Guided-Optimization results now reproduceable?
> > Better change it to Trace-Guided-Optimization.  But yeah, for a
> 
> not quite. I'm saying: no extra optimizations, no GCC changes.
> Compile kernel as-is. Most functions have a stub for mcount() already.
> Use it to track whether kernel function was called or not.
> Collect this data in userspace (as perf already does), add few
> more functions that had 'notrace' attribute on them, and feed this into
> special linker that unpacks existing vmlinux, throws away cold functions,
> relocates the rest and here you have tiny vmlinux without recompilation.

It sounds like unstripped kernel will not even fit on the target machine.
If it+application would fit there, you'd have no reason to strip it down...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
