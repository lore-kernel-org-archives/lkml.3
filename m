Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757017AbaCDK22 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 05:28:28 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:34056 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869AbaCDK2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 05:28:19 -0500
X-AuditID: cbfee61a-b7fb26d00000724f-d1-5315aabaf4a7
From: Lukasz Majewski <l.majewski@samsung.com>
To: Viresh Kumar <viresh.kumar@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, Thomas Abraham <ta.omasab@gmail.com>,
        thomas.ab@samsung.com,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org
Subject: [RFC v3 4/5] cpufreq:LAB:Kconfig Add LAB definitions to Kconfig
Date: Tue, 04 Mar 2014 11:27:31 +0100
Message-id: <1393928852-22725-5-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
References: <1367590072-10496-1-git-send-email-jonghwa3.lee@samsung.com>
 <1393928852-22725-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrCLMWRmVeSWpSXmKPExsVy+t9jAd1dq0SDDb7OFbbYOGM9q8XTph/s
	Fp1nnzBbvHnEbfHm4WZGi02Pr7FaXN41h83ic+8RRosZ5/cxWdxuXMFmceb0JVaL9TNes1hs
	nrCRzaJjGaPFxq8eDvweO2fdZfe4c20Pm8fmJfUe66a9ZfbYcrWdxaNvyypGj8+b5ALYo7hs
	UlJzMstSi/TtErgyDs46z14wT6hi65djbA2MV/m6GDk5JARMJBZtu88GYYtJXLi3Hsjm4hAS
	WMQocePUdUYIp4tJ4tHzZWBVbAJ6Ep/vPmUCsUUEQiWOTv3KDlLELHCGReLti92sIAlhAQ+J
	kw9fgzWwCKhKHLu6GCzOK+AmceXrHVaIdYoS3c8mgNVwCrhLHF/RzAyxrZVR4vLOG0wTGHkX
	MDKsYhRNLUguKE5KzzXUK07MLS7NS9dLzs/dxAgO22dSOxhXNlgcYhTgYFTi4Z0xTSRYiDWx
	rLgy9xCjBAezkgiv4kLRYCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8B1qtA4UE0hNLUrNTUwtS
	i2CyTBycUg2Mra0vU8PWX/EufeXZOb99T+OB63En8i3Zhfg8k6+/2Je6pivdbJ75pdt1Ij7c
	eS4zUj7WOdetb7H1vnZdeLXcsc/7a8/mtM/eFqWXFnn4j51A1dtH/xc+eH/skmHPIp/PZi+8
	r2hsaZhyd4LFRMFqw7s8lwNDfYzeFK8pnhV+Zo9a3bMAUxEWJZbijERDLeai4kQANDmICVcC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide support for LAB governor for the Kbuild.

It is important to note, that LAB is not possible to be compiled in as
a module since we cannot assure (in the kernel) that backing ondemand
module will not be removed without notice to LAB.

For this reason the LAB can be only compiled into the kernel without
possibility to be compiled as a module.

Signed-off-by: Lukasz Majewski <l.majewski@samsung.com>
Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/cpufreq/Kconfig |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
index 4b029c0..3a870ea 100644
--- a/drivers/cpufreq/Kconfig
+++ b/drivers/cpufreq/Kconfig
@@ -102,6 +102,18 @@ config CPU_FREQ_DEFAULT_GOV_CONSERVATIVE
 	  Be aware that not all cpufreq drivers support the conservative
 	  governor. If unsure have a look at the help section of the
 	  driver. Fallback governor will be the performance governor.
+
+config CPU_FREQ_DEFAULT_GOV_LAB
+	bool "lab"
+	select CPU_FREQ_GOV_LAB
+	select CPU_FREQ_GOV_PERFORMANCE
+	help
+	  Use the CPUFreq governor 'lab' as default. This allows
+	  you to get a full dynamic frequency capable system by simply
+	  loading your cpufreq low-level hardware driver.
+	  Be aware that not all cpufreq drivers support the lab governor.
+	  If unsure have a look at the help section of the driver.
+	  Fallback governor will be the performance governor.
 endchoice
 
 config CPU_FREQ_GOV_PERFORMANCE
@@ -183,6 +195,22 @@ config CPU_FREQ_GOV_CONSERVATIVE
 
 	  If in doubt, say N.
 
+config CPU_FREQ_GOV_LAB
+	bool "'lab' cpufreq policy governor - ONDEMAND extension"
+	select CPU_FREQ_TABLE
+	select CPU_FREQ_GOV_COMMON
+	select CPU_FREQ_GOV_ONDEMAND
+	help
+	  'lab' - This driver adds a dynamic cpufreq policy governor.
+
+	  LAB governor shall be regarded as an extension of the ONDEMAND on
+	  platforms with very weak HW support for power management.
+
+	  LAB governor can be either compiled in or not. It is not possible to
+	  compile it as module because of explicit ONDEMAND dependency.
+
+	  If in doubt, say N.
+
 config GENERIC_CPUFREQ_CPU0
 	tristate "Generic CPU0 cpufreq driver"
 	depends on HAVE_CLK && REGULATOR && OF && THERMAL && CPU_THERMAL
-- 
1.7.10.4

