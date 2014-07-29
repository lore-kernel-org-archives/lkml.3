Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbaG2NuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 09:50:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:57491 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbaG2Nt7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 09:49:59 -0400
Message-ID: <53D7A6A2.9020005@arm.com>
Date: Tue, 29 Jul 2014 14:50:26 +0100
From: Sudeep Holla <sudeep.holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Mark Rutland <Mark.Rutland@arm.com>
CC: Sudeep Holla <sudeep.holla@arm.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>, Robert Richter <rric@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Robert Moore <robert.moore@intel.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH 01/19] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
References: <1406206825-15590-1-git-send-email-hanjun.guo@linaro.org> <1406206825-15590-2-git-send-email-hanjun.guo@linaro.org> <53D69678.20002@arm.com> <53D79CD8.9050709@linaro.org>
In-Reply-To: <53D79CD8.9050709@linaro.org>
X-OriginalArrivalTime: 29 Jul 2014 13:49:53.0236 (UTC) FILETIME=[F95D5940:01CFAB33]
X-MC-Unique: 114072914495514601
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 29/07/14 14:08, Hanjun Guo wrote:
> On 2014-7-29 2:29, Sudeep Holla wrote:
> [...]
>>> +
>>> +/*
>>> + * We never plan to use RSDT on arm/arm64 as its deprecated in spec but this
>>> + * variable is still required by the ACPI core
>>> + */
>>> +u32 acpi_rsdt_forced;
>>
>> This looks like yet another stray variable not used anywhere including
>> core ACPI
>
> It will be used by ACPICA to get the RSDP in acpi_tb_parse_root_table()
> in tbutils.c.
>

No I couldn't find it in mainline/acpica/linux-next(pm tree).

On further digging found that commit fab461058385("ACPICA: Cleanup the
option of forcing the use of the RSDT") has renamed it to
acpi_gbl_do_not_use_xsdt and moved it into acpica with default false.
So you can remove this.

Regards,
Sudeep

