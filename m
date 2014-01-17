Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437AbaAQUHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 15:07:33 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61707 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689AbaAQUHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 15:07:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marc Carino <marc.ceeeee@gmail.com>
Subject: Re: [PATCH v4 8/8] ARM: brcmstb: dts: add a reference DTS for Broadcom 7445
Date: Fri, 17 Jan 2014 21:06:55 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Christian Daudt <bcm@fixthebug.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Matt Porter <matt.porter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <1389986367-4010-1-git-send-email-marc.ceeeee@gmail.com> <1389986367-4010-9-git-send-email-marc.ceeeee@gmail.com>
In-Reply-To: <1389986367-4010-9-git-send-email-marc.ceeeee@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201401172106.55668.arnd@arndb.de>
X-Provags-ID: V02:K0:GcWja+RMa2xyChhAa6bmza9bAzNHXUDcHdyxph0aaSQ
 k3L/qgalh14OxB1CVzu5g7DbwDLsUBBY7x+//5tKmlSCOTbDRD
 gCHp6jFAHzgQqg5KNAtrV4gZMM9Hmv3D9q/kEznqB1FwruEpeL
 100W1/rt/CNTmywYZj8dmspYUR2CvPehvNM/7zTfOylD8YodCS
 Z4PQFXfAT9iNt4R9X8PTbxoZBpSbWaXdjxsIHBGE032XeMyPTN
 uGKOuXEtWRvaFzcYJGSlNPlTFLol0/9+Vb0QE2jv1HoJyj5rnJ
 +EVbEoKWlWI2kXsVy8l7Tt+Ttm4qZBfl3qnxATvyYAA+ZHYBu6
 tT62/WPfYj6wVyHE1V8c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 17 January 2014, Marc Carino wrote:
> +       serial@f0406b00 {
> +               compatible = "ns16550a";
> +               reg = <0x00 0xf0406b00 0x00 0x20>;
> +               reg-shift = <2>;
> +               reg-io-width = <4>;
> +               interrupts = <0 75 0x4>;
> +               clock-frequency = <0x4d3f640>;
> +       };
> +
> +       rdb {
> +               #address-cells = <1>;
> +               #size-cells = <1>;
> +               compatible = "simple-bus";
> +               ranges = <0 0x00 0xf0000000 0x1000000>;
> +
> +               sun_top_ctrl: syscon@404000 {
> +                       compatible = "brcm,bcm7445-sun-top-ctrl",
> +                                    "syscon";
> +                       reg = <0x404000 0x51c>;
> +               };
> +

Yes, this looks better, but as a minor comment, the serial device above
should really be part of the rdb bus now, since that encompasses the
0xf0000000 device range.

	Arnd
