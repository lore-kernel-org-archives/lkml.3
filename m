Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752097AbaBSMHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 07:07:23 -0500
Received: from www.linutronix.de ([62.245.132.108]:50251 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaBSMHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 07:07:21 -0500
Date: Wed, 19 Feb 2014 13:07:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: carl peng <carlpeng008@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, x86@kernel.org,
        pingfank@linux.vnet.ibm.com, yoshihiro.yunomae.ez@hitachi.com,
        linux-kernel@vger.kernel.org
Subject: Re: Does it need to implement irq_set_type method in the
 ioapic_chip?
In-Reply-To: <CAC5e1FobNkgWuvk=F=fPfZiyd-r=TFRV6Lg9BTSLsLP6i_T7JA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1402191259590.4468@ionos.tec.linutronix.de>
References: <CAC5e1FoLrHWSa_7BnRt-u451ZJOVqKhSpbyp8O_ExDbgcXtU+g@mail.gmail.com> <alpine.DEB.2.02.1402182101450.4468@ionos.tec.linutronix.de> <CAC5e1FpChdyW9xzbwsyVx147hKrV0MxwkCMyKHR4ab5-Q=DyPg@mail.gmail.com> <fe0610e4-0073-42a7-803a-590de82e47ef@email.android.com>
 <CAC5e1FobNkgWuvk=F=fPfZiyd-r=TFRV6Lg9BTSLsLP6i_T7JA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014, carl peng wrote:
> At last, the device will be connected to AMBA bus, so the interrupt
> pin will be connected to IOAPIC through AMBA bus. The device now
> is in the pre-silicon verification stage.
> 
> So my question is the same:
> Why does APIC driver not implement the irq_set_type method?  if

Because we do not need it. All devices are properly connected and
configured by the BIOS and bus discovery.

> implement it, will supply more free space for the device driver
> developer(they can set the interrupttrigger mode by calling request_irq).

There are 3 different mechanisms already to tell the kernel to
configure a particular irq line: ACPI, MP Tables and SFI.

That's the way x86 does its interrupt configuration and there is no
need to provide another one.

Thanks,

	tglx
