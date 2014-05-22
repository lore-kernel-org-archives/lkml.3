Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710AbaEVBuf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 21:50:35 -0400
Received: from mail1.windriver.com ([147.11.146.13]:39721 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750770AbaEVBue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 21:50:34 -0400
Message-ID: <537D57CA.6000305@windriver.com>
Date: Thu, 22 May 2014 09:50:02 +0800
From: "Yang,Wei" <Wei.Yang@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: <Wei.Yang@windriver.com>, <daniel.lezcano@linaro.org>
CC: <tglx@linutronix.de>, <rostedt@goodmis.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1] drivers/clocksource: do not trace read_sched_clock
References: <1399950608-11873-1-git-send-email-Wei.Yang@windriver.com>
In-Reply-To: <1399950608-11873-1-git-send-email-Wei.Yang@windriver.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.162.170]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

What do you think of it?

Regards
Wei
On 05/13/2014 11:10 AM, Wei.Yang@windriver.com wrote:
> From: Yang Wei <Wei.Yang@windriver.com>
>
> We do not need to trace read_sched_clock function,
> so add notrace attribute for this function.
>
> Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
> ---
>   drivers/clocksource/dw_apb_timer_of.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/clocksource/dw_apb_timer_of.c b/drivers/clocksource/dw_apb_timer_of.c
> index 2a2ea27..d305fb0 100644
> --- a/drivers/clocksource/dw_apb_timer_of.c
> +++ b/drivers/clocksource/dw_apb_timer_of.c
> @@ -106,7 +106,7 @@ static void __init add_clocksource(struct device_node *source_timer)
>   	sched_rate = rate;
>   }
>   
> -static u64 read_sched_clock(void)
> +static u64 notrace read_sched_clock(void)
>   {
>   	return ~__raw_readl(sched_io_base);
>   }

