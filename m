Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764507Ab3DDTMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:12:32 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53593 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764451Ab3DDTM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:12:29 -0400
Date: Thu, 4 Apr 2013 21:12:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH V4 1/2] cpufreq: ondemand: allow custom
 powersave_bias_target handler to be registered
Message-ID: <20130404191225.GH32271@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Renninger <trenn@suse.de>
References: <1365092344-11310-1-git-send-email-jacob.shin@amd.com>
 <1365092344-11310-2-git-send-email-jacob.shin@amd.com>
 <CAKohpom6BSJZc_ohgnjRTV2EBUAPy8TKVphtoRaNSt1wFP70uA@mail.gmail.com>
 <20130404171804.GA4696@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130404171804.GA4696@jshin-Toonie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 04, 2013 at 12:18:04PM -0500, Jacob Shin wrote:
> @@ -574,6 +577,45 @@ static struct common_dbs_data od_dbs_cdata = {
>  	.exit = od_exit,
>  };
>  
> +static void od_set_powersave_bias(unsigned int powersave_bias)
> +{
> +	struct cpufreq_policy *policy;
> +	struct dbs_data *dbs_data;
> +	struct od_dbs_tuners *od_tuners;
> +	unsigned int cpu;
> +	cpumask_t done;
> +
> +	cpumask_clear(&done);
> +

get_online_cpus();

> +	for_each_online_cpu(cpu) {
> +		if (cpumask_test_cpu(cpu, &done))
> +			continue;
> +
> +		policy = per_cpu(od_cpu_dbs_info, cpu).cdbs.cur_policy;
> +		dbs_data = policy->governor_data;
> +		od_tuners = dbs_data->tuners;
> +		od_tuners->powersave_bias = powersave_bias;
> +
> +		cpumask_or(&done, &done, policy->cpus);
> +	}

put_online_cpus();

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
