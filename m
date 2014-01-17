Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaAQOgG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:36:06 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:63181 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbaAQOgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:36:03 -0500
Message-ID: <52D93FBF.2010609@linaro.org>
Date: Fri, 17 Jan 2014 15:35:43 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Hanjun Guo <hanjun.guo@linaro.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Olof Johansson <olof@lixom.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        linaro-acpi@lists.linaro.org, Charles.Garcia-Tobin@arm.com
Subject: Re: [PATCH 12/20] ARM64 / ACPI: Use Parked Address in GIC structure
 for spin table SMP initialisation
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <1389961514-13562-13-git-send-email-hanjun.guo@linaro.org> <201401171515.21250.arnd@arndb.de>
In-Reply-To: <201401171515.21250.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/14 15:15, Arnd Bergmann wrote:
> On Friday 17 January 2014, Hanjun Guo wrote:
>> +/* Parked Address in ACPI GIC structure */
>> +static u64 parked_address[NR_CPUS];
>
> Please use the per_cpu infrastructure rather than NR_CPUS long arrays.
Actually, per_cpu areas are initialized a bit later. If we really want 
to use here per_cpu, then we need to implement early_per_cpu 
Frankenstein like x86 does.

Tomasz
