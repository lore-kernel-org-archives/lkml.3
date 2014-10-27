Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbaJ0MoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:44:15 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45880 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJ0MoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:44:13 -0400
Date: Mon, 27 Oct 2014 13:44:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix XT-PIC-XT-PIC in /proc/interrupts
Message-ID: <20141027124409.GA22947@gmail.com>
References: <alpine.LFD.2.11.1410260147190.21390@eddie.linux-mips.org>
 <20141027074748.GA18025@gmail.com>
 <alpine.LFD.2.11.1410271207230.3413@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1410271207230.3413@eddie.linux-mips.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> On Mon, 27 Oct 2014, Ingo Molnar wrote:
> 
> > What's the effect of this change on the output for non-8259A irq 
> > controllers?
> 
>  Good question, I didn't expect any other IRQ controller to be used for 
> ISA interrupts (the APIC is handled elsewhere).  I have checked the 
> sources and the only other controller that can be used for `legacy_pic' 
> is `dummy_irq_chip' (cf. `default_legacy_pic' vs `null_legacy_pic' in 
> arch/x86/kernel/i8259.c).  That affects `init_ISA_irqs' only (the other 
> place, `make_8259A_irq', has a reference to `i8259A_chip' hardcoded).
> 
>  In this case the output would change from "dummy-dummy" to "dummy", 
> which IMHO has just as much value as the change from "XT-PIC-XT-PIC" to 
> "XT-PIC".  However I don't think you'd be able to request such IRQs so 
> they will never show up in /proc/interrupts, making this observation 
> largely irrelevant.  If you think I may be wrong here, then can you 
> please find such a system and try this change with it (or can someone 
> else reading this make this check for me by any chance)?  Unfortunately 
> all x86 hardware I have does have an 8259A pair.
> 
>  Also please note that both places explicitly refer to the name of the 
> IRQ chip being installed as the name of the handler as well, with 
> `i8259A_chip.name' and `chip->name' respectively, this is hardcoded.  
> So no matter which chip is used there'll be a duplicate name in 
> /proc/interrupts.
> 
>  Does this answer address your concern?

Yeah, it addresses it, I'll queue up your fix, thanks!

	Ingo
