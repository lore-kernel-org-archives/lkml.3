Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266AbaAXAMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 19:12:43 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:45388 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaAXAMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 19:12:40 -0500
Message-ID: <52E1AFE8.40601@linaro.org>
Date: Fri, 24 Jan 2014 08:12:24 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-19-git-send-email-hanjun.guo@linaro.org> <CACRpkdYKwaH5DX27irzmcTDAMhQMUhuzz6N7mjKWv9tZchv0Ug@mail.gmail.com>
In-Reply-To: <CACRpkdYKwaH5DX27irzmcTDAMhQMUhuzz6N7mjKWv9tZchv0Ug@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for the late reply.

On 2014年01月22日 16:26, Linus Walleij wrote:
> On Fri, Jan 17, 2014 at 1:25 PM, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>
>> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>
>> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
>> name from the ACPI timer table is matched with all the registered
>> timer controllers and matching initialisation routine is invoked.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> Actually I have a fat patch renaming CLOCKSOURCE_OF_DECLARE()
> to TIMER_OF_DECLARE() and I think this macro, if needed, should
> be named TIMER_ACPI_DECLARE().
>
> The reason is that "clocksource" is a Linux-internal name and this
> macro pertains to the hardware name in respective system
> description type.

That make sense to me too, I will update in next version if
this patch is still needed.

>
>> +#ifdef CONFIG_ACPI
>> +#define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)                     \
>> +       static const struct acpi_device_id __clksrc_acpi_table_##name   \
>> +               __used __section(__clksrc_acpi_table)                   \
>> +                = { .id = compat,                              \
>> +                    .driver_data = (kernel_ulong_t)fn }
>> +#else
>> +#define CLOCKSOURCE_ACPI_DECLARE(name, compat, fn)
>> +#endif
> This hammers down the world to compile one binary for ACPI
> and one binary for device tree. Maybe that's fine, I don't know.

This is a problem we can have some discussion on it.
I prefer mutually exclusive ACPI and DT support.

Thanks
Hanjun

