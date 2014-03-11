Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbaCKP4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbaCKP4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:56:35 -0400
Message-ID: <531F3203.3010807@redhat.com>
Date: Tue, 11 Mar 2014 16:55:47 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: mr.nuke.me@gmail.com, linux-sunxi@googlegroups.com
CC: devicetree@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Mike Turquette <mturquette@linaro.org>,
        Simon Baatz <gmbnomis@gmail.com>,
        =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        linux-mmc@vger.kernel.org, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Tejun Heo <tj@kernel.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-arm-kernel@lists.infradead.org, david.lanzendoerfer@o2s.ch
Subject: Re: [PATCH v5 6/8] ARM: dts: sun4i: Add support for mmc
References: <20140211190543.4568.83517.stgit@dizzy-6.o2s.ch> <20140211193423.4568.34947.stgit@dizzy-6.o2s.ch> <ac47de94-92ef-4b53-9983-34dd2f9924ea@googlegroups.com>
In-Reply-To: <ac47de94-92ef-4b53-9983-34dd2f9924ea@googlegroups.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Oh, good catch, thanks! Fixed in the sunxi-devel branch
in my *personal* git repo. I'll also push this to the official linux-sunxi
sunxi-devel branch later today.

Regards,

Hans



On 03/10/2014 10:49 PM, mr.nuke.me@gmail.com wrote:
> On Tuesday, February 11, 2014 1:34:25 PM UTC-6, David Lanzendörfer wrote:
>> diff --git a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>> b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>> index b139ee6..20b976a 100644
>> --- a/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>> +++ b/arch/arm/boot/dts/sun4i-a10-cubieboard.dts
>> @@ -33,6 +33,14 @@
>>  			};
>>  		
>>  		};
>> +		mmc0: mmc@01c0f000 {
>> +			pinctrl-names = "default", "default";
>> +			pinctrl-0 = <&mmc0_pins_a>;
>> +			pinctrl-1 = <&mmc0_cd_pin_reference_design>;
>> +			cd-gpios = <&pio 7 1 0>; /* PH1 */
>> +			status = "okay";
>> +		};
>> +
>>  		pinctrl@01c20800 {
>>  		
>>  			led_pins_cubieboard: led_pins@0 {
>>  			
>>  				allwinner,pins = "PH20", "PH21";
>> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi
>> b/arch/arm/boot/dts/sun4i-a10.dtsi
>> index 9044c53..d040d37 100644
>> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
>> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
>> @@ -330,6 +330,46 @@
>>  			#size-cells = <0>;
>>  		
>>  		};
>> +		mmc0: mmc@01c0f000 {
>> +			compatible = "allwinner,sun5i-a13-mmc";
> 
> Should be "allwinner,sun4i-a10-mmc", or we will hang the MMC driver on A10.
> 
>> +		mmc1: mmc@01c10000 {
>> +			compatible = "allwinner,sun5i-a13-mmc";
> ditto
> 
>> +		mmc2: mmc@01c11000 {
>> +			compatible = "allwinner,sun5i-a13-mmc";
> ditto
> 
>> +		mmc3: mmc@01c12000 {
>> +			compatible = "allwinner,sun5i-a13-mmc";
> ditto
> 
