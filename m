Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab3LPJ10 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 04:27:26 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:33630 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129Ab3LPJ1Z convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Mon, 16 Dec 2013 04:27:25 -0500
Message-Id: <52AED587020000780010D866@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 16 Dec 2013 09:27:19 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: <gordan@bobich.net>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [RFC PATCH 3/5] xen-pciback: Document when we
 FLR an PCI device.
References: <1386950978-8628-1-git-send-email-konrad.wilk@oracle.com>
 <1386950978-8628-4-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386950978-8628-4-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.12.13 at 17:09, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> When the toolstack wants us to drop or add an PCI device it
> changes the XenBus state to Configuring - and as result of that
> we find out which devices we should still be exporting out and
> which ones not. For the ones we don't need anymore we need to
> do an PCI reset so that it is ready for the next guest.
> 
> We are already doing it - but it was not clear _how_
> it was done. This should make it more obvious.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
>...
> --- a/drivers/xen/xen-pciback/pci_stub.c
> +++ b/drivers/xen/xen-pciback/pci_stub.c
> @@ -267,18 +267,8 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
>  	/* Cleanup our device
>  	 * (so it's ready for the next domain)
>  	 */
> +	pcistub_reset_pci_dev(dev);
>  
> -	/* This is OK - we are running from workqueue context
> -	 * and want to inhibit the user from fiddling with 'reset'
> -	 */
> -	pci_reset_function(dev);
> -	pci_restore_state(dev);
> -
> -	/* This disables the device. */
> -	xen_pcibk_reset_device(dev);
> -
> -	/* And cleanup up our emulated fields. */
> -	xen_pcibk_config_reset_dev(dev);
>  	xen_pcibk_config_free_dyn_fields(dev);
>  
>  	xen_unregister_device_domain_owner(dev);

Does this really belong here? It's neither covered by the description,
nor can I see where pcistub_reset_pci_dev() would be defined (i.e.
afaict this ought to yield a build or load time error).

Jan

