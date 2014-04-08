Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181AbaDHDOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:14:40 -0400
Received: from mx9.pku.edu.cn ([162.105.129.172]:39395 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754690AbaDHDOh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:14:37 -0400
X-Greylist: delayed 594 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2014 23:14:34 EDT
X-Spam-Flag: NO
X-Spam-Score: -307.247
Date: Tue, 8 Apr 2014 11:04:28 +0800 (CST)
From: =?utf-8?B?566h6Zuq5rab?= <gxt@pku.edu.cn>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>, rjw@rjwysocki.net,
        viresh kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <620835913.18252.1396926268726.JavaMail.root@bj-mail03.pku.edu.cn>
In-Reply-To: <53429445.5000005@gmail.com>
Subject: =?utf-8?Q?=E5=9B=9E=E5=A4=8D=EF=BC=9A_[PATCH]_drivers:cpufreq:uni?=
 =?utf-8?Q?core32:_fix_typo_issue_for_'clk'?=
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [162.105.129.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

Acked-by: Xuetao Guan <gxt@mprc.pku.edu.cn>

----- Chen Gang <gang.chen.5i5j@gmail.com> 写道：
> Need use 'clk' instead of 'mclk', which is the original removed local
> variable.
> 
> The related original commit:
> 
>   "652ed95 cpufreq: introduce cpufreq_generic_get() routine"
> 
> The related error with allmodconfig for unicore32:
> 
>     CC      drivers/cpufreq/unicore2-cpufreq.o
>   drivers/cpufreq/unicore2-cpufreq.c: In function ‘ucv2_target’:
>   drivers/cpufreq/unicore2-cpufreq.c:48: error: ‘struct cpufreq_policy’ has no member named ‘mclk’
>   make[2]: *** [drivers/cpufreq/unicore2-cpufreq.o] Error 1
>   make[1]: *** [drivers/cpufreq] Error 2
>   make: *** [drivers] Error 2
> 
> 
> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
> ---
>  drivers/cpufreq/unicore2-cpufreq.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/unicore2-cpufreq.c b/drivers/cpufreq/unicore2-cpufreq.c
> index 13be802..8d045af 100644
> --- a/drivers/cpufreq/unicore2-cpufreq.c
> +++ b/drivers/cpufreq/unicore2-cpufreq.c
> @@ -45,7 +45,7 @@ static int ucv2_target(struct cpufreq_policy *policy,
>  	freqs.new = target_freq;
>  
>  	cpufreq_freq_transition_begin(policy, &freqs);
> -	ret = clk_set_rate(policy->mclk, target_freq * 1000);
> +	ret = clk_set_rate(policy->clk, target_freq * 1000);
>  	cpufreq_freq_transition_end(policy, &freqs, ret);
>  
>  	return ret;
> -- 
> 1.7.9.5

