Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739AbaJ0Hry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 03:47:54 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:56948 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaJ0Hrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 03:47:52 -0400
Date: Mon, 27 Oct 2014 08:47:48 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Fix XT-PIC-XT-PIC in /proc/interrupts
Message-ID: <20141027074748.GA18025@gmail.com>
References: <alpine.LFD.2.11.1410260147190.21390@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1410260147190.21390@eddie.linux-mips.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Maciej W. Rozycki <macro@linux-mips.org> wrote:

> Fix duplicate XT-PIC seen in /proc/interrupts on x86 systems that make 
> use of 8259A Programmable Interrupt Controllers.  Specifically convert 
> output like this:
> 
>            CPU0
>   0:      76573    XT-PIC-XT-PIC    timer
>   1:         11    XT-PIC-XT-PIC    i8042
>   2:          0    XT-PIC-XT-PIC    cascade
>   4:          8    XT-PIC-XT-PIC    serial
>   6:          3    XT-PIC-XT-PIC    floppy
>   7:          0    XT-PIC-XT-PIC    parport0
>   8:          1    XT-PIC-XT-PIC    rtc0
>  10:        448    XT-PIC-XT-PIC    fddi0
>  12:         23    XT-PIC-XT-PIC    eth0
>  14:       2464    XT-PIC-XT-PIC    ide0
> NMI:          0   Non-maskable interrupts
> ERR:          0
> 
> to one like this:
> 
>            CPU0
>   0:     122033    XT-PIC  timer
>   1:         11    XT-PIC  i8042
>   2:          0    XT-PIC  cascade
>   4:          8    XT-PIC  serial
>   6:          3    XT-PIC  floppy
>   7:          0    XT-PIC  parport0
>   8:          1    XT-PIC  rtc0
>  10:        145    XT-PIC  fddi0
>  12:         31    XT-PIC  eth0
>  14:       2245    XT-PIC  ide0
> NMI:          0   Non-maskable interrupts
> ERR:          0
> 
> that is one like we used to have from ~2.2 till it was changed sometime.
> 
> The rationale is there is no value in this duplicate information, it 
> merely clutters output and looks ugly.  We only have one handler for 
> 8259A interrupts so there is no need to give it a name separate from the 
> name already given to irq_chip.
> 
> We could define meaningful names for handlers based on bits in the ELCR 
> register on systems that have it or the value of the LTIM bit we use in 
> ICW1 otherwise (hardcoded to 0 though with MCA support gone), to tell 
> edge-triggered and level-triggered inputs apart.  While that information 
> does not affect 8259A interrupt handlers it could help people determine 
> which lines are shareable and which are not.  That is material for a 
> separate change though.
> 
> Any tools that parse /proc/interrupts are supposed not to be affected 
> since it was many years we used the format this change converts back to.

What's the effect of this change on the output for non-8259A irq 
controllers?

Thanks,

	Ingo
