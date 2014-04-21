Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaDUNJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 09:09:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34685 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaDUNJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 09:09:09 -0400
Message-ID: <5355185B.70003@ti.com>
Date: Mon, 21 Apr 2014 08:08:43 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 06/19] bus: omap_l3_noc: un-obfuscate l3_targ address
 computation
References: <1397492726-17203-1-git-send-email-nm@ti.com> <1397767775-10965-1-git-send-email-nm@ti.com> <1397767775-10965-7-git-send-email-nm@ti.com> <20140417220036.GE8504@saruman.home>
In-Reply-To: <20140417220036.GE8504@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 05:00 PM, Felipe Balbi wrote:
> On Thu, Apr 17, 2014 at 03:49:22PM -0500, Nishanth Menon wrote:
>> just simplify derefencing that is equivalent.
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
>> ---
>> V2: just ordering change
>> V1: https://patchwork.kernel.org/patch/3984201/
>>  drivers/bus/omap_l3_noc.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/bus/omap_l3_noc.c b/drivers/bus/omap_l3_noc.c
>> index c8facb0..f7d3bf4 100644
>> --- a/drivers/bus/omap_l3_noc.c
>> +++ b/drivers/bus/omap_l3_noc.c
>> @@ -76,7 +76,7 @@ static irqreturn_t l3_interrupt_handler(int irq, void *_l3)
>>  			err_src = __ffs(err_reg);
>>  
>>  			/* Read the stderrlog_main_source from clk domain */
>> -			l3_targ_base = base + *(l3_targ[i] + err_src);
>> +			l3_targ_base = base + l3_targ[i][err_src];
> 
> hmmm, wasn't it so that pointer arithmetic was slightly faster than
> array indexing ? In that case would it be best to:
> 
> l3_targ_base = base + *(l3_targ + i + err_src);
> 
Yes, if this was a hot path (example: interrupt handler that gets
invoked very often), I would probably have preferred optimization at
this point.

However, the patch is just a step away from patches that converts the
target information into a structure under flagmux structure allowing
us to get rid of multiple array operations.

This patch just makes the further changes a bit readable.

-- 
Regards,
Nishanth Menon
