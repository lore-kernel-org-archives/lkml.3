Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaKGOr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:47:56 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:57381 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaKGOrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:47:55 -0500
Message-ID: <545CD9A4.3080900@linaro.org>
Date: Fri, 07 Nov 2014 15:39:32 +0100
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linaro-acpi@lists.linaro.org
CC: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        Liviu.Dudau@arm.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@rjwysocki.net, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-acpi] [RFC PATCH 3/4] arm64, acpi, pci: Add arch specific
 functions for mmconfig driver.
References: <1415366876-30811-1-git-send-email-tomasz.nowicki@linaro.org> <1415366876-30811-4-git-send-email-tomasz.nowicki@linaro.org> <16660879.6KxQndPqBW@wuerfel>
In-Reply-To: <16660879.6KxQndPqBW@wuerfel>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.11.2014 15:12, Arnd Bergmann wrote:
> On Friday 07 November 2014 14:27:55 Tomasz Nowicki wrote:
>> These calls allow to map/unmap PCI config space ranges (which are specified in
>> MMCFG ACPI table).
>>
>> Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
>>
>
> Nothing in this patch looks arm64 specific, and most of it looks like a
> copy of the x86 code.

Yes, most of the logic was borrowed from mmconfig_64.c file, 
mmconfig_32.c looks differently, though. It is not simple to merge them 
both. IMO, we have two choices:
1. Refactor and move mmconfig_64.c out of x86 to e.g. drivers/acpi/ and 
let it be default.
2. Stay with solution presented in this patch.
3. Thoughts ?

Regards,
Tomasz
