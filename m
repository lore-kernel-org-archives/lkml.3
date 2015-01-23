Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756652AbbAWU0Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 15:26:25 -0500
Received: from violet.fr.zoreil.com ([92.243.8.30]:40565 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753191AbbAWU0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 15:26:22 -0500
Date: Fri, 23 Jan 2015 21:26:19 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Jay Cliburn <jcliburn@gmail.com>, Chris Snook <chris.snook@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atheros/atlx: Simplify bit manipulations
Message-ID: <20150123202619.GA10084@electric-eye.fr.zoreil.com>
References: <1422011212-30095-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1422011212-30095-1-git-send-email-linux@rasmusvillemoes.dk>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rasmus Villemoes <linux@rasmusvillemoes.dk> :
[...]
> diff --git a/drivers/net/ethernet/atheros/atlx/atl2.c b/drivers/net/ethernet/atheros/atlx/atl2.c
> index 84a09e8ddd9c..46d1b959daa8 100644
> --- a/drivers/net/ethernet/atheros/atlx/atl2.c
> +++ b/drivers/net/ethernet/atheros/atlx/atl2.c
> @@ -1278,14 +1278,10 @@ static void atl2_setup_pcicmd(struct pci_dev *pdev)
>  
>  	pci_read_config_word(pdev, PCI_COMMAND, &cmd);
>  
> -	if (cmd & PCI_COMMAND_INTX_DISABLE)
> -		cmd &= ~PCI_COMMAND_INTX_DISABLE;
> -	if (cmd & PCI_COMMAND_IO)
> -		cmd &= ~PCI_COMMAND_IO;
> -	if (0 == (cmd & PCI_COMMAND_MEMORY))
> -		cmd |= PCI_COMMAND_MEMORY;
> -	if (0 == (cmd & PCI_COMMAND_MASTER))
> -		cmd |= PCI_COMMAND_MASTER;
> +	cmd &= ~PCI_COMMAND_INTX_DISABLE;
> +	cmd &= ~PCI_COMMAND_IO;
> +	cmd |= PCI_COMMAND_MEMORY;
> +	cmd |= PCI_COMMAND_MASTER;
>  	pci_write_config_word(pdev, PCI_COMMAND, cmd);

Mostly open-coded pci_set_master, pci_enable_device_mem and pci_intx.

I'd suggest to ignore the PCI_COMMAND_IO bit at all then use the standard
pci helpers.

-- 
Ueimor
