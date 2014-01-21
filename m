Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbaAUDjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 22:39:13 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:50571 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaAUDjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 22:39:05 -0500
Message-ID: <52DDEBB6.8040908@linaro.org>
Date: Tue, 21 Jan 2014 11:38:30 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Sudeep Holla <Sudeep.Holla@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
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
References: <1389924207-7360-1-git-send-email-hanjun.guo@linaro.org> <5375666.26CZK1LlZA@vostro.rjw.lan> <52DD2DE9.9060202@linaro.org> <1945528.uEVBjXteWy@vostro.rjw.lan>
In-Reply-To: <1945528.uEVBjXteWy@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-21 7:34, Rafael J. Wysocki wrote:
> On Monday, January 20, 2014 10:08:41 PM Hanjun Guo wrote:
>> On 2014年01月18日 21:47, Rafael J. Wysocki wrote:
>>> On Saturday, January 18, 2014 11:52:18 AM Hanjun Guo wrote:
>>>> On 2014-1-18 11:45, Hanjun Guo wrote:
>>>>> On 2014-1-17 20:06, Sudeep Holla wrote:
>>>>>> On 17/01/14 02:03, Hanjun Guo wrote:
>>>>>>> Move idle_boot_override out of the arch directory to be a single enum
>>>>>>> including both platforms values, this will make it rather easier to
>>>>>>> avoid ifdefs around which definitions are for which processor in
>>>>>>> generally used ACPI code.
>>>>>>>
>>>>>>> IDLE_FORCE_MWAIT for IA64 is not used anywhere, so romove it.
>>>>>>>
>>>>>>> No functional change in this patch.
>>>>>>>
>>>>>>> Suggested-by: Alan <gnomes@lxorguk.ukuu.org.uk>
>>>>>>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>>>>>>> ---
>>>> [...]
>>>>>>> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
>>>>>>> index 03e235ad..e324561 100644
>>>>>>> --- a/include/linux/cpu.h
>>>>>>> +++ b/include/linux/cpu.h
>>>>>>> @@ -220,6 +220,14 @@ void cpu_idle(void);
>>>>>>>   
>>>>>>>   void cpu_idle_poll_ctrl(bool enable);
>>>>>>>   
>>>>>>> +enum idle_boot_override {
>>>>>>> +	IDLE_NO_OVERRIDE = 0,
>>>>>>> +	IDLE_HALT,
>>>>>>> +	IDLE_NOMWAIT,
>>>>>>> +	IDLE_POLL,
>>>>>>> +	IDLE_POWERSAVE_OFF
>>>>>>> +};
>>>>>>> +
>>>>>> I do understand the idea behind this change, but IMO HALT and MWAIT are x86
>>>>>> specific and may not make sense for other architectures.
>>>>> yes, this is the strange part, the value is arch-dependent.
>>>>>
>>>>>> It will also require every architecture using ACPI to export
>>>>>> boot_option_idle_override which may not be really required.
>>>>> so, how about forget this patch and move boot_option_idle_override
>>>>> related code into arch directory such as arch/x86/acpi/boot.c for
>>>>> x86?
>>>> The general idea is that we can move all the arch-dependent codes
>>>> in ACPI driver to arch directory, then make codes in drivers/acpi/
>>>> arch independent.
>>> Well, MWAIT is arch-dependent, so I'm not sure how IDLE_NOMWAIT fits into
>>> include/linux/cpu.h?
>>
>> So you will not happy with this patch and should find another solution?
> 
> No, I'm not happy with it.
> 
> If you want to move that to an arch-agnostic header, the symbol names cannot
> be arch-dependent any more.

Ok, will find another solution for that, thanks for your comments :)

Hanjun

