Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaBYJSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:18:54 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51463 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbaBYJSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:18:49 -0500
Date: Tue, 25 Feb 2014 09:18:39 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Quadros <rogerq@ti.com>
Cc: tony@atomide.com, bcousson@baylibre.com, balbi@ti.com, nm@ti.com,
        khilman@linaro.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v8 03/14] mfd: omap-usb-host: Use clock names as per
 function for reference clocks
Message-ID: <20140225091839.GE19099@lee--X1>
References: <1392896409-5101-1-git-send-email-rogerq@ti.com>
 <1392896409-5101-4-git-send-email-rogerq@ti.com>
 <20140225085234.GB19099@lee--X1>
 <530C5C29.1090503@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <530C5C29.1090503@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Use a meaningful name for the reference clocks so that it indicates the function.
> >>
> >> CC: Lee Jones <lee.jones@linaro.org>
> >> CC: Samuel Ortiz <sameo@linux.intel.com>
> >> Signed-off-by: Roger Quadros <rogerq@ti.com>
> >> ---
> >>  drivers/mfd/omap-usb-host.c | 12 ++++++------
> >>  1 file changed, 6 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> >> index 865c276..651e249 100644
> >> --- a/drivers/mfd/omap-usb-host.c
> >> +++ b/drivers/mfd/omap-usb-host.c
> >> @@ -718,24 +718,24 @@ static int usbhs_omap_probe(struct platform_device *pdev)
> >>  		goto err_mem;
> >>  	}
> >>  
> >> -	omap->xclk60mhsp1_ck = devm_clk_get(dev, "xclk60mhsp1_ck");
> >> +	omap->xclk60mhsp1_ck = devm_clk_get(dev, "refclk_60m_ext_p1");
> >>  	if (IS_ERR(omap->xclk60mhsp1_ck)) {
> >>  		ret = PTR_ERR(omap->xclk60mhsp1_ck);
> >> -		dev_err(dev, "xclk60mhsp1_ck failed error:%d\n", ret);
> >> +		dev_err(dev, "refclk_60m_ext_p1 failed error:%d\n", ret);
> >>  		goto err_mem;
> >>  	}
> > 
> > Will anything break if I were to apply the MFD patches seperately?
> > 
> 
> Nothing will break for OMAP3, but OMAP4 USB host will break (e.g. Panda board).
> OMAP5 USB host was never working so it doesn't matter there.
> 
> To make sure nothing breaks, we need at least these 2 patches to go in together with mfd changes.
> 
> [PATCH v8 08/14] ARM: dts: omap4: Update omap-usb-host node
> [PATCH v8 09/14] ARM: dts: omap5: Update omap-usb-host node
> 
> Any suggestions about how we can proceed?

Yes, unfortunately you have to squash each of the patches into one
patch. Applying a patch which breaks a build, then applying another one
immediately after which subsequently fixes the break is not an acceptable
way of working I'm afraid. What would happen if we were to fall into
the middle of the two patches when bisecting?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
