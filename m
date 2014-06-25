Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbaFYKTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 06:19:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:63529 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754719AbaFYKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 06:19:16 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-47-53aaa2218b48
Message-id: <1403691551.22107.9.camel@AMDC1943>
Subject: Re: [PATCH v3 04/14] clk: max77686: Improve Maxim 77686 PMIC clocks
 binding
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>, Olof Johansson <olof@lixom.net>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Daniel Stone <daniels@collabora.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 12:19:11 +0200
In-reply-to: <1403202040-12641-5-git-send-email-javier.martinez@collabora.co.uk>
References: <1403202040-12641-1-git-send-email-javier.martinez@collabora.co.uk>
 <1403202040-12641-5-git-send-email-javier.martinez@collabora.co.uk>
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.10.4-0ubuntu1
MIME-version: 1.0
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnkeLIzCtJLcpLzFFi42I5/e/4FV3FRauCDe50i1ksuXiV3WLqwyds
	Fpv6t7JbzD9yjtXi7LKDbBZHfxdY9C64ymZx/+tRRotvVzqYLDY9vsZqcXnXHDaLGef3MVk8
	nXCRzeLU9c9sFqe7WS2mH3/LatG39hKbg6DH7IaLLB5/n19n8dhxdwmjx85Zd9k9Nq3qZPO4
	c20Pm8e8k4Eem5fUe1w50cTq0bdlFaPH9Hk/mTw+b5IL4InisklJzcksSy3St0vgylj+ewJj
	wQGhinv7jzI3ML7n62Lk4JAQMJG4ejigi5ETyBSTuHBvPVsXIxeHkMBSRokZj2YxQjifGSWW
	P2tmAaniFdCXePviDTOILSwQJrHn0EUwm03AWGLz8iVsILaIgJ3EjdUPmUGamQUesUg82vKH
	ESTBIqAqserBVFaQzZwCARJNW8sgFkxllFh5ci87SA2zgLrEpHmLmCFOUpaYt/8YE8RiQYkf
	k++xQNTIS2xe85Z5AqPALCQts5CUzUJStoCReRWjaGppckFxUnqukV5xYm5xaV66XnJ+7iZG
	SCR+3cG49JjVIUYBDkYlHt4AnlXBQqyJZcWVuYcYJTiYlUR4HecAhXhTEiurUovy44tKc1KL
	DzEycXBKNTDqaeScuXbKm7W3vZWl6OTvS/tcArbP/Zqr2FDr4qVzKmeWhF7IfeaVogtFN7GZ
	T5OcvvD199iItvLHImyX7793tV/r4nHA4On5c1l//RltrCUEnc//3ejhcUx42olZJueUv5jM
	aHpkoljEWKA372tJGvPa7LRYqWlJQrPmKKdvPCr9xXfXouNKLMUZiYZazEXFiQBwhCFgogIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On czw, 2014-06-19 at 20:20 +0200, Javier Martinez Canillas wrote:
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
> ---
>  .../devicetree/bindings/clock/maxim,max77686.txt          | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)

Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

Best regards,
Krzysztof


> diff --git a/Documentation/devicetree/bindings/clock/maxim,max77686.txt b/Documentation/devicetree/bindings/clock/maxim,max77686.txt
> index 96ce71b..8dea305 100644
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
>  	max77686: max77686@09 {
> @@ -33,6 +38,6 @@ Example: Clock consumer node
>  	foo@0 {
>  		compatible = "bar,foo";
>  		/* ... */
> -		clock-names = "my-clock";
> -		clocks = <&max77686 2>;
> +		clock-names = "32khz_pmic";
> +		clocks = <&max77686 MAX77686_CLK_PMIC>;
>  	};

