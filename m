Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014AbaE3JvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:51:06 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:56385 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaE3JvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:51:04 -0400
Message-ID: <53885483.3030807@linaro.org>
Date: Fri, 30 May 2014 10:50:59 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 06/13] mmc: mmci: add ddrmode mask to variant data
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>	<1401284807-16686-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFraGdp2QUHzhjoe5mO6ZyuS08notgkxpRB5A_GpYtyXTw@mail.gmail.com>
In-Reply-To: <CAPDyKFraGdp2QUHzhjoe5mO6ZyuS08notgkxpRB5A_GpYtyXTw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30/05/14 10:35, Ulf Hansson wrote:
> On 28 May 2014 15:46,  <srinivas.kandagatla@linaro.org> wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch adds ddrmode mask to variant structure giving more flexibility
>> to the driver to support more SOCs which have different datactrl register
>> layout.
>>
>> Without this patch datactrl register is updated with wrong ddrmode mask on non
>> ST SOCs, resulting in card detection failures.
>
> The above statement seems not correct. We don't have any issues
> currently, right. :-)
I should have said Qualcomm instead of generalizing it to non-ST SOCs.
Will fix this in next version.

Thanks,
srini
>
> Kind regards
> Ulf Hansson
>
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>   drivers/mmc/host/mmci.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>> index 23401b0..729105b 100644
>> --- a/drivers/mmc/host/mmci.c
>> +++ b/drivers/mmc/host/mmci.c
>> @@ -59,6 +59,7 @@ static unsigned int fmax = 515633;
>>    *               is asserted (likewise for RX)
>>    * @sdio: variant supports SDIO
>>    * @st_clkdiv: true if using a ST-specific clock divider algorithm
>> + * @datactrl_mask_ddrmode: ddr mode mask in datactrl register.
>>    * @blksz_datactrl16: true if Block size is at b16..b30 position in datactrl register
>>    * @blksz_datactrl4: true if Block size is at b4..b16 position in datactrl
>>    *                  register
>> @@ -74,6 +75,7 @@ struct variant_data {
>>          unsigned int            datalength_bits;
>>          unsigned int            fifosize;
>>          unsigned int            fifohalfsize;
>> +       unsigned int            datactrl_mask_ddrmode;
>>          bool                    sdio;
>>          bool                    st_clkdiv;
>>          bool                    blksz_datactrl16;
>> @@ -152,6 +154,7 @@ static struct variant_data variant_ux500v2 = {
>>          .fifohalfsize           = 8 * 4,
>>          .clkreg                 = MCI_CLK_ENABLE,
>>          .clkreg_enable          = MCI_ST_UX500_HWFCEN,
>> +       .datactrl_mask_ddrmode  = MCI_ST_DPSM_DDRMODE,
>>          .datalength_bits        = 24,
>>          .sdio                   = true,
>>          .st_clkdiv              = true,
>> @@ -779,7 +782,7 @@ static void mmci_start_data(struct mmci_host *host, struct mmc_data *data)
>>                  }
>>
>>          if (host->mmc->ios.timing == MMC_TIMING_UHS_DDR50)
>> -               datactrl |= MCI_ST_DPSM_DDRMODE;
>> +               datactrl |= variant->datactrl_mask_ddrmode;
>>
>>          /*
>>           * Attempt to use DMA operation mode, if this
>> --
>> 1.9.1
>>
