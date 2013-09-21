Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113Ab3IUFz3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Sep 2013 01:55:29 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38324 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab3IUFz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Sep 2013 01:55:26 -0400
Message-ID: <523D33D2.4050602@linux.vnet.ibm.com>
Date: Sat, 21 Sep 2013 11:21:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: rjw@sisk.pl, linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH] cpufreq: check cpufreq driver is valid and cpufreq isn't
 disabled in cpufreq_get()
References: <389fbc3c8ad7c339cd2d9572d73c355b7b967823.1379669625.git.viresh.kumar@linaro.org>
In-Reply-To: <389fbc3c8ad7c339cd2d9572d73c355b7b967823.1379669625.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092105-1618-0000-0000-000004AA2837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2013 10:37 PM, Viresh Kumar wrote:
> cpufreq_get() can be called from external drivers which might not be aware if
> cpufreq driver is registered or not. And so we should actually check if cpufreq
> driver is registered or not and also if cpufreq is active or disabled, at the
> beginning of cpufreq_get().
> 
> Otherwise call to lock_policy_rwsem_read() might hit BUG_ON(!policy).
> 
> Reported-and-Tested-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---

Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Regards,
Srivatsa S. Bhat

> 
> For 3.12.
> 
>  drivers/cpufreq/cpufreq.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
> index 82ecbe3..db004a8 100644
> --- a/drivers/cpufreq/cpufreq.c
> +++ b/drivers/cpufreq/cpufreq.c
> @@ -1460,6 +1460,9 @@ unsigned int cpufreq_get(unsigned int cpu)
>  {
>  	unsigned int ret_freq = 0;
> 
> +	if (cpufreq_disabled() || !cpufreq_driver)
> +		return -ENOENT;
> +
>  	if (!down_read_trylock(&cpufreq_rwsem))
>  		return 0;
> 

