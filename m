Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751401AbbARFuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 00:50:07 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:45045 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbbARFuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 00:50:02 -0500
Message-ID: <54BB497E.7050606@linaro.org>
Date: Sun, 18 Jan 2015 13:49:50 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, "jcm@redhat.com" <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
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
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH v7 07/17] ARM64 / ACPI: Disable ACPI if FADT revision
 is less than 5.1
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-8-git-send-email-hanjun.guo@linaro.org> <20150116143337.GA14505@red-moon>
In-Reply-To: <20150116143337.GA14505@red-moon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015年01月16日 22:33, Lorenzo Pieralisi wrote:
> On Wed, Jan 14, 2015 at 03:04:55PM +0000, Hanjun Guo wrote:
>> FADT Major.Minor version was introduced in ACPI 5.1, it is the same
>> as ACPI version.
>>
>> In ACPI 5.1, some major gaps are fixed for ARM, such as updates in
>> MADT table for GIC and SMP init, without those updates, we can not
>> get the MPIDR for SMP init, and GICv2/3 related init information, so
>> we can't boot arm64 ACPI properly with table versions predating 5.1.
>>
>> If firmware provides ACPI tables with ACPI version less than 5.1,
>> OS will be messed up with those information and have no way to init
>
> Nit: "that information"
>
> or
>
> "...OS has no way to retrieve the configuration data that is necessary
> to init SMP boot protocol and the GIC properly, so.."
>
>> smp and GIC, so disable ACPI if we get an FADT table with version
>> less that 5.1.
>>
>
> Patch should be reordered in the series and must be sequenced before
> patch 5 for bisectability (that patch implements DT unflattening if ACPI
> is disabled), or squashed with previous patches.

OK, I will reorder this patch set and update the change log above.

Thanks
Hanjun
