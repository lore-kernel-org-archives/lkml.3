Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648Ab3EQVVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:21:45 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51336 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab3EQVVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:21:44 -0400
Message-ID: <51969F66.7080205@free-electrons.com>
Date: Fri, 17 May 2013 23:21:42 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oliver Schinagl <oliver+list@schinagl.nl>
CC: arnd@ardb.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Oliver Schinagl <oliver@schinagl.nl>
Subject: Re: [PATCH 2/2] Add sunxi-sid to dts for sun4i and sun5i
References: <1368797744-13737-1-git-send-email-oliver+list@schinagl.nl> <1368797744-13737-3-git-send-email-oliver+list@schinagl.nl>
In-Reply-To: <1368797744-13737-3-git-send-email-oliver+list@schinagl.nl>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

Le 17/05/2013 15:35, Oliver Schinagl a écrit :
> From: Oliver Schinagl <oliver@schinagl.nl>
> 
> This should add support for the sunxi-sid driver to the device table for sun4i and sun5i

And it actually does :)

> 
> Signed-off-by: Oliver Schinagl <oliver@schinagl.nl>
> ---
>  arch/arm/boot/dts/sun4i-a10.dtsi | 5 +++++
>  arch/arm/boot/dts/sun5i-a13.dtsi | 5 +++++
>  2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/sun4i-a10.dtsi b/arch/arm/boot/dts/sun4i-a10.dtsi
> index e7ef619..1043db2 100644
> --- a/arch/arm/boot/dts/sun4i-a10.dtsi
> +++ b/arch/arm/boot/dts/sun4i-a10.dtsi
> @@ -163,6 +163,11 @@
>  		reg = <0x01c20000 0x300000>;
>  		ranges;
>  
> +		sid: eeprom@01c23800 {
> +			compatible = "allwinner,sun4i-sid";
> +			reg = <0x01c23800 0x10>;
> +		};
> +

I'd prefer to have the nodes sorted by base addresses.
Also, the reserved address space for this IP is 1kB, please make it as
such in the dt.

>  		intc: interrupt-controller@01c20400 {
>  			compatible = "allwinner,sun4i-ic";
>  			reg = <0x01c20400 0x400>;
> diff --git a/arch/arm/boot/dts/sun5i-a13.dtsi b/arch/arm/boot/dts/sun5i-a13.dtsi
> index 8ba65c1..f715132 100644
> --- a/arch/arm/boot/dts/sun5i-a13.dtsi
> +++ b/arch/arm/boot/dts/sun5i-a13.dtsi
> @@ -153,6 +153,11 @@
>  		reg = <0x01c20000 0x300000>;
>  		ranges;
>  
> +		sid: eeprom@01c23800 {
> +			compatible = "allwinner,sun4i-sid";
> +			reg = <0x01c23800 0x10>;
> +		};

Ditto,

> +
>  		intc: interrupt-controller@01c20400 {
>  			compatible = "allwinner,sun4i-ic";
>  			reg = <0x01c20400 0x400>;
> 

Thanks,
Maxime

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
