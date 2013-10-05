Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab3JESaE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 14:30:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:58722 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313Ab3JESaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 14:30:00 -0400
Message-ID: <52505A7E.80802@ti.com>
Date: Sat, 5 Oct 2013 13:29:18 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>, Paul Walmsley <paul@pwsan.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Mark A. Greer" <mgreer@animalcreek.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list: DOCUMENTATION <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, ;
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	;
			^-missing semicolon to end mail group, extraneous tokens in mailbox, missing end of mailbox
Subject: Re: [PATCH v2 4/9] ARM: dts: Add AES data and documentation for AM33XX
References: <1380553986-15910-1-git-send-email-joelf@ti.com> <1380553986-15910-5-git-send-email-joelf@ti.com> <20131004143348.GJ6999@e106331-lin.cambridge.arm.com>
In-Reply-To: <20131004143348.GJ6999@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were not authored by me but I'll go ahead and fix them up anyway.

On 10/04/2013 09:33 AM, Mark Rutland wrote:
> On Mon, Sep 30, 2013 at 04:13:01PM +0100, Joel Fernandes wrote:
>> From: "Mark A. Greer" <mgreer@animalcreek.com>
>>
>> Add the generic AM33XX AES module's device tree data and
>> enable it for the am335x-evm, am335x-evmsk, and am335x-bone
>> platforms.  Also add Documentation file describing the data
>> for the AES module.
>>
>> [joelf@ti.com: Dropped interrupt-parent propert]
>>
>> CC: Paul Walmsley <paul@pwsan.com>
>> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
>> ---
>>  .../devicetree/bindings/crypto/omap-aes.txt        | 34 ++++++++++++++++++++++
>>  arch/arm/boot/dts/am335x-bone.dts                  |  4 +++
>>  arch/arm/boot/dts/am335x-evm.dts                   |  4 +++
>>  arch/arm/boot/dts/am335x-evmsk.dts                 |  4 +++
>>  arch/arm/boot/dts/am33xx.dtsi                      | 10 +++++++
>>  5 files changed, 56 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/omap-aes.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/omap-aes.txt b/Documentation/devicetree/bindings/crypto/omap-aes.txt
>> new file mode 100644
>> index 0000000..4bb1e27
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/omap-aes.txt
>> @@ -0,0 +1,34 @@
>> +OMAP SoC AES crypto Module
>> +
>> +Required properties:
>> +
>> +- compatible : Should contain entries for this and backward compatible
>> +  AES versions:
>> +  - "ti,omap2-aes" for OMAP2.
>> +  - "ti,omap3-aes" for OMAP3.
>> +  - "ti,omap4-aes" for OMAP4 and AM33XX.
>> +  Note that the OMAP2 and 3 versions are compatible (OMAP3 supports
>> +  more algorithms) but they are incompatible with OMAP4.
>> +- ti,hwmods: Name of the hwmod associated with the AES odule
>> +- reg : Offset and length of the register set for the module
>> +- interrupt-parent : the phandle for the interrupt controller that
>> +  services interrupts for this module.
>> +- interrupts : the interrupt number for the AES odule.
> 
> Similar comments to the SHAM module here:
> 
> * s/interrupt number/interrupt-specifier/
> * Drop interrupt-parent.
> * s/AES odule/AES module/

Ok, done.

>> +
>> +Optional properties:
>> +- dmas: DMA specifier for tx and rx dma. See the DMA client binding,
>> +	Documentation/devicetree/bindings/dma/dma.txt
> 
> s/DMA specifier/DMA specifiers/
> 
>> +- dma-names: DMA request names. Should be '"tx", "rx"' if dma is present.
> 
> Nit: I'd prefer 'Should include "tx" and "rx" if present' -- I hope the

Ok, changed to the same.

> driver's requesting these by name rather than relying on a specific
> ordering (it makes future expansion and optional components far easier
> to handle sanely).

Yes, that's the case. Its handled by name using the
dma_request_slave_channel_compat API.

>> +
>> +Example:
>> +	/* AM335x */
>> +	aes: aes@53500000 {
>> +		compatible = "ti,omap4-aes";
>> +		ti,hwmods = "aes";
>> +		reg = <0x53500000 0xa0>;
>> +		interrupt-parent = <&intc>;
>> +		interrupts = <102>;
>> +		dmas = <&edma 6
>> +			&edma 5>;
>> +		dma-names = "tx", "rx";
>> +	};
> 
> Minor nit, but for consistency could you bracket the DMAs individually:
> 
> 		dmas = <&edma 6>,
> 		       <&edma 5>;

Ok changed as above.

> 
>> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
>> index 8a9802e..94ee427 100644
>> --- a/arch/arm/boot/dts/am335x-bone.dts
>> +++ b/arch/arm/boot/dts/am335x-bone.dts
>> @@ -23,3 +23,7 @@
>>  &sham {
>>  	status = "okay";
>>  };
>> +
>> +&aes {
>> +	status = "okay";
>> +};
>> diff --git a/arch/arm/boot/dts/am335x-evm.dts b/arch/arm/boot/dts/am335x-evm.dts
>> index d59e51c..86463fa 100644
>> --- a/arch/arm/boot/dts/am335x-evm.dts
>> +++ b/arch/arm/boot/dts/am335x-evm.dts
>> @@ -526,3 +526,7 @@
>>  &sham {
>>  	status = "okay";
>>  };
>> +
>> +&aes {
>> +	status = "okay";
>> +};
>> diff --git a/arch/arm/boot/dts/am335x-evmsk.dts b/arch/arm/boot/dts/am335x-evmsk.dts
>> index d45a330..f577e65 100644
>> --- a/arch/arm/boot/dts/am335x-evmsk.dts
>> +++ b/arch/arm/boot/dts/am335x-evmsk.dts
>> @@ -428,3 +428,7 @@
>>  &sham {
>>  	status = "okay";
>>  };
>> +
>> +&aes {
>> +	status = "okay";
>> +};
>> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
>> index 299710b..0daa1b2 100644
>> --- a/arch/arm/boot/dts/am33xx.dtsi
>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>> @@ -719,5 +719,15 @@
>>  			dmas = <&edma 36>;
>>  			dma-names = "rx";
>>  		};
>> +
>> +		aes: aes@53500000 {
>> +			compatible = "ti,omap4-aes";
>> +			ti,hwmods = "aes";
>> +			reg = <0x53500000 0xa0>;
>> +			interrupts = <102>;
>> +			dmas = <&edma 6
>> +				&edma 5>;
> 
> Bracketing here too, please.

Done.

Thanks,

-Joel

