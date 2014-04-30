Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945968AbaD3RwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 13:52:05 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:50125 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945934AbaD3RwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 13:52:03 -0400
Date: Wed, 30 Apr 2014 10:51:57 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Boris BREZILLON <b.brezillon.dev@gmail.com>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Herring <robherring2@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mtd@lists.infradead.org,
        dev@linux-sunxi.org
Subject: Re: [PATCH v3 1/9] mtd: nand: define struct nand_timings
Message-ID: <20140430175157.GB2497@norris-Latitude-E6410>
References: <1394647664-8258-1-git-send-email-b.brezillon.dev@gmail.com>
 <1394647664-8258-2-git-send-email-b.brezillon.dev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1394647664-8258-2-git-send-email-b.brezillon.dev@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris,

On Wed, Mar 12, 2014 at 07:07:36PM +0100, Boris BREZILLON wrote:
> Define a struct containing the standard NAND timings as described in NAND
> datasheets.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
>  include/linux/mtd/nand.h |   49 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 49 insertions(+)
> 
> diff --git a/include/linux/mtd/nand.h b/include/linux/mtd/nand.h
> index 389b3c5..f3ff3a3 100644
> --- a/include/linux/mtd/nand.h
> +++ b/include/linux/mtd/nand.h
> @@ -846,4 +846,53 @@ static inline bool nand_is_slc(struct nand_chip *chip)
>  {
>  	return chip->bits_per_cell == 1;
>  }
> +
> +/**
> + * struct nand_sdr_timings - SDR NAND chip timings
> + *
> + * This struct defines the timing requirements of a SDR NAND chip.
> + * These informations can be found in every NAND datasheets and the timings
> + * meaning are described in the ONFI specifications:
> + * www.onfi.org/~/media/ONFI/specs/onfi_3_1_spec.pdf‎ (chapter 4.15 Timing

Can you remove the unicode U+200E character?

> + * Parameters)

Please document the units for these fields here. It looks like you're
using picoseconds.

> + *
> + */
> +

Extra blank line.

> +struct nand_sdr_timings {
> +	u32 tALH_min;
> +	u32 tADL_min;
> +	u32 tALS_min;
> +	u32 tAR_min;
> +	u32 tCEA_max;
> +	u32 tCEH_min;
> +	u32 tCH_min;
> +	u32 tCHZ_max;
> +	u32 tCLH_min;
> +	u32 tCLR_min;
> +	u32 tCLS_min;
> +	u32 tCOH_min;
> +	u32 tCS_min;
> +	u32 tDH_min;
> +	u32 tDS_min;
> +	u32 tFEAT_max;
> +	u32 tIR_min;
> +	u32 tITC_max;
> +	u32 tRC_min;
> +	u32 tREA_max;
> +	u32 tREH_min;
> +	u32 tRHOH_min;
> +	u32 tRHW_min;
> +	u32 tRHZ_max;
> +	u32 tRLOH_min;
> +	u32 tRP_min;
> +	u32 tRR_min;
> +	u64 tRST_max;
> +	u32 tWB_max;
> +	u32 tWC_min;
> +	u32 tWH_min;
> +	u32 tWHR_min;
> +	u32 tWP_min;
> +	u32 tWW_min;
> +};
> +
>  #endif /* __LINUX_MTD_NAND_H */

Brian
