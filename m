Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3LEKeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:34:04 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:32822 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab3LEKd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:33:58 -0500
Date: Thu, 5 Dec 2013 11:33:53 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        hskinnemoen@gmail.com, heiko@sntech.de
Subject: Re: [PATCH] cpufreq_ at32ap-cpufreq.c: Fix section mismatch
Message-ID: <20131205103353.GB13219@samfundet.no>
References: <1386237597-1211-1-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386237597-1211-1-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Thu 05 Dec 2013 10:59:57 +0100 or thereabout, Matthias Brugger wrote:
> The function at32_cpufreq_driver_init was marked as __init but will be
> called from inside the cpufreq framework. This lead to the following a
> section mismatch during compilation:
> 
> WARNING: drivers/built-in.o(.data+0x2448): Section mismatch in reference
> from the variable at32_driver to the function
> .init.text:at32_cpufreq_driver_init()
> The variable at32_driver references
> the function __init at32_cpufreq_driver_init()
> If the reference is valid then annotate the
> variable with __init* or __refdata (see linux/init.h) or name the
> variable:
> *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console

You're right, it is added in struct cpufreq_driver, and AFAICT the cpufreq
core might call init every now and then.

Added to my for-linus branch.

> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  drivers/cpufreq/at32ap-cpufreq.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/at32ap-cpufreq.c b/drivers/cpufreq/at32ap-cpufreq.c
> index e0c38d9..372c426 100644
> --- a/drivers/cpufreq/at32ap-cpufreq.c
> +++ b/drivers/cpufreq/at32ap-cpufreq.c
> @@ -83,7 +83,7 @@ static int at32_set_target(struct cpufreq_policy *policy,
>  	return 0;
>  }
>  
> -static int __init at32_cpufreq_driver_init(struct cpufreq_policy *policy)
> +static int at32_cpufreq_driver_init(struct cpufreq_policy *policy)
>  {
>  	if (policy->cpu != 0)
>  		return -EINVAL;
-- 
mvh
Hans-Christian Egtvedt
