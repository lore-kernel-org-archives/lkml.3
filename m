Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3BAPqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 10:46:42 -0500
Received: from mail-ve0-f175.google.com ([209.85.128.175]:54175 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab3BAPqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 10:46:38 -0500
X-Greylist: delayed 328 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2013 10:46:38 EST
MIME-Version: 1.0
In-Reply-To: <alpine.SOC.1.00.1302011726290.17427@math.ut.ee>
References: <alpine.SOC.1.00.1302011321220.17427@math.ut.ee>
	<CAH3drwb-248ngSqiXZGU=X1k45V8wmN4127_0gr=AQA=px2g0g@mail.gmail.com>
	<alpine.SOC.1.00.1302011726290.17427@math.ut.ee>
Date: Fri, 1 Feb 2013 10:41:10 -0500
Message-ID: <CADnq5_Ny9_OVqyahSN9WOuwt=PxbT48=NbWr0-r1A5y0yhHKhA@mail.gmail.com>
Subject: Re: Radeon RV100 init fails with specific card+mobo - IRQ problem
From: Alex Deucher <alexdeucher@gmail.com>
To: Meelis Roos <mroos@linux.ee>
Cc: Jerome Glisse <j.glisse@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 1, 2013 at 10:26 AM, Meelis Roos <mroos@linux.ee> wrote:
>> > Adding some printks reveals it calls
>> > r100_init() -> radeon_irq_kms_init() -> drm_irq_install() ->
>> > drm_dev_to_irq() and that fails. So no IRQ, no KMS.
>> >
>> > lspci does not show Interrupt like on some other PCI devices.
>> > /proc/interrupts obviously does not contain the irq since we do not
>> > register any yet.
>> >
>> > There is no BIOS option of "Enable IRQ for VGA" or similar (BIOS is
>> > latest). Could this be the problem?
>> >
>> > What can I do to get KMS working on this computer?
>> >
>> > --
>> > Meelis Roos (mroos@linux.ee)
>>
>> Try booting with radeon.agp_mode=-1
>
> radeon: `-1' invalid for parameter `agp_mode'

radeon.agpmode=-1

However, I think there are a number of places where we require
interrupts that would need to be worked around (fences, display
hotplug, pageflipping) if not interrupt is available.

Alex
