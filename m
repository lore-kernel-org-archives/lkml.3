Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab3LPJXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:23:39 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33486 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3LPJXh convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 16 Dec 2013 04:23:37 -0500
Message-Id: <52AED4A3020000780010D863@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 16 Dec 2013 09:23:31 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <gordan@bobich.net>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC PATCH 2/5] xen-pciback: First reset, then
 free.
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
 <1386950978-8628-3-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386950978-8628-3-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.12.13 at 17:09, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> We were doing the operations of freeing and reset in the wrong
> order. Granted nothing broke b/c the reset functions just
> set bar->which = 0.
> 
> But nonethless this was incorrect.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

> ---
>  drivers/xen/xen-pciback/pci_stub.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/xen/xen-pciback/pci_stub.c 
> b/drivers/xen/xen-pciback/pci_stub.c
> index 5300a21..36dd4f3 100644
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -278,8 +278,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>  	xen_pcibk_reset_device(dev);
>  
>  	/* And cleanup up our emulated fields. */
> -	xen_pcibk_config_free_dyn_fields(dev);
>  	xen_pcibk_config_reset_dev(dev);
> +	xen_pcibk_config_free_dyn_fields(dev);
>  
>  	xen_unregister_device_domain_owner(dev);
>  
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



