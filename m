Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbaBSN3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:29:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54767 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752701AbaBSN3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:29:05 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <alpine.DEB.2.02.1402191259590.4468@ionos.tec.linutronix.de>
References: <CAC5e1FoLrHWSa_7BnRt-u451ZJOVqKhSpbyp8O_ExDbgcXtU+g@mail.gmail.com> <alpine.DEB.2.02.1402182101450.4468@ionos.tec.linutronix.de> <CAC5e1FpChdyW9xzbwsyVx147hKrV0MxwkCMyKHR4ab5-Q=DyPg@mail.gmail.com> <fe0610e4-0073-42a7-803a-590de82e47ef@email.android.com> <CAC5e1FobNkgWuvk=F=fPfZiyd-r=TFRV6Lg9BTSLsLP6i_T7JA@mail.gmail.com> <alpine.DEB.2.02.1402191259590.4468@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Does it need to implement irq_set_type method in the ioapic_chip?
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 19 Feb 2014 05:28:15 -0800
To: Thomas Gleixner <tglx@linutronix.de>, carl peng <carlpeng008@gmail.com>
CC: mingo@redhat.com, x86@kernel.org, pingfank@linux.vnet.ibm.com,
        yoshihiro.yunomae.ez@hitachi.com, linux-kernel@vger.kernel.org
Message-ID: <5e7b7684-2f67-4dca-b889-94b942cc72dd@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the casee of your ACPI-enabled AMBA device I believe the BIOS, which provides the ACPI tables, is expected to set the interrupt type.

On February 19, 2014 4:07:09 AM PST, Thomas Gleixner <tglx@linutronix.de> wrote:
>On Wed, 19 Feb 2014, carl peng wrote:
>> At last, the device will be connected to AMBA bus, so the interrupt
>> pin will be connected to IOAPIC through AMBA bus. The device now
>> is in the pre-silicon verification stage.
>> 
>> So my question is the same:
>> Why does APIC driver not implement the irq_set_type method?  if
>
>Because we do not need it. All devices are properly connected and
>configured by the BIOS and bus discovery.
>
>> implement it, will supply more free space for the device driver
>> developer(they can set the interrupttrigger mode by calling
>request_irq).
>
>There are 3 different mechanisms already to tell the kernel to
>configure a particular irq line: ACPI, MP Tables and SFI.
>
>That's the way x86 does its interrupt configuration and there is no
>need to provide another one.
>
>Thanks,
>
>	tglx

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
