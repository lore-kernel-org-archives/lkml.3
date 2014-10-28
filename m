Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaJ1Jxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:53:41 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:61480 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754930AbaJ1Jxi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:53:38 -0400
MIME-Version: 1.0
In-Reply-To: <1413883364-681-10-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1413883364-681-1-git-send-email-sebastian.hesselbarth@gmail.com>
	<1413883364-681-10-git-send-email-sebastian.hesselbarth@gmail.com>
Date: Tue, 28 Oct 2014 10:53:37 +0100
Message-ID: <CAPDyKFqibXtPB57m772HcMsicDbjHH8TiJUtSMRypAJrePygPg@mail.gmail.com>
Subject: Re: [PATCH RESEND 09/12] mmc: sdhci-pxav3: Document clocks and
 additional clock-names property
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 October 2014 11:22, Sebastian Hesselbarth
<sebastian.hesselbarth@gmail.com> wrote:
> Now that sdhci-pxav3 driver allows to have more than one IP clock defined,
> document both clocks and clock-names properties.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Thanks! Applied for next!

Kind regards
Uffe


> ---
> Cc: Chris Ball <chris@printf.net>
> Cc: Ulf Hansson <ulf.hansson@linaro.org>
> Cc: "Antoine Ténart" <antoine.tenart@free-electrons.com>
> Cc: linux-mmc@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/devicetree/bindings/mmc/sdhci-pxa.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt b/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
> index 86223c3eda90..4dd6deb90719 100644
> --- a/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
> +++ b/Documentation/devicetree/bindings/mmc/sdhci-pxa.txt
> @@ -12,6 +12,10 @@ Required properties:
>    * for "marvell,armada-380-sdhci", two register areas. The first one
>      for the SDHCI registers themselves, and the second one for the
>      AXI/Mbus bridge registers of the SDHCI unit.
> +- clocks: Array of clocks required for SDHCI; requires at least one for
> +    I/O clock.
> +- clock-names: Array of names corresponding to clocks property; shall be
> +    "io" for I/O clock and "core" for optional core clock.
>
>  Optional properties:
>  - mrvl,clk-delay-cycles: Specify a number of cycles to delay for tuning.
> @@ -23,6 +27,8 @@ sdhci@d4280800 {
>         reg = <0xd4280800 0x800>;
>         bus-width = <8>;
>         interrupts = <27>;
> +       clocks = <&chip CLKID_SDIO1XIN>, <&chip CLKID_SDIO1>;
> +       clock-names = "io", "core";
>         non-removable;
>         mrvl,clk-delay-cycles = <31>;
>  };
> @@ -32,5 +38,6 @@ sdhci@d8000 {
>         reg = <0xd8000 0x1000>, <0xdc000 0x100>;
>         interrupts = <0 25 0x4>;
>         clocks = <&gateclk 17>;
> +       clock-names = "io";
>         mrvl,clk-delay-cycles = <0x1F>;
>  };
> --
> 2.1.1
>
