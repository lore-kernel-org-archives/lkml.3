Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbbATQOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:14:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:39287 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbbATQO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:14:27 -0500
Date: Tue, 20 Jan 2015 16:14:03 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/8] soc: Add MediaTek infracfg controller support
Message-ID: <20150120161403.GG15924@leverpostej>
References: <1421747231-554-1-git-send-email-s.hauer@pengutronix.de>
 <1421747231-554-2-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421747231-554-2-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 09:47:04AM +0000, Sascha Hauer wrote:
> This adds support for the MediaTek infracfg controller found
> on the MT8135/MT8173 SoCs. The infracfg controller contains
> miscellaneous registers for controlling peripheral resets and
> clocks.
> 
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>  .../devicetree/bindings/soc/mediatek/infracfg.txt  |  19 +++
>  drivers/soc/Kconfig                                |   1 +
>  drivers/soc/Makefile                               |   1 +
>  drivers/soc/mediatek/Kconfig                       |  12 ++
>  drivers/soc/mediatek/Makefile                      |   1 +
>  drivers/soc/mediatek/mtk-infracfg.c                | 127 ++++++++++++++++++++
>  drivers/soc/mediatek/mtk-pericfg.c                 | 128 +++++++++++++++++++++
>  7 files changed, 289 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/soc/mediatek/infracfg.txt
>  create mode 100644 drivers/soc/mediatek/Kconfig
>  create mode 100644 drivers/soc/mediatek/Makefile
>  create mode 100644 drivers/soc/mediatek/mtk-infracfg.c
>  create mode 100644 drivers/soc/mediatek/mtk-pericfg.c
> 
> diff --git a/Documentation/devicetree/bindings/soc/mediatek/infracfg.txt b/Documentation/devicetree/bindings/soc/mediatek/infracfg.txt
> new file mode 100644
> index 0000000..042083a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/mediatek/infracfg.txt
> @@ -0,0 +1,19 @@
> +MediaTek infracfg Controller
> +
> +The infracfg controller contains miscellaneous registers for controlling
> +clocks, resets and bus settings.
> +
> +Required properties:
> +- compatible: must be one of:
> +       mediatek,mt8135-infracfg
> +       mediatek,mt8173-infracfg
> +- reg: Address range for the infracfg controller
> +
> +Example:
> +
> +       infracfg: infracfg@10003000 {
> +               #reset-cells = <1>;
> +               #clock-cells = <1>;

These weren't listed as required or optional above.

Please document these, along with the values a given clock-specifier or
reset-specifier may take.

> +               compatible = "mediatek,mt8135-infracfg";
> +               reg = <0 0x10003000 0 0x1000>;
> +       };

Thanks,
Mark.
