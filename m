Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743Ab3AYUp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 15:45:26 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:57255 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab3AYUpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 15:45:24 -0500
Date: Fri, 25 Jan 2013 13:45:21 -0700
From: Jerry Snitselaar <dev@snitselaar.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Abdallah Chatila <abdallah.chatila@ericsson.com>
Subject: Re: [ 11/15] ahci: Add identifiers for ASM106x devices
Message-ID: <20130125204521.GA1637@cantor.Home>
Reply-To: Jerry Snitselaar <dev@snitselaar.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
	Jeff Garzik <jgarzik@redhat.com>,
	Abdallah Chatila <abdallah.chatila@ericsson.com>
References: <20130124211723.489089115@linuxfoundation.org>
 <20130124211727.847446491@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124211727.847446491@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Jan 24 13, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Alan Cox <alan@linux.intel.com>
> 
> commit 7b4f6ecacb14f384adc1a5a67ad95eb082c02bd1 upstream.
> 
> They don't always appear as AHCI class devices but instead as IDE class.
> 
> Based on an initial patch by Hiroaki Nito
> 
> Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=42804
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Abdallah Chatila <abdallah.chatila@ericsson.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/ata/ahci.c      |    6 ++++++
>  include/linux/pci_ids.h |    2 ++
>  2 files changed, 8 insertions(+)
> 
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -402,6 +402,12 @@ static const struct pci_device_id ahci_p
>  	/* Promise */
>  	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
>  
> + 	/* Asmedia */
> +	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
> +	{ PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci },	/* ASM1060 */
> +	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
> +	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
> +
>  	/* Generic, PCI class code for AHCI */
>  	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
>  	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci },
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2390,6 +2390,8 @@
>  
>  #define PCI_VENDOR_ID_AZWAVE		0x1a3b
>  
> +#define PCI_VENDOR_ID_ASMEDIA		0x1b21
> +
>  #define PCI_VENDOR_ID_TEKRAM		0x1de1
>  #define PCI_DEVICE_ID_TEKRAM_DC290	0xdc29
>  
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

There is a whitespace error in this patch:

Applying: ahci: Add identifiers for ASM106x devices
/root/linux/linux/.git/rebase-apply/patch:12: space before tab in indent.
        /* Asmedia */
warning: 1 line adds whitespace errors.

