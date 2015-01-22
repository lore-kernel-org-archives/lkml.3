Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbbAVOqY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:46:24 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:40998 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbbAVOqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:46:21 -0500
Message-ID: <54C10D31.1090203@arm.com>
Date: Thu, 22 Jan 2015 14:46:09 +0000
From: Marc Zyngier <marc.zyngier@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
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
Subject: Re: [PATCH v7 13/17] ARM64 / ACPI: Add GICv2 specific ACPI boot support
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-14-git-send-email-hanjun.guo@linaro.org> <54B8F2E3.80306@arm.com> <CACxGe6tBb8L8upS3zenZbrOc_c0E=MA=DqLjkSezEbregaAaaA@mail.gmail.com> <54B92245.6080306@arm.com> <54C0F133.8060901@linaro.org>
In-Reply-To: <54C0F133.8060901@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hanjun,

On 22/01/15 12:46, Hanjun Guo wrote:
> Hi Marc,
> 
> We (Tomasz, Suravee and me) are working on supporting stacked domain on
> ACPI, and rework GIC ACPI related patch, before we going further, we
> need your guidance to see if we are going the right direction.
> 
>    - You said that we spread GIC related code every where, so how
>      about put all the ACPI related GIC init code in one file under
>      drivers/irqchip/ with name irq-gic-acpi.c?

That would certainly be an improvement.

>    - ACPI only support one GICD for now, so we assume that there
>     only one gicv2/v3 core domain and every device not using MSI
>      will refer to that irqdomain in default.

That's good enough, provided that nobody comes up with any form of
chained interrupt controller (in whatever way that's implemented). ACPI
doesn't seem to cater for that anyway.

But default domains are only a quick optimization (it is only there to
cope with code that didn't know about irq domains at all). What we need
is a proper integration of the ACPI namespace in the irq domain code.
Being able to lookup a domain by ACPI table, for example (just like
irq_find_host returns the domain associated to a DT node).

This would ensure that we can reuse most of the existing code (stacked
domains, per-device MSI domains [WIP]) without too much effort.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
