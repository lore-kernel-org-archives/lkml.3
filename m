Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbaFISi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:38:28 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44468 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaFISiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:38:25 -0400
Message-ID: <5395FF1D.1010606@wwwdotorg.org>
Date: Mon, 09 Jun 2014 12:38:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>, rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, dianders@chromium.org
Subject: Re: [PATCH] cpufreq: tegra: update comment for clarity
References: <594cf0e6982c471eb314fe4a00647bfaf59a3456.1402029512.git.viresh.kumar@linaro.org>
In-Reply-To: <594cf0e6982c471eb314fe4a00647bfaf59a3456.1402029512.git.viresh.kumar@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2014 10:38 PM, Viresh Kumar wrote:
> Tegra's driver got updated a bit (00917dd cpufreq: Tegra: implement intermediate
> frequency callbacks) and implements new 'intermediate freq' infrastructure of
> core. Above commit updated comments about when to call
> clk_prepare_enable(pll_x_clk) and Doug wasn't satisfied with those comments and
> said this:
> 
>> The "Though when target-freq is intermediate freq, we don't need to
>> take this reference." makes me think that this function is actually
>> called when target-freq is intermediate freq.  I don't think it is,
>> right?
> 
> For better clarity just make that comment more explicit about when we call
> tegra_target_intermediate(). Wasn't sure if we actually need a commit for this,
> but anyway lets other decide if its worth enough :)

> diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
> index a5fbc0a..48bc89b 100644
> --- a/drivers/cpufreq/tegra-cpufreq.c
> +++ b/drivers/cpufreq/tegra-cpufreq.c
> @@ -73,7 +73,7 @@ static int tegra_target_intermediate(struct cpufreq_policy *policy,
>  	 * off when we move the cpu off of it as enabling it again while we
>  	 * switch to it from tegra_target() would take additional time. Though
>  	 * when target-freq is intermediate freq, we don't need to take this
> -	 * reference.
> +	 * reference and so this routine isn't called at all.
>  	 */
>  	clk_prepare_enable(pll_x_clk);

I would remove the word "so" in the added line; the function is not
called because we don't need to use an intermediate frequency, not
because we don't need to take a reference to pll_x. With that change,

Reviewed-by: Stephen Warren <swarren@nvidia.com>
