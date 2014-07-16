Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760200AbaGPI7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:59:30 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:34952 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933489AbaGPI7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:59:16 -0400
Date: Wed, 16 Jul 2014 09:59:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stuart Longland <stuartl@vrt.com.au>
Cc: Roman Fietze <roman.fietze@telemotive.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH] drivers/rtc/rtc-isl12022.c: Device tree support
Message-ID: <20140716085904.GA26951@leverpostej>
References: <1405477705-16885-1-git-send-email-stuartl@vrt.com.au>
 <1405477705-16885-2-git-send-email-stuartl@vrt.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405477705-16885-2-git-send-email-stuartl@vrt.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 03:28:25AM +0100, Stuart Longland wrote:
> Add some support for configuring isl12020/isl12022 devices using the
> Device Tree blob.
> 
> Signed-off-by: Stuart Longland <stuartl@vrt.com.au>

Please document this as with isl,isl12057, in
Documentation/devicetree/bindings/i2c/trivial-devices.txt

The string itself looks fine.

> ---
>  drivers/rtc/rtc-isl12022.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/drivers/rtc/rtc-isl12022.c b/drivers/rtc/rtc-isl12022.c
> index 03b8911..aa55f08 100644
> --- a/drivers/rtc/rtc-isl12022.c
> +++ b/drivers/rtc/rtc-isl12022.c
> @@ -17,6 +17,8 @@
>  #include <linux/slab.h>
>  #include <linux/module.h>
>  #include <linux/err.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
>  
>  #define DRV_VERSION "0.1"
>  
> @@ -271,6 +273,13 @@ static int isl12022_probe(struct i2c_client *client,
>  	return PTR_ERR_OR_ZERO(isl12022->rtc);
>  }
>  
> +#ifdef CONFIG_OF
> +static struct of_device_id isl12022_dt_match[] = {
> +	{ .compatible = "isl,isl12022" },
> +	{ },
> +};
> +#endif
> +
>  static const struct i2c_device_id isl12022_id[] = {
>  	{ "isl12022", 0 },
>  	{ }
> @@ -280,6 +289,9 @@ MODULE_DEVICE_TABLE(i2c, isl12022_id);
>  static struct i2c_driver isl12022_driver = {
>  	.driver		= {
>  		.name	= "rtc-isl12022",
> +#ifdef CONFIG_OF
> +		.of_match_table = of_match_ptr(isl12022_dt_match),
> +#endif

You can drop the ifdef here, of_match_ptr(x) is NULL if !CONFIG_OF.

Thanks,
Mark.
