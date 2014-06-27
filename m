Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbaF0Ium (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 04:50:42 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33788 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaF0Iue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 04:50:34 -0400
Message-ID: <53AD3052.40901@collabora.co.uk>
Date: Fri, 27 Jun 2014 10:50:26 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>,
        Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 08/14] mfd: max77802: Add DT binding documentation
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk> <1403806546-31122-9-git-send-email-javier.martinez@collabora.co.uk> <53AD25F6.6030007@suse.de>
In-Reply-To: <53AD25F6.6030007@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andreas,

Thanks a lot for your feedback.

On 06/27/2014 10:06 AM, Andreas Färber wrote:
> Am 26.06.2014 20:15, schrieb Javier Martinez Canillas:
>> Add Device Tree binding documentation for Maxim 77802 PMIC.
>> 
>> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
>> ---
>> 
>> Changes since v4: None
>> 
>> Changes since v3: None
>> 
>> Changes since v2:
>>  - Explain better the Dynamic Voltage Scaling (DVS) support in some Buck
>>    regulators and the max77802,pmic-buck-{dvs,selb}-gpios properties.
>>    Suggested by Mark Brown.
>> 
>>  Documentation/devicetree/bindings/mfd/max77802.txt | 97 ++++++++++++++++++++++
>>  1 file changed, 97 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/mfd/max77802.txt
>> 
>> diff --git a/Documentation/devicetree/bindings/mfd/max77802.txt b/Documentation/devicetree/bindings/mfd/max77802.txt
>> new file mode 100644
>> index 0000000..f3b67c5
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/mfd/max77802.txt
>> @@ -0,0 +1,97 @@
>> +Maxim MAX77802 multi-function device
>> +
>> +MAX77802 is a Mulitifunction device with PMIC, RTC and Charger on chip. It is
> 
> "Multifunction"?
> 

Yes, another typo. I'll fix it on the next series as well.

>> +interfaced to host controller using i2c interface. PMIC, Charger and RTC
>> +submodules are addressed using same i2c slave address.
>> +
>> +Buck regulators 1, 2, 3, 4 and 6 include Dynamic Voltage Scaling (DVS) that
>> +allows each output voltage to change dynamically. Each Buck output voltage
>> +is selected using a set of external inputs: DVS1-3 and SELB1, 2, 3 and 6.
>> +
>> +There are 8 DVS registers that can be used to configure the output voltage
>> +for each Buck regulator and which one is active is controled by DVSx lines.
>> +
>> +SELBx lines are used to control if individual Buck lines are ON or OFF.
>> +
>> +This document describes the binding for mfd device and PMIC submodule.
>> +
>> +Binding for the built-in 32k clock generator block is defined separately
>> +in bindings/clk/maxim,max77802.txt file.
>> +
>> +Required properties:
>> +- compatible : Must be "maxim,max77802";
>> +- reg : Specifies the i2c slave address of PMIC block.
>> +- interrupts : This i2c device has an IRQ line connected to the main SoC.
>> +- interrupt-parent : The parent interrupt controller.
>> +
>> +Optional properties:
>> +- max77802,pmic-buck-default-dvs-idx: We'll always write this DVS index in the
>> +  PMIC for Bucks with DVS.
>> +  NOTE: at the moment these bindings don't include enough details for actual
>> +  GPIO-DVS--this just lets you choose which single slot to use.
>> +
>> +- max77802,pmic-buck-dvs-gpios: A GPIO array where each GPIO is connected to a
>> +  DVS line. We'll try to set these GPIOs to match pmic-buck-default-dvs-idx at
>> +  probe time if they are defined. If some or all of these GPIOs are not defined
>> +  it's assumed that the board has any missing GPIOs hardwired to match
>> +  pmic-buck-default-dvs-idx.
>> +
>> +- max77802,pmic-buck-selb-gpios: A GPIO array where each GPIO is connected to a
>> +  SELBx line. Should be five values: 1, 2, 3, 4, 6. It is strongly suggested to
>> +  include these GPIOs if there's any chance that changing DVS GPIOs one line at
>> +  a time might glitch your DVS values.
>> +
>> +Optional node:
>> +- regulators : The regulators of max77802 have to be instantiated
>> +  under subnode named "regulators" using the following format.
>> +
>> +	regulator_name {
> 
> The convention, I was told, would be regulator-name as node name.
> 

Ok, I'll change this to regulator-name. It is a symbolic name to refer to the
regulator node name anyways since now that the regulator-compatible property is
deprecated, the regulator node name is used for matching. So the list of valid
regulator node names is properly defined below:

>> +
>> +  The regulator node name should be initialized with a string
>> +to get matched with their hardware counterparts as follow:
>> +
>> +	-LDOn 	:	for LDOs, where n can lie in range 1 to 35.
>> +			example: LDO1, LDO2, LDO35.
>> +	-BUCKn 	:	for BUCKs, where n can lie in range 1 to 10.
>> +			example: BUCK1, BUCK5, BUCK10.
>> +Example:
>> +
>> +	max77802@09 {
>> +		compatible = "maxim,max77802";
>> +		interrupt-parent = <&wakeup_eint>;
>> +		interrupts = <26 0>;
>> +		reg = <0x09>;
>> +		#address-cells = <1>;
>> +		#size-cells = <0>;
>> +
>> +		max77802,pmic-buck-default-dvs-idx = <1>;
>> +		max77802,pmic-buck-dvs-gpios = <&gpy7 6 0>,
>> +					       <&gpj4 2 0>,
>> +					       <&gpj4 3 0>;
>> +		max77802,pmic-buck-selb-gpios = <&gph0 2 0>,
>> +						<&gph0 3 0>,
>> +						<&gph0 4 0>,
>> +						<&gph0 5 0>,
>> +						<&gph0 6 0>;
>> +
>> +		regulators {
>> +			ldo11_reg: LDO11 {
>> +				regulator-compatible = "LDO11";
>> +				regulator-name = "vdd_ldo11";
>> +				regulator-min-microvolt = <1900000>;
>> +				regulator-max-microvolt = <1900000>;
>> +				regulator-always-on;
>> +			};
>> +
>> +			buck1_reg {
> 
> Missing ": BUCK1"
> 

Ups, since it was documentation and not the DTS I completely missed that. Thanks
for pointing out!

>> +				regulator-compatible = "BUCK1";
>> +				regulator-name = "vdd_mif";
>> +				regulator-min-microvolt = <950000>;
>> +				regulator-max-microvolt = <1300000>;
>> +				regulator-always-on;
>> +				regulator-boot-on;
>> +			};
>> +	};
> 
> Regards,
> Andreas
> 

Best regards,
Javier
