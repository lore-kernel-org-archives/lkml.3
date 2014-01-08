Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbaAHQal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 11:30:41 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:51447 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928AbaAHQaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 11:30:39 -0500
MIME-Version: 1.0
In-Reply-To: <1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
	<1389190924-26226-4-git-send-email-b.brezillon@overkiz.com>
Date: Wed, 8 Jan 2014 10:30:39 -0600
Message-ID: <CAL_Jsq+PT9MzEpHwuiSU2oeqzzqajGdBKgdxCZ8S+9W2mPN+tA@mail.gmail.com>
Subject: Re: [RFC PATCH 3/9] of: mtd: add NAND timings retrieval support
From: Rob Herring <robherring2@gmail.com>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        dev@linux-sunxi.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 8, 2014 at 8:21 AM, Boris BREZILLON <b.brezillon@overkiz.com> wrote:
> Add a function to retrieve NAND timings from a given DT node.
>
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
> ---
>  drivers/of/of_mtd.c    |   47 +++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/of_mtd.h |    9 +++++++++
>  2 files changed, 56 insertions(+)
>
> diff --git a/drivers/of/of_mtd.c b/drivers/of/of_mtd.c
> index a27ec94..52e07fd 100644
> --- a/drivers/of/of_mtd.c
> +++ b/drivers/of/of_mtd.c
> @@ -83,3 +83,50 @@ bool of_get_nand_on_flash_bbt(struct device_node *np)
>         return of_property_read_bool(np, "nand-on-flash-bbt");
>  }
>  EXPORT_SYMBOL_GPL(of_get_nand_on_flash_bbt);
> +
> +/**
> + * of_get_nand_timings - Get nand timings for the given device_node
> + * @np:        Pointer to the given device_node
> + *
> + * return 0 on success errno other wise
> + */
> +int of_get_nand_timings(struct device_node *np, struct nand_timings *timings)
> +{
> +       memset(timings, 0, sizeof(*timings));
> +
> +       of_property_read_u32(np, "tCLS-min", &timings->tCLS_min);
> +       of_property_read_u32(np, "tCLH-min", &timings->tCLH_min);
> +       of_property_read_u32(np, "tCS-min", &timings->tCS_min);
> +       of_property_read_u32(np, "tCH-min", &timings->tCH_min);
> +       of_property_read_u32(np, "tWP-min", &timings->tWP_min);
> +       of_property_read_u32(np, "tALS-min", &timings->tALS_min);
> +       of_property_read_u32(np, "tALH-min", &timings->tALH_min);
> +       of_property_read_u32(np, "tDS-min", &timings->tDS_min);
> +       of_property_read_u32(np, "tDH-min", &timings->tDH_min);
> +       of_property_read_u32(np, "tWC-min", &timings->tWC_min);
> +       of_property_read_u32(np, "tWH-min", &timings->tWH_min);
> +       of_property_read_u32(np, "tR-max", &timings->tR_max);
> +       of_property_read_u32(np, "tAR-min", &timings->tAR_min);
> +       of_property_read_u32(np, "tCLR-min", &timings->tCLR_min);
> +       of_property_read_u32(np, "tRR-min", &timings->tRR_min);
> +       of_property_read_u32(np, "tRP-min", &timings->tRP_min);
> +       of_property_read_u32(np, "tWB-max", &timings->tWB_max);
> +       of_property_read_u32(np, "tRC-min", &timings->tRC_min);
> +       of_property_read_u32(np, "tREA-max", &timings->tREA_max);
> +       of_property_read_u32(np, "tRHZ-max", &timings->tRHZ_max);
> +       of_property_read_u32(np, "tCHZ-max", &timings->tCHZ_max);
> +       of_property_read_u32(np, "tRHOH-min", &timings->tRHOH_min);
> +       of_property_read_u32(np, "tRLOH-min", &timings->tRLOH_min);
> +       of_property_read_u32(np, "tCOH-min", &timings->tCOH_min);
> +       of_property_read_u32(np, "tREH-min", &timings->tREH_min);
> +       of_property_read_u32(np, "tWHR-min", &timings->tWHR_min);
> +       of_property_read_u32(np, "tRHW-min", &timings->tRHW_min);
> +       of_property_read_u32(np, "tIR-min", &timings->tIR_min);
> +       of_property_read_u32(np, "tCR-min", &timings->tCR_min);
> +       of_property_read_u32(np, "tADL-min", &timings->tADL_min);
> +       of_property_read_u32(np, "tRST-max", &timings->tRST_max);
> +       of_property_read_u32(np, "tWW-min", &timings->tWW_min);

These all need to be documented. These apply to which compatible
strings? They should also be suffixed with the unit the property is in
(i.e. -ms, -us, -ns).

Rob
