Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017AbaIOQch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:32:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41079 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752769AbaIOQce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:32:34 -0400
Message-ID: <54171454.6090906@redhat.com>
Date: Mon, 15 Sep 2014 12:31:16 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Olof Johansson <olof@lixom.net>
CC: "hanjun.guo@linaro.org" <hanjun.guo@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Sudeep Holla <Sudeep.Holla@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@kernel.org>, Rob Herring <robh@kernel.org>,
        Robert Richter <rric@kernel.org>, Lv Zheng <lv.zheng@intel.com>,
        Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Al Stone <al.stone@linaro.org>
Subject: Re: [PATCH v4 06/18] ARM64 / ACPI: Introduce early_param for "acpi"
References: <1410530416-30200-1-git-send-email-hanjun.guo@linaro.org> <1410530416-30200-7-git-send-email-hanjun.guo@linaro.org> <20140915062824.GB26649@localhost> <20140915145106.GC5415@arm.com>
In-Reply-To: <20140915145106.GC5415@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 10:51 AM, Catalin Marinas wrote:
> On Mon, Sep 15, 2014 at 07:28:24AM +0100, Olof Johansson wrote:
>> On Fri, Sep 12, 2014 at 10:00:04PM +0800, Hanjun Guo wrote:
>>>  			See also Documentation/power/runtime_pm.txt, pci=noacpi
>>>  
>>> diff --git a/arch/arm64/kernel/acpi.c b/arch/arm64/kernel/acpi.c
>>> index 9252f72..693da7f 100644
>>> --- a/arch/arm64/kernel/acpi.c
>>> +++ b/arch/arm64/kernel/acpi.c
>>> @@ -67,3 +67,18 @@ void __init acpi_boot_table_init(void)
>>>  	if (acpi_table_init())
>>>  		disable_acpi();
>>>  }
>>> +
>>> +static int __init parse_acpi(char *arg)
>>> +{
>>> +	if (!arg)
>>> +		return -EINVAL;
>>> +
>>> +	/* "acpi=off" disables both ACPI table parsing and interpreter */
>>> +	if (strcmp(arg, "off") == 0)
>>> +		disable_acpi();
>>> +	else
>>> +		return -EINVAL;	/* Core will print when we return error */
>>
>> For symmetry, you should handle acpi=force here too (i.e. if someone
>> disables by default, which I expect we'll ask for when this code is
>> first merged).
> 
> Does this mean you want another Kconfig option - ACPI_DEFAULT_OFF (which
> would be set by default)?

This would make sense. I mentioned this before since it gives distros an
opportunity to set this differently for their shipping preference
without the upstream having to default to being on.

Jon.


