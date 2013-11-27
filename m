Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3K0IoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 03:44:17 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52553 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab3K0IoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 03:44:15 -0500
Message-ID: <5295B0C1.8060400@ti.com>
Date: Wed, 27 Nov 2013 14:13:45 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux@arm.linux.org.uk>, <santosh.shilimkar@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] phy: kconfig: add depends on "USB_SUPPORT" to OMAP_USB2
 and TWL4030_USB
References: <1385460115-31194-1-git-send-email-kishon@ti.com> <20131126155425.GC24310@saruman.home>
In-Reply-To: <20131126155425.GC24310@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 26 November 2013 09:24 PM, Felipe Balbi wrote:
> On Tue, Nov 26, 2013 at 03:31:55PM +0530, Kishon Vijay Abraham I wrote:
>> Fixes
>> warning: (OMAP_USB2 && TWL4030_USB) selects USB_PHY which has unmet
>> direct dependencies (USB_SUPPORT)
>> that shows up while disabling USB_SUPPORT from menuconfig.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/phy/Kconfig |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index a344f3d..0c87e4c 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -24,6 +24,7 @@ config PHY_EXYNOS_MIPI_VIDEO
>>  config OMAP_USB2
>>  	tristate "OMAP USB2 PHY Driver"
>>  	depends on ARCH_OMAP2PLUS
>> +	depends on USB_SUPPORT
>>  	select GENERIC_PHY
>>  	select USB_PHY
>>  	select OMAP_CONTROL_USB
>> @@ -36,6 +37,7 @@ config OMAP_USB2
>>  config TWL4030_USB
>>  	tristate "TWL4030 USB Transceiver Driver"
>>  	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
>> +	depends on USB_SUPPORT
> 
> The problem is actually the select below. Make this driver depend on
> GENERIC_PHY instead. Note that we have to remove that dependency soonish
> as this same IP is used as a SATA PHY.

the problem is actually the "select USB_PHY" after that. The *select* was added
in the later versions of the Generic PHY framework series after Greg expressed
his concerns on using *depends* [1]

I think this wouldn't be an issue when we have pipe3 driver adapted to generic
phy framework since it need not use *usb_phy* unlike omap-usb2 phy and twl4030
phy because of MUSB using the *xceiv*.

Thanks
Kishon

[1] -> https://lkml.org/lkml/2013/7/17/520
> 

