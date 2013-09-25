Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753799Ab3IYP3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 11:29:48 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:51381 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab3IYP3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 11:29:47 -0400
Message-ID: <52430167.4000701@linaro.org>
Date: Wed, 25 Sep 2013 17:29:43 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] clocksource: of: respect device tree node status
References: <523AD63A.8040906@gmail.com>
In-Reply-To: <523AD63A.8040906@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 12:47 PM, Sebastian Hesselbarth wrote:
> Clocksource devices provided by DT can be disabled (status != "okay").
> Instead of registering clocksource drivers for disabled nodes, respect
> the device's status by skiping disabled nodes.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

Shall it be applied as a 3.12 fix ?

> ---
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clocksource/clksrc-of.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/clocksource/clksrc-of.c
> b/drivers/clocksource/clksrc-of.c
> index 37f5325..b9ddd9e 100644
> --- a/drivers/clocksource/clksrc-of.c
> +++ b/drivers/clocksource/clksrc-of.c
> @@ -30,6 +30,9 @@ void __init clocksource_of_init(void)
>      clocksource_of_init_fn init_func;
>       for_each_matching_node_and_match(np, __clksrc_of_table, &match) {
> +        if (!of_device_is_available(np))
> +            continue;
> +
>          init_func = match->data;
>          init_func(np);
>      }


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

