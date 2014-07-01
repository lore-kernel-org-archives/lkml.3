Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758343AbaGARaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 13:30:15 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:40903 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbaGARaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 13:30:12 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        "Lee Jones" <lee.jones@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1403806546-31122-5-git-send-email-javier.martinez@collabora.co.uk>
Cc: "Samuel Ortiz" <sameo@linux.intel.com>, "Mark Brown" <broonie@kernel.org>,
        "Liam Girdwood" <lgirdwood@gmail.com>,
        "Alessandro Zummo" <a.zummo@towertech.it>,
        "Kukjin Kim" <kgene.kim@samsung.com>,
        "Doug Anderson" <dianders@chromium.org>,
        "Olof Johansson" <olof@lixom.net>,
        "Sjoerd Simons" <sjoerd.simons@collabora.co.uk>,
        "Daniel Stone" <daniels@collabora.com>,
        "Tomeu Vizoso" <tomeu.vizoso@collabora.com>,
        "Krzysztof Kozlowski" <k.kozlowski@samsung.com>,
        "Yadwinder Singh Brar" <yadi.brar01@gmail.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Javier Martinez Canillas" <javier.martinez@collabora.co.uk>
References: <1403806546-31122-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403806546-31122-5-git-send-email-javier.martinez@collabora.co.uk>
Message-ID: <20140701172959.32686.9863@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v5 04/14] clk: max77686: Improve Maxim 77686 PMIC clocks binding
Date: Tue, 01 Jul 2014 10:29:59 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Javier Martinez Canillas (2014-06-26 11:15:36)
> Like most clock drivers, the Maxim 77686 PMIC clock binding
> follows the convention that the "#clock-cells" property is
> used to specify the number of cells in a clock provider.
> 
> But the binding document is not clear enough that it shall
> be set to 1 since the PMIC support multiple clocks outputs.
> 
> Also, explain that the clocks identifiers are defined in a
> header file that can be included by Device Tree source with
> client nodes to avoid using magic numbers.
> 
> Signed-off-by: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
> Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Reviewed-by: Doug Anderson <dianders@chromium.org>

Looks good to me.

Regards,
Mike

> ---
> 
> Changes since v4: None
> 
> Changes since v3:
>  - Don't change clock-names property to make clear that it's
>    the consumer clock name and should not match the producer clock.
>    Suggested by Doug Anderson.
> 
>  Documentation/devicetree/bindings/clock/maxim,max77686.txt | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/clock/maxim,max77686.txt b/Documentation/devicetree/bindings/clock/maxim,max77686.txt
> index 96ce71b..48e00bb 100644
> --- a/Documentation/devicetree/bindings/clock/maxim,max77686.txt
> +++ b/Documentation/devicetree/bindings/clock/maxim,max77686.txt
> @@ -9,13 +9,18 @@ The MAX77686 contains three 32.768khz clock outputs that can be controlled
>  Following properties should be presend in main device node of the MFD chip.
>  
>  Required properties:
> -- #clock-cells: simple one-cell clock specifier format is used, where the
> -  only cell is used as an index of the clock inside the provider. Following
> -  indices are allowed:
> +
> +- #clock-cells: from common clock binding; shall be set to 1.
> +
> +Each clock is assigned an identifier and client nodes can use this identifier
> +to specify the clock which they consume. Following indices are allowed:
>      - 0: 32khz_ap clock,
>      - 1: 32khz_cp clock,
>      - 2: 32khz_pmic clock.
>  
> +Clocks are defined as preprocessor macros in dt-bindings/clock/maxim,max77686.h
> +header and can be used in device tree sources.
> +
>  Example: Node of the MFD chip
>  
>         max77686: max77686@09 {
> @@ -34,5 +39,5 @@ Example: Clock consumer node
>                 compatible = "bar,foo";
>                 /* ... */
>                 clock-names = "my-clock";
> -               clocks = <&max77686 2>;
> +               clocks = <&max77686 MAX77686_CLK_PMIC>;
>         };
> -- 
> 2.0.0.rc2
> 
