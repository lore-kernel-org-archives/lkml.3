Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab3BDQmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 11:42:45 -0500
Received: from mail-ve0-f174.google.com ([209.85.128.174]:61957 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756544Ab3BDQmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 11:42:44 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1302041830450.5692@math.ut.ee>
References: <alpine.SOC.1.00.1302011321220.17427@math.ut.ee>
	<CAH3drwb-248ngSqiXZGU=X1k45V8wmN4127_0gr=AQA=px2g0g@mail.gmail.com>
	<alpine.SOC.1.00.1302011726290.17427@math.ut.ee>
	<CADnq5_Ny9_OVqyahSN9WOuwt=PxbT48=NbWr0-r1A5y0yhHKhA@mail.gmail.com>
	<alpine.SOC.1.00.1302041830450.5692@math.ut.ee>
Date: Mon, 4 Feb 2013 11:42:43 -0500
Message-ID: <CADnq5_OntptrUzPgKOhS4GMs2Y5m9-yCaezOsLwY7vB5n0kskw@mail.gmail.com>
Subject: Re: Radeon RV100 init fails with specific card+mobo - IRQ problem
From: Alex Deucher <alexdeucher@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Jerome Glisse <j.glisse@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 4, 2013 at 11:32 AM, Meelis Roos <mroos@linux.ee> wrote:
>> >> > Adding some printks reveals it calls
>> >> > r100_init() -> radeon_irq_kms_init() -> drm_irq_install() ->
>> >> > drm_dev_to_irq() and that fails. So no IRQ, no KMS.
>> >> >
>> >> > lspci does not show Interrupt like on some other PCI devices.
>> >> > /proc/interrupts obviously does not contain the irq since we do not
>> >> > register any yet.
>> >> >
>> >> > There is no BIOS option of "Enable IRQ for VGA" or similar (BIOS is
>> >> > latest). Could this be the problem?
>> >> >
>> >> > What can I do to get KMS working on this computer?
>> >> >
>> >> > --
>> >> > Meelis Roos (mroos@linux.ee)
>> >>
>> >> Try booting with radeon.agp_mode=-1
>> >
>> > radeon: `-1' invalid for parameter `agp_mode'
>>
>> radeon.agpmode=-1
>>
>> However, I think there are a number of places where we require
>> interrupts that would need to be worked around (fences, display
>> hotplug, pageflipping) if not interrupt is available.
>
> I did dome more testing with different cards an got a surprise. The
> machine works fine with other AGP cards - one MX440 with nouvea, another
> RV100 QY and a R200. They do have interrupt in lspci -vvv output.
>
> Why does this specific card not have its IRQ routed - card ROM problem?

For some reason the system bios on your box doesn't assign it one.
The video bios isn't really involved.  I'm not sure if there is a way
to force assign an irq in Linux or not.

Alex
