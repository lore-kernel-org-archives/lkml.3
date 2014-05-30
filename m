Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaE3J7w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:59:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:44149 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156AbaE3J7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:59:50 -0400
Message-ID: <53885690.8050003@linaro.org>
Date: Fri, 30 May 2014 10:59:44 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-mmc <linux-mmc@vger.kernel.org>, Chris Ball <chris@printf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v4 09/13] mmc: mmci: add Qcom specifics of clk and datactrl
 registers.
References: <1401284608-16428-1-git-send-email-srinivas.kandagatla@linaro.org>	<1401284844-16811-1-git-send-email-srinivas.kandagatla@linaro.org> <CAPDyKFqiu8y4oOOKCLNEuGZ8KajvE3AuDnO7M7re9SPjB7+vbg@mail.gmail.com>
In-Reply-To: <CAPDyKFqiu8y4oOOKCLNEuGZ8KajvE3AuDnO7M7re9SPjB7+vbg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 30/05/14 10:55, Ulf Hansson wrote:
> On 28 May 2014 15:47,  <srinivas.kandagatla@linaro.org> wrote:
>> From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>>
>> This patch adds specifics of clk and datactrl register on Qualcomm SD
>> Card controller. This patch also populates the Qcom variant data with
>> these new values specific to Qualcomm SD Card Controller.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>> ---
>>   drivers/mmc/host/mmci.c |  4 ++++
>>   drivers/mmc/host/mmci.h | 17 +++++++++++++++++
>>   2 files changed, 21 insertions(+)
>>
>> diff --git a/drivers/mmc/host/mmci.c b/drivers/mmc/host/mmci.c
>> index 8deea4a..dbcb952 100644
>> --- a/drivers/mmc/host/mmci.c
>> +++ b/drivers/mmc/host/mmci.c
>> @@ -179,6 +179,10 @@ static struct variant_data variant_qcom = {
>>          .fifosize               = 16 * 4,
>>          .fifohalfsize           = 8 * 4,
>>          .clkreg                 = MCI_CLK_ENABLE,
>> +       .clkreg_enable          = MCI_QCOM_CLK_FLOWENA |
>> +                                 MCI_QCOM_CLK_SELECT_IN_FBCLK,
>> +       .clkreg_8bit_bus_enable = MCI_QCOM_CLK_WIDEBUS_8,
>> +       .datactrl_mask_ddrmode  = MCI_QCOM_CLK_SELECT_IN_DDR_MODE,
>
> This stuff should go in patch3.

Yes, I will merge patch3 and this change-set in next version.

>
>>          .blksz_datactrl4        = true,
>>          .datalength_bits        = 24,
>>          .pwrreg_powerup         = MCI_PWR_UP,
>> diff --git a/drivers/mmc/host/mmci.h b/drivers/mmc/host/mmci.h
>> index cd83ca3..706eb513 100644
>> --- a/drivers/mmc/host/mmci.h
>> +++ b/drivers/mmc/host/mmci.h
>> @@ -41,6 +41,15 @@
>>   /* Modified PL180 on Versatile Express platform */
>>   #define MCI_ARM_HWFCEN         BIT(12)
>>
>> +/* Modified on Qualcomm Integrations */
>> +#define MCI_QCOM_CLK_WIDEBUS_8 (BIT(10) | BIT(11))
>> +#define MCI_QCOM_CLK_FLOWENA   BIT(12)
>> +#define MCI_QCOM_CLK_INVERTOUT BIT(13)
>> +
>> +/* select in latch data and command in */
>> +#define MCI_QCOM_CLK_SELECT_IN_FBCLK   BIT(15)
>> +#define MCI_QCOM_CLK_SELECT_IN_DDR_MODE        (BIT(14) | BIT(15))
>> +
>>   #define MMCIARGUMENT           0x008
>>   #define MMCICOMMAND            0x00c
>>   #define MCI_CPSM_RESPONSE      BIT(6)
>> @@ -54,6 +63,14 @@
>>   #define MCI_ST_NIEN            BIT(13)
>>   #define MCI_ST_CE_ATACMD       BIT(14)
>>
>> +/* Modified on Qualcomm Integrations */
>> +#define MCI_QCOM_CSPM_DATCMD           BIT(12)
>> +#define MCI_QCOM_CSPM_MCIABORT         BIT(13)
>> +#define MCI_QCOM_CSPM_CCSENABLE                BIT(14)
>> +#define MCI_QCOM_CSPM_CCSDISABLE       BIT(15)
>> +#define MCI_QCOM_CSPM_AUTO_CMD19       BIT(16)
>> +#define MCI_QCOM_CSPM_AUTO_CMD21       BIT(21)
>> +
>
> Maybe you should have one patch in the beginning of the patchset, that
> adds all the new QCOM bits in the header file? Instead of splitting
> them up?
Ok, I will do that in next version.

Thanks,
srini
>
>>   #define MMCIRESPCMD            0x010
>>   #define MMCIRESPONSE0          0x014
>>   #define MMCIRESPONSE1          0x018
>> --
>> 1.9.1
>>
>
> Kind regards
> Ulf Hansson
>
