Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3LEOBx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:01:53 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39166 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755561Ab3LEOBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:01:51 -0500
Message-ID: <52A08738.8060701@linaro.org>
Date: Thu, 05 Dec 2013 22:01:28 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linaro-acpi@lists.linaro.org,
        linux-acpi@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Jon Masters <jonathan@jonmasters.org>,
        Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [RFC part2 PATCH 8/9] ACPI / ARM64: Update acpi_register_gsi
 to register with the core IRQ subsystem
References: <1386088753-2850-1-git-send-email-hanjun.guo@linaro.org> <1386088753-2850-9-git-send-email-hanjun.guo@linaro.org> <201312050448.10312.arnd@arndb.de>
In-Reply-To: <201312050448.10312.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年12月05日 11:48, Arnd Bergmann wrote:
> On Tuesday 03 December 2013, Hanjun Guo wrote:
>> +       /*
>> +        * ACPI have no bindings to indicate SPI or PPI, so we
>> +        * use different mappings from DT in ACPI.
>> +        *
>> +        * For FDT
>> +        * PPI interrupt: in the range [0, 15];
>> +        * SPI interrupt: in the range [0, 987];
>> +        *
>> +        * For ACPI, using identity mapping for hwirq:
>> +        * PPI interrupt: in the range [16, 31];
>> +        * SPI interrupt: in the range [32, 1019];
> This difference might cause endless confusion. Can't you register PPI and SPI as
> separate IRQ controllers to have the same number space that we normally have?

In ACPI, they used a conception named GSI (Global System Interrupts)
for irq, GSI number can not be the same even if there are muti GICs,
so I use the identity mapping for hwirq for ACPI.

Thanks you very much for your comments :)

Hanjun
