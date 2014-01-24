Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723AbaAXJUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 04:20:00 -0500
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59466 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbaAXJT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 04:19:57 -0500
Message-ID: <52E2302D.5040001@linaro.org>
Date: Fri, 24 Jan 2014 17:19:41 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Rutland <mark.rutland@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: Re: [PATCH 18/20] clocksource / acpi: Add macro CLOCKSOURCE_ACPI_DECLARE
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <52DCE790.6080809@linaro.org> <20140122114616.GB15591@e106331-lin.cambridge.arm.com> <3140612.0s75qS6VKb@wuerfel>
In-Reply-To: <3140612.0s75qS6VKb@wuerfel>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年01月22日 22:56, Arnd Bergmann wrote:
> On Wednesday 22 January 2014 11:46:16 Mark Rutland wrote:
>> On Mon, Jan 20, 2014 at 09:08:32AM +0000, Hanjun Guo wrote:
>>> On 2014-1-17 22:21, Arnd Bergmann wrote:
>>>> On Friday 17 January 2014, Hanjun Guo wrote:
>>>>> From: Amit Daniel Kachhap <amit.daniel@samsung.com>
>>>>>
>>>>> This macro does the same job as CLOCKSOURCE_OF_DECLARE. The device
>>>>> name from the ACPI timer table is matched with all the registered
>>>>> timer controllers and matching initialisation routine is invoked.
>>>> I wouldn't anticipate this infrastructure to be required. Shouldn't all
>>>> ARMv8 machines have an architected timer?
>>> I not sure of this, could anyone can give some guidance? if only arch
>>> timer is available for ARM64, this will make thing very simple.
>> All ARMv8 systems should have an architected timer.
>>
>> However, they may also have other timers (e.g. global timers for use
>> when CPUs are in low power states and their local architected timers
>> aren't active).
> But all other timers could be regular platform drivers I suppose. No
> need for special infrastructure for those.

One more information, acpi_early_init() is run before timekeeping_init()
now, and that patch was merged into 3.14-rc1. So we can initialize
timers for scanning the DSDT table, and it also means that timer defined
in DSDT can be initialized early enough.

Thanks
Hanjun



