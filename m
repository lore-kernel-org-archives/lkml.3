Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756973Ab3EGKSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 06:18:41 -0400
Received: from mailbackup.inode.at ([213.229.60.24]:55009 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755019Ab3EGKSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 06:18:40 -0400
Message-ID: <5188D4BC.8010603@streamunlimited.com>
Date: Tue, 07 May 2013 12:17:32 +0200
From: Marek Belisko <marek.belisko@streamunlimited.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Marek Belisko <marek.belisko@gmail.com>, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org
Subject: Re: [PATCH 1/2] clk: si5351: Fix msynth_recalc_rate return value
 when fOUT is 0.
References: <1367914491-17445-1-git-send-email-marek.belisko@streamunlimited.com> <5188D174.90400@gmail.com>
In-Reply-To: <5188D174.90400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: marek.belisko@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2013 12:03 PM, Sebastian Hesselbarth wrote:
> On 05/07/2013 10:14 AM, Marek Belisko wrote:
>> When p3 is eual to 0 then result for fOUT is 0. In that case we should
>> return 0 not parent_rate;
>>
>> This issue was causing deadlock in si5351 chip when user set_rate for
>> ms0->clk0 and then set_rate for ms1->clk1 (both ms sourced from plla).
>> After that clk1 was 0 and it wasn't possible to enable it again (try also
>> manually with i2cset commands). Only power cycle helps.
>
> Marek,
>
> does the fix below also affect the behavior above, i.e. not causing
> si5351 to hang?
Yes this fix problems with si5351 hang. Didn't investigate why but I 
assume some wrong register access or something.
>
> Anyway, your fix looks very sane to me and you get my
>
> Acked-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
>
>> Signed-off-by: Marek Belisko<marek.belisko@streamunlimited.com>
>> ---
>>   drivers/clk/clk-si5351.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
>> index fc215ce..a8fc0f4 100644
>> --- a/drivers/clk/clk-si5351.c
>> +++ b/drivers/clk/clk-si5351.c
>> @@ -607,7 +607,7 @@ static unsigned long
>> si5351_msynth_recalc_rate(struct clk_hw *hw,
>>           si5351_read_parameters(hwdata->drvdata, reg,&hwdata->params);
>>
>>       if (hwdata->params.p3 == 0)
>> -        return parent_rate;
>> +        return 0;
>>
>>       /*
>>        * multisync0-5: fOUT = (128 * P3 * fIN) / (P1*P3 + P2 + 512*P3)
>
>

	~marek

-- 
Marek Belisko

Software Developer
StreamUnlimited Engineering GmbH
Gutheil Schodergasse 8-12
A-1100 Vienna, Austria

Office: +421 267200087

e-mail: marek.belisko@streamunlimited.com
http://www.streamunlimited.com

Meet us at:

High End - Munich, 09 - 12 May, Hall 4/F05
IFA - Berlin, 6-11 September
CEDIA - Denver, 25-28 September
