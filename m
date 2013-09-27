Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949Ab3I0Ipo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:45:44 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64488 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3I0Ipl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:45:41 -0400
Message-ID: <524545B2.7000608@linaro.org>
Date: Fri, 27 Sep 2013 10:45:38 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Rob Herring <rob.herring@calxeda.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 2/6] cpuidle: calxeda: add cpu_pm_enter/exit calls
References: <1380248694-13388-1-git-send-email-robherring2@gmail.com> <1380248694-13388-3-git-send-email-robherring2@gmail.com>
In-Reply-To: <1380248694-13388-3-git-send-email-robherring2@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 04:24 AM, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
>
> Wnen powergating the core, we need to call cpu pm notifiers to save VFP
> state (!SMP only) and resetting the breakpoint h/w.
>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-pm@vger.kernel.org

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

Shouldn't this patch be the first in the series ?

> ---
>   drivers/cpuidle/cpuidle-calxeda.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/drivers/cpuidle/cpuidle-calxeda.c b/drivers/cpuidle/cpuidle-calxeda.c
> index 01cfecf3..b04767a 100644
> --- a/drivers/cpuidle/cpuidle-calxeda.c
> +++ b/drivers/cpuidle/cpuidle-calxeda.c
> @@ -21,6 +21,7 @@
>    */
>
>   #include <linux/cpuidle.h>
> +#include <linux/cpu_pm.h>
>   #include <linux/init.h>
>   #include <linux/of.h>
>   #include <asm/cpuidle.h>
> @@ -39,7 +40,10 @@ static int calxeda_pwrdown_idle(struct cpuidle_device *dev,
>   				struct cpuidle_driver *drv,
>   				int index)
>   {
> +	cpu_pm_enter();
>   	cpu_suspend(0, calxeda_idle_finish);
> +	cpu_pm_exit();
> +
>   	return index;
>   }
>
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

