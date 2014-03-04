Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaCDNcW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:32:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53772 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757081AbaCDNcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:32:18 -0500
Message-ID: <5315D5AD.7070501@ti.com>
Date: Tue, 4 Mar 2014 19:01:25 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <bcousson@baylibre.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>, <george.cherian@ti.com>,
        <heikki.krogerus@linux.intel.com>, <rogerq@ti.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>, <tony@atomide.com>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: Re: [PATCH v5 0/6] Make dwc3 use Generic PHY Framework
References: <1393846695-14644-1-git-send-email-kishon@ti.com> <20140303164051.GB10987@saruman.home>
In-Reply-To: <20140303164051.GB10987@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 03 March 2014 10:10 PM, Felipe Balbi wrote:
> Hi,
>
> On Mon, Mar 03, 2014 at 05:08:09PM +0530, Kishon Vijay Abraham I wrote:
>> Added support for optional PHY in dwc3 as not all SoCs having PHYs for DWC3
>> should be programmed. While this can be considered as a temporary fix,
>> a long term solution would be to add 'nop' PHY for platforms that does
>> not have programmable PHY.
>> Adapted DWC3 and USB3 PHY to use Generic PHY framework. Also changed the
>> name of USB3 PHY driver to PIPE3 PHY driver since the same driver has to
>> be used for SATA and PCIE too.
>>
>> Changes from v4: (sending the entire patch series again)
>> * check the return values of phy_init and phy_power_on
>> * print errors if power_on or power_off of PHY fails.
>>
>> Changes from v3: (Sent only adapt dwc3 core to use Generic PHY Framework)
>> * avoided using quirks and rely on the return values of PHY APIs to find the
>> presence of PHY.
>>
>> Changes from v2:
>> * added a couple of fixes. One is invoking phy_resume after phy_init and the
>> other is power off phy in error patch
>> * used quirks to identify if a particular platform does not have PHYs
>> * removed using separate header for pipe3 driver and also removed all referencs
>> to SATA and PCIe in pipe3 driver since it's not yet adapted for those drivers.
>>
>> Changes from v1:
>> * The logic in which the driver detects the presence of PHYs has changed.
>> * patch ordering has changed
>> * udelay is replaced with usleep_range
>> * A patch to remove set_suspend callback which was deferred from Generic
>> PHY Framework series has been included.
>>
>> Kishon Vijay Abraham I (6):
>>    usb: dwc3: core: support optional PHYs
>>    usb: dwc3: adapt dwc3 core to use Generic PHY Framework
>>    drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic PHY Framework
>>    usb: phy: omap-usb2: remove *set_suspend* callback from omap-usb2
>>    phy: omap-usb2: move omap_usb.h from linux/usb/ to linux/phy/
>>    arm/dts: added dt properties to adapt to the new phy framwork
>
> patches 1 and 2 are in my testing/next, I guess 3,4,5 and 6 have no
> direct dependency on those, right ?

that's right. I'll take 3, 4 and 5th patch in my tree and ping Tony to 
take 6th patch.

-Kishon
