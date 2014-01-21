Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749AbaAUDlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 22:41:02 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64054 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaAUDky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 22:40:54 -0500
Message-ID: <52DDEC3B.1000208@linaro.org>
Date: Tue, 21 Jan 2014 11:40:43 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Rutland <mark.rutland@arm.com>, Matthew Garrett <mjg59@srcf.ucam.org>,
        linaro-kernel@lists.linaro.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linaro-acpi@lists.linaro.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        patches@linaro.org, Olof Johansson <olof@lixom.net>,
        Charles.Garcia-Tobin@arm.com, Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH 06/20] ARM64 / ACPI: Introduce some PCI functions when
 PCI is enabled
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <4387274.ri38HmFxAV@wuerfel> <52DD2F23.2010109@linaro.org> <201401201939.53035.arnd@arndb.de>
In-Reply-To: <201401201939.53035.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-1-21 2:39, Arnd Bergmann wrote:
> On Monday 20 January 2014, Hanjun Guo wrote:
>>>> acpi_register_ioapic()/acpi_unregister_ioapic() will be used for IOAPIC
>>>> hotplug and GIC distributor is something like IOAPIC on x86, so I think
>>>> these two functions can be reserved for future use.
>>> But GIC is not hotplugged, is it? It still sounds x86 specific to me.
>>
>> Well, if we want to do physical CPU hotplug on ARM/ARM64 (maybe years 
>> later?),
>> then GIC add/remove is needed because we have to remove GIC
>> on the SoC too when we remove the physical CPU.
> 
> In general, I recommend not planning for the future in kernel code when you
> don't know what is going to happen. It's always easy enough to change
> things once you get there, as long as no stable ABI is involved.

Ok, I agree with you.

> 
> I just looked at the caller of these functions, and found a self-contained
> PCI driver in drivers/pci/ioapic.c, which uses two sepate PCI classes for
> ioapic and ioxapic. I think it's a safe assumption to say that even if we
> get ARM CPU+GIC hotplug, that would not use the same ioapic driver. This
> driver is currently marked X86-only, and that should probably stay this way,
> so you won't need the hooks.

Will find a suitable way to fix that in next version, thanks for you comments :)

Hanjun

