Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab3IINCR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:02:17 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:33888 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab3IINCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:02:16 -0400
Date: Mon, 9 Sep 2013 14:02:11 +0100
From: Lee Jones <lee.jones@linaro.org>
To: wei_wang@realsil.com.cn
Cc: sameo@linux.intel.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        rogerable@realtek.com, micky_ching@realsil.com.cn
Subject: Re: [PATCH v2] mfd: rtsx: Modify rts5249_optimize_phy
Message-ID: <20130909130211.GG22938@lee--X1>
References: <cover.1378437776.git.wei_wang@realsil.com.cn>
 <e858b38c5b87dd761c764c6214f49cf9a9b5ad1d.1378437776.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e858b38c5b87dd761c764c6214f49cf9a9b5ad1d.1378437776.git.wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Sep 2013, wei_wang@realsil.com.cn wrote:

> From: Wei WANG <wei_wang@realsil.com.cn>
> 
> In some platforms, specially Thinkpad series, rts5249 won't be
> initialized properly. So we need adjust some phy parameters to
> improve the compatibility issue.
> 
> Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
> ---
>  drivers/mfd/rts5249.c        |   35 ++++++++++++++++++++++++++++++++--
>  include/linux/mfd/rtsx_pci.h |   43 ++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mfd/rts5249.c b/drivers/mfd/rts5249.c
> index 3b835f5..7653638 100644
> --- a/drivers/mfd/rts5249.c
> +++ b/drivers/mfd/rts5249.c

Ignoring the driver code for now.

>  static int rts5249_turn_on_led(struct rtsx_pcr *pcr)
> diff --git a/include/linux/mfd/rtsx_pci.h b/include/linux/mfd/rtsx_pci.h
> index d1382df..de20538 100644
> --- a/include/linux/mfd/rtsx_pci.h
> +++ b/include/linux/mfd/rtsx_pci.h
> @@ -719,16 +719,41 @@
>  
>  /* Phy register */
>  #define PHY_PCR				0x00
> +#define  FORCE_CODE			0xB000
> +#define  OOBS_CALI_50			0x0800
> +#define  OOBS_VCM_08			0x0200
> +#define  OOBS_SEN_90			0x0040
> +#define  RSSI_EN			0x0002
>  #define PHY_RCR0			0x01
>  #define PHY_RCR1			0x02
> +#define  ADP_TIME			0x0100
> +#define  VCO_COARSE			0x001F
>  #define PHY_RCR2			0x03
> +#define  EMPHASE_EN			0x8000
> +#define  NADJR				0x4000
> +#define  CDR_CP_10			0x0400
> +#define  CDR_SR_2			0x0100
> +#define  FREQSEL_12			0x0040
> +#define  CPADJEN			0x0020
> +#define  CDR_SC_8			0x0008
> +#define  CALIB_LATE			0x0002
>  #define PHY_RTCR			0x04
>  #define PHY_RDR				0x05
> +#define  RXDSEL_1_9			0x4000
>  #define PHY_TCR0			0x06
>  #define PHY_TCR1			0x07
>  #define PHY_TUNE			0x08
> +#define  TUNEREF_1_0			0x4000
> +#define  VBGSEL_1252			0x0C00
> +#define  SDBUS_33			0x0200
> +#define  TUNED18			0x01C0
> +#define  TUNED12			0X0020
>  #define PHY_IMR				0x09
>  #define PHY_BPCR			0x0A
> +#define  IBRXSEL			0x0400
> +#define  IBTXSEL			0x0100
> +#define  IB_FILTER			0x0080
> +#define  CMIRROR_EN			0x0040
>  #define PHY_BIST			0x0B
>  #define PHY_RAW_L			0x0C
>  #define PHY_RAW_H			0x0D
> @@ -744,11 +769,29 @@
>  #define PHY_BRNR2			0x17
>  #define PHY_BENR			0x18
>  #define PHY_REG_REV			0x19
> +#define  REG_REV_RESV			0xE000
> +#define  RXIDLE_LATCHED			0x1000
> +#define  P1_EN				0x0800
> +#define  RXIDLE_EN			0x0400
> +#define  CLKREQ_DLY_TIMER_1_0		0x0040
> +#define  STOP_CLKRD			0x0020
> +#define  RX_PWST			0x0008
> +#define  STOP_CLKWR			0x0004
>  #define PHY_FLD0			0x1A
>  #define PHY_FLD1			0x1B
>  #define PHY_FLD2			0x1C
>  #define PHY_FLD3			0x1D
> +#define  TIMER_4			0x7800
> +#define  TIMER_6			0x00E0
> +#define  RXDELINK			0x0004
>  #define PHY_FLD4			0x1E
> +#define  FLDEN_SEL			0x4000
> +#define  REQ_REF			0x2000
> +#define  RXAMP_OFF			0x1000
> +#define  REQ_ADDA			0x0800
> +#define  BER_COUNT			0x00E0
> +#define  BER_TIMER			0x000A
> +#define  BER_CHK_EN			0x0001
>  #define PHY_DUM_REG			0x1F
>  
>  #define LCTLR				0x80

This doesn't look right.

We had a nicely structured, ordered list and now you've seemingly
randomly shoved a truck load of un-prefixed defines between them.

Am I missing something? Is there method to the madness?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
