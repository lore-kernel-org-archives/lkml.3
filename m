Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752899AbaKCRAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:00:55 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:43900 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbaKCRAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:00:52 -0500
Date: Mon, 3 Nov 2014 17:00:42 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v3 02/14] mfd/regulator: dt-bindings: max77686: Document
 of_compatible for regulator
Message-ID: <20141103170042.GC12011@x1>
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com>
 <1414668053-31370-3-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1414668053-31370-3-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014, Krzysztof Kozlowski wrote:

> Document new required property for regulator driver: of_compatible. The
> property allows MFD core to bind the driver to node with regulators and
> this simplifies parsing regulators init data from DTS
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> ---
>  Documentation/devicetree/bindings/mfd/max77686.txt | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

I want a thumbs-up from Mark on this before applying.

> diff --git a/Documentation/devicetree/bindings/mfd/max77686.txt b/Documentation/devicetree/bindings/mfd/max77686.txt
> index 75fdfaf41831..f4010a9f66eb 100644
> --- a/Documentation/devicetree/bindings/mfd/max77686.txt
> +++ b/Documentation/devicetree/bindings/mfd/max77686.txt
> @@ -18,8 +18,11 @@ Required properties:
>  
>  Optional node:
>  - voltage-regulators : The regulators of max77686 have to be instantiated
> -  under subnode named "voltage-regulators" using the following format.
> +  under subnode named "voltage-regulators".
> +  Required property:
> +  - compatible : Must be "maxim,max77686-pmic"
>  
> +  Optional properties: For each regulator use following format:
>  	regulator_name {
>  		regulator-compatible = LDOn/BUCKn
>  		standard regulator constraints....
> @@ -49,6 +52,8 @@ Example:
>  		reg = <0x09>;
>  
>  		voltage-regulators {
> +			compatible = "maxim,max77686-pmic";
> +
>  			ldo11_reg {
>  				regulator-compatible = "LDO11";
>  				regulator-name = "vdd_ldo11";

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
