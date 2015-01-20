Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722AbbATRCr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:02:47 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:62074 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbbATRCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:02:19 -0500
Message-ID: <54BE8A0E.30604@gmail.com>
Date: Tue, 20 Jan 2015 17:02:06 +0000
From: Iain Paton <ipaton0@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com
CC: Vishnu Patekar <vishnupatekar0510@gmail.com>, dmitry.torokhov@gmail.com,
        hdegoede@redhat.com, ijc+devicetree@hellion.org.uk,
        maxime.ripard@free-electrons.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [linux-sunxi] [PATCH v4 5/5] ARM: sunxi: dts: Add PS2 nodes for
 A20 lime2 board
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com> <1421417021-3247-6-git-send-email-vishnupatekar0510@gmail.com>
In-Reply-To: <1421417021-3247-6-git-send-email-vishnupatekar0510@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/01/15 14:03, Vishnu Patekar wrote:
> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> ---
>  arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> index ed364d5..3365f12 100644
> --- a/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-olinuxino-lime2.dts
> @@ -113,6 +113,18 @@
>  			status = "okay";
>  		};
>  
> +		ps20: ps2@01c2a000 {
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&ps20_pins_a>;
> +			status = "okay";
> +		};
> +
> +		ps21: ps2@01c2a400 {
> +			pinctrl-names = "default";
> +			pinctrl-0 = <&ps21_pins_a>;
> +			status = "okay";
> +		};
> +
>  		i2c0: i2c@01c2ac00 {
>  			pinctrl-names = "default";
>  			pinctrl-0 = <&i2c0_pins_a>;
> 

As the Lime2 doesn't actually have any PS2 connectors on the board, 
I'd prefer that these are not enabled unconditionally. Doing so 
only makes it more difficult for people who want to use these pins 
for other functions.

Device tree overlays seem to be close to being merged, perhaps we 
could leave enabling this to an overlay?
