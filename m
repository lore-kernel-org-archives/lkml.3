Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514AbaBROLX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:11:23 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:59548 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298AbaBROLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:11:21 -0500
Date: Tue, 18 Feb 2014 08:08:54 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 2/3] usb: chipidea: msm: Add device tree support
Message-ID: <20140218140854.GC31116@joshc.qualcomm.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
 <1392729681-21022-3-git-send-email-iivanov@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392729681-21022-3-git-send-email-iivanov@mm-sol.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Ivan-

Nit below.

On Tue, Feb 18, 2014 at 03:21:20PM +0200, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Allows controller to be specified via device tree.
> Pass PHY phandle specified in DT to core driver.
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> ---
>  drivers/usb/chipidea/ci_hdrc_msm.c |   23 ++++++++++++++++++++++-
>  1 file changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/chipidea/ci_hdrc_msm.c b/drivers/usb/chipidea/ci_hdrc_msm.c
> index 2d51d85..3f67f1f 100644
> --- a/drivers/usb/chipidea/ci_hdrc_msm.c
> +++ b/drivers/usb/chipidea/ci_hdrc_msm.c
> @@ -57,9 +57,21 @@ static struct ci_hdrc_platform_data ci_hdrc_msm_platdata = {
>  static int ci_hdrc_msm_probe(struct platform_device *pdev)
>  {
>  	struct platform_device *plat_ci;
> +	struct usb_phy *phy;
>  
>  	dev_dbg(&pdev->dev, "ci_hdrc_msm_probe\n");
>  
> +	/*
> +	 * OTG(PHY) driver takes care of PHY initialization, clock management,
> +	 * powering up VBUS, mapping of registers address space and power
> +	 * management.
> +	 */
> +	phy = devm_usb_get_phy_by_phandle(&pdev->dev, "usb-phy", 0);
> +	if (IS_ERR(phy))
> +		return PTR_ERR(phy);
> +
> +	ci_hdrc_msm_platdata.phy = phy;
> +
>  	plat_ci = ci_hdrc_add_device(&pdev->dev,
>  				pdev->resource, pdev->num_resources,
>  				&ci_hdrc_msm_platdata);
> @@ -86,10 +98,19 @@ static int ci_hdrc_msm_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +static struct of_device_id msm_ci_dt_match[] = {

const?

> +	{ .compatible = "qcom,ci-hdrc", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, msm_ci_dt_match);

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
