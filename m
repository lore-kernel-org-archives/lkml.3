Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab3HCRNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Aug 2013 13:13:48 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50231 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab3HCRNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Aug 2013 13:13:46 -0400
MIME-Version: 1.0
In-Reply-To: <c685424014a84ad05ee55b669a6cda1c8c66723e.1375530162.git.viresh.kumar@linaro.org>
References: <cover.1375530162.git.viresh.kumar@linaro.org>
	<c685424014a84ad05ee55b669a6cda1c8c66723e.1375530162.git.viresh.kumar@linaro.org>
Date: Sat, 3 Aug 2013 22:43:45 +0530
Message-ID: <CAKohpomVKac+1c7rNseUKM_RCVaNiFsaioJuW98oLJP5atSaSg@mail.gmail.com>
Subject: Re: [PATCH 02/10] cpufreq: Re-arrange declarations in cpufreq.h
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        l.majewski@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 August 2013 17:19, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> They are pretty much mixed up. Although generic headers are present but
> definitions/declarations are present outside them too..
>
> This patch just moves stuff up and down to make it look better and consistent.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  include/linux/cpufreq.h | 370 +++++++++++++++++++++++-------------------------
>  1 file changed, 177 insertions(+), 193 deletions(-)

Fixup due to compilation reported by Fengguang's kbuild system:
[Will post the series again once I receive more comments on it]

diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index a6b97e2..d568f39 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -268,6 +268,19 @@ int cpufreq_unregister_notifier(struct
notifier_block *nb, unsigned int list);
 void cpufreq_notify_transition(struct cpufreq_policy *policy,
                struct cpufreq_freqs *freqs, unsigned int state);

+#else /* CONFIG_CPU_FREQ */
+static inline int cpufreq_register_notifier(struct notifier_block *nb,
+                                               unsigned int list)
+{
+       return 0;
+}
+static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
+                                               unsigned int list)
+{
+       return 0;
+}
+#endif /* !CONFIG_CPU_FREQ */
+
 /**
  * cpufreq_scale - "old * mult / div" calculation for large values (32-bit-arch
  * safe)
@@ -282,32 +295,16 @@ static inline unsigned long
cpufreq_scale(unsigned long old, u_int div,
                u_int mult)
 {
 #if BITS_PER_LONG == 32
-
        u64 result = ((u64) old) * ((u64) mult);
        do_div(result, div);
        return (unsigned long) result;

 #elif BITS_PER_LONG == 64
-
        unsigned long result = old * ((u64) mult);
        result /= div;
        return result;
-
 #endif
-};
-
-#else /* CONFIG_CPU_FREQ */
-static inline int cpufreq_register_notifier(struct notifier_block *nb,
-                                               unsigned int list)
-{
-       return 0;
 }
-static inline int cpufreq_unregister_notifier(struct notifier_block *nb,
-                                               unsigned int list)
-{
-       return 0;
-}
-#endif /* !CONFIG_CPU_FREQ */

 /*********************************************************************
  *                          CPUFREQ GOVERNORS                        *
