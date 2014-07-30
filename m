Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaG3LXM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 07:23:12 -0400
Received: from gloria.sntech.de ([95.129.55.99]:60299 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaG3LXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 07:23:10 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Kever Yang <kever.yang@rock-chips.com>, Sonny Rao <sonnyrao@chromium.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: dts: Turn on USB host vbus on rk3288-evb
Date: Wed, 30 Jul 2014 13:24:17 +0200
Message-ID: <1836225.xQCoI7eRWl@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1406676273-20701-2-git-send-email-dianders@chromium.org>
References: <1406676273-20701-1-git-send-email-dianders@chromium.org> <1406676273-20701-2-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 29. Juli 2014, 16:24:31 schrieb Doug Anderson:
> There is no phy driver that works on the Rockchip board for either USB
> host port yet.  For now just hardcode the vbus signal to be on all the
> time which makes both the dwc2 host and the EHCI port work.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/boot/dts/rk3288-evb.dtsi | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi
> b/arch/arm/boot/dts/rk3288-evb.dtsi index 749e20d..efd625e 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -35,6 +35,18 @@
>  			debounce-interval = <100>;
>  		};
>  	};
> +
> +	/* This turns on vbus for both host0 (ehci) and host1 (dwc2) */
> +	usb_host_vbus_regulator: usb-host-vbus-regulator {
> +		compatible = "regulator-fixed";
> +		enable-active-high;
> +		gpio = <&gpio0 14 GPIO_ACTIVE_HIGH>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&usb_host_vbus>;
> +		regulator-name = "usb-host-vbus";
> +		regulator-always-on;
> +		regulator-boot-on;
> +	};
>  };

It seems I have a slightly outdated schematics pdf for the evb ... and only 
see the OTG vbus pin, on <&gpio0 12>, but am missing the whole host vbus.

Could you think about finding another name for the handle? For example, in my 
incomplete evb-schematics the supply coming from the otg regulator is called 
vcc50_usb and there should be something similar for the host supply, so I'd 
like something like

	vcc50_usbhost: usb-host-vbus-regulator { /* or whatever it gets called */
	...
	};

simply to keep with the supply names defined in the schematics - makes reading 
easier.


Heiko

> 
>  &i2c0 {
> @@ -71,4 +83,10 @@
>  			rockchip,pins = <0 5 RK_FUNC_GPIO &pcfg_pull_up>;
>  		};
>  	};
> +
> +	usb-host {
> +		usb_host_vbus: usb-host-vbus {
> +			rockchip,pins = <0 14 RK_FUNC_GPIO &pcfg_pull_none>;
> +		};
> +	};
>  };

