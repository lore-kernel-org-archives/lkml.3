Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbaJ2VbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:31:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:59063 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259AbaJ2VbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:31:11 -0400
Date: Wed, 29 Oct 2014 22:31:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Kevin Cernekee <cernekee@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Maxime Bizon <mbizon@freebox.fr>, Jonas Gorski <jogo@openwrt.org>,
        Linux MIPS Mailing List <linux-mips@linux-mips.org>
Subject: Re: [PATCH 01/11] irqchip: Allow irq_reg_{readl,writel} to use
 __raw_{readl_writel}
In-Reply-To: <22478002.kqKBdeLAKz@wuerfel>
Message-ID: <alpine.DEB.2.11.1410292226050.5308@nanos>
References: <1414555138-6500-1-git-send-email-cernekee@gmail.com> <5338153.4SY4TFtus9@wuerfel> <CAJiQ=7C7SzT2ngQzP=dQqdQz=+ShJ_Jf0z4kwFgvUKg1G3vrAw@mail.gmail.com> <22478002.kqKBdeLAKz@wuerfel>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Oct 2014, Arnd Bergmann wrote:
> On Wednesday 29 October 2014 13:09:47 Kevin Cernekee wrote:
> > generic-chip.c already has a fair amount of indirection, with pointers
> > to saved masks, user-specified register offsets, and such.  Is there a
> > concern that introducing, say, a pair of readl/writel function
> > pointers, would cause an unacceptable performance drop?
> 
> I don't know. Thomas' reply suggests that it isn't. Doing byteswap
> in software at a register access is usually free in terms of CPU
> cycles, but an indirect function call can be noticeable if we do
> that a lot.

I did not say that it is free. I merily said that I prefer to have
this solved at the core level rather than at the driver level. So you
have several options to do so:

1) Indirections

2) Different functions for the different access modes

3) Alternatives

#1 Is the simplest solution, but imposes the overhead of an indirect
   function call for something trivial

#2 The most efficient and flexible way if you have to provide
   different access modes for different drivers. But it comes with the
   price of increasing the text foot print.

#3 Smart and efficient, but requires that on a particular system all
   drivers use the same access mode.

Thanks,

	tglx



  
