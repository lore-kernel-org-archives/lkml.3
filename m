Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140Ab3GaOTl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 10:19:41 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:55200 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3GaOTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 10:19:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/15] cpufreq: initialize drivers .owner field with THIS_MODULE
Date: Wed, 31 Jul 2013 19:49:09 +0530
Message-Id: <cover.1375279948.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFreq core does following at multiple places:
module_{get|put}(cpufreq_driver->owner)).

This is done to make sure module doesn't get unloaded if it is currently in use.
This will work only if the .owner field of cpufreq driver is initialized with a
valid pointer.

This field wasn't initialized for many cpufreq driver, lets initialize it with
THIS_MODULE.

Rebased over: v3.11-rc3 and pushed here:

https://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-fix-owner

Viresh Kumar (15):
  cpufreq: arm_big_little: initialize .owner field with THIS_MODULE
  cpufreq: cpufreq-cpu0: initialize .owner field with THIS_MODULE
  cpufreq: davinci: initialize .owner field with THIS_MODULE
  cpufreq: dbx500: initialize .owner field with THIS_MODULE
  cpufreq: exynos: initialize .owner field with THIS_MODULE
  cpufreq: imx6q: initialize .owner field with THIS_MODULE
  cpufreq: integrator: initialize .owner field with THIS_MODULE
  cpufreq: omap: initialize .owner field with THIS_MODULE
  cpufreq: pxa: initialize .owner field with THIS_MODULE
  cpufreq: s3c24xx: initialize .owner field with THIS_MODULE
  cpufreq: s5pv210: initialize .owner field with THIS_MODULE
  cpufreq: sa11**: initialize .owner field with THIS_MODULE
  cpufreq: SPEAr: initialize .owner field with THIS_MODULE
  cpufreq: Tegra: initialize .owner field with THIS_MODULE
  cpufreq: Unicore: initialize .owner field with THIS_MODULE

 drivers/cpufreq/arm_big_little.c     | 1 +
 drivers/cpufreq/cpufreq-cpu0.c       | 1 +
 drivers/cpufreq/davinci-cpufreq.c    | 1 +
 drivers/cpufreq/dbx500-cpufreq.c     | 1 +
 drivers/cpufreq/exynos-cpufreq.c     | 1 +
 drivers/cpufreq/exynos5440-cpufreq.c | 1 +
 drivers/cpufreq/imx6q-cpufreq.c      | 1 +
 drivers/cpufreq/integrator-cpufreq.c | 1 +
 drivers/cpufreq/omap-cpufreq.c       | 1 +
 drivers/cpufreq/pxa2xx-cpufreq.c     | 1 +
 drivers/cpufreq/pxa3xx-cpufreq.c     | 1 +
 drivers/cpufreq/s3c24xx-cpufreq.c    | 1 +
 drivers/cpufreq/s5pv210-cpufreq.c    | 1 +
 drivers/cpufreq/sa1100-cpufreq.c     | 1 +
 drivers/cpufreq/sa1110-cpufreq.c     | 1 +
 drivers/cpufreq/spear-cpufreq.c      | 1 +
 drivers/cpufreq/tegra-cpufreq.c      | 1 +
 drivers/cpufreq/unicore2-cpufreq.c   | 1 +
 18 files changed, 18 insertions(+)

-- 
1.7.12.rc2.18.g61b472e

