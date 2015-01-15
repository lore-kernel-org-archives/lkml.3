Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976AbbAOSq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 13:46:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbbAOSq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 13:46:26 -0500
Message-ID: <54B80AAF.7030107@redhat.com>
Date: Thu, 15 Jan 2015 12:45:03 -0600
From: Mark Langsdorf <mlangsdo@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Hanjun Guo <hanjun.guo@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Will Deacon <will.deacon@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Jon Masters <jcm@redhat.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mark Brown <broonie@kernel.org>,
        Rob Herring <robh@kernel.org>, Robert Richter <rric@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, Charles.Garcia-Tobin@arm.com,
        phoenix.liyi@huawei.com, Timur Tabi <timur@codeaurora.org>,
        suravee.suthikulpanit@amd.com, wangyijing@huawei.com,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org,
        Al Stone <al.stone@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: Re: [PATCH v7 02/17] ARM64 / ACPI: Get RSDP and ACPI boot-time tables
References: <1421247905-3749-1-git-send-email-hanjun.guo@linaro.org> <1421247905-3749-3-git-send-email-hanjun.guo@linaro.org>
In-Reply-To: <1421247905-3749-3-git-send-email-hanjun.guo@linaro.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2015 09:04 AM, Hanjun Guo wrote:
> From: Al Stone <al.stone@linaro.org>
>
> As we want to get ACPI tables to parse and then use the information
> for system initialization, we should get the RSDP (Root System
> Description Pointer) first, it then locates Extended Root Description
> Table (XSDT) which contains all the 64-bit physical address that
> pointer to other boot-time tables.
>
> Introduce acpi.c and its related head file in this patch to provide
> fundamental needs of extern variables and functions for ACPI core,
> and then get boot-time tables as needed.
>    - asm/acenv.h for arch specific ACPICA environments and
>      implementation, It is needed unconditionally by ACPI core;
>    - asm/acpi.h for arch specific variables and functions needed by
>      ACPI driver core;
>    - acpi.c for ARM64 related ACPI implementation for ACPI driver
>      core;
>
> acpi_boot_table_init() is introduced to get RSDP and boot-time tables,
> it will be called in setup_arch() before paging_init(), so we should
> use eary_memremap() mechanism here to get the RSDP and all the table
> pointers.
>
> Tested-by: Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
> Tested-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Al Stone <al.stone@linaro.org>
> Signed-off-by: Graeme Gregory <graeme.gregory@linaro.org>
> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
Tested-by: Mark Langsdorf <mlangsdo@redhat.com>

