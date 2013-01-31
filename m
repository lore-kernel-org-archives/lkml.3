Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506Ab3AaLef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:34:35 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:47414 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab3AaLec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:34:32 -0500
Message-ID: <510A56BF.3040804@ti.com>
Date: Thu, 31 Jan 2013 17:04:23 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <balbi@ti.com>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt
 node.
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 31 January 2013 04:50 PM, Vivek Gautam wrote:
> With device tree support in place for dwc3-core layer,
> it gets PHY from "synopsis-dwc3" node.
> Some controllers may not have separate memory maps and interrupts
> for dwc3 core and platform glue layers. In such case only glue
> layer's node will exist.

Not really. As long as you have dwc3 core as a separate device, you can 
add a node for it.
Just that the glue should create a device for dwc3 core using 
of_platform_populate.(You can have a look at 
drivers/usb/dwc3/dwc3-omap.c in usb-next)
> Moreover, SoCs having multiple dwc3 controllers will have multiple
> PHYs, which eventually be added using usb_add_phy_dev(), and not
> using usb_add_phy(). So each dwc3 controller won't be able to
> get PHYs by simply calling devm_usb_get_phy() also.
No. We have added usb_get_phy_dev() for that purpose in the case of non-dt.
I think, instead you can have a patch to use devm_usb_get_phy_dev() here 
and in exynos platform specific code use usb_bind_phy() to bind the phy 
and controller till you change it to dt.
> In such cases, dwc3 should expect PHYs from its parent's node.
NAK.

Thanks
Kishon
