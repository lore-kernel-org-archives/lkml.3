Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab3LDO1g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 09:27:36 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:51662 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab3LDO1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 09:27:34 -0500
Message-ID: <529F3BCA.1020908@linaro.org>
Date: Wed, 04 Dec 2013 22:27:22 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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
        Jon Masters <jonathan@jonmasters.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>
Subject: Re: [RFC part3 PATCH 2/2] ARM64 / clocksource: Use arch_timer_acpi_init()
References: <1386088891-2917-1-git-send-email-hanjun.guo@linaro.org> <1386088891-2917-3-git-send-email-hanjun.guo@linaro.org> <20131203170815.GB16025@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131203170815.GB16025@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月04日 01:08, Mark Rutland wrote:
> On Tue, Dec 03, 2013 at 04:41:31PM +0000, Hanjun Guo wrote:
>> Use arch_timer_acpi_init() on ARM64 to initialise arch timer
>> in ACPI way when DT is not available.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>   arch/arm64/kernel/time.c |    4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm64/kernel/time.c b/arch/arm64/kernel/time.c
>> index 29c39d5..fb009da 100644
>> --- a/arch/arm64/kernel/time.c
>> +++ b/arch/arm64/kernel/time.c
>> @@ -67,6 +67,10 @@ void __init time_init(void)
>>   
>>   	clocksource_of_init();
>>   
>> +	/* if can't be initialised from DT, try ACPI way */
>> +	if (!arch_timer_get_rate())
>> +		arch_timer_acpi_init();
>> +
> As mentioned on the previous patch, I think for the timebeing we should
> rely on CNTFREQ.
>
> Additionally, if you need to do this we should have an analagous
> mechanism to clocksource_of_init() that performs this initialisation for
> ACPI, and here we can call a clocksource_*_init function that does the
> right thing.
>
> There's no need for this file to know anything about ACPI.

Oh, Amit already have some patches to introduce clocksource_acpi_init()
like clocksource_of_init() did, please refer to the link below.

http://marc.info/?l=linaro-acpi&m=138131929721943&w=2

is this the idea you mentioned in your comments?

Thanks
Hanjun


