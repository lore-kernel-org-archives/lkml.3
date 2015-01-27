Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221AbbA0QMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:12:32 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40517 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583AbbA0QMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:12:30 -0500
MIME-Version: 1.0
In-Reply-To: <54B92245.6080306@arm.com>
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org>
 <1421247905-3749-14-git-send-email-hanjun.guo@linaro.org> <54B8F2E3.80306@arm.com>
 <CACxGe6tBb8L8upS3zenZbrOc_c0E=MA=DqLjkSezEbregaAaaA@mail.gmail.com> <54B92245.6080306@arm.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Tue, 27 Jan 2015 16:12:08 +0000
X-Google-Sender-Auth: aAi-kw0DuhYKkpjD8Fb_E-hZUSo
Message-ID: <CACxGe6vb8au6sc0gDMDu4kuzmYBCuOrcObWkbj1mDoCGTgVLVw@mail.gmail.com>
Subject: Re: [PATCH v7 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "phoenix.liyi@huawei.com" <phoenix.liyi@huawei.com>,
        Timur Tabi <timur@codeaurora.org>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "wangyijing@huawei.com" <wangyijing@huawei.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 2:37 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>>> @@ -78,6 +79,10 @@ void __init set_handle_irq(void (*handle_irq)(struct pt_regs *))
>>>>  void __init init_IRQ(void)
>>>>  {
>>>>     irqchip_init();
>>>> +
>>>> +   if (!handle_arch_irq)
>>>> +           acpi_gic_init();
>>>> +
>>>
>>> Why isn't this called from irqchip_init? It would seem like the logical
>>> spot to probe an interrupt controller.
>>
>> What has been done here isn't an unusual choice. We've got stuff all
>> over the kernel that may or may not be implemented depending on what
>> the architecture supports. If the function call is renamed to
>> acpi_init_irq(), are you content?
>
> My (full) suggestion was to do it like we've done it for DT, and I don't
> think I varied much from this point of view. Yes, calling it
> acpi_irq_init() would be a good start, and having the ACPI-compatible
> irqchips to be self-probable even better.
>
> <lack-of-sleep-rant>
>
> Hell, if nobody beats me to it, maybe I'll just write that code, with
> proper entry points in the various GIC drivers. Yes, this is
> infrastructure. Maybe it is grossly overdesigned. But I really spend too
> much time dealing with the crap that people are happy to pile on top of
> the GIC code to be madly enthusiastic about the general "good enough"
> attitude.
>
> </lack-of-sleep-rant>
>
> Or to put it in a slightly more diplomatic way: If ACPI is to be our
> future, can we please make the future look a bit better?

Hi Marc,

As per our off-list discussion, I completely agree. We don't want to
be adding hack upon hack, and I will be first in line to NAK any
patches taking that approach. However, for this initial series, it
only supports exactly one GIC that can be set up by ACPI. Can we agree
to leave it as is in this series, with the agreement that it will be
replaced for v2m and v3 support with a proper pluggable initializer?
Tomasz is currently working on getting that change ready, but the
logistics are simpler if this series isn't blocked on that change.

g.
