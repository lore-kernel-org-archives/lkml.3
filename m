Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaFBUS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:18:59 -0400
Received: from mout.perfora.net ([74.208.4.194]:61539 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbaFBUS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:18:57 -0400
Message-ID: <538CDC08.7020106@ziswiler.com>
Date: Mon, 02 Jun 2014 22:18:16 +0200
From: Marcel Ziswiler <marcel@ziswiler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com
CC: linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Subject: Re: [PATCH 3/3] arm: tegra: initial support for apalis t30
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com> <b470c9c8631a6ef021d140192eb07006de3cfd93.1401665237.git.marcel@ziswiler.com> <538CA5C3.5050709@wwwdotorg.org>
In-Reply-To: <538CA5C3.5050709@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:1AgeltexjifWo+R7H80a2fThnv9PEC+z3eUu2xadvmx
 XXId+SRacbPfDxfJktaIUFaYRT3VmFe1ccJ4jjeCQo9zoG1OSi
 sF93fQwee+fryZxGpnLWALlB/wLF/tmeR3CWhSo+TV4dFjg8OW
 e/Wckiuq5PMqWk3iBbbg/knMAsh/S2Z1GCr2IguKpgrl+gZhb8
 F8rxXtPctvcR75Pt3Z0olouvqmPB0fAxlwRASL75Y0al20I7Fp
 1nMsbSokFmXrV+2eha2vyABRylMZOrkMVvqDDSUYwok1I9HHKI
 yqK1HY1G/Enj7V+LwXFDjeTlrJDrTeG4WsmuJ0w6PNGKwyywXr
 pqEAcLb/vb1aLLf4wvKI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2014 06:26 PM, Stephen Warren wrote:
>> +  toradex,colibri_t30
>> +  toradex,colibri_t30-eval-v3
>
> Those don't seem to be related to Apalis support.

Yes, that's why I mentioned it in the commit message as follows:

 >> While at it also add the device tree binding documentation for Apalis
 >> T30 as well as the previously missing one for the recently added
 >> Colibri T30.

If it is preferred having this as a separate commit I can ask Stefan to 
submit one once he returns from his vacation next week.

>> diff --git a/arch/arm/boot/dts/tegra30-apalis-eval.dts b/arch/arm/boot/dts/tegra30-apalis-eval.dts
>> +	host1x@50000000 {
>> +		dc@54200000 {
>> +			rgb {
>> +				status = "okay";
>> +				nvidia,panel = <&panel>;
>> +			};
>> +		};
>> +		hdmi@54280000 {
>
> Nit: Add a blank line between the nodes. Check elsewhere too.

Sure, I actually checked elsewhere as it is 1-to-1 how it got accepted 
for the Colibri T30.

>> +	serial@70006040 {
>> +		compatible = "nvidia,tegra30-hsuart";
>> +		status = "okay";
>> +	};
>
> Nit: Put the status property first followed by new/overridden
> properties, to be consistent with other Tegra DTs. Check elsewhere too.

Dito.

>> +	/* SPI1: Apalis SPI1 */
>> +	spi@7000d400 {
>> +		status = "okay";
>> +		spi-max-frequency = <25000000>;
>> +		spidev0: spidev@1 {
>
> Nit: Add a blank line between properties and nodes. Check elsewhere too.

Dito.

Please excuse our ignorance. I will fix it and ask Stefan to do the same 
for the Colibri T30 DT.

>> +	sd1: sdhci@78000000 {
> ...
>> +	mmc1: sdhci@78000400 {
>
> Do those nodes really need labels? Nothing appears to reference them,
> and I can't see why anything would.

Yes, you are absolutely right. This is a remnant of our tries to use 
aliases thereof to solve the predominant MMC block device ordering 
issue. I will remove them.

> Should the mmc1 node be non-removable? It seems a bit odd for a
> removable device to have an 8-bit data bus.

No, not odd at all. Our Apalis Evaluation Board does actually feature an 
8-bit MMCplus socket which while such cards are rather rare can be used 
to test this functionality in preparation of maybe designing an 
additional albeit then non-removable eMMC onto their custom carrier 
boards. So nothing wrong with that I believe.

>> +	backlight: backlight {
>> +		compatible = "pwm-backlight";
>> +
>> +		/* PWM0 */
>
> Nit: No need for a blank line between a bunch of related properties.
> Check elsewhere too.

Sure, dito Colibri T30 DT again.

>> +	pwmleds {
>> +		compatible = "pwm-leds";
>> +
>> +		pwm3 {
>> +			label = "PWM3";
>> +			pwms = <&pwm 1 19600>;
>> +			max-brightness = <255>;
>> +		};
>> +		pwm2 {
>> +			label = "PWM2";
>> +			pwms = <&pwm 2 19600>;
>> +			max-brightness = <255>;
>> +		};
>> +		pwm1 {
>> +			label = "PWM1";
>> +			pwms = <&pwm 3 19600>;
>> +			max-brightness = <255>;
>> +		};
>
> Nit: Why not sort those nodes in numerical order?

Sure, the only question is ordering based on what. I choose the actual 
Tegra PWM instance while you propose to use our Apalis instance 
numbering which in this particular case turns out to be the opposite but 
makes us even more happy to comply.

>> +	regulators {
>> +		sys_5v0_reg: regulator@1 {
>
> Nit: Why not start the numbering at 0?

Good question which I asked Stefan earlier as well. He proposed to start 
with 101 in the module dtsi while starting with 1 in the board dts. But 
I guess starting with 100 resp. 0 might be more C programmer friendly.

>> diff --git a/arch/arm/boot/dts/tegra30-apalis.dtsi b/arch/arm/boot/dts/tegra30-apalis.dtsi
>
>> +	pinmux@70000868 {
>> +		pinctrl-names = "default";
>> +		pinctrl-0 = <&state_default>;
>> +
>> +		state_default: pinmux {
>
> It might make sense to add all the pinmux data to
> https://github.com/NVIDIA/tegra-pinmux-scripts, so that both the kernel
> and U-Boot pinmux initialization tables can be auto-generated from a
> single data-structure. I think that'll get a small amount of
> error-/consistency-checking of the data too.

Yes, that makes sense. Please understand that our current mainlining 
effort started long before we even learned about the existence of those 
scripts. Let me look into adding this there as well.

