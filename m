Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab3HZJGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 05:06:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56855 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab3HZJGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 05:06:06 -0400
X-AuditID: cbfee68f-b7f656d0000058e3-c5-521b1a7c8b8b
Message-id: <521B1A87.4000500@samsung.com>
Date: Mon, 26 Aug 2013 18:06:15 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'James Hogan'" <james.hogan@imgtec.com>,
        "'Grant Grundler'" <grundler@chromium.org>,
        "'Alim Akhtar'" <alim.akhtar@samsung.com>,
        "'Abhilash Kesavan'" <a.kesavan@samsung.com>,
        "'Tomasz Figa'" <tomasz.figa@gmail.com>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mmc: dw_mmc: Honor requests to set the clock to 0
 (turn off clock)
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377188348-3418-3-git-send-email-dianders@chromium.org>
 <001201cea215$8c125e30$a4371a90$%jun@samsung.com>
In-reply-to: <001201cea215$8c125e30$a4371a90$%jun@samsung.com>
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIIsWRmVeSWpSXmKPExsWyRsSkRLdGSjrIYN5vSYvHaxYzWTyYt43N
	YvvrjWwWZ5cdZLN4deQHk8W7eS+YLW78amO1uLxrDpvFkf/9jBanrn9ms/hw/yKzxapdfxgd
	eDxmN1xk8dg56y67R8/OM4weh66sZfS4cqKJ1aNvyypGj8+b5ALYo7hsUlJzMstSi/TtErgy
	Wp9dZy94L1dxde8RpgbG8xJdjJwcEgImEsd+nmaFsMUkLtxbz9bFyMUhJLCUUeLVrhuMMEXX
	175jgkhMZ5SYcXEPVNVrRokDe18zgVTxCmhJnP33FmwUi4CqxJS+C2DdbAI6Etu/HQerERUI
	k3jxahczRL2gxI/J91i6GDk4RAQ0JL7MTwAJMwusYZb4etMMxBYWSJC4e/oqK8SuzYwSK9bN
	A5vDKWAnsWn6CRaIBg2Jqa9PM0LY8hKb17xlhri6lUNi3V9viHsEJL5NPgS2S0JAVmLTAagS
	SYmDK26wTGAUm4XkollIps5CMnUBI/MqRtHUguSC4qT0ImO94sTc4tK8dL3k/NxNjMDoPf3v
	Wf8OxrsHrA8xJgOtnMgsJZqcD4z+vJJ4Q2MzIwtTE1NjI3NLM9KElcR51VqsA4UE0hNLUrNT
	UwtSi+KLSnNSiw8xMnFwSjUwJixo7ZBTiNDrrsvubdT7U9p8UMCT5/av/GWcv9oSr/Lsnsma
	f+l80vs0//zzM0t2LTjKJHq26tmX9qK7Lw9eWfjYruf2uUf2T5OUL4sueRxvVW3INPv5mik7
	PkUXtD8V6nI/b9XAKd15s7nk9p8Luau67auF1OZ8r7/Z++VnQbn7ig3zfmXuVmIpzkg01GIu
	Kk4EABreIAH0AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPKsWRmVeSWpSXmKPExsVy+t9jQd0aKekggzUrBC0er1nMZPFg3jY2
	i+2vN7JZnF12kM3i1ZEfTBbv5r1gtrjxq43V4vKuOWwWR/73M1qcuv6ZzeLD/YvMFqt2/WF0
	4PGY3XCRxWPnrLvsHj07zzB6HLqyltHjyokmVo++LasYPT5vkgtgj2pgtMlITUxJLVJIzUvO
	T8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOlVJoSwxpxQoFJBYXKykb4dp
	QmiIm64FTGOErm9IEFyPkQEaSFjDmNH67Dp7wXu5iqt7jzA1MJ6X6GLk5JAQMJG4vvYdE4Qt
	JnHh3nq2LkYuDiGB6YwSMy7ugXJeM0oc2PsarIpXQEvi7L+3rCA2i4CqxJS+C4wgNpuAjsT2
	b8fBakQFwiRevNrFDFEvKPFj8j2WLkYODhEBDYkv8xNAwswCa5glvt40A7GFBRIk7p6+ygqx
	azOjxIp188DmcArYSWyafoIFokFDYurr04wQtrzE5jVvmScwCsxCsmIWkrJZSMoWMDKvYhRN
	LUguKE5KzzXSK07MLS7NS9dLzs/dxAhODs+kdzCuarA4xCjAwajEwxvAJh0kxJpYVlyZe4hR
	goNZSYTXXBQoxJuSWFmVWpQfX1Sak1p8iDEZGAITmaVEk/OBiSuvJN7Q2MTMyNLI3NDCyNic
	NGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhgn5z72qZrDbisUpLubk4Mp8UV7mdnLON3i
	3/dEmB6ujojzt7z2OSLX4ZeXELP+MTk7//kLwg/vn1mTISZsZn3/s++Rfbxl3wIXy6wW3PIi
	I2z9yg9LFqQ5XG3P55FfU7/02Pn3uim3jy49U2UTZnub9W3QvLgHmruW3ll+boX48WVZM14c
	2/RBiaU4I9FQi7moOBEA9omBPFIDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 01:34 PM, Seungwon Jeon wrote:
> On Fri, August 23, 2013, Doug Anderson wrote:
>> Previously the dw_mmc driver would ignore any requests to disable the
>> card's clock.  This doesn't seem like a good thing in general, but had
>> one extra bad side effect in the following situtation:
>> * mmc core would set clk to 400kHz at boot time while initting
>> * mmc core would set clk to 0 since no card, but it would be ignored.
>> * suspend to ram and resume; clocks in the dw_mmc IP block are now 0
>>   but dw_mmc thinks that they're 400kHz (it ignored the set to 0).
>> * insert card
>> * mmc core would set clk to 400kHz which would be considered a no-op.
>>
>> Note that if there is no card in the slot and we do a suspend/resume
>> cycle, we _do_ still end up with differences in a dw_mmc register
>> dump, but the differences are clock related and we've got the clock
>> disabled both before and after, so this should be OK.
>>
>> Signed-off-by: Doug Anderson <dianders@chromium.org>
>> ---
>> Changes in v6:
>> - Replaces previous pathes that ensured saving/restoring clocks.
>>
>>  drivers/mmc/host/dw_mmc.c | 21 +++++++++++----------
>>  1 file changed, 11 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
>> index ee5f167..f6c7545 100644
>> --- a/drivers/mmc/host/dw_mmc.c
>> +++ b/drivers/mmc/host/dw_mmc.c
>> @@ -635,7 +635,11 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>  	u32 div;
>>  	u32 clk_en_a;
>>
>> -	if (slot->clock != host->current_speed || force_clkinit) {
>> +	if (slot->clock == 0) {
>> +		mci_writel(host, CLKENA, 0);
>> +		mci_send_cmd(slot,
>> +			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
> Basically dw_mmc driver uses host's low power mode(auto clock gating)
> So, how about keeping origin code rather than programming clock setting to '0'?
Right, Dw-mmc controller can use the Low-power mode. 
This mode is functionality like clock-gating. Well, i didn't know what benefit we get, if set to 0.

Best Regards,
Jaehoon Chung
>  
>> +	} else if (slot->clock != host->current_speed || force_clkinit) {
> And then, if condition('slot->clock is not zero') is added in order to allow to set clock,
> print messages which Jaehoon pointed would be solved.
> 
> Thanks,
> Seungwon Jeon
> 
>>  		div = host->bus_hz / slot->clock;
>>  		if (host->bus_hz % slot->clock && host->bus_hz > slot->clock)
>>  			/*
>> @@ -675,9 +679,8 @@ static void dw_mci_setup_bus(struct dw_mci_slot *slot, bool force_clkinit)
>>  		/* inform CIU */
>>  		mci_send_cmd(slot,
>>  			     SDMMC_CMD_UPD_CLK | SDMMC_CMD_PRV_DAT_WAIT, 0);
>> -
>> -		host->current_speed = slot->clock;
>>  	}
>> +	host->current_speed = slot->clock;
>>
>>  	/* Set the current slot bus width */
>>  	mci_writel(host, CTYPE, (slot->ctype << slot->id));
>> @@ -807,13 +810,11 @@ static void dw_mci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>>
>>  	mci_writel(slot->host, UHS_REG, regs);
>>
>> -	if (ios->clock) {
>> -		/*
>> -		 * Use mirror of ios->clock to prevent race with mmc
>> -		 * core ios update when finding the minimum.
>> -		 */
>> -		slot->clock = ios->clock;
>> -	}
>> +	/*
>> +	 * Use mirror of ios->clock to prevent race with mmc
>> +	 * core ios update when finding the minimum.
>> +	 */
>> +	slot->clock = ios->clock;
>>
>>  	if (drv_data && drv_data->set_ios)
>>  		drv_data->set_ios(slot->host, ios);
>> --
>> 1.8.3
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

