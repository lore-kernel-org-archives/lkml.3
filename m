Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3LCOOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:14:32 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34210 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab3LCOO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:14:27 -0500
Message-ID: <529DE711.2090008@ti.com>
Date: Tue, 3 Dec 2013 19:43:37 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Heikki Krogerus <heikki.krogerus@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 2/7] usb: dwc3: adapt dwc3 core to use Generic PHY
 Framework
References: <1381866857-3861-1-git-send-email-kishon@ti.com> <1381866857-3861-3-git-send-email-kishon@ti.com> <20131203115927.GD26423@xps8300>
In-Reply-To: <20131203115927.GD26423@xps8300>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 03 December 2013 05:29 PM, Heikki Krogerus wrote:
> Hi Kishon,
> 
> On Wed, Oct 16, 2013 at 01:24:12AM +0530, Kishon Vijay Abraham I wrote:
>> +	count = of_property_match_string(node, "phy-names", "usb2-phy");
>> +	if (count >= 0 || (pdata && pdata->usb2_generic_phy)) {
>> +		dwc->usb2_generic_phy = devm_phy_get(dev, "usb2-phy");
>> +		if (IS_ERR(dwc->usb2_generic_phy)) {
>> +			dev_err(dev, "no usb2 phy configured yet");
>> +			return PTR_ERR(dwc->usb2_generic_phy);
>> +		}
>> +		dwc->usb2_phy = NULL;
>> +	}
>> +
>> +	count = of_property_match_string(node, "phy-names", "usb3-phy");
>> +	if (count >= 0 || (pdata && pdata->usb3_generic_phy)) {
>> +		dwc->usb3_generic_phy = devm_phy_get(dev, "usb3-phy");
>> +		if (IS_ERR(dwc->usb3_generic_phy)) {
>> +			dev_err(dev, "no usb3 phy configured yet");
>> +			return PTR_ERR(dwc->usb3_generic_phy);
>> +		}
>> +		dwc->usb3_phy = NULL;
>> +	}
> 
> Is there some specific reason for these checks? The driver should not
> need to care about the platform (DT, ACPI, platform based).

yeah just wanted to throw an error if a platform needs PHY but wasn't able to
get it. Btw this has changed after my v3 of this patch series which I sent
sometime back [1] where we use quirks to know if a PHY is needed for that
platform or not.

http://www.spinics.net/lists/linux-usb/msg98077.html

Thanks
Kishon
