Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161287AbaJ3U57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:57:59 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50026 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933386AbaJ3U55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:57:57 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: James Geboski <jgeboski@gmail.com>,
        "'Dirk Brandewie'" <dirk.j.brandewie@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "'Dirk Brandewie'" <dirk.brandewie@gmail.com>
Subject: Re: [PATCH v2] cpufreq: allow powersave governor as the default without expert mode
Date: Thu, 30 Oct 2014 22:18:33 +0100
Message-ID: <1463060.7rHn3OIKry@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1413459431-12355-1-git-send-email-jgeboski@gmail.com>
References: <1413322689-6195-1-git-send-email-jgeboski@gmail.com> <1413459431-12355-1-git-send-email-jgeboski@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 16, 2014 07:37:11 AM James Geboski wrote:
> The intel_pstate driver only supports the performance and the powersave
> governors. With the performance governor ensuring the highest possible
> performance settings, userspace tools fail to make any lasting changes.
> In order to allow userspace tools to make modifications to the settings,
> the powersave governor must be in use. This makes having the powersave
> governor as the default convenient for systems where the intel_pstate
> driver is being employed. Having to enable expert mode in the kernel
> configuration is just a headache for such a trivial task.
> 
> This patch applies to all kernel versions 2.6.38 or greater after the
> migration from CONFIG_EMBEDDED to CONFIG_EXPERT (6a108a14fa35). Most
> importantly, this applies to kernel versions 3.9 or greater when the
> intel_pstate driver was introduced.
> 
> Signed-off-by: James Geboski <jgeboski@gmail.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

Dirk, any objections?

> ---
> ChangeLog v2:
>   - Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index 3489f8f..73df7db 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -63,7 +63,6 @@ config CPU_FREQ_DEFAULT_GOV_PERFORMANCE
>  
>  config CPU_FREQ_DEFAULT_GOV_POWERSAVE
>  	bool "powersave"
> -	depends on EXPERT
>  	select CPU_FREQ_GOV_POWERSAVE
>  	help
>  	  Use the CPUFreq governor 'powersave' as default. This sets
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
