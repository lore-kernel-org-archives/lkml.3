Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3JDWfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 18:35:10 -0400
Received: from mga03.intel.com ([143.182.124.21]:51290 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab3JDWfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 18:35:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1036,1371106800"; 
   d="scan'208";a="370015798"
Message-ID: <524F438C.3090806@linux.intel.com>
Date: Fri, 04 Oct 2013 15:39:08 -0700
From: David Cohen <david.a.cohen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130929 Icedove/17.0.9
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] usb: g_ffs: fix compilation warning
References: <1380925821-12848-1-git-send-email-david.a.cohen@linux.intel.com>
In-Reply-To: <1380925821-12848-1-git-send-email-david.a.cohen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 10/04/2013 03:30 PM, David Cohen wrote:
> If USB_FUNCTIONFS is selected without USB_FUNCTIONFS_ETH and
> USB_FUNCTIONFS_RNIS, u_ether.h won't be included and then
> USB_ETHERNET_MODULE_PARAMAETERS macro won't be available causing the
> following warning compilation:
>
> drivers/usb/gadget/g_ffs.c:81:1: warning: data definition has no type or
> storage class [enabled by default]
> drivers/usb/gadget/g_ffs.c:81:1: warning: type defaults to ‘int’ in
> declaration of ‘USB_ETHERNET_MODULE_PARAMETERS’ [-Wimplicit-int]
> drivers/usb/gadget/g_ffs.c:81:1: warning: function declaration isn’t a
> prototype [-Wstrict-prototypes]
>
> This patch fixes the warning by making USB_ETHERNET_MODULE_PARAMETERS to
> be used iff u_ether.h is included, otherwise it is not needed.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>   drivers/usb/gadget/g_ffs.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
> index 5327c82..2344efe 100644
> --- a/drivers/usb/gadget/g_ffs.c
> +++ b/drivers/usb/gadget/g_ffs.c
> @@ -76,7 +76,9 @@ struct gfs_ffs_obj {
>
>   USB_GADGET_COMPOSITE_OPTIONS();
>
> +#if defined CONFIG_USB_FUNCTIONFS_ETH || defined CONFIG_USB_FUNCTIONFS_RNDIS
>   USB_ETHERNET_MODULE_PARAMETERS();

This warning happens on kernel v3.11+
But luckily it has no real effect on kernel despite the warning, so no 
tests would report it.

Br, David Cohen

> +#endif
>
>   static struct usb_device_descriptor gfs_dev_desc = {
>   	.bLength		= sizeof gfs_dev_desc,
>

