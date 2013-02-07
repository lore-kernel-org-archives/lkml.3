Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090Ab3BGNp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 08:45:56 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:50022 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758731Ab3BGNpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 08:45:53 -0500
MIME-Version: 1.0
In-Reply-To: <1360170133-5066-5-git-send-email-dirk.brandewie@gmail.com>
References: <1360170133-5066-1-git-send-email-dirk.brandewie@gmail.com>
	<1360170133-5066-5-git-send-email-dirk.brandewie@gmail.com>
Date: Thu, 7 Feb 2013 19:15:51 +0530
X-Google-Sender-Auth: 87YeCrMOj-LOJ5UzPOD0UZ-m1c0
Message-ID: <CAOh2x=mZv+mWas__0e6mXQTf6FO2F3deW1rAxEVcKfNuG0qeuw@mail.gmail.com>
Subject: Re: [PATCH 3/5] cpufreq: Do not track governor name for scaling
 drivers with internal governors.
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
> Scaling drivers that implement internal governors do not have governor
> structures assocaited with them.  Only track the name of the governor
> associated with the CPU if the driver does not implement
> cpufreq_driver.setpolicy()
>
> Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

To fix sparse warning updated this patch as:

commit ea241d95152c535c3d261f3a2240c45480b040bc
Author: Viresh Kumar <viresh.kumar@linaro.org>
Date:   Thu Feb 7 19:13:43 2013 +0530

    fixup! cpufreq: Do not track governor name for scaling drivers
with internal governors.
---
 drivers/cpufreq/cpufreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index e140b81..819aa33 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1039,7 +1039,7 @@ static int __cpufreq_remove_dev(struct device
*dev, struct subsys_interface *sif
                __cpufreq_governor(data, CPUFREQ_GOV_STOP);

 #ifdef CONFIG_HOTPLUG_CPU
-       if (!cpufreq_driver->setpolicy)
+       if (!driver->setpolicy)
                strncpy(per_cpu(cpufreq_cpu_governor, cpu),
                        data->governor->name, CPUFREQ_NAME_LEN);
 #endif
