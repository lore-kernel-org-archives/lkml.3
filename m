Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3GXS0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 14:26:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:8934 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab3GXS0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 14:26:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,736,1367996400"; 
   d="scan'208";a="375809063"
Date: Wed, 24 Jul 2013 11:26:35 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: xhci: Mark two functions __maybe_unused
Message-ID: <20130724182635.GI5289@xanatos>
References: <1374605900-29700-1-git-send-email-olof@lixom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374605900-29700-1-git-send-email-olof@lixom.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 11:58:20AM -0700, Olof Johansson wrote:
> Resolves the following build warnings:
> drivers/usb/host/xhci.c:332:13: warning: 'xhci_msix_sync_irqs' defined but not used [-Wunused-function]
> drivers/usb/host/xhci.c:3901:12: warning: 'xhci_change_max_exit_latency' defined but not used [-Wunused-function]
> 
> These functions are not always used, and since they're marked static
> they will produce build warnings:
> - xhci_msix_sync_irqs is only used with CONFIG_PCI.
> - xhci_change_max_exit_latency is a little more complicated with
>   dependencies on CONFIG_PM and CONFIG_PM_RUNTIME.
> 
> Instead of building a bigger maze of ifdefs in this code, I've just
> marked both with __maybe_unused.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>
> ---
> 
> Sarah,
> 
> I guess taste might differ on ifdef vs __maybe_unused, let me know this
> is not to your liking.

__maybe_unused is fine, I will queue this up shortly.

Sarah Sharp

> 
> Thanks,
> 
> -Olof
> 
>  drivers/usb/host/xhci.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
> index 2c49f00..87ae8cd 100644
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -329,7 +329,7 @@ static void xhci_cleanup_msix(struct xhci_hcd *xhci)
>  	return;
>  }
>  
> -static void xhci_msix_sync_irqs(struct xhci_hcd *xhci)
> +static void __maybe_unused xhci_msix_sync_irqs(struct xhci_hcd *xhci)
>  {
>  	int i;
>  
> @@ -3898,7 +3898,7 @@ int xhci_find_raw_port_number(struct usb_hcd *hcd, int port1)
>   * Issue an Evaluate Context command to change the Maximum Exit Latency in the
>   * slot context.  If that succeeds, store the new MEL in the xhci_virt_device.
>   */
> -static int xhci_change_max_exit_latency(struct xhci_hcd *xhci,
> +static int __maybe_unused xhci_change_max_exit_latency(struct xhci_hcd *xhci,
>  			struct usb_device *udev, u16 max_exit_latency)
>  {
>  	struct xhci_virt_device *virt_dev;
> -- 
> 1.7.10.4
> 
