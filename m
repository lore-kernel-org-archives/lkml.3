Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470Ab3JPWsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 18:48:54 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51434 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754856Ab3JPWsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 18:48:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        kbuild test robot <fengguang.wu@intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpufreq: Add dummy cpufreq_cpu_get/put for CONFIG_CPU_FREQ=n
Date: Thu, 17 Oct 2013 01:00:42 +0200
Message-ID: <3064536.Uv6oZedeVB@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1381222571-20317-1-git-send-email-daniel.vetter@ffwll.ch>
References: <1381222571-20317-1-git-send-email-daniel.vetter@ffwll.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 08, 2013 10:56:11 AM Daniel Vetter wrote:
> The drm/i915 driver wants to adjust it's own power policies using the
> cpu policies as a guideline (we can implicitly boost the cpus through
> the gpus on some platforms). To avoid a dreaded select (since a
> depends will leave users wondering where where their driver has gone
> too) add dummy functions.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Cc: kbuild test robot <fengguang.wu@intel.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Viresh Kumar <viresh.kumar@linaro.org>
> Cc: cpufreq@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> ---
> A quick ack for merging this this through the drm-intel tree is
> probably the simplest way forward.

Well, ACK, or please let me know if you want me to take this.

Thanks!

> ---
>  include/linux/cpufreq.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index fcabc42..5ad9a4e 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -93,8 +93,16 @@ struct cpufreq_policy {
>  #define CPUFREQ_SHARED_TYPE_ALL	 (2) /* All dependent CPUs should set freq */
>  #define CPUFREQ_SHARED_TYPE_ANY	 (3) /* Freq can be set from any dependent CPU*/
>  
> +#ifdef CONFIG_CPU_FREQ
>  struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu);
>  void cpufreq_cpu_put(struct cpufreq_policy *policy);
> +#else
> +static inline struct cpufreq_policy *cpufreq_cpu_get(unsigned int cpu)
> +{
> +	return NULL;
> +}
> +static inline void cpufreq_cpu_put(struct cpufreq_policy *policy) { }
> +#endif
>  
>  static inline bool policy_is_shared(struct cpufreq_policy *policy)
>  {
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
