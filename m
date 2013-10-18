Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab3JRJmv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 05:42:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39764 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab3JRJmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 05:42:49 -0400
X-AuditID: cbfee691-b7fe06d0000008c4-5d-5261027068e5
Message-id: <52610273.3080005@samsung.com>
Date: Fri, 18 Oct 2013 18:42:11 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.0
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>, Chris Ball <cjb@laptop.org>
Cc: Seungwon Jeon <tgih.jun@samsung.com>, James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        Sonny Rao <sonnyrao@chromium.org>, Bing Zhao <bzhao@marvell.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mmc: dw_mmc: Cleanup disable of low power mode w/ SDIO
 interrupts
References: <1381876762-10892-1-git-send-email-dianders@chromium.org>
 <1381876762-10892-2-git-send-email-dianders@chromium.org>
In-reply-to: <1381876762-10892-2-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsWyRsSkWLeAKTHI4ONsXovHaxYzWTyYt43N
	Yt7Wo6wW219vZLM4u+wgm8WrIz+YLN7Ne8FscXnXHDaLI//7GS1OXf/MZvHkzExGiw/3LzJb
	rNr1h9GB12N2w0UWj52z7rJ79Ow8w+hx6MpaRo8rJ5pYPSYvvMjs0bdlFaPH501yARxRXDYp
	qTmZZalF+nYJXBlL7qQUzNSteHi9m6mB8YtyFyMnh4SAicT045fYIGwxiQv31gPZXBxCAksZ
	Ja73XmCBKTr86h47RGIRo8SPU+2sEM5rRoknE9+zg1TxCmhJnL2+ihnEZhFQlVhzcj5YnE1A
	R2L7t+NMXYwcHKICIRLfJuRAlAtK/Jh8jwUkLCLgJrFivy9ImFlgErPEjmawTmGBGIllD4+z
	QKxqZJToX7kNLMEJVP/941tGiAYdif2t09ggbHmJzWveMoM0SAhM5JDoXnqNCeIeAYlvkw+B
	LZMQkJXYdIAZ4jFJiYMrbrBMYBSbheSkWUjGzkIydgEj8ypG0dSC5ILipPQiU73ixNzi0rx0
	veT83E2MwHg+/e/ZxB2M9w9YH2JMBlo5kVlKNDkfmA7ySuINjc2MLExNTI2NzC3NSBNWEudV
	b7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAo+XfGq0dB4k+X7tL9ufSVu+sLp6gzjavu
	JJ/1OXtuunWyqOXFoJgXOSzzetaWPpj/o+x1SnVSq6BG9fS+kkVLk9nOlKfKn7lbbPim6Ogz
	98epvn8XvYs6cq225OgZxr4dSaWPVhjWHznMHv1fmtEpuejpFr2bBpNUO9P0VrQZ7Ip81PU0
	gSVbiaU4I9FQi7moOBEAujUnZv0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAd0CpsQgg8V/mSwer1nMZPFg3jY2
	i3lbj7JabH+9kc3i7LKDbBavjvxgsng37wWzxeVdc9gsjvzvZ7Q4df0zm8WTMzMZLT7cv8hs
	sWrXH0YHXo/ZDRdZPHbOusvu0bPzDKPHoStrGT2unGhi9Zi88CKzR9+WVYwenzfJBXBENTDa
	ZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdraRQlphT
	ChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMWHInpWCmbsXD691MDYxflLsYOTkk
	BEwkDr+6xw5hi0lcuLeerYuRi0NIYBGjxI9T7awQzmtGiScT34NV8QpoSZy9vooZxGYRUJVY
	c3I+WJxNQEdi+7fjTF2MHByiAiES3ybkQJQLSvyYfI8FJCwi4CaxYr8vSJhZYBKzxI5msE5h
	gRiJZQ+Ps0CsamSU6F+5DSzBCVT//eNbRogGHYn9rdPYIGx5ic1r3jJPYBSYhWTFLCRls5CU
	LWBkXsUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnCyeSe9gXNVgcYhRgINRiYf3wLf4ICHW
	xLLiytxDjBIczEoivM//JgQJ8aYkVlalFuXHF5XmpBYfYkwGBsBEZinR5HxgIssriTc0NjEz
	sjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBkYO9dlhRyvfumw/UuHNuMOm
	7JLdn1zznhXWDT4r9su8mz+trOzglJfsf/tyJh58/H76lV2xvcavONW22P5ntk8oi2cR55Lf
	zqv7u+F3qe+CR94XU/89PsbQy3z5YKehzXmj+4f478/XaLadcVSkdZeVg6JhdcK8thMRemz2
	1vJ+wpvXGwQLblFiKc5INNRiLipOBAAghGRXWgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Doug,

On 10/16/2013 07:39 AM, Doug Anderson wrote:
> In the patch (9623b5b mmc: dw_mmc: Disable low power mode if SDIO
> interrupts are used) I added code that disabled the low power mode of
> dw_mmc when SDIO interrupts are used.  That code worked but always
> felt a little hacky because we ended up disabling low power as a side
> effect of the first enable_sdio_irq() call.  That wouldn't be so bad
> except that disabling low power involves a complicated process of
> writing to the CMD/CMDARG registers and that extra process makes it
> difficult to cleanly the read-modify-write race in
> dw_mci_enable_sdio_irq() (see future patch in the series).
> 
> Change the code to take advantage of the init_card() callback of the
> mmc core to know when an SDIO card has been inserted.  If we've got a
> SDIO card and we're configured to use SDIO Interrupts then turn off
> "low power mode" right away.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc.c | 68 ++++++++++++++++++++++++-----------------------
>  drivers/mmc/host/dw_mmc.h |  1 +
>  2 files changed, 36 insertions(+), 33 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 0a6a512..1b75816 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -27,6 +27,7 @@
>  #include <linux/stat.h>
>  #include <linux/delay.h>
>  #include <linux/irq.h>
> +#include <linux/mmc/card.h>
>  #include <linux/mmc/host.h>
>  #include <linux/mmc/mmc.h>
>  #include <linux/mmc/sdio.h>
> @@ -822,7 +823,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>  
>  		/* enable clock; only low power if no SDIO */
>  		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
> -		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
> +		if (!test_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags))
>  			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>  		mci_writel(host, CLKENA, clk_en_a);
>  
> @@ -1050,27 +1051,37 @@ static int dw_mci_get_cd(struct mmc_host *mmc)
>  	return present;
>  }
>  
> -/*
> - * Disable lower power mode.
> - *
> - * Low power mode will stop the card clock when idle.  According to the
> - * description of the CLKENA register we should disable low power mode
> - * for SDIO cards if we need SDIO interrupts to work.
> - *
> - * This function is fast if low power mode is already disabled.
> - */
> -static void dw_mci_disable_low_power(struct dw_mci_slot *slot)
> +static void dw_mci_init_card(struct mmc_host *mmc, struct mmc_card *card)
>  {
> +	struct dw_mci_slot *slot = mmc_priv(mmc);
>  	struct dw_mci *host = slot->host;
> -	u32 clk_en_a;
> -	const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
>  
> -	clk_en_a = mci_readl(host, CLKENA);
> +	/*
> +	 * Low power mode will stop the card clock when idle.  According to the
> +	 * description of the CLKENA register we should disable low power mode
> +	 * for SDIO cards if we need SDIO interrupts to work.
> +	 */
> +	if (mmc->caps | MMC_CAP_SDIO_IRQ) {
mmc->caps & MMC_CAP_SDIO_IRQ?
> +		const u32 clken_low_pwr = SDMMC_CLKEN_LOW_PWR << slot->id;
> +		u32 clk_en_a_old;
> +		u32 clk_en_a;
>  
> -	if (clk_en_a & clken_low_pwr) {
> -		mci_writel(host, CLKENA, clk_en_a & ~clken_low_pwr);
> -		mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
> -			     SDMMC_CMD_PRV_DAT_WAIT, 0);
> +		clk_en_a_old = mci_readl(host, CLKENA);
> +
> +		if (card->type == MMC_TYPE_SDIO ||
> +		    card->type == MMC_TYPE_SD_COMBO) {
> +			set_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
> +			clk_en_a = clk_en_a_old & ~clken_low_pwr;
> +		} else {
> +			clear_bit(DW_MMC_CARD_NO_LOW_PWR, &slot->flags);
> +			clk_en_a = clk_en_a_old | clken_low_pwr;
When this condition is entered? card->type is always MMC_TYPE_SDIO or MMC_TYPE_SD_COMBO, isn't?

Best Regards,
Jaehoon Chung
> +		}
> +
> +		if (clk_en_a != clk_en_a_old) {
> +			mci_writel(host, CLKENA, clk_en_a);
> +			mci_send_cmd(slot, SDMMC_CMD_UPD_CLK |
> +				     SDMMC_CMD_PRV_DAT_WAIT, 0);
> +		}
>  	}
>  }
>  
> @@ -1082,21 +1093,11 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>  
>  	/* Enable/disable Slot Specific SDIO interrupt */
>  	int_mask = mci_readl(host, INTMASK);
> -	if (enb) {
> -		/*
> -		 * Turn off low power mode if it was enabled.  This is a bit of
> -		 * a heavy operation and we disable / enable IRQs a lot, so
> -		 * we'll leave low power mode disabled and it will get
> -		 * re-enabled again in dw_mci_setup_bus().
> -		 */
> -		dw_mci_disable_low_power(slot);
> -
> -		mci_writel(host, INTMASK,
> -			   (int_mask | SDMMC_INT_SDIO(slot->id)));
> -	} else {
> -		mci_writel(host, INTMASK,
> -			   (int_mask & ~SDMMC_INT_SDIO(slot->id)));
> -	}
> +	if (enb)
> +		int_mask |= SDMMC_INT_SDIO(slot->id);
> +	else
> +		int_mask &= ~SDMMC_INT_SDIO(slot->id);
> +	mci_writel(host, INTMASK, int_mask);
>  }
>  
>  static int dw_mci_execute_tuning(struct mmc_host *mmc, u32 opcode)
> @@ -1140,6 +1141,7 @@ static const struct mmc_host_ops dw_mci_ops = {
>  	.get_cd			= dw_mci_get_cd,
>  	.enable_sdio_irq	= dw_mci_enable_sdio_irq,
>  	.execute_tuning		= dw_mci_execute_tuning,
> +	.init_card		= dw_mci_init_card,
>  };
>  
>  static void dw_mci_request_end(struct dw_mci *host, struct mmc_request *mrq)
> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
> index 6bf24ab..26d4657 100644
> --- a/drivers/mmc/host/dw_mmc.h
> +++ b/drivers/mmc/host/dw_mmc.h
> @@ -227,6 +227,7 @@ struct dw_mci_slot {
>  	unsigned long		flags;
>  #define DW_MMC_CARD_PRESENT	0
>  #define DW_MMC_CARD_NEED_INIT	1
> +#define DW_MMC_CARD_NO_LOW_PWR	2
>  	int			id;
>  	int			last_detect_state;
>  };
> 

