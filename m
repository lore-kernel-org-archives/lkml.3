Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751389AbaEXXdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 19:33:33 -0400
Received: from mail-wg0-f41.google.com ([74.125.82.41]:54073 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304AbaEXXdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 19:33:32 -0400
Message-ID: <53812C46.3060607@gmail.com>
Date: Sun, 25 May 2014 01:33:26 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomasz Figa <t.figa@samsung.com>, linux-arm-kernel@lists.infradead.org
CC: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Maxime COQUELIN <maxime.coquelin@st.com>
Subject: [FIX] [CRITICAL] Re: [PATCH] clk: divider: Fix overflow in clk_divider_bestdiv
References: <1399479850-25292-1-git-send-email-t.figa@samsung.com> <5374F07E.9070106@samsung.com>
In-Reply-To: <5374F07E.9070106@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

On 15.05.2014 18:51, Tomasz Figa wrote:
> Hi Mike,
> 
> On 07.05.2014 18:24, Tomasz Figa wrote:
>> Commit c686078 ("clk: divider: Add round to closest divider") introduced
>> a helper function to check whether given divisor is the best one instead
>> of direct check. However due to int type used instead of unsigned long
>> for passing calculated rates to this function in certain cases an
>> overflow could occur, for example when trying to obtain maximum possible
>> clock rate by calling clk_round_rate(..., UINT_MAX).
>>
>> This patch fixes this issue by changing the type of rate, now and best
>> arguments of the function to unsigned long, which is the type that
>> should be used for clock rates.
>>
>> Signed-off-by: Tomasz Figa <t.figa@samsung.com>
>> ---
>>  drivers/clk/clk-divider.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk-divider.c b/drivers/clk/clk-divider.c
>> index c572945..e0b360a 100644
>> --- a/drivers/clk/clk-divider.c
>> +++ b/drivers/clk/clk-divider.c
>> @@ -232,7 +232,7 @@ static int _div_round(struct clk_divider *divider, unsigned long parent_rate,
>>  }
>>  
>>  static bool _is_best_div(struct clk_divider *divider,
>> -		int rate, int now, int best)
>> +		unsigned long rate, unsigned long now, unsigned long best)
>>  {
>>  	if (divider->flags & CLK_DIVIDER_ROUND_CLOSEST)
>>  		return abs(rate - now) < abs(rate - best);
>>
> 
> Ping. It's quite important fix as the issue makes all Exynos boards
> using sdhci-s3c almost unusable.

Any issues with this patch?

Due to this issue, now since almost 3 weeks, all Samsung boards using
sdhci-s3c have been suffering from boot failures on linux-next due to
incorrect clock rates being calculated.

Best regards,
Tomasz
