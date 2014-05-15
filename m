Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaEOS5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 14:57:06 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:47358 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaEOS5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 14:57:05 -0400
MIME-Version: 1.0
In-Reply-To: <1400173652-30583-1-git-send-email-pawel.moll@arm.com>
References: <1400173652-30583-1-git-send-email-pawel.moll@arm.com>
Date: Thu, 15 May 2014 13:57:04 -0500
Message-ID: <CAL_JsqJotigd1vtj+iOecVMkF79xUxT2i8YxcUgta35RRqDMrw@mail.gmail.com>
Subject: Re: [PATCH] amba: Put the device's of_node on its release
From: Rob Herring <robherring2@gmail.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Russell King <linux@arm.linux.org.uk>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 15, 2014 at 12:07 PM, Pawel Moll <pawel.moll@arm.com> wrote:
> An amba device created from Device Tree, when released, does not
> decrease of_node's reference counter.
>
> Fixed by adding a call to of_device_node_put() on the release
> path, in a similar way to what platform_device_release() is doing.
>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Acked-by: Rob Herring <robh@kernel.org>

Does this go with the rest of your series? Who needs to pick this up?

Rob

> ---
>  drivers/amba/bus.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/amba/bus.c b/drivers/amba/bus.c
> index 3cf61a1..0f489fb 100644
> --- a/drivers/amba/bus.c
> +++ b/drivers/amba/bus.c
> @@ -17,6 +17,7 @@
>  #include <linux/pm_runtime.h>
>  #include <linux/amba/bus.h>
>  #include <linux/sizes.h>
> +#include <linux/of_device.h>
>
>  #include <asm/irq.h>
>
> @@ -268,6 +269,7 @@ static void amba_device_release(struct device *dev)
>  {
>         struct amba_device *d = to_amba_device(dev);
>
> +       of_device_node_put(dev);
>         if (d->res.parent)
>                 release_resource(&d->res);
>         kfree(d);
> --
> 1.9.1
>
