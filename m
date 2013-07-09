Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab3GINTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 09:19:33 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58195 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846Ab3GINTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 09:19:30 -0400
MIME-Version: 1.0
In-Reply-To: <1373372929-17800-4-git-send-email-richard.genoud@gmail.com>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373372929-17800-1-git-send-email-richard.genoud@gmail.com> <1373372929-17800-4-git-send-email-richard.genoud@gmail.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Tue, 9 Jul 2013 15:19:09 +0200
Message-ID: <CACQ1gAg8WQTaz4XkXJCH+-bNU_U3s_1pgmQYoQR3v-KHOzzBTA@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] Documentation: DT: update atmel SSC with DMA binding
To: Mark Brown <broonie@kernel.org>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>
Cc: Bo Shen <voice.shen@atmel.com>, Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Richard Genoud <richard.genoud@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/7/9 Richard Genoud <richard.genoud@gmail.com>:
> As atmel-ssc can be used with DMA, the documentation should be updated.
> Also, a configuration DMA example is given.
>
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> ---
>  .../devicetree/bindings/misc/atmel-ssc.txt         |   24 ++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/misc/atmel-ssc.txt b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> index 38e51ad..96958ca 100644
> --- a/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> +++ b/Documentation/devicetree/bindings/misc/atmel-ssc.txt
> @@ -6,10 +6,30 @@ Required properties:
>         - atmel,at91sam9g45-ssc: support dma transfer
>  - reg: Should contain SSC registers location and length
>  - interrupts: Should contain SSC interrupt
> +For dma transfer:
> +- dmas: DMA specifier, consisting of a phandle to DMA controller node,
> +  the memory interface and SSC DMA channel ID (for tx and rx).
> +  See Documentation/devicetree/bindings/dma/atmel-dma.txt for details.
> +- dma-names: Must be "tx", "rx".
>
> -Example:
> +
> +Examples:
>  ssc0: ssc@fffbc000 {
>         compatible = "atmel,at91rm9200-ssc";
>         reg = <0xfffbc000 0x4000>;
> -       interrupts = <14 4 5>;
> +       interrupts = <14 IRQ_TYPE_LEVEL_HIGH 5>;
maybe I should not use macro in the documentation (not sure if I should or not).
>  };
> +
> +
> +ssc0: ssc@f0010000 {
> +      compatible = "atmel,at91sam9g45-ssc";
> +      reg = <0xf0010000 0x4000>;
> +      interrupts = <28 IRQ_TYPE_LEVEL_HIGH 5>;
> +      dmas = <&dma0 1 AT91_DMA_CFG_PER_ID(13)>,
> +            <&dma0 1 AT91_DMA_CFG_PER_ID(14)>;
same here
> +      dma-names = "tx", "rx";
> +      pinctrl-names = "default";
> +      pinctrl-0 = <&pinctrl_ssc0_tx &pinctrl_ssc0_rx>;
> +      status = "disabled";
> +};
> +
> --
> 1.7.10.4
>



-- 
for me, ck means con kolivas and not calvin klein... does it mean I'm a geek ?
