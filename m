Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaDYH5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:57:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36651 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbaDYH5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:57:48 -0400
Message-ID: <535A156F.6060004@linaro.org>
Date: Fri, 25 Apr 2014 13:27:35 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>
CC: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        t.figa@samsung.com, k.debski@samsung.com, jg1.han@samsung.com
Subject: Re: [PATCH V4 1/5] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com> <1396967803-28868-2-git-send-email-gautam.vivek@samsung.com> <534BF28E.7040906@samsung.com>
In-Reply-To: <534BF28E.7040906@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2014 08:07 PM, Sylwester Nawrocki wrote:
> On 08/04/14 16:36, Vivek Gautam wrote:
>> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> index 28f9edb..6d99ba9 100644
>> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
>> @@ -74,3 +74,45 @@ phy-consumer@12340000 {
>>  
>>  Refer to DT bindings documentation of particular PHY consumer devices for more
>>  information about required PHYs and the way of specification.
>> +
>> +Samsung Exynos5 SoC series USB DRD PHY controller
>> +--------------------------------------------------
>> +
>> +Required properties:
>> +- compatible : Should be set to one of the following supported values:
>> +	- "samsung,exynos5250-usbdrd-phy" - for exynos5250 SoC,
>> +	- "samsung,exynos5420-usbdrd-phy" - for exynos5420 SoC.
>> +- reg : Register offset and length of USB DRD PHY register set;
>> +- clocks: Clock IDs array as required by the controller
>> +- clock-names: names of clocks correseponding to IDs in the clock property;
>> +	       Required clocks:
>> +	- phy: main PHY clock (same as USB DRD controller i.e. DWC3 IP clock),
>> +	       used for register access.
>> +	- ref: PHY's reference clock (usually crystal clock), associated by
>> +	       phy name, used to determine bit values for clock settings
>> +	       register.
>> +	Additional clock required for Exynos5420:
>> +	- usb30_sclk_100m: Additional special clock used for PHY operation
>> +			   depicted as 'sclk_usbphy30' in CMU of Exynos5420.
>> +- samsung,syscon-phandle: phandle for syscon interface, which is used to
>> +			  control pmu registers for power isolation.
> 
> Why to append "-phandle" to the property's name ? If this is for PMU
> perhaps make it more explicit and name it: samsung,pmu-syscon or
> samsung,pmureg ?
> 

There are already a couple of nodes (watchdog and sata) using
samsung,syscon-phandle. IMHO, we should keep only property string for
syscon node. Either we keep syscon-phandle here or change sata/watchdog
driver to use the modified property name.

-- 
Tushar Behera
