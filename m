Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3KZEM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 23:12:56 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:33135 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3KZEMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 23:12:53 -0500
Message-ID: <52941FBB.7070603@linaro.org>
Date: Tue, 26 Nov 2013 09:42:43 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: rjw@rjwysocki.net
CC: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, swarren@wwwdotorg.org,
        kgene.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH V3 1/6] cpufreq: suspend governors on system suspend/hibernate
References: <cover.1385374819.git.viresh.kumar@linaro.org> <55cc3fbf9c553d669629e8ba98eef2b0ef33aaad.1385374822.git.viresh.kumar@linaro.org>
In-Reply-To: <55cc3fbf9c553d669629e8ba98eef2b0ef33aaad.1385374822.git.viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 November 2013 07:41 PM, Viresh Kumar wrote:
> diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
> index dc196bb..6d93f91 100644
> --- a/include/linux/cpufreq.h
> +++ b/include/linux/cpufreq.h
> @@ -255,6 +255,9 @@ struct cpufreq_driver {
>  int cpufreq_register_driver(struct cpufreq_driver *driver_data);
>  int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
>  
> +void cpufreq_suspend(void);
> +void cpufreq_resume(void);
> +
>  const char *cpufreq_get_current_driver(void);
>  
>  static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,

A minor fix here to get kernel compiled without cpufreq support enabled:

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 8d8b2f4..d40809d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -259,9 +259,6 @@ struct cpufreq_driver {
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);

-void cpufreq_suspend(void);
-void cpufreq_resume(void);
-
 const char *cpufreq_get_current_driver(void);

 static inline void cpufreq_verify_within_limits(struct cpufreq_policy *policy,
@@ -287,6 +284,14 @@ cpufreq_verify_within_cpu_limits(struct cpufreq_policy *policy)
                        policy->cpuinfo.max_freq);
 }

+#ifdef CONFIG_CPU_FREQ
+void cpufreq_suspend(void);
+void cpufreq_resume(void);
+#elif
+static inline void cpufreq_suspend(void) {}
+static inline void cpufreq_resume(void) {}
+#endif
+
 /*********************************************************************
  *                     CPUFREQ NOTIFIER INTERFACE                    *
  *********************************************************************/
