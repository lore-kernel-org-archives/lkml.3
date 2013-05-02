Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560Ab3EBPQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 11:16:53 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58988 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932506Ab3EBPQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 11:16:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Amit Daniel kachhap <amit.daniel@samsung.com>
Subject: [PATCH, RFC 12/22] thermal: cpu_cooling: fix stub function
Date: Thu,  2 May 2013 17:16:16 +0200
Message-Id: <1367507786-505303-13-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367507786-505303-1-git-send-email-arnd@arndb.de>
References: <1367507786-505303-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:KzsyrsOqdjI9ydfbCTPDL1Y23UsyRoNrilnMYRo1uii
 VtW+agm0abnKlcB707TF/AR6G01An7KyVFllJtG/Af3mE2cL3g
 nDoScTd28uj1Tc+JJBnHp92jxPIMr/o8fxwI3C3Fw9No3/wIJE
 GsegfvFnDoANzBfEF1nNfIlBVCiWm/17xhtkhHiCb2FDXWViA3
 C8K5hW0DjGKxqgp6n5AZ4NNC6mv65zbNBLJAz8SGb/8rw3TQUa
 3TB/lWqOgsCV4aDV3jFANBP7DOATUzHW33OfI1N9S85frWyh73
 EJ39e+BXXZ2gEvdomw9k9bjtWVklkIb7wkKvF2j/rpYfx9Tftx
 MQBSWfv0xNhzncrHjAl/gGsKVcgT8kdkeGRvAb0qt
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function stub for cpufreq_cooling_get_level introduced
in 57df81069 "Thermal: exynos: fix cooling state translation"
is not syntactically correct C and needs to be fixed to avoid
this error:

In file included from drivers/thermal/db8500_thermal.c:20:0:
 include/linux/cpu_cooling.h: In function 'cpufreq_cooling_get_level':
include/linux/cpu_cooling.h:57:1:
 error: parameter name omitted  unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)  ^
 include/linux/cpu_cooling.h:57:1: error: parameter name omitted

Cc: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Amit Daniel kachhap <amit.daniel@samsung.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 include/linux/cpu_cooling.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cpu_cooling.h b/include/linux/cpu_cooling.h
index 282e270..cf03111 100644
--- a/include/linux/cpu_cooling.h
+++ b/include/linux/cpu_cooling.h
@@ -54,7 +54,7 @@ void cpufreq_cooling_unregister(struct thermal_cooling_device *cdev)
 	return;
 }
 static inline
-unsigned long cpufreq_cooling_get_level(unsigned int, unsigned int)
+unsigned long cpufreq_cooling_get_level(unsigned int cpu, unsigned int freq)
 {
 	return THERMAL_CSTATE_INVALID;
 }
-- 
1.8.1.2

