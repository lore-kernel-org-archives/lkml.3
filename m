Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747Ab3BGNqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:46:32 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:41430 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3BGNq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:46:29 -0500
MIME-Version: 1.0
In-Reply-To: <1360170133-5066-2-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
	<1360170133-5066-2-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 7 Feb 2013 19:16:20 +0530
X-Google-Sender-Auth: 6d8J2bFgDheN3j5uJfP10UDzQBM
Message-ID: <CAOh2x=mU=nPv2t2kh3YR-Lyx3gqgNPbms_kPsimFLZcbU2ULsw@mail.gmail.com>
Subject: Re: [PATCH 1/5] cpufreq: Retrieve current frequency from scaling
 drivers with internal governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: dirk.brandewie@gmail.com
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 10:32 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Scaling drivers that implement the cpufreq_driver.setpolicy() versus
> the cpufreq_driver.target() interface do not set policy->cur.
>
> Normally policy->cur is set during the call to cpufreq_driver.target()
> when the frequnecy request is made by the governor.
>
> If the scaling driver implements cpufreq_driver.setpolicy() and
> cpufreq_driver.get() interfaces use cpufreq_driver.get() to retrieve
> the current frequency.
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

To fix sparse warning updated this patch as:

commit f6060fa13ace2da4e691233706a788f91ad453da
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Thu Feb 7 19:12:16 2013 +0530

    fixup! cpufreq: Retrieve current frequency from scaling drivers
with internal governors
---
 drivers/cpufreq/cpufreq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 447b313..e140b81 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1173,12 +1173,12 @@ static void cpufreq_out_of_sync(unsigned int
cpu, unsigned int old_freq,
  */
 unsigned int cpufreq_quick_get(unsigned int cpu)
 {
+       struct cpufreq_driver *driver = rcu_dereference(cpufreq_driver);
        struct cpufreq_policy *policy;
        unsigned int ret_freq = 0;

-       if (cpufreq_driver && cpufreq_driver->setpolicy &&
-                       cpufreq_driver->get)
-                       return cpufreq_driver->get(cpu);
+       if (driver && driver->setpolicy && driver->get)
+                       return driver->get(cpu);

        policy = cpufreq_cpu_get(cpu);
        if (policy) {
