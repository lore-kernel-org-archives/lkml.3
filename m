Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385AbaATSkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:40:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50904 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaATSk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:40:28 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Hanjun Guo <hanjun.guo@linaro.org>
Subject: Re: [PATCH 06/20] ARM64 / ACPI: Introduce some PCI functions when PCI is enabled
Date: Mon, 20 Jan 2014 19:39:52 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linaro-kernel@lists.linaro.org, Mark Rutland <mark.rutland@arm.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Rob Herring <robh@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org, linux-acpi@vger.kernel.org,
        patches@linaro.org, Grant Likely <grant.likely@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-arm-kernel@lists.infradead.org, Charles.Garcia-Tobin@arm.com
References: <1389961514-13562-1-git-send-email-hanjun.guo@linaro.org> <4387274.ri38HmFxAV@wuerfel> <52DD2F23.2010109@linaro.org>
In-Reply-To: <52DD2F23.2010109@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201401201939.53035.arnd@arndb.de>
X-Provags-ID: V02:K0:arV9etJoR3luTBUvdR06Qtd+PKHhixOcdIW7rplzKlN
 PwldnGKVldlB/3pyvZ0FHVcQZBh19H3wxg6vGIET1TLWXrKShl
 QXSGdp31QBLu9vcqTx9qmQI1i0tagD+ap29vm7Gg3q/f/ictHc
 q3oEKZq2m5o/EU5A0qbJRdjMqfNXqmmQE6TqEQKSOfudsm7v6K
 j2nIwKl5wQ6b+Q7+5wD5uK/YenDurYtkA3h6EF37nCDImpNv7K
 tD9tUq3bmOuTD8/tibjU1n59GMMtKiC4B4IzRqeTWKtAGCSrQI
 H+/nsVFYAL1oBY21lAFOd3LDma6fW9cvs46LTWnKZzSquUDjlZ
 beEo3kWdGhuTo2iKUH8g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 January 2014, Hanjun Guo wrote:
> >> acpi_register_ioapic()/acpi_unregister_ioapic() will be used for IOAPIC
> >> hotplug and GIC distributor is something like IOAPIC on x86, so I think
> >> these two functions can be reserved for future use.
> > But GIC is not hotplugged, is it? It still sounds x86 specific to me.
> 
> Well, if we want to do physical CPU hotplug on ARM/ARM64 (maybe years 
> later?),
> then GIC add/remove is needed because we have to remove GIC
> on the SoC too when we remove the physical CPU.

In general, I recommend not planning for the future in kernel code when you
don't know what is going to happen. It's always easy enough to change
things once you get there, as long as no stable ABI is involved.

I just looked at the caller of these functions, and found a self-contained
PCI driver in drivers/pci/ioapic.c, which uses two sepate PCI classes for
ioapic and ioxapic. I think it's a safe assumption to say that even if we
get ARM CPU+GIC hotplug, that would not use the same ioapic driver. This
driver is currently marked X86-only, and that should probably stay this way,
so you won't need the hooks.

	Arnd
