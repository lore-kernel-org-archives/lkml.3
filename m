Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933479Ab3CNBw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 21:52:27 -0400
Received: from mga11.intel.com ([192.55.52.93]:20520 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755196Ab3CNBwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 21:52:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,840,1355126400"; 
   d="scan'208";a="302301494"
Date: Thu, 14 Mar 2013 10:01:23 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, htejun@gmail.com, ming.lei@canonical.com,
        sshtylyov@mvista.com, lpechacek@suse.cz, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, seth.heasley@intel.com, jlee@suse.com,
        james.d.ralston@intel.com, stable@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>, youquan.song@intel.com
Subject: Re: [PATCH v3] ata: Fix DVD not dectected at some Haswell platforms
Message-ID: <20130314140123.GA19289@linux-youquan.bj.intel.com>
References: <1362584945-10202-1-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362584945-10202-1-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maintainer,

Can you look at the patch which required by some Haswell platforms?

Thanks
-Youquan

On Wed, Mar 06, 2013 at 10:49:05AM -0500, Youquan Song wrote:
> There is a quirk patch 5e5a4f5d5a08c9c504fe956391ac3dae2c66556d 
> "ata_piix: make DVD Drive recognisable on systems with Intel Sandybridge
>  chipsets(v2)" fixing the 4 ports IDE controller 32bit PIO mode. 
> 
> We've hit a problem with DVD not recognized on Haswell Desktop platform which
> includes Lynx Point 2-port SATA controller.
> 
> This quirk patch disables 32bit PIO on this controller in IDE mode.
> 
> v2: Change spelling error in statememnt pointed by Sergei Shtylyov.
> v3: Change comment statememnt and spliting line over 80 characters pointed by
>     Libor Pechacek and also rebase the patch against 3.8-rc7 kernel.
> 
> Tested-by: Lee, Chun-Yi <jlee@suse.com>
> Signed-off-by: Youquan Song <youquan.song@intel.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/ata/ata_piix.c |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
> index 174eca6..4aab550 100644
> --- a/drivers/ata/ata_piix.c
> +++ b/drivers/ata/ata_piix.c
> @@ -150,6 +150,7 @@ enum piix_controller_ids {
>  	tolapai_sata,
>  	piix_pata_vmw,			/* PIIX4 for VMware, spurious DMA_ERR */
>  	ich8_sata_snb,
> +	ich8_2port_sata_snb,
>  };
>  
>  struct piix_map_db {
> @@ -304,7 +305,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
>  	/* SATA Controller IDE (Lynx Point) */
>  	{ 0x8086, 0x8c01, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
>  	/* SATA Controller IDE (Lynx Point) */
> -	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
> +	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
>  	/* SATA Controller IDE (Lynx Point) */
>  	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
>  	/* SATA Controller IDE (Lynx Point-LP) */
> @@ -422,6 +423,7 @@ static const struct piix_map_db *piix_map_db_table[] = {
>  	[ich8m_apple_sata]	= &ich8m_apple_map_db,
>  	[tolapai_sata]		= &tolapai_map_db,
>  	[ich8_sata_snb]		= &ich8_map_db,
> +	[ich8_2port_sata_snb]	= &ich8_2port_map_db,
>  };
>  
>  static struct pci_bits piix_enable_bits[] = {
> @@ -1225,6 +1227,16 @@ static struct ata_port_info piix_port_info[] = {
>  		.udma_mask	= ATA_UDMA6,
>  		.port_ops	= &piix_sata_ops,
>  	},
> +
> +	[ich8_2port_sata_snb] =
> +	{
> +		.flags		= PIIX_SATA_FLAGS | PIIX_FLAG_SIDPR
> +					| PIIX_FLAG_PIO16,
> +		.pio_mask	= ATA_PIO4,
> +		.mwdma_mask	= ATA_MWDMA2,
> +		.udma_mask	= ATA_UDMA6,
> +		.port_ops	= &piix_sata_ops,
> +	},
>  };
>  
>  #define AHCI_PCI_BAR 5
> -- 
> 1.7.7.4
> 
> 
