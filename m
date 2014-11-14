Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935332AbaKNWrI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:47:08 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:52761 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935230AbaKNWrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:47:05 -0500
MIME-Version: 1.0
In-Reply-To: <20141113005908.GA27381@saruman>
References: <1415832094-20991-1-git-send-email-george.mccollister@gmail.com>
	<1415832094-20991-2-git-send-email-george.mccollister@gmail.com>
	<20141113005908.GA27381@saruman>
Date: Fri, 14 Nov 2014 16:47:02 -0600
Message-ID: <CAFSKS=PvoibYvP8fauFT8J7t_pRDK56-ZbRvOovu=Q5mrw9wpA@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: dts: Add devicetree for NovaTech OrionLXm
From: George McCollister <george.mccollister@gmail.com>
To: Felipe Balbi <balbi@ti.com>
Cc: "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        "open list:OMAP DEVICE TREE..." <linux-omap@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

Thank you for your reply.

>> +     vbat: fixedregulator@0 {
>> +             compatible = "regulator-fixed";
>> +             regulator-name = "vbat";
>> +             regulator-min-microvolt = <5000000>;
>> +             regulator-max-microvolt = <5000000>;
>> +             regulator-boot-on;
>> +     };
>
> I suppose this is the 5V on a power jack, or something like that ?

It comes with one of three different power supplies (24 - 250VDC, 120
- 240VAC, 12VDC input) all of which ultimately supply a fixed 5V and
3.3V.

>
>> +     vmmcsd_fixed: fixedregulator@0 {
>> +             compatible = "regulator-fixed";
>> +             regulator-name = "vmmcsd_fixed";
>> +             regulator-min-microvolt = <3300000>;
>> +             regulator-max-microvolt = <3300000>;
>
> but this... I know every other board devices this as a fixed regulator,
> but is it really a fixed regulator or is supplied by one of the LDOs on
> the PMIC ?
>

It's actually fixed (not from TP65910).

>> +     };
>> +};
>> +
>> +&am33xx_pinmux {
>> +     mmc1_pins: pinmux_mmc1_pins {
>> +             pinctrl-single,pins = <
>> +                     0xf0 (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_dat3 */
>> +                     0xf4 (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_dat2 */
>> +                     0xf8 (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_dat1 */
>> +                     0xfc (PIN_INPUT_PULLUP | MUX_MODE0)     /* mmc0_dat0 */
>> +                     0x100 (PIN_INPUT_PULLUP | MUX_MODE0)    /* mmc0_clk */
>> +                     0x104 (PIN_INPUT_PULLUP | MUX_MODE0)    /* mmc0_cmd */
>> +             >;
>> +     };
>> +
>> +     i2c0_pins: pinmux_i2c0_pins {
>> +             pinctrl-single,pins = <
>> +                     0x188 (PIN_INPUT_PULLUP | MUX_MODE0)    /* i2c0_sda.i2c0_sda */
>> +                     0x18c (PIN_INPUT_PULLUP | MUX_MODE0)    /* i2c0_scl.i2c0_scl */
>> +             >;
>> +     };
>> +
>> +     i2c2_pins: pinmux_i2c2_pins {
>> +             pinctrl-single,pins = <
>> +                     0x178 (PIN_INPUT_PULLUP | MUX_MODE3)    /* uart1_ctsn.i2c2_sda */
>> +                     0x17c (PIN_INPUT_PULLUP | MUX_MODE3)    /* uart1_rtsn.i2c2_scl */
>
> on thing to keep in mind, if you already have external pullups, you
> might not want to add internal pullups as you'd end up with both
> resistors in parallel. For I2C the danger is minimal (unless you have a
> ton of bus capacitance, then it changes high/low time), but it's best to
> write a more "pristine" DTS. (and sure, I know pretty much every board
> makes this mistake, but it's best if we don't proliferate the error)

I'll make sure this is correct and include any required changes in the
next version of the patch series.

>
>> +&i2c0 {
>> +     pinctrl-names = "default";
>> +     pinctrl-0 = <&i2c0_pins>;
>> +
>> +     status = "okay";
>> +     clock-frequency = <400000>;
>> +
>> +     serial_config1: serial_config1@20 {
>> +             compatible = "nxp,pca9539";
>> +             reg = <0x20>;
>> +     };
>> +
>> +     serial_config2: serial_config2@21 {
>> +             compatible = "nxp,pca9539";
>> +             reg = <0x21>;
>> +     };
>> +
>> +     tps: tps@2d {
>> +             reg = <0x2d>;
>
> which TPS device ? no compatible ?
>
>> +/include/ "tps65910.dtsi"
>
> oh... okay.

I'm assuming that means you're okay with this (if not please elaborate
on how to improve it).

>
>> +&tps {
>> +     vcc1-supply = <&vbat>;
>> +     vcc2-supply = <&vbat>;
>> +     vcc3-supply = <&vbat>;
>> +     vcc4-supply = <&vbat>;
>> +     vcc5-supply = <&vbat>;
>> +     vcc6-supply = <&vbat>;
>> +     vcc7-supply = <&vbat>;
>> +     vccio-supply = <&vbat>;
>> +
>> +     regulators {
>> +             vrtc_reg: regulator@0 {
>> +                     regulator-always-on;
>
> this should not be always on, you want to pass this as supply to the RTC
> module so it can manage it. It's also best to give names to all
> regulators, so people know what they're used for.

I think we may actually be able to turn this one and possibly two
others off, I will investigate.

I've come up with names for all of the regulators being used and will
include the changes in the next version of the patch series.

>
>> +             };
>> +
>> +             vio_reg: regulator@1 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vdd1_reg: regulator@2 {
>> +                     regulator-name = "vdd_mpu";
>> +                     regulator-min-microvolt = <600000>;
>> +                     regulator-max-microvolt = <1500000>;
>> +                     regulator-boot-on;
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vdd2_reg: regulator@3 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vdd3_reg: regulator@4 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vdig1_reg: regulator@5 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vdig2_reg: regulator@6 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vpll_reg: regulator@7 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vdac_reg: regulator@8 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vaux1_reg: regulator@9 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vaux2_reg: regulator@10 {
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vaux33_reg: regulator@11 {
>
> isn't this the supply to the other MMC slot ?

no, it's actually being used for the USB PHY. As I said above I will
name all regulators being used.

>
>> +                     regulator-always-on;
>> +             };
>> +
>> +             vmmc_reg: regulator@12 {
>> +                     regulator-min-microvolt = <3300000>;
>> +                     regulator-max-microvolt = <3300000>;
>> +                     regulator-always-on;
>> +             };
>> +     };
>> +};
>> +
>> +&sham {
>> +     status = "okay";
>> +};
>> +
>> +&aes {
>> +     status = "okay";
>> +};
>
> just making sure, are you really using them ?

We may need them at some point, I'd like to keep them enabled.

>
>> +&mmc1 {
>> +     pinctrl-names = "default";
>> +     pinctrl-0 = <&mmc1_pins>;
>> +     bus-width = <4>;
>> +     status = "okay";
>> +     vmmc-supply = <&vmmc_reg>;
>> +     ti,vcc-aux-disable-is-sleep;
>
> this binding isn't documented anywhere. What was it supposed to do ?

I mentioned in the commit message that there is a micro SD slot.

>
> --
> balbi
