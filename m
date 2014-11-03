Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaKCKYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 05:24:17 -0500
Received: from regular1.263xmail.com ([211.150.99.135]:46718 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaKCKYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 05:24:15 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: jh80.chung@samsung.com
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <4079c2c6729a5538196b821181b654be>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Message-ID: <545757B3.30208@rock-chips.com>
Date: Mon, 03 Nov 2014 18:23:47 +0800
From: addy ke <addy.ke@rock-chips.com>
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: jh80.chung@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, tgih.jun@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org
CC: huangtao@rock-chips.com, devicetree@vger.kernel.org, hl@rock-chips.com,
        linux-doc@vger.kernel.org, yzq@rock-chips.com, zyw@rock-chips.com,
        zhangqing@rock-chips.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kever.yang@rock-chips.com,
        lintao@rock-chips.com, linux-rockchip@lists.infradead.org,
        xjq@rock-chips.com, zhenfu.fang@rock-chips.com, chenfen@rock-chips.com,
        cf@rock-chips.com, hj@rock-chips.com,
        linux-arm-kernel@lists.infradead.org, zyf@rock-chips.com
Subject: Re: [PATCH v3] mmc: dw_mmc: add support for the other bit of sdio
 interrupt
References: <1414666240-16782-1-git-send-email-addy.ke@rock-chips.com> <1414977633-3196-1-git-send-email-addy.ke@rock-chips.com> <5457440E.3070002@samsung.com>
In-Reply-To: <5457440E.3070002@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jaehoo

On 2014/11/3 16:59, Jaehoon Chung wrote:
> Hi, Addy.
> 
> On 11/03/2014 10:20 AM, Addy Ke wrote:
>> The bit of sdio interrupt is 16 in designware implementation,
>> but it is 24 on Rockchip SoCs.This patch add sdio_id0 for the
>> number of slot0 in the SDIO interrupt registers.
>>
>> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
>> ---
>> Changes in v2:
>> - rebase on http://git.linaro.org/git/people/ulf.hansson/mmc.git, next branch
>> Changes in v3:
>> - Remove dts for sdio_id0, just replace this with 8, suggested by Doug
>> - Change to support all Rockchip Socs, suggested by Heiko
>>
>>  drivers/mmc/host/dw_mmc-rockchip.c | 10 ++++++++++
>>  drivers/mmc/host/dw_mmc.c          | 12 +++++++-----
>>  drivers/mmc/host/dw_mmc.h          |  2 ++
>>  include/linux/mmc/dw_mmc.h         |  3 +++
>>  4 files changed, 22 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
>> index bbb4ec3..b997c8f 100644
>> --- a/drivers/mmc/host/dw_mmc-rockchip.c
>> +++ b/drivers/mmc/host/dw_mmc-rockchip.c
>> @@ -68,14 +68,24 @@ static void dw_mci_rk3288_set_ios(struct dw_mci *host, struct mmc_ios *ios)
>>  	}
>>  }
>>  
>> +static int dw_mci_rockchip_parse_dt(struct dw_mci *host)
>> +{
>> +	/* It is slot 8 on Rockchip SoCs */
>> +	host->sdio_id0 = 8;
>> +
>> +	return 0;
>> +}
> 
> Well, function is "__parse_dt__", but this function don't parse anything.
> If All rockchip soc is supported, i think that it can be located to other place.
> 
Can add it in "init" function? like this:
int dw_mci_rockchip_init(struct dw_mci *host)
{
	/* It is slot 8 on Rockchip SoCs */
	host->sdio_id0 = 8;

	return 0;
}
static const struct dw_mci_drv_data xxxx {
    ....
    .init = dw_mci_rockchip_init,
};


> Best Regards,
> Jaehoon Chung
> 
>> +
>>  static const struct dw_mci_drv_data rk2928_drv_data = {
>>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>> +	.parse_dt	= dw_mci_rockchip_parse_dt,
>>  };
>>  
>>  static const struct dw_mci_drv_data rk3288_drv_data = {
>>  	.prepare_command        = dw_mci_rockchip_prepare_command,
>>  	.set_ios		= dw_mci_rk3288_set_ios,
>>  	.setup_clock    = dw_mci_rk3288_setup_clock,
>> +	.parse_dt	= dw_mci_rockchip_parse_dt,
>>  };
>>  
>>  static const struct of_device_id dw_mci_rockchip_match[] = {
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index bb46b1b..a633b58 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -823,7 +823,7 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>  
>>  		/* enable clock; only low power if no SDIO */
>>  		clk_en_a = SDMMC_CLKEN_ENABLE << slot->id;
>> -		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->id)))
>> +		if (!(mci_readl(host, INTMASK) & SDMMC_INT_SDIO(slot->sdio_id)))
>>  			clk_en_a |= SDMMC_CLKEN_LOW_PWR << slot->id;
>>  		mci_writel(host, CLKENA, clk_en_a);
>>  
>> @@ -1184,10 +1184,10 @@ static void dw_mci_enable_sdio_irq(struct mmc_host *mmc, int enb)
>>  		dw_mci_disable_low_power(slot);
>>  
>>  		mci_writel(host, INTMASK,
>> -			   (int_mask | SDMMC_INT_SDIO(slot->id)));
>> +			   (int_mask | SDMMC_INT_SDIO(slot->sdio_id)));
>>  	} else {
>>  		mci_writel(host, INTMASK,
>> -			   (int_mask & ~SDMMC_INT_SDIO(slot->id)));
>> +			   (int_mask & ~SDMMC_INT_SDIO(slot->sdio_id)));
>>  	}
>>  }
>>  
>> @@ -2056,8 +2056,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
>>  		/* Handle SDIO Interrupts */
>>  		for (i = 0; i < host->num_slots; i++) {
>>  			struct dw_mci_slot *slot = host->slot[i];
>> -			if (pending & SDMMC_INT_SDIO(i)) {
>> -				mci_writel(host, RINTSTS, SDMMC_INT_SDIO(i));
>> +			if (pending & SDMMC_INT_SDIO(slot->sdio_id)) {
>> +				mci_writel(host, RINTSTS,
>> +					   SDMMC_INT_SDIO(slot->sdio_id));
>>  				mmc_signal_sdio_irq(slot->mmc);
>>  			}
>>  		}
>> @@ -2145,6 +2146,7 @@ static int dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>>  
>>  	slot = mmc_priv(mmc);
>>  	slot->id = id;
>> +	slot->sdio_id = host->sdio_id0 + id;
>>  	slot->mmc = mmc;
>>  	slot->host = host;
>>  	host->slot[id] = slot;
>> diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
>> index 71d4995..0562f10 100644
>> --- a/drivers/mmc/host/dw_mmc.h
>> +++ b/drivers/mmc/host/dw_mmc.h
>> @@ -214,6 +214,7 @@ extern int dw_mci_resume(struct dw_mci *host);
>>   *	with CONFIG_MMC_CLKGATE.
>>   * @flags: Random state bits associated with the slot.
>>   * @id: Number of this slot.
>> + * @sdio_id: Number of this slot in the SDIO interrupt registers.
>>   */
>>  struct dw_mci_slot {
>>  	struct mmc_host		*mmc;
>> @@ -233,6 +234,7 @@ struct dw_mci_slot {
>>  #define DW_MMC_CARD_PRESENT	0
>>  #define DW_MMC_CARD_NEED_INIT	1
>>  	int			id;
>> +	int			sdio_id;
>>  };
>>  
>>  struct dw_mci_tuning_data {
>> diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
>> index 69d0814..72c319f 100644
>> --- a/include/linux/mmc/dw_mmc.h
>> +++ b/include/linux/mmc/dw_mmc.h
>> @@ -96,6 +96,7 @@ struct mmc_data;
>>   * @quirks: Set of quirks that apply to specific versions of the IP.
>>   * @irq_flags: The flags to be passed to request_irq.
>>   * @irq: The irq value to be passed to request_irq.
>> + * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
>>   *
>>   * Locking
>>   * =======
>> @@ -191,6 +192,8 @@ struct dw_mci {
>>  	bool			vqmmc_enabled;
>>  	unsigned long		irq_flags; /* IRQ flags */
>>  	int			irq;
>> +
>> +	int			sdio_id0;
>>  };
>>  
>>  /* DMA ops for Internal/External DMAC interface */
>>
> 
> 
> 
> 

