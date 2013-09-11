Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3IKK5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 06:57:16 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:63124 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753967Ab3IKK5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 06:57:13 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: [PATCH 2/2] am335x-boneblack: add eMMC DT entry
From: Koen Kooi <koen@dominion.thruhere.net>
In-Reply-To: <523040B5.60407@ti.com>
Date: Wed, 11 Sep 2013 12:57:12 +0200
Cc: <linux-omap@vger.kernel.org>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7BIT
Message-Id: <341E26D5-851E-433A-BC53-3B3A43B78D46@dominion.thruhere.net>
References: <1378879946-13037-1-git-send-email-koen@dominion.thruhere.net> <1378879946-13037-3-git-send-email-koen@dominion.thruhere.net> <523040B5.60407@ti.com>
To: Sekhar Nori <nsekhar@ti.com>
X-Mailer: Apple Mail (2.1508)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Op 11 sep. 2013, om 12:06 heeft Sekhar Nori <nsekhar@ti.com> het volgende geschreven:

> On Wednesday 11 September 2013 11:42 AM, Koen Kooi wrote:
>> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>
>> ---
>> arch/arm/boot/dts/am335x-bone-common.dtsi |  7 +++++++
>> arch/arm/boot/dts/am335x-boneblack.dts    | 15 +++++++++++++++
>> 2 files changed, 22 insertions(+)
>> 
>> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
>> index ced256c..9c61fef 100644
>> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
>> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
>> @@ -241,6 +241,13 @@
>> 			regulator-always-on;
>> 		};
>> 	};
>> +
>> +	vmmcsd_fixed: fixedregulator@0 {
>> +		compatible = "regulator-fixed";
>> +		regulator-name = "vmmcsd_fixed";
>> +		regulator-min-microvolt = <3300000>;
>> +		regulator-max-microvolt = <3300000>;
>> +	};
>> };
>> 
>> &cpsw_emac0 {
>> diff --git a/arch/arm/boot/dts/am335x-boneblack.dts b/arch/arm/boot/dts/am335x-boneblack.dts
>> index 197cadf..c09947a 100644
>> --- a/arch/arm/boot/dts/am335x-boneblack.dts
>> +++ b/arch/arm/boot/dts/am335x-boneblack.dts
>> @@ -15,3 +15,18 @@
>> 	regulator-max-microvolt = <1800000>;
>> 	regulator-always-on;
>> };
>> +
>> +&mmc1 { 
>> +	vmmc-supply = <&vmmcsd_fixed>;
>> +};
>> +
>> +&mmc2 { 
>> +	vmmc-supply = <&vmmcsd_fixed>;
>> +	pinctrl-names = "default";
>> +	pinctrl-0 = <&emmc_pins>;
>> +	bus-width = <8>;
>> +	ti,non-removable;
> 
> There is a standard binding available for this: "non-removable"
> There should not be a need to introduce a TI specific binding for this
> (I know this is not your fault).
> 
> I will send a patch to change the existing .dts files and update the
> driver - can you drop this line for now so we don't introduce more
> incompatibilities? I can send a patch adding "non-removable" to this
> node as part of my clean-up series.

Sure, I'll send a v2 shortly. Thank you very much for killing another ti, prefixed node!

regards,

Koen

