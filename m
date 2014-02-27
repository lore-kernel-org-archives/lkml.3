Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751508AbaB0IYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:24:31 -0500
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:35913 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750781AbaB0IYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:24:30 -0500
Message-ID: <530EF467.5000504@overkiz.com>
Date: Thu, 27 Feb 2014 09:16:39 +0100
From: Boris BREZILLON <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        nicolas.ferre@atmel.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jason@lakedaemon.net
Subject: Re: [PATCH v2 2/4] clk: at91: propagate rate change on system clks
References: <1391589458-28018-1-git-send-email-jjhiblot@traphandler.com> <1391589458-28018-3-git-send-email-jjhiblot@traphandler.com> <20140227004229.12081.25317@quantum>
In-Reply-To: <20140227004229.12081.25317@quantum>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 17651295790738667548
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On 27/02/2014 01:42, Mike Turquette wrote:
> Quoting Jean-Jacques Hiblot (2014-02-05 00:37:36)
>> From: Boris BREZILLON <b.brezillon@overkiz.com>
>>
>> System clks are just gates, and thus do not provide any rate operations.
>> Authorize clk rate change to be propagated to system clk parents.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   drivers/clk/at91/clk-system.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/clk/at91/clk-system.c b/drivers/clk/at91/clk-system.c
>> index 8f7c043..a98557b 100644
>> --- a/drivers/clk/at91/clk-system.c
>> +++ b/drivers/clk/at91/clk-system.c
>> @@ -84,7 +84,8 @@ at91_clk_register_system(struct at91_pmc *pmc, const char *name,
>>           * (see drivers/memory) which would request and enable the ddrck clock.
>>           * When this is done we will be able to remove CLK_IGNORE_UNUSED flag.
>>           */
>> -       init.flags = CLK_IGNORE_UNUSED;
>> +       init.flags = CLK_SET_RATE_GATE | CLK_SET_RATE_PARENT |
> Just wanted to do a quick sanity check here. Do you really need
> CLK_SET_RATE_GATE?

After taking a closer look, I'd say I don't need this flag, because it's
already set on programmable clks, am I right ?

Do you want me to send a new version removing this flag ?

> Otherwise these patches look fine.
>
> Regards,
> Mike
>
>> +                    CLK_IGNORE_UNUSED;
>>   
>>          sys->id = id;
>>          sys->hw.init = &init;
>> -- 
>> 1.8.5.2
>>

