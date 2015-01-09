Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbbAIWy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:54:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:19892 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752355AbbAIWy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:54:57 -0500
Date: Fri, 9 Jan 2015 17:54:53 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>, Pavel Machek <pavel@ucw.cz>,
        Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150109225453.GB29629@home.goodmis.org>
References: <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
 <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
 <CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
 <CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
 <alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
 <CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
 <alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
 <20150107205346.GO12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501071558000.1322@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501071558000.1322@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 04:15:00PM -0500, Nicolas Pitre wrote:
> 
> > However, if running userland on platform A works, and but it doesn't
> > work on platform B.  The breakage may well be due to platform A reporting
> > 300 bogomips because it's using the kernel software loop, and platform
> > B reporting 6 bogomips because its using a hardware timer, but the CPU
> > is actually faster.  However, this is not a kernel problem, and it
> > certainly is not a regression.  It's a userspace bug which needs
> > userspace to fix.
> 
> There I disagree.  In the spirit of "the kernel shall never break user 
> space ever" I'd say that the kernel is simply doing a poor job at 
> providing user space with a value that won't break user space 
> expectations.  And since it is not that hard to do (I made a patch 
> already) I'd say we have less to lose by fixing it than keeping a 
> totally senseless value around.

It's not that the kernel shall never break userspace. It must not cause
userspace regressions.

If application A worked on box X and they upgrade the kernel and then
application A no longer works. That's a regression, and must be fixed.

Now if I understand what Russell stated, if application A works on box X
and you move to box Y using the same kernel, and application A no longer
works, that's not a regression with the kernel (unless it use to work
on box Y). If it never worked on box Y, it's a platform issue and
application A is not robust enough to deal with it. AKA, not a kernel
bug.

Now, it gets interesting if a fix was made that lets application A work
on box Y, but that fix broked application B on box X. Reverting that
fix will cause a regression for A or Y, but the fix itself caused a
regression for B on X. In that case we need a new fix (which may be
the case we are here).

-- Steve

