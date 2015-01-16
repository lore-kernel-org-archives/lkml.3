Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752278AbbAPWvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 17:51:46 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65275 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbbAPWvo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 17:51:44 -0500
Message-ID: <54B995FC.9080903@nod.at>
Date: Fri, 16 Jan 2015 23:51:40 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: ssantosh@kernel.org
CC: linux-kernel@vger.kernel.org, d.walter@0x90.at
Subject: Re: [PATCH] ddr: Use less generic identifiers
References: <1420386535-22530-1-git-send-email-richard@nod.at>
In-Reply-To: <1420386535-22530-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.01.2015 um 16:48 schrieb Richard Weinberger:
> At least on UML this identifiers clash with register names.
> Use something less generic than Rx, Cx and Cx.
> 
>   CC      lib//jedec_ddr_data.o
> In file included from ./arch/um/include/asm/ptrace-generic.h:11:0,
>                  from ./arch/x86/um/asm/ptrace.h:8,
>                  from ./arch/x86/include/asm/alternative.h:8,
>                  from ./arch/x86/include/asm/bitops.h:16,
>                  from include/linux/bitops.h:36,
>                  from include/linux/kernel.h:10,
>                  from include/linux/list.h:8,
>                  from include/linux/module.h:9,
>                  from lib//jedec_ddr_data.c:14:
> ./arch/x86/include/uapi/asm/ptrace-abi.h:28:0: warning: "R15" redefined [enabled by default]
>  #define R15 0
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
> Please note that this patch is untested.
> 
> Thanks,
> //richard
> ---
>  drivers/memory/emif.c      |  4 ++--
>  include/memory/jedec_ddr.h | 36 ++++++++++++++++++------------------
>  lib/jedec_ddr_data.c       | 20 ++++++++++----------
>  3 files changed, 30 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
> index 04644e7..e0aa09f 100644
> --- a/drivers/memory/emif.c
> +++ b/drivers/memory/emif.c
> @@ -439,7 +439,7 @@ static u32 get_sdram_tim_1_shdw(const struct lpddr2_timings *timings,
>  	val = max(min_tck->tWTR, DIV_ROUND_UP(timings->tWTR, t_ck)) - 1;
>  	tim1 |= val << T_WTR_SHIFT;
>  
> -	if (addressing->num_banks == B8)
> +	if (addressing->num_banks == DDR_BANK_8)
>  		val = DIV_ROUND_UP(timings->tFAW, t_ck*4);
>  	else
>  		val = max(min_tck->tRRD, DIV_ROUND_UP(timings->tRRD, t_ck));
> @@ -476,7 +476,7 @@ static u32 get_sdram_tim_1_shdw_derated(const struct lpddr2_timings *timings,
>  	 * tFAW is approximately 4 times tRRD. So add 1875*4 = 7500ps
>  	 * to tFAW for de-rating
>  	 */
> -	if (addressing->num_banks == B8) {
> +	if (addressing->num_banks == DDR_BANK_8) {
>  		val = DIV_ROUND_UP(timings->tFAW + 7500, 4 * t_ck) - 1;
>  	} else {
>  		val = DIV_ROUND_UP(timings->tRRD + 1875, t_ck);
> diff --git a/include/memory/jedec_ddr.h b/include/memory/jedec_ddr.h
> index ddad0f8..39144d0 100644
> --- a/include/memory/jedec_ddr.h
> +++ b/include/memory/jedec_ddr.h
> @@ -40,28 +40,28 @@
>  #define DDR_IO_WIDTH_32		4
>  
>  /* Number of Row bits */
> -#define R9			9
> -#define R10			10
> -#define R11			11
> -#define R12			12
> -#define R13			13
> -#define R14			14
> -#define R15			15
> -#define R16			16
> +#define DDR_ROW_9		9
> +#define DDR_ROW_10		10
> +#define DDR_ROW_11		11
> +#define DDR_ROW_12		12
> +#define DDR_ROW_13		13
> +#define DDR_ROW_14		14
> +#define DDR_ROW_15		15
> +#define DDR_ROW_16		16
>  
>  /* Number of Column bits */
> -#define C7			7
> -#define C8			8
> -#define C9			9
> -#define C10			10
> -#define C11			11
> -#define C12			12
> +#define DDR_COL_7		7
> +#define DDR_COL_8		8
> +#define DDR_COL_9		9
> +#define DDR_COL_10		10
> +#define DDR_COL_11		11
> +#define DDR_COL_12		12
>  
>  /* Number of Banks */
> -#define B1			0
> -#define B2			1
> -#define B4			2
> -#define B8			3
> +#define DDR_BANK_1		0
> +#define DDR_BANK_2		1
> +#define DDR_BANK_4		2
> +#define DDR_BANK_8		3
>  
>  /* Refresh rate in nano-seconds */
>  #define T_REFI_15_6		15600
> diff --git a/lib/jedec_ddr_data.c b/lib/jedec_ddr_data.c
> index 6d2cbf1..2181be4 100644
> --- a/lib/jedec_ddr_data.c
> +++ b/lib/jedec_ddr_data.c
> @@ -16,16 +16,16 @@
>  /* LPDDR2 addressing details from JESD209-2 section 2.4 */
>  const struct lpddr2_addressing
>  	lpddr2_jedec_addressing_table[NUM_DDR_ADDR_TABLE_ENTRIES] = {
> -	{B4, T_REFI_15_6, T_RFC_90}, /* 64M */
> -	{B4, T_REFI_15_6, T_RFC_90}, /* 128M */
> -	{B4, T_REFI_7_8,  T_RFC_90}, /* 256M */
> -	{B4, T_REFI_7_8,  T_RFC_90}, /* 512M */
> -	{B8, T_REFI_7_8, T_RFC_130}, /* 1GS4 */
> -	{B8, T_REFI_3_9, T_RFC_130}, /* 2GS4 */
> -	{B8, T_REFI_3_9, T_RFC_130}, /* 4G */
> -	{B8, T_REFI_3_9, T_RFC_210}, /* 8G */
> -	{B4, T_REFI_7_8, T_RFC_130}, /* 1GS2 */
> -	{B4, T_REFI_3_9, T_RFC_130}, /* 2GS2 */
> +	{DDR_BANK_4, T_REFI_15_6, T_RFC_90}, /* 64M */
> +	{DDR_BANK_4, T_REFI_15_6, T_RFC_90}, /* 128M */
> +	{DDR_BANK_4, T_REFI_7_8,  T_RFC_90}, /* 256M */
> +	{DDR_BANK_4, T_REFI_7_8,  T_RFC_90}, /* 512M */
> +	{DDR_BANK_8, T_REFI_7_8, T_RFC_130}, /* 1GS4 */
> +	{DDR_BANK_8, T_REFI_3_9, T_RFC_130}, /* 2GS4 */
> +	{DDR_BANK_8, T_REFI_3_9, T_RFC_130}, /* 4G */
> +	{DDR_BANK_8, T_REFI_3_9, T_RFC_210}, /* 8G */
> +	{DDR_BANK_4, T_REFI_7_8, T_RFC_130}, /* 1GS2 */
> +	{DDR_BANK_4, T_REFI_3_9, T_RFC_130}, /* 2GS2 */
>  };
>  EXPORT_SYMBOL_GPL(lpddr2_jedec_addressing_table);

Ping?

Thanks,
//richard
