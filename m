Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3LCL7h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:59:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:58483 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752970Ab3LCL7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:59:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,817,1378882800"; 
   d="scan'208";a="443773103"
Date: Tue, 3 Dec 2013 13:59:27 +0200
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, swarren@wwwdotorg.org,
        ijc+devicetree@hellion.org.uk, rob@landley.net, bcousson@baylibre.com,
        tony@atomide.com, linux@arm.linux.org.uk, grant.likely@linaro.org,
        s.nawrocki@samsung.com, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY
 Framework
Message-ID: <20131203115927.GD26423@xps8300>
References: <1381866857-3861-1-git-send-email-kishon@ti.com>
 <1381866857-3861-3-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381866857-3861-3-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On Wed, Oct 16, 2013 at 01:24:12AM +0530, Kishon Vijay Abraham I wrote:
> +	count = of_property_match_string(node, "phy-names", "usb2-phy");
> +	if (count >= 0 || (pdata && pdata->usb2_generic_phy)) {
> +		dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
> +		if (IS_ERR(dwc->usb2_generic_phy)) {
> +			dev_err(dev, "no usb2 phy configured yet");
> +			return PTR_ERR(dwc->usb2_generic_phy);
> +		}
> +		dwc->usb2_phy = NULL;
> +	}
> +
> +	count = of_property_match_string(node, "phy-names", "usb3-phy");
> +	if (count >= 0 || (pdata && pdata->usb3_generic_phy)) {
> +		dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
> +		if (IS_ERR(dwc->usb3_generic_phy)) {
> +			dev_err(dev, "no usb3 phy configured yet");
> +			return PTR_ERR(dwc->usb3_generic_phy);
> +		}
> +		dwc->usb3_phy = NULL;
> +	}

Is there some specific reason for these checks? The driver should not
need to care about the platform (DT, ACPI, platform based).

Just get the phys and check the return value. In case ERR_PTR(-ENODEV)
leave the phy as NULL and let the driver continue normally. With other
errors you make the dwc3 probe fail.

Thanks,

-- 
heikki
