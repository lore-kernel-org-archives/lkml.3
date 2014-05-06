Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbaEFMcN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 08:32:13 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:59865 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953AbaEFMcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 08:32:10 -0400
Message-ID: <5368D645.7030206@st.com>
Date: Tue, 6 May 2014 14:32:05 +0200
From: Gabriel Fernandez <gabriel.fernandez@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Valentin Ilie <valentin.ilie@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, <pankaj.dev@st.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: st: Fix memory leak
References: <1398172554-22053-1-git-send-email-valentin.ilie@gmail.com> <CAHuBVBZbLbAuVp3bwnWO45=9=irS8krPKiS905eC0K1Bgs4S9g@mail.gmail.com>
In-Reply-To: <CAHuBVBZbLbAuVp3bwnWO45=9=irS8krPKiS905eC0K1Bgs4S9g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.19.41]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-06_03:2014-05-06,2014-05-06,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valentin
Thanks for the patch, i agree with it.

Mike do you planned to integrate this patch ?

Gabriel.

Best Regards.


On 05/06/2014 11:29 AM, Valentin Ilie wrote:
> On 22 April 2014 16:15, Valentin Ilie <valentin.ilie@gmail.com> wrote:
>> When it fails to allocate div, gate should be free'd before return
>>
>> Signed-off-by: Valentin Ilie <valentin.ilie@gmail.com>
>> ---
>>   drivers/clk/st/clkgen-pll.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/st/clkgen-pll.c b/drivers/clk/st/clkgen-pll.c
>> index bca0a0b..a886702 100644
>> --- a/drivers/clk/st/clkgen-pll.c
>> +++ b/drivers/clk/st/clkgen-pll.c
>> @@ -521,8 +521,10 @@ static struct clk * __init clkgen_odf_register(const char *parent_name,
>>          gate->lock = odf_lock;
>>
>>          div = kzalloc(sizeof(*div), GFP_KERNEL);
>> -       if (!div)
>> +       if (!div) {
>> +               kfree(gate);
>>                  return ERR_PTR(-ENOMEM);
>> +       }
>>
>>          div->flags = CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO;
>>          div->reg = reg + pll_data->odf[odf].offset;
>> --
>> 1.8.3.2
>>
> Can someone look into this?
>

