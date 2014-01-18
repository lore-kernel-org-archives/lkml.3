Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbaARDwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 22:52:34 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:44864 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaARDwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 22:52:31 -0500
Message-ID: <52D9FA72.5020505@linaro.org>
Date: Sat, 18 Jan 2014 11:52:18 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sudeep Holla <Sudeep.Holla@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Jon Masters <jonathan@jonmasters.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [PATCH 1/3] ACPI / idle: Move idle_boot_override out of the arch
 directory
References: <1389924207-7360-1-git-send-email-hanjun.guo@linaro.org> <1389924207-7360-2-git-send-email-hanjun.guo@linaro.org> <52D91CE2.3050704@arm.com> <52D9F8E8.8030602@linaro.org>
In-Reply-To: <52D9F8E8.8030602@linaro.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-18 11:45, Hanjun Guo wrote:
> On 2014-1-17 20:06, Sudeep Holla wrote:
>> On 17/01/14 02:03, Hanjun Guo wrote:
>>> Move idle_boot_override out of the arch directory to be a single enum
>>> including both platforms values, this will make it rather easier to
>>> avoid ifdefs around which definitions are for which processor in
>>> generally used ACPI code.
>>>
>>> IDLE_FORCE_MWAIT for IA64 is not used anywhere, so romove it.
>>>
>>> No functional change in this patch.
>>>
>>> Suggested-by: Alan <gnomes@lxorguk.ukuu.org.uk>
>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>> ---
[...]
>>> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
>>> index 03e235ad..e324561 100644
>>> --- a/include/linux/cpu.h
>>> +++ b/include/linux/cpu.h
>>> @@ -220,6 +220,14 @@ void cpu_idle(void);
>>>  
>>>  void cpu_idle_poll_ctrl(bool enable);
>>>  
>>> +enum idle_boot_override {
>>> +	IDLE_NO_OVERRIDE = 0,
>>> +	IDLE_HALT,
>>> +	IDLE_NOMWAIT,
>>> +	IDLE_POLL,
>>> +	IDLE_POWERSAVE_OFF
>>> +};
>>> +
>>
>> I do understand the idea behind this change, but IMO HALT and MWAIT are x86
>> specific and may not make sense for other architectures.
> 
> yes, this is the strange part, the value is arch-dependent.
> 
>>
>> It will also require every architecture using ACPI to export
>> boot_option_idle_override which may not be really required.
> 
> so, how about forget this patch and move boot_option_idle_override
> related code into arch directory such as arch/x86/acpi/boot.c for
> x86?

The general idea is that we can move all the arch-dependent codes
in ACPI driver to arch directory, then make codes in drivers/acpi/
arch independent.

Thanks
Hanjun
