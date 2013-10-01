Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab3JAQBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 12:01:32 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:51189 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab3JAQAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 12:00:21 -0400
Date: Tue, 1 Oct 2013 09:00:14 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 25/28] PCI, x86: Make ioapic hotplug support built-in
Message-ID: <20131001160014.GA7438@google.com>
References: <1376189294-32022-1-git-send-email-yinghai@kernel.org>
 <1376189294-32022-26-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376189294-32022-26-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 07:48:11PM -0700, Yinghai Lu wrote:
> ioapic hotplug should be built-in like pci root bus hotplug.
> 
> Also need to make it depends on X86_IO_APIC.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

Hi Yinghai,

What's the status of these?  It looks like the last three or four
could go via my PCI tree, but I don't know whether they depend on
the earlier patches.  If they could be applied separately, I could
merge them and we could make *some* progress.

Also, it looks like you planned some rework related to _UID and
resource parsing, so I've been waiting for that to show up before
doing much more.

Bjorn

> ---
>  drivers/pci/Kconfig  | 3 ++-
>  drivers/pci/ioapic.c | 6 +++++-
>  2 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 81944fb..6c9ede2 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -109,9 +109,10 @@ config PCI_PASID
>  	  If unsure, say N.
>  
>  config PCI_IOAPIC
> -	tristate "PCI IO-APIC hotplug support" if X86
> +	bool "PCI IO-APIC hotplug support" if X86
>  	depends on PCI
>  	depends on ACPI
> +	depends on X86_IO_APIC
>  	default !X86
>  
>  config PCI_LABEL
> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> index 1b90579..7d6b157 100644
> --- a/drivers/pci/ioapic.c
> +++ b/drivers/pci/ioapic.c
> @@ -113,6 +113,10 @@ static struct pci_driver ioapic_driver = {
>  	.remove		= ioapic_remove,
>  };
>  
> -module_pci_driver(ioapic_driver);
> +static int __init ioapic_init(void)
> +{
> +	return pci_register_driver(&ioapic_driver);
> +}
> +module_init(ioapic_init);
>  
>  MODULE_LICENSE("GPL");
> -- 
> 1.8.1.4
> 
