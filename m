Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab3IWOAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:00:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:17507 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614Ab3IWOAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:00:19 -0400
X-AuditID: cbfec7f5-b7ef66d00000795a-ad-5240497071ce
From: Tomasz Figa <t.figa@samsung.com>
To: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Cc: kyungmin.park@samsung.com, dwmw2@infradead.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk, rob@landley.net,
        linux-samsung-soc@vger.kernel.org, m.szyprowski@samsung.com,
        b.zolnierkie@samsung.com
Subject: Re: [PATCH v2] MTD: Onenand: Add device tree support for samsung
 onenand
Date: Mon, 23 Sep 2013 16:00:05 +0200
Message-id: <1552206.KhB7jIjAI2@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11 (Linux/3.10.10-gentoo; KDE/4.11.0; x86_64; ; )
In-reply-to: <1379941608-5068-1-git-send-email-m.krawczuk@partner.samsung.com>
References: <1379941608-5068-1-git-send-email-m.krawczuk@partner.samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOIsWRmVeSWpSXmKPExsVy+t/xy7oFng5BBm/2W1tsnLGe1WL+kXOs
	FhNXTma2OPBnB6PFuVcrGS3ONr1ht1jYtoTF4vKuOWwWu5uWsVvMOL+PyeL0mlPMFmuP3GW3
	WHr9IpPFhOlrWSwOrzjAZLHu5XQWi1cH21gcBD3WzFvD6LHg8xV2j5XLv7B5bF6h5fFq9UxW
	jzvX9gB5S+o9Dr7bw+TRt2UVo8fnTXIeG+eGBnBHcdmkpOZklqUW6dslcGVsXPKHueCyVsXZ
	iZ9YGxg3KHUxcnJICJhIzOh8zAJhi0lcuLeerYuRi0NIYCmjxJZbnVBOF5PEldnbwKrYBNQk
	Pjc8YgOxRQRMJd7dvQZWxCywhlli96/HzCAJYYFgidWbLzJ2MXJwsAioShyYbQMS5hXQlPj1
	qQmshF9AXeLdtqdMILaogKvEp4Ub2UFsTgE/ib693WA1QgK+Eh3XrzND9ApK/Jh8D+wGZgF5
	iX37p7JC2FoS63ceZ5rAKDgLSdksJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7
	iRESmV93MC49ZnWIUYCDUYmHNyLRPkiINbGsuDL3EKMEB7OSCO8iRYcgId6UxMqq1KL8+KLS
	nNTiQ4xMHJxSDYzLPwnrmIo28ZutDAoVn/Qk896SL3cVlGYsmn989rIJfe3eifxZ/T9d2r92
	H0i6JyUf/vGE3dZXe/ZNEuBq1JCMu+vuKV0j0sLtpLT9ueTibU6vXU5WHUpd/fbiOVEtE1eR
	49LmuQsELR9urhfef6RJUvLPH7+vcZndvlM/lzbEpuxd7O0VwKvEUpyRaKjFXFScCABhR3dS
	qgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mateusz,

On Monday 23 of September 2013 15:06:48 Mateusz Krawczuk wrote:
> This patch add clk and device tree nodes for samsung onenand driver.
> 
> since v1:
> Updated Documentation according to Mark Rutland notes.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/mtd/samsung-onenand.txt    | 44 ++++++++++++++++++++++
>  drivers/mtd/onenand/samsung.c                      | 37 +++++++++++++++++-
>  2 files changed, 80 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> 
> diff --git a/Documentation/devicetree/bindings/mtd/samsung-onenand.txt b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> new file mode 100644
> index 0000000..5bf931c
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mtd/samsung-onenand.txt
> @@ -0,0 +1,44 @@
> +Device tree bindings for Samsung Onenand
> +
> +Required properties:
> +  - compatible: value should be either of the following.
> +      (a) "samsung,s3c6400-onenand",
> +		for onenand controller compatible with s3c6400.
> +      (b) "samsung,s3c6410-onenand",
> +		for onenand controller compatible with s3c6410.
> +      (c) "samsung,s5pc100-onenand",
> +		for onenand controller compatible with s5pc100.
> +      (d) "samsung,s5pc110-onenand",

For consistency with other bindings, I would use s5pv210 here, even if
existing driver code refers to it as s5pc110. Device tree bindings are
independent from driver internals.

> +      for s5pc100-like onenand controller used on s5pc110 which supports DMA.

nit: inconsistent indentation of (d) case

nit2: each subsequent indentation level should use higher indentation:

	- compatible: value should be either of the following.
		(a) "samsung,s3c6400-onenand",
			for onenand controller compatible with s3c6400.

> +
> +Required properties for s5pc110:
> +
> + - reg: the offset and length of the control registers. First region describes
> +	OneNAND interface, second control registers.
> + - interrupt-parent, interrupts		Onenand memory interrupts

Inconsistent formatting of property description. The reg property above
used "property: description", while this one uses a single tab.

Also please describe both properties separately and specify how many
interrupts are required.

> +
> +Required properties for others:
> +
> + - reg: the offset and length of the control registers. First region describes
> +	control registers, second OneNAND interface.
> +
> +Clocks:
> + - gate - clock which output is supplied to external OneNAND flash memory.

Inconsistent formatting of property description.

> +
> +
> +For partiton table parsing (optional) please refer to:
> + [1] Documentation/devicetree/bindings/mtd/partition.txt
> +
> +Example for an s5pv210 board:
> +
> +		onenand@b0000000 {
> +			compatible = "samsung,s5pc110-onenand";
> +			reg = <0xb0000000 0x20000>, <0xb0600000 0x2000>;
> +			interrupt-parent = <&vic1>;
> +			interrupts = <31>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			clocks = <&clocks NANDXL>;
> +			clock-names = "gate";
> +			status = "okay";

This status property is not a part of this binding, so it can be safely
dropped.

> +		};
> diff --git a/drivers/mtd/onenand/samsung.c b/drivers/mtd/onenand/samsung.c
> index df7400d..5a2cc4b 100644
> --- a/drivers/mtd/onenand/samsung.c
> +++ b/drivers/mtd/onenand/samsung.c
> @@ -14,6 +14,7 @@
>   *	S5PC110: use DMA
>   */
>  
> +#include <linux/clk.h>
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/sched.h>
> @@ -24,6 +25,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/interrupt.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  
>  #include <asm/mach/flash.h>
>  
> @@ -133,6 +135,7 @@ enum soc_type {
>  struct s3c_onenand {
>  	struct mtd_info	*mtd;
>  	struct platform_device	*pdev;
> +	struct clk *gate;
>  	enum soc_type	type;
>  	void __iomem	*base;
>  	struct resource *base_res;
> @@ -859,6 +862,19 @@ static void s3c_onenand_setup(struct mtd_info *mtd)
>  	this->write_bufferram = onenand_write_bufferram;
>  }
>  
> +static const struct of_device_id onenand_s3c_dt_match[] = {
> +	{ .compatible = "samsung,s3c6400-onenand",
> +		.data = (void *)TYPE_S3C6400 },
> +	{ .compatible = "samsung,s3c6410-onenand",
> +		.data = (void *)TYPE_S3C6410 },
> +	{ .compatible = "samsung,s5pc100-onenand",
> +		.data = (void *)TYPE_S5PC100 },
> +	{ .compatible = "samsung,s5pc110-onenand",
> +		.data = (void *)TYPE_S5PC110 },
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, onenand_s3c_dt_match);
> +
>  static int s3c_onenand_probe(struct platform_device *pdev)
>  {
>  	struct onenand_platform_data *pdata;
> @@ -883,12 +899,26 @@ static int s3c_onenand_probe(struct platform_device *pdev)
>  		goto onenand_fail;
>  	}
>  
> +	onenand->gate = clk_get(&pdev->dev, "gate");

You can use devm_clk_get() here to remove the need to explicitly put the
clock at remove.

> +	if (IS_ERR(onenand->gate))
> +		return PTR_ERR(onenand->gate);
> +	clk_prepare_enable(onenand->gate);
> +

This is a separate change that should be submitted as a separate patch.

Also you need to add a clk_disable_unprepare() in error path at the
bottom of this function.

Best regards,
Tomasz

