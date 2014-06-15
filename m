Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752811AbaFOG5h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 02:57:37 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:51627 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaFOG5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 02:57:36 -0400
Date: Sun, 15 Jun 2014 08:57:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: David Lang <david@lang.hm>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140615065731.GB20028@gmail.com>
References: <20140506140516.GF2099@localhost.localdomain>
 <20140506145010.GA6702@treble.redhat.com>
 <20140507122444.GB12234@gmail.com>
 <20140507154114.GA31555@treble.redhat.com>
 <20140507155754.GA15221@gmail.com>
 <alpine.DEB.2.02.1405071552520.5876@nftneq.ynat.uz>
 <20140508061220.GB31184@gmail.com>
 <alpine.DEB.2.02.1405072348580.17457@nftneq.ynat.uz>
 <20140508070814.GA31856@gmail.com>
 <20140614203138.GA3853@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140614203138.GA3853@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > > in terms of hit-patching kernels you are correct.
> > > 
> > > but that's a far cry from what it sounded like you were demanding 
> > > (that it must handle any kernel patch)
> > 
> > No, I was not demanding that at all, my suggestion was:
> > 
> >    > My claim is that if a patch is correct/safe in the old fashioned 
> >    > way, then a fundamental principle is that a live patching 
> >    > subsystem must either safely apply, or safely reject the live 
> >    > patching attempt, independently from any user input.
> > 
> > Note the 'if'. It could start simple and stupid, and only allow 
> > cases where we know the patch must be trivially safe (because it 
> > does not do much in terms of disturbing globally visible state). 
> > That needs some tooling help, but apparently tooling help is in 
> > place already.
> 
> Actually, even if patch is very trivial, it will be difficult to 
> determine if it is safe. Consider adding error check:
> 
> int
> do_something(void)
> {
> #if 0
>   if (1)
>     return -1;
> #endif
>   return 0;
> }
> 
> void
> main(void)
> {
>   if (do_something())
>     printf("error happened\n");
> }
> 
> Imagine changing that #if 0 to #if 1. But gcc at -O3 already 
> optimized out the error message. So... do we compile whole second 
> kernel and compare the binaries? I think I seen remark "don't try to 
> do binary compares" somewhere...

Fair enough.

Thanks,

	Ingo
