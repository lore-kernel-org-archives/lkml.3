Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751853AbaKEWKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:10:08 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:36747 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaKEWKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:10:05 -0500
Date: Wed, 5 Nov 2014 15:10:01 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 18/31] PCI/MSI, trivial: Fix minor syntax issues
 according to coding styles
Message-ID: <20141105221001.GD6168@google.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <1415102525-9898-19-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415102525-9898-19-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:01:52PM +0800, Jiang Liu wrote:
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Needs a changelog, even if it's similar to the topic.

Speaking of the topic, please run "git log --oneline drivers/pci/msi.c" and
make yours look similar to the others.  This doesn't really fix a syntax
issue; the existing code is syntactically correct.  It's only a style
issue.

I'd say something like:

  PCI/MSI: Remove unnecessary braces around single statements

  Per Documentation/CodingStyle, don't use braces around single statements.

> ---
>  drivers/pci/msi.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 9fab30af0e75..fb2ccb536324 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -244,9 +244,8 @@ void default_restore_msi_irqs(struct pci_dev *dev)
>  {
>  	struct msi_desc *entry;
>  
> -	list_for_each_entry(entry, &dev->msi_list, list) {
> +	list_for_each_entry(entry, &dev->msi_list, list)
>  		default_restore_msi_irq(dev, entry->irq);
> -	}
>  }
>  
>  void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
> @@ -451,9 +450,8 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
>  				PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL);
>  
>  	arch_restore_msi_irqs(dev);
> -	list_for_each_entry(entry, &dev->msi_list, list) {
> +	list_for_each_entry(entry, &dev->msi_list, list)
>  		msix_mask_irq(entry, entry->masked);
> -	}
>  
>  	msix_clear_and_set_ctrl(dev, PCI_MSIX_FLAGS_MASKALL, 0);
>  }
> @@ -497,9 +495,8 @@ static int populate_msi_sysfs(struct pci_dev *pdev)
>  	int count = 0;
>  
>  	/* Determine how many msi entries we have */
> -	list_for_each_entry(entry, &pdev->msi_list, list) {
> +	list_for_each_entry(entry, &pdev->msi_list, list)
>  		++num_msi;
> -	}
>  	if (!num_msi)
>  		return 0;
>  
> -- 
> 1.7.10.4
> 
