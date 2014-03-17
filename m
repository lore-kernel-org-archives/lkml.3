Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962AbaCQMJC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:09:02 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:43729 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932767AbaCQMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:09:00 -0400
MIME-Version: 1.0
In-Reply-To: <1395057839-23871-3-git-send-email-ks.giri@samsung.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
	<1395057839-23871-3-git-send-email-ks.giri@samsung.com>
Date: Mon, 17 Mar 2014 17:38:58 +0530
Message-ID: <CAKrE-KdsPD8Q+UWaqJMMgskvhZ0oTeCyO2AQ9-mBDZR76KzSjQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] arm64: dts: exynos: added mailbox node
From: Girish KS <girishks2000@gmail.com>
To: Girish K S <ks.giri@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Anna, Suman" <s-anna@ti.com>, Jassi Singh <jassisinghbrar@gmail.com>,
        Ilho Lee <ilho215.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 5:33 PM, Girish K S <ks.giri@samsung.com> wrote:
> This patch adds the dt node for the mailbox IP
>
> Signed-off-by: Girish K S <ks.giri@samsung.com>
>
> Change-Id: I35e45e9a62592887a84a909aee54f259a2f731fa

Sorry for this. will modify in the v2 with other comments

> ---
>  .../bindings/mailbox/samsung-mailbox.txt           |   24 +++++++
>  arch/arm64/boot/dts/samsung-gh7.dtsi               |   66 ++++++++++++++++++++
>  arch/arm64/boot/dts/samsung-ssdk-gh7.dts           |    3 +
>  3 files changed, 93 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
>
> diff --git a/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
> new file mode 100644
> index 0000000..1908d71
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mailbox/samsung-mailbox.txt
> @@ -0,0 +1,24 @@
> +
> +Samsung Mailbox Driver
> +
> +Required properties:
> +- compatible:          Should be one of the following,
> +                           "samsung,gh7-mailbox" for
> +                               Samsung GH7 SoC series
> +                           "samsung,exynos-mailbox" for
> +                               exynosx SoC series
> +- reg:                 Contains the mailbox register address range (base address
> +                       and length)
> +- interrupts:          Contains the interrupt information for the mailbox
> +                       device.
> +- samsung,mbox-names:  Array of the names of the mailboxes
> +
> +Example:
> +
> +/* Samsung GH7 SoC */
> +mailbox@100a0000 {
> +       compatible = "samsung,gh7-mailbox";
> +       reg = <0x0 0x100a0000 0x0 0x1000>;
> +       interrupts = <0 310 0>;
> +       samsung,mbox-names = "a7q-scp";
> +};
> diff --git a/arch/arm64/boot/dts/samsung-gh7.dtsi b/arch/arm64/boot/dts/samsung-gh7.dtsi
> index c3610bd..be4cce9 100644
> --- a/arch/arm64/boot/dts/samsung-gh7.dtsi
> +++ b/arch/arm64/boot/dts/samsung-gh7.dtsi
> @@ -107,5 +107,71 @@
>                         interrupts = <0 420 0>;
>                         arm,primecell-periphid = <0x341011>; /* HACK */
>                 };
> +
> +       };
> +
> +       mailbox@100a0000 {
> +               compatible = "samsung,gh7-mailbox";
> +               reg = <0x0 0x100a0000 0x0 0x1000>;
> +               interrupts = <0 310 0>;
> +               samsung,mbox-names = "a7q-scp";
> +               status = "disabled";
> +       };
> +
> +       mailbox@24100000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   < 0x0 0x24100000 0x0 0x10000>;
> +               interrupts = <0 251 0>;
> +               samsung,mbox-names = "ncp-a7q-0";
> +               status = "disabled";
> +       };
> +       mailbox@24110000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   <0x0 0x24110000 0x0 0x10000>;
> +               interrupts = <0 252 0>;
> +               samsung,mbox-names = "ncp-a7q-1";
> +               status = "disabled";
> +       };
> +       mailbox@24120000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   <0x0 0x24120000 0x0 0x10000>;
> +               interrupts = <0 253 0>;
> +               samsung,mbox-names = "ncp-a7q-2";
> +               status = "disabled";
> +       };
> +       mailbox@24130000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   <0x0 0x24130000 0x0 0x10000>;
> +               interrupts = <0 254 0>;
> +               samsung,mbox-names = "ncp-a7q-3";
> +               status = "disabled";
> +       };
> +       mailbox@24140000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   <0x0 0x24140000 0x0 0x10000>;
> +               interrupts = <0 255 0>;
> +               samsung,mbox-names = "ncp-a7q-4";
> +               status = "disabled";
> +       };
> +       mailbox@24150000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   <0x0 0x24150000 0x0 0x10000>;
> +               interrupts = <0 256 0>;
> +               samsung,mbox-names = "ncp-a7q-5";
> +               status = "disabled";
> +       };
> +       mailbox@24160000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   <0x0 0x24160000 0x0 0x10000>;
> +               interrupts = <0 257 0>;
> +               samsung,mbox-names = "ncp-a7q-6";
> +               status = "disabled";
> +       };
> +       mailbox@24170000 {
> +               compatible = "samsung,exynos-mailbox";
> +               reg =   <0x0 0x24170000 0x0 0x10000>;
> +               interrupts = <0 258 0>;
> +               samsung,mbox-names = "ncp-a7q-7";
> +               status = "disabled";
>         };
>  };
> diff --git a/arch/arm64/boot/dts/samsung-ssdk-gh7.dts b/arch/arm64/boot/dts/samsung-ssdk-gh7.dts
> index 4ce7d67..bfe5455 100644
> --- a/arch/arm64/boot/dts/samsung-ssdk-gh7.dts
> +++ b/arch/arm64/boot/dts/samsung-ssdk-gh7.dts
> @@ -23,4 +23,7 @@
>                 device_type = "memory";
>                 reg = <0x00000000 0x80000000 0 0x20000000>;
>         };
> +       mailbox@100a0000 {
> +               status = "okay";
> +       };
>  };
> --
> 1.7.10.4
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
