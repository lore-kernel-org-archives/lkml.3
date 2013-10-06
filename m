Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745Ab3JFVCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:02:10 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:44571 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab3JFVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:02:09 -0400
Message-ID: <5251DDDA.3070606@cogentembedded.com>
Date: Mon, 07 Oct 2013 00:02:02 +0200
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
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

Hello.

On 05-10-2013 0:30, David Cohen wrote:

> If USB_FUNCTIONFS is selected without USB_FUNCTIONFS_ETH and
> USB_FUNCTIONFS_RNIS, u_ether.h won't be included and then
> USB_ETHERNET_MODULE_PARAMAETERS macro won't be available causing the
> following warning compilation:

> drivers/usb/gadget/g_ffs.c:81:1: warning: data definition has no type or
> storage class [enabled by default]
> drivers/usb/gadget/g_ffs.c:81:1: warning: type defaults to ‘int’ in
> declaration of ‘USB_ETHERNET_MODULE_PARAMETERS’ [-Wimplicit-int]
> drivers/usb/gadget/g_ffs.c:81:1: warning: function declaration isn’t a
> prototype [-Wstrict-prototypes]

> This patch fixes the warning by making USB_ETHERNET_MODULE_PARAMETERS to
> be used iff u_ether.h is included, otherwise it is not needed.

> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>   drivers/usb/gadget/g_ffs.c | 2 ++
>   1 file changed, 2 insertions(+)

> diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
> index 5327c82..2344efe 100644
> --- a/drivers/usb/gadget/g_ffs.c
> +++ b/drivers/usb/gadget/g_ffs.c
> @@ -76,7 +76,9 @@ struct gfs_ffs_obj {
>
>   USB_GADGET_COMPOSITE_OPTIONS();
>
> +#if defined CONFIG_USB_FUNCTIONFS_ETH || defined CONFIG_USB_FUNCTIONFS_RNDIS

    I thought the 'defined' operator requires ()?

WBR, Sergei

