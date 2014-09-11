Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaIKMRt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:17:49 -0400
Received: from mout.gmx.net ([212.227.15.15]:58231 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754271AbaIKMRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:17:47 -0400
From: Marc Dietrich <marvin24@gmx.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-i2c@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jean Delvare <jdelvare@suse.de>, Magnus Damm <magnus.damm@gmail.com>,
        Andrey Danin <danindrey@mail.ru>, devicetree@vger.kernel.org,
        Stephen Warren <swarren@wwwdotorg.org>
Subject: Re: [RFC 4/4] ARM: shmobile: r8a7790: adapt DTS for I2C slave support
Date: Thu, 11 Sep 2014 14:17:16 +0200
Message-ID: <16809905.2REViph6WO@fb07-iapwap2>
User-Agent: KMail/4.13.3 (Linux/3.16.1-46.g90bc0f1-desktop; KDE/4.13.3; x86_64; ; )
In-Reply-To: <1410274470-12712-5-git-send-email-wsa@the-dreams.de>
References: <1410274470-12712-1-git-send-email-wsa@the-dreams.de> <1410274470-12712-5-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
X-Provags-ID: V03:K0:e1R/nFpofb31YBcOp9cVBVwlKBO/Cs1u31DYNBctyrfMw75ibb1
 L5rlDvtPML0sBYEvd43pe77UZFLYZEVvgNg86ZpHIt5nh3F+jg2DNa4nUBKi31mBr3Swval
 y58IafuqYLjEPrmvsqayb22gUqtI+y9UBiImcnQmOoDkGT6iTyf7Ortgbw/EHcVPsOETB64
 84MNbhr5IMI9Yw9EI5v+Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cc'ing: devicetree

Am Dienstag, 9. September 2014, 16:54:30 schrieb Wolfram Sang:
> From: Wolfram Sang <wsa+renesas@sang-engineering.com>
> 
> Not for upstream!
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  arch/arm/boot/dts/r8a7790-lager.dts | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/r8a7790-lager.dts
> b/arch/arm/boot/dts/r8a7790-lager.dts index 856b4236b674..12aa2f21e6fa
> 100644
> --- a/arch/arm/boot/dts/r8a7790-lager.dts
> +++ b/arch/arm/boot/dts/r8a7790-lager.dts
> @@ -205,9 +205,9 @@
>  		renesas,function = "msiof1";
>  	};
> 
> -	iic1_pins: iic1 {
> -		renesas,groups = "iic1";
> -		renesas,function = "iic1";
> +	i2c1_pins: i2c1 {
> +		renesas,groups = "i2c1";
> +		renesas,function = "i2c1";
>  	};
> 
>  	iic2_pins: iic2 {
> @@ -356,10 +356,15 @@
>  	status = "ok";
>  };
> 
> -&iic1	{
> +&i2c1	{
>  	status = "ok";
> -	pinctrl-0 = <&iic1_pins>;
> +	pinctrl-0 = <&i2c1_pins>;
>  	pinctrl-names = "default";
> +
> +	eeprom@64 {
> +		compatible = "slave-24c02";

a "real" compatible value should have vendor,device syntax.

> +		reg = <0x64>;

we had some discussions in the past how to represent i2c master devices in 
device tree. The outcome was to use to a special representation to distinguish 
them from slave devices, e.g. something like reg = <0x1 0x64>, where the 0x1 
would mean "master" device (0x0 -> slave). If nothing is added, then it's also 
slave. The adapter address cell would also need to be changed if this 
extension is used.

An alternative would be to use a special property (e.g. slave address), but 
that would encode the same value twice (or even three times).

Marc

