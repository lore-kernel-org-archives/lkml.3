Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbaJGR1m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:27:42 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38745 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754718AbaJGR1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:27:40 -0400
Message-ID: <54342287.7020005@linaro.org>
Date: Tue, 07 Oct 2014 18:27:35 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>,
        Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: Re: [PATCH v2 04/15] clk: divider: Make generic for usage elsewhere
References: <1409957256-23729-1-git-send-email-sboyd@codeaurora.org> <1409957256-23729-5-git-send-email-sboyd@codeaurora.org> <542EE5FE.9080806@codeaurora.org>
In-Reply-To: <542EE5FE.9080806@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Just noticed this regression while testing the patch on Arndale board.

https://bugs.linaro.org/show_bug.cgi?id=740


--srini

On 03/10/14 19:07, Stephen Boyd wrote:
> On 09/05/14 15:47, Stephen Boyd wrote:
>> +
>> +int divider_get_val(unsigned long rate, unsigned long parent_rate,
>> +		    const struct clk_div_table *table, u8 width,
>> +		    unsigned long flags)
>> +{
>>   	unsigned int div, value;
>> -	unsigned long flags = 0;
>> -	u32 val;
>>
>>   	div = DIV_ROUND_UP(parent_rate, rate);
>>
>> -	if (!_is_valid_div(divider, div))
>> +	if (!_is_valid_div(table, div, flags))
>>   		return -EINVAL;
>>
>> -	value = _get_val(divider, div);
>> +	value = _get_val(table, div, flags);
>> +
>> +	min_t(unsigned int, value, div_mask(width));
>> +
>> +	return 0;
>
> This should be return value, not return 0.
>
>> +}
>> +EXPORT_SYMBOL_GPL(divider_get_val);
>>
