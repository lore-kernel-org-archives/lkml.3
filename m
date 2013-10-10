Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab3JJCQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 22:16:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50161 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab3JJCQq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 22:16:46 -0400
Message-ID: <1381371357.5538.25.camel@marge.simpson.net>
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
From: Mike Galbraith <bitbucket@online.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Thu, 10 Oct 2013 04:15:57 +0200
In-Reply-To: <20131009171811.GA12623@gmail.com>
References: <20131005234430.GA22485@localhost>
	 <CA+55aFxEeKixnH7mZZs5iwupA9_GsRN0N7QZxqcTcE4RKZvTTg@mail.gmail.com>
	 <20131008143400.GA14721@redhat.com> <20131009080459.GA2298@localhost>
	 <20131009121911.GA18770@localhost>
	 <20131009122705.GG3081@twins.programming.kicks-ass.net>
	 <20131009125228.GA24215@gmail.com> <20131009171811.GA12623@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:S0IZbu3CVl7wqu5D5agUWTzgo0wrere5NE96z0iOcsW
 e0Upp1EiMn5CkfpYgAilQ0ASOh2WFBX6A+wf8BBo9bjTErNfj/
 pF02GQ3YPBqKsxy40jXGTwv7q+u6hCJWoya7BqCwvhy0yLXcnE
 mw3c+H0ShiTsVLqmKCyEkyJ0eaJQtAxyOzy0B73Okrg+/P/3zi
 VQGiTF0d6opSFGuo1c/0FClWxYte4hU6TKMYdMjZY50CRPSlsG
 NZDNOqWbreJtT9BtFaVMg9SFxptVTf5AVI+3NQ1KE46KLGtO/n
 MOrBIRVBPno5V/LlvJ0FXy2qZJ9nBshVspTpP+CBSLCo+Vi8sV
 ntYYJ+X+HpuAhes/d3Ex+2u52GDyQBebpH5nUph/E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-09 at 19:18 +0200, Ingo Molnar wrote: 
> * Ingo Molnar <mingo@kernel.org> wrote:
> 
> > 
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > On Wed, Oct 09, 2013 at 08:19:11PM +0800, Fengguang Wu wrote:
> > > > > > Fengguang, I do not think this will help, but just in case. Could you
> > > > > > show the result of
> > > > > > 
> > > > > >         $ kernel/task_work.s
> > > > 
> > > > Update: I recompiled the kernel with gcc 4.4.7 and find it booting fine!
> > > 
> > > > # 208 "/c/wfg/tip/arch/x86/include/asm/bitops.h" 1
> > > > 	bts $1, 8(%eax); setc %dl	#,, c
> > > 
> > > That compiler doesn't appear to have asm goto support, so we fall back 
> > > to the code we already knew worked :-)
> > 
> > I'm using 4.7.2 with randconfig testing, which has asm goto support, and 
> > I haven't seen this crash yet.
> > 
> > Unless my testing is off it might be a bug in GCC 4.8, or a pre-existing 
> > bug gets exposed by GCC 4.8.
> 
> And as it happens, just a few hours later I hit a very similar crash, this 
> time compiled with both 4.7.3 and 4.7.2! (config attached)
> 
> This has a weird-x86-arch tuning knob as well:
> 
>   CONFIG_MGEODE_LX=y
> 
> So I think we might need to turn off asm goto for all things 32-bit x86.

Hm, 32 bit x86...

I built 4.8.1 yesterday, so can now build x86_64 tip, but I suspect I'll
not be the only one with a compiler that goes belly up.

net/sunrpc/xprtsock.c: In function ‘xs_setup_tcp’:
net/sunrpc/xprtsock.c:2844:1: internal compiler error: in move_insn, at haifa-sched.c:2353

gcc-4.6.2 (opensuse 12.1) has happily chewed up humongous piles of
source, but finds this asm goto stuff to be toxic.

-Mike

