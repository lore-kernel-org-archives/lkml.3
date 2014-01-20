Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbaATIVV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:21:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62279 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaATIVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:21:18 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linaro-kernel@lists.linaro.org
Cc: Hanjun Guo <hanjun.guo@linaro.org>, Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Rob Herring <robh@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, linux-acpi@vger.kernel.org,
        patches@linaro.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, Charles.Garcia-Tobin@arm.com
Subject: Re: [PATCH 06/20] ARM64 / ACPI: Introduce some PCI functions when PCI is enabled
Date: Mon, 20 Jan 2014 09:20:49 +0100
Message-ID: <4387274.ri38HmFxAV@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <52DCD961.70303@linaro.org>
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <201401171504.24525.arnd@arndb.de> <52DCD961.70303@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:D3hIGvlBxGc6UiJDt5aWsqargzcqEySQOF9wUwsPSab
 0UF4kJhnBhJ+P8AVCauKFejXNqr27dLCVukX/mo0KvtUeVds+V
 8uWCsAc+5AiWtb2lptpFLgTlm5pMK2b0eyhUXHOkbLBFF5WAq6
 Qor3/2SfzH+htL/X1/0eJYbudlMsEPO/d21AbHcz2bhHaD2aZo
 4zjzIqqy9Ws3AE0hfYD41VS9OrF07SGVqtQ06cmmacc9CLcWhO
 eAflmRj+dVIuwrHk0dUplqgT1u4+OvnFmhkQxYTf1HMMkGdK0o
 PalHd4Ht2bv9YjzHvSrJK18OzsWlVGSqIW3r44gereBA8xJbiB
 cKz1xGuK9s238rkrrg/4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 January 2014 16:08:01 Hanjun Guo wrote:
> >> diff --git a/drivers/acpi/plat/arm-core.c b/drivers/acpi/plat/arm-core.c
> >> index 3c8521d..1835b21 100644
> >> --- a/drivers/acpi/plat/arm-core.c
> >> +++ b/drivers/acpi/plat/arm-core.c
> >> @@ -100,6 +100,25 @@ int acpi_gsi_to_irq(u32 gsi, unsigned int *irq)
> >>  }
> >>  EXPORT_SYMBOL_GPL(acpi_gsi_to_irq);
> >>  
> >> +int acpi_isa_irq_to_gsi(unsigned isa_irq, u32 *gsi)
> >> +{
> >> +    return -1;
> >> +}
> >> +
> >> +int acpi_register_ioapic(acpi_handle handle, u64 phys_addr, u32 gsi_base)
> >> +{
> >> +    /* TBD */
> >> +    return -EINVAL;
> >> +}
> >> +EXPORT_SYMBOL(acpi_register_ioapic);
> >> +
> >> +int acpi_unregister_ioapic(acpi_handle handle, u32 gsi_base)
> >> +{
> >> +    /* TBD */
> >> +    return -EINVAL;
> >> +}
> >> +EXPORT_SYMBOL(acpi_unregister_ioapic);
> >> +
> > 
> > My feeling is that these are better handled in the ACPI code by not
> > calling them on architectures that have no ISA or no IOAPIC support.
> > 
> > We have configuration symbols for both, so you don't have to make
> > it depend on CONFIG_ARM64 or CONFIG_X86.
> 
> Do you mean introduce a stub function when there is no ISA support?

Do you anticipate ISA devices on ARM64? I hope not ;-)

My guess is that whatever code calls this function should be disabled
in reduced hw mode.

> acpi_register_ioapic()/acpi_unregister_ioapic() will be used for IOAPIC
> hotplug and GIC distributor is something like IOAPIC on x86, so I think
> these two functions can be reserved for future use.

But GIC is not hotplugged, is it? It still sounds x86 specific to me.

	Arnd
