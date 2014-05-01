Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754452AbaEAJ1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 05:27:32 -0400
Received: from cpsmtpb-ews04.kpnxchange.com ([213.75.39.7]:53145 "EHLO
	cpsmtpb-ews04.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753063AbaEAJ1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 05:27:30 -0400
Message-ID: <1398936447.4121.12.camel@x220>
Subject: Re: [4/5] IBM Akebono: Add the Akebono platform
From: Paul Bolle <pebolle@tiscali.nl>
To: Alistair Popple <alistair@popple.id.au>
Cc: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Thu, 01 May 2014 11:27:27 +0200
In-Reply-To: <1394077948-8395-5-git-send-email-alistair@popple.id.au>
References: <1394077948-8395-5-git-send-email-alistair@popple.id.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 May 2014 09:27:28.0143 (UTC) FILETIME=[91CB11F0:01CF651F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 14:52 +1100, Alistair Popple wrote:
> This patch adds support for the IBM Akebono board.

This patch just landed in linux-next (ie, in next-20140501).

> Signed-off-by: Alistair Popple <alistair@popple.id.au>
>[...]
> --- a/arch/powerpc/platforms/44x/Kconfig
> +++ b/arch/powerpc/platforms/44x/Kconfig
> @@ -199,6 +199,32 @@ config CURRITUCK
>  	help
>  	  This option enables support for the IBM Currituck (476fpe) evaluation board
>  
> +config AKEBONO
> +	bool "IBM Akebono (476gtr) Support"
> +	depends on PPC_47x
> +	default n
> +	select SWIOTLB
> +	select 476FPE
> +	select PPC4xx_PCI_EXPRESS
> +	select I2C
> +	select I2C_IBM_IIC
> +	select NETDEVICES
> +	select ETHERNET
> +	select NET_VENDOR_IBM
> +	select IBM_EMAC_EMAC4
> +	select IBM_EMAC_RGMII_WOL

The patch that added this symbol (and the related driver) was submitted
in https://lkml.org/lkml/2014/2/21/25 . It's not (yet) included in
linux-next. Is it queued somewhere else?

> +	select USB
> +	select USB_OHCI_HCD_PLATFORM
> +	select USB_EHCI_HCD_PLATFORM
> +	select MMC_SDHCI
> +	select MMC_SDHCI_PLTFM
> +	select MMC_SDHCI_OF_476GTR

The plan to add MMC_SDHCI_OF_476GTR seems to have been abandoned (see
the discussion of https://lkml.org/lkml/2014/2/21/24 ). So this select
is not needed. Should I submit a trivial patch to drop this select?

> +	select ATA
> +	select SATA_AHCI_PLATFORM
> +	help
> +	  This option enables support for the IBM Akebono (476gtr) evaluation board
> +
> +
>  config ICON
>  	bool "Icon"
>  	depends on 44x


Paul Bolle

