Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbbAVTrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:47:13 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36069 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbbAVTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:47:10 -0500
From: Kevin Hilman <khilman@kernel.org>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linaro-kernel@lists.linaro.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene@kernel.org>,
        "open list\:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        "moderated list\:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: exynos5422-odroidxu3: add on-board INA231 sensors
References: <1421284089-421-1-git-send-email-khilman@kernel.org>
	<54BF14FB.8050300@samsung.com>
Date: Thu, 22 Jan 2015 11:47:06 -0800
In-Reply-To: <54BF14FB.8050300@samsung.com> (Joonyoung Shim's message of "Wed,
	21 Jan 2015 11:54:51 +0900")
Message-ID: <7hy4ou61j9.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonyoung Shim <jy0922.shim@samsung.com> writes:

> Hi Kevin,
>
> On 01/15/2015 10:08 AM, Kevin Hilman wrote:
>> From: Kevin Hilman <khilman@linaro.org>
>> 
>> The odroid-xu3 has 4 INA231 current sensors on board which can be
>> accessed from the Linux via the hwmon interface.
>> 
>> There is one sensor for each of these power rails:
>> 
>> - A15 cluster: VDD_ARM
>> - A7 cluster: VDD_KFC
>> - GPU: VDD_G3D
>> - memory: VDD_MEM
>> 
>> In addition to adding the sensors, LDO26 from the PMIC needs to be
>> enabled because it's powering these sensor.
>> 
>> Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> Cc: Sjoerd Simons <sjoerd.simons@collabora.co.uk>
>> Signed-off-by: Kevin Hilman <khilman@linaro.org>
>> ---
>> v2: use "ti,ina231" as compatible string.
>> 
>> Applies on top of "ARM: dts: Add dts file for odroid XU3 board" from Sjoerd Simons.
>> 
>>  arch/arm/boot/dts/exynos5422-odroidxu3.dts | 39 ++++++++++++++++++++++++++++++
>>  1 file changed, 39 insertions(+)
>> 
>> diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3.dts b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
>> index c29123c0734d..50353d023225 100644
>> --- a/arch/arm/boot/dts/exynos5422-odroidxu3.dts
>> +++ b/arch/arm/boot/dts/exynos5422-odroidxu3.dts
>> @@ -174,6 +174,13 @@
>>  					regulator-always-on;
>>  				};
>>  
>> +				ldo26_reg: LDO26 {
>> +					regulator-name = "vdd_ldo26";
>> +					regulator-min-microvolt = <3000000>;
>> +					regulator-max-microvolt = <3000000>;
>> +					regulator-always-on;
>> +				};
>> +
>>  				buck1_reg: BUCK1 {
>>  					regulator-name = "vdd_mif";
>>  					regulator-min-microvolt = <800000>;
>> @@ -257,6 +264,38 @@
>>  		};
>>  	};
>>  
>> +	i2c_0: i2c@12C60000 {
>
> It's ok but IMHO it can split using label reference, e.g. 
>
> &i2c_0 {
> 	...
> };

Yes, you're right.  I'll spin a v3.

Kevin
