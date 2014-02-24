Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127AbaBXTSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 14:18:48 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:35627 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbaBXTSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 14:18:47 -0500
Date: Mon, 24 Feb 2014 14:18:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-kernel@vger.kernel.org,
        David Vrabel <david.vrabel@citrix.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] xen-pciback: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140224191831.GA7056@phenom.dumpdata.com>
References: <1392804931-30671-10-git-send-email-agordeev@redhat.com>
 <5304CC49.7020000@oracle.com>
 <5304D063.90000@oracle.com>
 <20140219160501.GA32067@dhcp-26-207.brq.redhat.com>
 <5304DABD.9000605@oracle.com>
 <20140221165235.GF17353@dhcp-26-207.brq.redhat.com>
 <20140221165340.GG17353@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221165340.GG17353@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 05:53:40PM +0100, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range()  or pci_enable_msi_exact()
> and pci_enable_msix_range() or pci_enable_msix_exact()
> interfaces.

What is this based on? Thanks.

> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: linux-pci@vger.kernel.org
> ---
>  drivers/xen/xen-pciback/pciback_ops.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/pciback_ops.c b/drivers/xen/xen-pciback/pciback_ops.c
> index 64eb0cd..929dd46 100644
> --- a/drivers/xen/xen-pciback/pciback_ops.c
> +++ b/drivers/xen/xen-pciback/pciback_ops.c
> @@ -213,8 +213,7 @@ int xen_pcibk_enable_msix(struct xen_pcibk_device *pdev,
>  		entries[i].vector = op->msix_entries[i].vector;
>  	}
>  
> -	result = pci_enable_msix(dev, entries, op->value);
> -
> +	result = pci_enable_msix_exact(dev, entries, op->value);
>  	if (result == 0) {
>  		for (i = 0; i < op->value; i++) {
>  			op->msix_entries[i].entry = entries[i].entry;
> -- 
> 1.7.7.6
> 
> -- 
> Regards,
> Alexander Gordeev
> agordeev@redhat.com
