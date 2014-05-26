Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaEZHce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:32:34 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34677 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231AbaEZHcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:32:33 -0400
Message-ID: <5382EDEC.9040503@st.com>
Date: Mon, 26 May 2014 09:31:56 +0200
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>, Fabio Estevam <festevam@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: divider: Fix table round up function
References: <1399481332-9550-1-git-send-email-maxime.coquelin@st.com> <20140523213915.23136.16939@quantum>
In-Reply-To: <20140523213915.23136.16939@quantum>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-25_03:2014-05-23,2014-05-25,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/23/2014 11:39 PM, Mike Turquette wrote:
> Quoting Maxime COQUELIN (2014-05-07 09:48:52)
>> Commit 1d9fe6b97 ("clk: divider: Fix best div calculation for power-of-two and
>> table dividers") introduces a regression in its _table_round_up function.
>>
>> When the divider passed to this function is greater than the max divider
>> available in the table, this function returns table's max divider.
>> Problem is that it causes an infinite loop in clk_divider_bestdiv() because
>> _next_div() will never return a value greater than maxdiv.
>>
>> Instead of returning table's max divider, this patch returns INT_MAX.
>>
>> Reported-by: Fabio Estevam <festevam@gmail.com>
>> Reported-by: Shawn Guo <shawn.guo@freescale.com>
>> Tested-by: Fabio Estevam <festevam@gmail.com>
>> Cc: Mike Turquette <mike.turquette@linaro.org>
>> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
>
> Pulled into clk-fixes for -rc7.

Thanks Mike.

Regards,
Maxime

>
> Regards,
> Mike
>
>> ---
>>   drivers/clk/clk-divider.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
>> index b3c8396..cf9114a 100644
>> --- a/drivers/clk/clk-divider.c
>> +++ b/drivers/clk/clk-divider.c
>> @@ -158,7 +158,7 @@ static bool _is_valid_div(struct clk_divider *divider, unsigned int div)
>>   static int _round_up_table(const struct clk_div_table *table, int div)
>>   {
>>          const struct clk_div_table *clkt;
>> -       int up = _get_table_maxdiv(table);
>> +       int up = INT_MAX;
>>
>>          for (clkt = table; clkt->div; clkt++) {
>>                  if (clkt->div == div)
>> --
>> 1.9.1
>>
