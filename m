Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaI2TlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 15:41:21 -0400
Received: from www.linutronix.de ([62.245.132.108]:53780 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbaI2TlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 15:41:17 -0400
Date: Mon, 29 Sep 2014 21:41:47 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Sebastian Lackner <sebastian@fds-team.de>
Subject: Re: [PATCH] x86 : Ensure X86_FLAGS_NT is cleared on syscall entry
In-Reply-To: <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1409292135090.22082@ionos.tec.linutronix.de>
References: <1411674171-24442-1-git-send-email-anish@chelsio.com> <54299979.6080705@amacapital.net> <alpine.DEB.2.02.1409292038590.22082@ionos.tec.linutronix.de> <CALCETrX7yce2PfYi-Gqkf116a1rXUzjKkO3JAf==zd3WuZuDsQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2014, Andy Lutomirski wrote:
> On Mon, Sep 29, 2014 at 11:59 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Mon, 29 Sep 2014, Andy Lutomirski wrote:
> >> Presumably interrupt delivery clears NT.  I haven't spotted where that's
> >> documented yet.
> >
> > Nope, that's unrelated.
> 
> If it weren't the case, then we'd be totally screwed.  Fortunately, it
> is.  I found it: SDM Volume 3 6.12.1.2 says:
> 
> (On calls to exception and interrupt
> handlers, the processor also clears the VM, RF, and NT flags in the
> EFLAGS register,
> after they are saved on the stack.)

Sorry, I misunderstood your question.

And yes on exception and interrupt entry it is cleared. Otherwise the
whole feature would not work at all ...

But that's why I'm really not worried about it. While we can mask out
the stupid bit easily, it does not provide any value except protecting
silly userspace from rightfully raised exceptions.

When I first saw that patch, I was worried about the security impact,
but after staring long enough at the SDM and the code, the only way it
can explode is when returning to user space. It cannot explode in the
kernel.

So in IA-32e it creates a #GP otherwise it falls over the return to
NULL (TSS.back_link). So what?

Thanks,

	tglx
