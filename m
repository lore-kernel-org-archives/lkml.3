Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab3JCUOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 16:14:48 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:5539 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755367Ab3JCUOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 16:14:45 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 03 Oct 2013 13:10:48 -0700
Message-ID: <524DD034.30906@nvidia.com>
Date: Thu, 3 Oct 2013 13:14:44 -0700
From: Paul Walmsley <pwalmsley@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 03/16] cpuidle: make __cpuidle_get_cpu_driver() inline
References: <cover.1380815504.git.viresh.kumar@linaro.org> <d95bfe847f8c6a89442004d0897f8f9ef5a53300.1380815504.git.viresh.kumar@linaro.org>
In-Reply-To: <d95bfe847f8c6a89442004d0897f8f9ef5a53300.1380815504.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

a comment on this one (and any similar patch)

On 10/03/2013 08:56 AM, Viresh Kumar wrote:
> __cpuidle_get_cpu_driver() is a single line function and so deserves to be
> marked inline.

In general, this is a violation of Documentation/CodingStyle - see 
Chapter 15.

Unless this produces a significant benefit, it's probably best to just 
let the compiler do this if it wants.

- Paul


> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>   drivers/cpuidle/driver.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
> index ced1df6..25455e8 100644
> --- a/drivers/cpuidle/driver.c
> +++ b/drivers/cpuidle/driver.c
> @@ -29,7 +29,7 @@ static DEFINE_PER_CPU(struct cpuidle_driver *, cpuidle_drivers);
>    * Returns a pointer to struct cpuidle_driver or NULL if no driver has been
>    * registered for @cpu.
>    */
> -static struct cpuidle_driver *__cpuidle_get_cpu_driver(int cpu)
> +static inline struct cpuidle_driver *__cpuidle_get_cpu_driver(int cpu)
>   {
>   	return per_cpu(cpuidle_drivers, cpu);
>   }

