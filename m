Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaJGJ4V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 05:56:21 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:57948 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbaJGJ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 05:56:19 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Message-ID: <5433B843.5060200@smartplayin.com>
Date: Tue, 07 Oct 2014 15:24:11 +0530
From: Kiran Padwal <kiran.padwal@smartplayin.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH 1/2] input: Add Qualcomm PM8941 power key driver
References: <1412644321-27683-1-git-send-email-bjorn.andersson@sonymobile.com> <1412644321-27683-2-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1412644321-27683-2-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 October 2014 06:42 AM, Bjorn Andersson wrote:
> From: Courtney Cavin <courtney.cavin@sonymobile.com>
> 
> Signed-off-by: Courtney Cavin <courtney.cavin@sonymobile.com>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  drivers/input/misc/Kconfig         |   12 +++
>  drivers/input/misc/Makefile        |    1 +
>  drivers/input/misc/pm8941-pwrkey.c |  196 ++++++++++++++++++++++++++++++++++++

<snip>

> +
> +	platform_set_drvdata(pdev, pwrkey);
> +	device_init_wakeup(&pdev->dev, 1);
> +
> +	return 0;
> +}
> +
> +static int pm8941_pwrkey_remove(struct platform_device *pdev)
> +{
> +	device_init_wakeup(&pdev->dev, 0);

Shouldn't we unregister input device?

> +
> +	return 0;
> +}
> +
> +static const struct of_device_id pm8941_pwr_key_id_table[] = {
> +	{ .compatible = "qcom,pm8941-pwrkey" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, pm8941_pwr_key_id_table);
> +
> +static struct platform_driver pm8941_pwrkey_driver = {
> +	.probe		= pm8941_pwrkey_probe,
> +	.remove		= pm8941_pwrkey_remove,
> +	.driver		= {
> +		.name	= "pm8941-pwrkey",
> +		.owner	= THIS_MODULE,

This field can be removed because this driver which use the
module_platform_driver api as this is overridden in
platform_driver_register.

> +		.pm	= &pm8941_pwr_key_pm_ops,
> +		.of_match_table = of_match_ptr(pm8941_pwr_key_id_table),
> +	},
> +};
> +module_platform_driver(pm8941_pwrkey_driver);
> +
> +MODULE_DESCRIPTION("PM8941 Power Key driver");
> +MODULE_LICENSE("GPL v2");

May be you can add module author name.

Thanks,
--Kiran
