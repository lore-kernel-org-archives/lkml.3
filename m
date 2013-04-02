Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761634Ab3DBNbS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:31:18 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59921 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761563Ab3DBNbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:31:16 -0400
Date: Tue, 2 Apr 2013 15:31:14 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V2 1/2] cpufreq: ondemand: allow custom
 powersave_bias_target function to be registered
Message-ID: <20130402133114.GC5488@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jacob Shin <jacob.shin@amd.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Viresh Kumar <viresh.kumar@linaro.org>
References: <1364495057-14939-1-git-send-email-jacob.shin@amd.com>
 <1364495057-14939-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1364495057-14939-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 01:24:16PM -0500, Jacob Shin wrote:
> @@ -206,8 +209,8 @@ static void od_check_cpu(int cpu, unsigned int load_freq)
>  			__cpufreq_driver_target(policy, freq_next,
>  					CPUFREQ_RELATION_L);
>  		} else {
> -			int freq = powersave_bias_target(policy, freq_next,
> -					CPUFREQ_RELATION_L);
> +			int freq = od_ops.powersave_bias_target(policy,
> +					freq_next, CPUFREQ_RELATION_L);
>  			__cpufreq_driver_target(policy, freq,
>  					CPUFREQ_RELATION_L);

Btw, one more thing: you can simplify this code a bit, while you're at
it:

                if (!od_tuners->powersave_bias) {
                        __cpufreq_driver_target(policy, freq_next,
						CPUFREQ_RELATION_L);
			return;
		}

		freq_next = od_ops.powersave_bias_target(policy, freq_next, CPUFREQ_RELATION_L);
		__cpufreq_driver_target(policy, freq, CPUFREQ_RELATION_L);
	}

and drop the local "int freq" too.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
