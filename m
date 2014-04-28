Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756301AbaD1Oqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 10:46:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:49813 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613AbaD1Oqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 10:46:35 -0400
Message-ID: <535E698F.7060104@ti.com>
Date: Mon, 28 Apr 2014 20:15:35 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <davem@davemloft.net>,
        <richardcochran@gmail.com>, <jeffrey.t.kirsher@intel.com>,
        <dborkman@redhat.com>, <ast@plumgrid.com>, <tklauser@distanz.ch>,
        <mpa@pengutronix.de>, <bhutchings@solarflare.com>, <zonque@gmail.com>,
        <mugunthanvnm@ti.com>, <t-kristo@ti.com>, <mturquette@linaro.org>,
        <linux@arm.linux.org.uk>, <galak@codeaurora.org>,
        <ijc+devicetree@hellion.org.uk>, <mark.rutland@arm.com>,
        <pawel.moll@arm.com>, <robh+dt@kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: Re: [PATCH 1/6] drivers: net: cpts: Remove hardcoded clock name for
 CPTS
References: <1398658225-25873-1-git-send-email-george.cherian@ti.com> <1398658225-25873-2-git-send-email-george.cherian@ti.com> <20140428143115.GC30292@saruman.home>
In-Reply-To: <20140428143115.GC30292@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/28/2014 8:01 PM, Felipe Balbi wrote:
> On Mon, Apr 28, 2014 at 09:40:20AM +0530, George Cherian wrote:
>> CPTS refclk name is hardcoded, which makes it fail in case of DRA7x
>> Remove the hardcoded clock name for CPTS refclk and get the same from DT.
>>
>> Signed-off-by: George Cherian <george.cherian@ti.com>
>> ---
>>   drivers/net/ethernet/ti/cpts.c | 11 ++++-------
>>   1 file changed, 4 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/ti/cpts.c b/drivers/net/ethernet/ti/cpts.c
>> index 2435139..0b6f6f7 100644
>> --- a/drivers/net/ethernet/ti/cpts.c
>> +++ b/drivers/net/ethernet/ti/cpts.c
>> @@ -236,13 +236,11 @@ static void cpts_overflow_check(struct work_struct *work)
>>   	schedule_delayed_work(&cpts->overflow_work, CPTS_OVERFLOW_PERIOD);
>>   }
>>   
>> -#define CPTS_REF_CLOCK_NAME "cpsw_cpts_rft_clk"
>> -
>> -static void cpts_clk_init(struct cpts *cpts)
>> +static void cpts_clk_init(struct device *dev, struct cpts *cpts)
>>   {
>> -	cpts->refclk = clk_get(NULL, CPTS_REF_CLOCK_NAME);
>> +	cpts->refclk = devm_clk_get(dev, "cpts");
>>   	if (IS_ERR(cpts->refclk)) {
>> -		pr_err("Failed to clk_get %s\n", CPTS_REF_CLOCK_NAME);
>> +		pr_err("Failed to get cpts refclk\n");
> now you have a dev pointer as argument, how about converting this to
> dev_err() ?
Yep will do.. in next version.


-- 
-George

