Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaACBR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 20:17:59 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:59379 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbaACBR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:17:28 -0500
Date: Thu, 2 Jan 2014 17:17:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 06/10] Input: pm8xxx-vibrator - Add DT match table
Message-ID: <20140103011722.GA9300@core.coreip.homeip.net>
References: <1388709460-19222-1-git-send-email-sboyd@codeaurora.org>
 <1388709460-19222-7-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388709460-19222-7-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Thu, Jan 02, 2014 at 04:37:36PM -0800, Stephen Boyd wrote:
> The driver is only supported on DT enabled platforms. Convert the
> driver to DT so that it can probe properly.

I do not see MFD_PM8XXX depending on OF, should it be added if it only
supported on DT?

Thanks.

> 
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/input/misc/pm8xxx-vibrator.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/input/misc/pm8xxx-vibrator.c b/drivers/input/misc/pm8xxx-vibrator.c
> index 28251560249d..458d51b88be5 100644
> --- a/drivers/input/misc/pm8xxx-vibrator.c
> +++ b/drivers/input/misc/pm8xxx-vibrator.c
> @@ -142,6 +142,13 @@ static int pm8xxx_vib_play_effect(struct input_dev *dev, void *data,
>  	return 0;
>  }
>  
> +static const struct of_device_id pm8xxx_vib_id_table[] = {
> +	{ .compatible = "qcom,pm8058-vib" },
> +	{ .compatible = "qcom,pm8921-vib" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, pm8xxx_vib_id_table);
> +
>  static int pm8xxx_vib_probe(struct platform_device *pdev)
>  
>  {
> @@ -221,6 +228,7 @@ static struct platform_driver pm8xxx_vib_driver = {
>  		.name	= "pm8xxx-vib",
>  		.owner	= THIS_MODULE,
>  		.pm	= &pm8xxx_vib_pm_ops,
> +		.of_match_table = pm8xxx_vib_id_table,
>  	},
>  };
>  module_platform_driver(pm8xxx_vib_driver);
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 

-- 
Dmitry
