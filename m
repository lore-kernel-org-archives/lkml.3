Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab3LPJTJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:19:09 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33254 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3LPJTH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 16 Dec 2013 04:19:07 -0500
Message-Id: <52AED394020000780010D850@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 16 Dec 2013 09:19:00 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <gordan@bobich.net>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC PATCH 1/5] xen-pciback: Cleanup up
 pcistub_put_pci_dev
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
 <1386950978-8628-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386950978-8628-2-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.12.13 at 17:09, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> We are using both psdev->dev and dev and both are the same.
> To keep it straight lets just use one - dev.

This should properly describe the patch, which otherwise at the
first glance looks wrong: You're also replacing found_psdev->dev.

> This will also make it easier in the patch:
> "xen/pciback: When reconfiguring an PCIe device, FLR it"
> and "xen/pciback: PCI reset slot or bus" to use it.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Apart from the above,
Reviewed-by: Jan Beulich <jbeulich@suse.com>

> ---
>  drivers/xen/xen-pciback/pci_stub.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/xen/xen-pciback/pci_stub.c 
> b/drivers/xen/xen-pciback/pci_stub.c
> index 62fcd48..5300a21 100644
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -272,16 +272,16 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>  	 * and want to inhibit the user from fiddling with 'reset'
>  	 */
>  	pci_reset_function(dev);
> -	pci_restore_state(psdev->dev);
> +	pci_restore_state(dev);
>  
>  	/* This disables the device. */
> -	xen_pcibk_reset_device(found_psdev->dev);
> +	xen_pcibk_reset_device(dev);
>  
>  	/* And cleanup up our emulated fields. */
> -	xen_pcibk_config_free_dyn_fields(found_psdev->dev);
> -	xen_pcibk_config_reset_dev(found_psdev->dev);
> +	xen_pcibk_config_free_dyn_fields(dev);
> +	xen_pcibk_config_reset_dev(dev);
>  
> -	xen_unregister_device_domain_owner(found_psdev->dev);
> +	xen_unregister_device_domain_owner(dev);
>  
>  	spin_lock_irqsave(&found_psdev->lock, flags);
>  	found_psdev->pdev = NULL;
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



