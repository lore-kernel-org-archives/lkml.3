Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab3HFLwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 07:52:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:32993 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281Ab3HFLv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 07:51:58 -0400
Message-ID: <5200E358.9010505@ti.com>
Date: Tue, 6 Aug 2013 17:21:52 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <tony@atomide.com>, <george.cherian@ti.com>,
        <dmurphy@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] usb: musb: omap2430: Don't use omap_get_control_dev()
References: <1375365915-21380-1-git-send-email-rogerq@ti.com> <1375365915-21380-5-git-send-email-rogerq@ti.com>
In-Reply-To: <1375365915-21380-5-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 01 August 2013 07:35 PM, Roger Quadros wrote:
> omap_get_control_dev() is being deprecated as it doesn't support
> multiple instances. As control device is present only from OMAP4
> onwards which supports DT only, we use phandles to get the
> reference to the control device.
>
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>   drivers/usb/musb/omap2430.c |   22 ++++++++++++++++++----
>   1 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index ebb46ec..1db9588 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -38,6 +38,7 @@
>   #include <linux/delay.h>
>   #include <linux/usb/musb-omap.h>
>   #include <linux/usb/omap_control_usb.h>
> +#include <linux/of_platform.h>
>
>   #include "musb_core.h"
>   #include "omap2430.h"
> @@ -547,12 +548,25 @@ static int omap2430_probe(struct platform_device *pdev)
>   	}
>
>   	if (pdata->has_mailbox) {

I think you can remove this this check all together. Mailbox is present 
only from OMAP4 so it can be dt only.

Thanks
Kishon
