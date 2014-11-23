Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKWTDA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 14:03:00 -0500
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40527 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaKWTC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 14:02:58 -0500
MIME-Version: 1.0
In-Reply-To: <1416758928-12640-1-git-send-email-b.galvani@gmail.com>
References: <1416758928-12640-1-git-send-email-b.galvani@gmail.com>
Date: Sun, 23 Nov 2014 20:02:57 +0100
X-Google-Sender-Auth: -DVvJm-gRED4GAP6_lnqofs54ng
Message-ID: <CAOQ7t2ZZn9J-b9Vw0rpq7GSSSXRPcpK8FA2nxj4S9U319cwm9w@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: meson: enable Ethernet controller
From: Carlo Caione <carlo@caione.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Carlo Caione <carlo@caione.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Jerry Cao <jerry.cao@amlogic.com>, Victor Wan <victor.wan@amlogic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 23, 2014 at 5:08 PM, Beniamino Galvani <b.galvani@gmail.com> wrote:
> Add a node for the Ethernet controller to Meson DTS file and
> enable it on the Geniatech ATV1200 board.
>
> Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> ---
>  arch/arm/boot/dts/meson.dtsi         | 11 +++++++++++
>  arch/arm/boot/dts/meson6-atv1200.dts |  4 ++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/arch/arm/boot/dts/meson.dtsi b/arch/arm/boot/dts/meson.dtsi
> index 03bcff8..4704b95 100644
> --- a/arch/arm/boot/dts/meson.dtsi
> +++ b/arch/arm/boot/dts/meson.dtsi
> @@ -143,5 +143,16 @@
>                         #size-cells = <0>;
>                         status = "disabled";
>                 };
> +
> +               ethmac: ethernet@c9410000 {
> +                       compatible = "amlogic,meson6-dwmac", "snps,dwmac";
> +                       reg = <0xc9410000 0x10000
> +                              0xc1108108 0x4>;
> +                       interrupts = <0 8 1>;
> +                       interrupt-names = "macirq";
> +                       clocks = <&clk81>;
> +                       clock-names = "stmmaceth";
> +                       status = "disabled";
> +               };
>         };
>  }; /* end of / */
> diff --git a/arch/arm/boot/dts/meson6-atv1200.dts b/arch/arm/boot/dts/meson6-atv1200.dts
> index d7d351a..1237faa 100644
> --- a/arch/arm/boot/dts/meson6-atv1200.dts
> +++ b/arch/arm/boot/dts/meson6-atv1200.dts
> @@ -64,3 +64,7 @@
>  &uart_AO {
>         status = "okay";
>  };
> +
> +&ethmac {
> +       status = "okay";
> +};
> --
> 1.9.1
>

Tested-by: Carlo Caione <carlo@caione.org>

Thanks,

-- 
Carlo Caione
