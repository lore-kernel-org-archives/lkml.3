Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbaJ2Kmv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:42:51 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:31958 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbaJ2Kms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:42:48 -0400
X-AuditID: cbfec7f5-b7f956d000005ed7-2c-5450c4a42477
Message-id: <1414579362.18868.11.camel@AMDC1943>
Subject: Re: [PATCH 6/8] regulator: max77686: Add external GPIO control
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Date: Wed, 29 Oct 2014 11:42:42 +0100
In-reply-to: <1414498308.24949.32.camel@AMDC1943>
References: <1414422226-10948-1-git-send-email-k.kozlowski@samsung.com>
 <1414422226-10948-7-git-send-email-k.kozlowski@samsung.com>
 <544EA4FA.6040704@collabora.co.uk> <1414486356.24949.19.camel@AMDC1943>
 <1414498308.24949.32.camel@AMDC1943>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu2
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsVy+t/xy7pLjgSEGFx7rWuxccZ6VotJ6w4w
	WUx9+ITN4vqX56wW84+cY7U4+rvAonfBVTaLs01v2C3ufz3KaPHtSgeTxabH11gtLu+aw2Yx
	4/w+Jovbl3kt1h65y25xupvVQcCjpbmHzePv8+ssHn9XvWD22DnrLrvHplWdbB53ru1h85h3
	MtBj85J6j74tqxg9Pm+SC+CK4rJJSc3JLEst0rdL4MrYuuUGU8FtsYrNG54wNTA+EOxi5OSQ
	EDCRWPd/NTOELSZx4d56ti5GLg4hgaWMEjMefmGFcD4zShzeuhasilfAQOLs4+2sILawgLvE
	/YWHmEBsNgFjic3Ll7CB2CICdhI3Vj9kBmlmFjjMIrHowXWwBIuAqkTbrZ9ADRwcnAKGEmvv
	ZkEs+MYo8WPVS7AaZgF1iUnzFjGD1EgIKEs09rtB7BWU+DH5HgtEibzE5jVvmScwCsxC0jEL
	SdksJGULGJlXMYqmliYXFCel5xrpFSfmFpfmpesl5+duYoRE2tcdjEuPWR1iFOBgVOLhjWDx
	DxFiTSwrrsw9xCjBwawkwvtub0CIEG9KYmVValF+fFFpTmrxIUYmDk6pBsZTQg4T2/50MBWf
	ulVQfXN1G/u5WXwKnFnHuZy3hOZMnP+uTfDi/wyfxalTYnrvMkb29NTV/lyuscldNmvGfd8P
	VnK7T+vcLDh0YEYjR9qdtrmxTyL0b8ZN4iwu29o7semeSx1f8w/+J3KeWh5WU4RyZyosmSnE
	vYAl3rNE9dbZ7dacQZ/nzlBiKc5INNRiLipOBAA8xbIGkgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On wto, 2014-10-28 at 13:11 +0100, Krzysztof Kozlowski wrote:
> On wto, 2014-10-28 at 09:52 +0100, Krzysztof Kozlowski wrote:
> > On pon, 2014-10-27 at 21:03 +0100, Javier Martinez Canillas wrote:
> > > Hello Krzysztof,
> > > 
> > > On 10/27/2014 04:03 PM, Krzysztof Kozlowski wrote:
> > > > @@ -85,6 +91,9 @@ struct max77686_data {
> > > >  	struct max77686_regulator_data *regulators;
> > > >  	int num_regulators;
> > > >  
> > > > +	/* Array of size num_regulators with GPIOs for external control. */
> > > > +	int *ext_control_gpio;
> > > > +
> > > 
> > > The integer-based GPIO API is deprecated in favor of the descriptor-based GPIO
> > > interface (Documentation/gpio/consumer.txt). Could you please use the later?
> > 
> > Sure, I can. Please have in mind that regulator core still accepts old
> > GPIO so I will have to use desc_to_gpio(). That should work... and
> > should be future-ready.
> 
> It seems I was too hasty... I think usage of the new gpiod API implies
> completely different bindings.
> 
> The gpiod_get() gets GPIO from a device level, not from given sub-node
> pointer. This means that you cannot have DTS like this:
> ldo21_reg: ldo21 {
> 	regulator-compatible = "LDO21";
> 	regulator-name = "VTF_2.8V";
> 	regulator-min-microvolt = <2800000>;
> 	regulator-max-microvolt = <2800000>;
> 	ec-gpio = <&gpy2 0 0>;
> };
> 
> ldo22_reg: ldo22 {
> 	regulator-compatible = "LDO22";
> 	regulator-name = "VMEM_VDD_2.8V";
> 	regulator-min-microvolt = <2800000>;
> 	regulator-max-microvolt = <2800000>;
> 	ec-gpio = <&gpk0 2 0>;
> };
> 
> 
> I could put GPIOs in device node:
> 
> max77686_pmic@09 {
> 	compatible = "maxim,max77686";
> 	interrupt-parent = <&gpx0>;
> 	interrupts = <7 0>;
> 	reg = <0x09>;
> 	#clock-cells = <1>;
> 	ldo21-gpio = <&gpy2 0 0>;
> 	ldo22-gpio = <&gpk0 2 0>;
> 
> 	ldo21_reg: ldo21 {
> 		regulator-compatible = "LDO21";
> 		regulator-name = "VTF_2.8V";
> 		regulator-min-microvolt = <2800000>;
> 		regulator-max-microvolt = <2800000>;
> 	};
> 
> 	ldo22_reg: ldo22 {
> 		regulator-compatible = "LDO22";
> 		regulator-name = "VMEM_VDD_2.8V";
> 		regulator-min-microvolt = <2800000>;
> 		regulator-max-microvolt = <2800000>;
> 	};
> 
> This would work but I don't like it. The properties of a regulator are
> above the node configuring that regulator.
> 
> Any ideas?
> 

Continuing talking to myself... I found another problem - GPIO cannot be
requested more than once (-EBUSY). In case of this driver (and board:
Trats2) one GPIO is connected to regulators. The legacy GPIO API and
regulator core handle this.

With new GPIO API I would have to implement some additional steps in
such case...

So there are 2 issues:
1. Cannot put GPIO property in regulator node.
2. Cannot request some GPIO more than once.

I'm going back to legacy API for now.

Best regards,
Krzysztof

