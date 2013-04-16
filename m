Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936191Ab3DPU12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 16:27:28 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:41732 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936130Ab3DPU1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 16:27:25 -0400
Date: Tue, 16 Apr 2013 13:27:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Jiang Liu <liuj97@gmail.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Jiang Liu <jiang.liu@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: [PATCH v9 09/16] PCI, x86: implement pcibios_{add|remove}_bus()
 hooks
In-Reply-To: <1365781470-32379-10-git-send-email-jiang.liu@huawei.com>
Message-ID: <alpine.DEB.2.02.1304161324500.30779@chino.kir.corp.google.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com> <1365781470-32379-10-git-send-email-jiang.liu@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Apr 2013, Jiang Liu wrote:

> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 901177d..305c68b 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -6,6 +6,7 @@
>  
>  #include <linux/sched.h>
>  #include <linux/pci.h>
> +#include <linux/pci-acpi.h>
>  #include <linux/ioport.h>
>  #include <linux/init.h>
>  #include <linux/dmi.h>
> @@ -170,6 +171,16 @@ void pcibios_fixup_bus(struct pci_bus *b)
>  		pcibios_fixup_device_resources(dev);
>  }
>  
> +void pcibios_add_bus(struct pci_bus *bus)
> +{
> +	acpi_pci_add_bus(bus);
> +}
> +
> +void pcibios_remove_bus(struct pci_bus *bus)
> +{
> +	acpi_pci_remove_bus(bus);
> +}
> +
>  /*
>   * Only use DMI information to set this if nothing was passed
>   * on the kernel command line (which was parsed earlier).

This causes build errors when CONFIG_ACPI isn't enabled since both 
acpi_pci_{add,remove}_bus() aren't defined in such a configuration:

arch/x86/pci/common.c: In function 'pcibios_add_bus':
arch/x86/pci/common.c:176:2: error: implicit declaration of function 'acpi_pci_add_bus'
arch/x86/pci/common.c: In function 'pcibios_remove_bus':
arch/x86/pci/common.c:181:2: error: implicit declaration of function 'acpi_pci_remove_bus'
