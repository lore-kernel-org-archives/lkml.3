Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbaLODqV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:46:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:42880 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750713AbaLODqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:46:19 -0500
X-AuditID: cbfee68d-f79296d000004278-07-548e5988ecc4
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, Ulf Hansson <ulf.hansson@linaro.org>,
        Kevin Hilman <khilman@linaro.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Pavel Machek <pavel@ucw.cz>, linux-arm-kernel@lists.infradead.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v2] PM/ Domains: Export of_genpd_get_from_provider function.
Date: Mon, 15 Dec 2014 09:08:59 +0530
Message-id: <1418614739-7989-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 2.2.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkRrcjsi/E4N5UOYuGqyEWc2dPYrT4
	engFo8WsKXuZLDY9vsZqcXnXHDaLz71HGC3unjrKZnHm9CVWi+Nrwx24PCae1fVYvOclk8ed
	a3vYPDYvqffYcrWdxaNvyypGjxWrv7N7fN4kF8ARxWWTkpqTWZZapG+XwJWx7u9ttoKXohXb
	eswbGLcLdTFycEgImEjc7dXsYuQEMsUkLtxbz9bFyMUhJLCUUeLry/2MEAkTic1rjzBCJKYz
	Sjx69IcFwpnAJHH19SU2kCo2AWOJnzv3s4PYIgIyElOv7GcFKWIWuMsk8XT9Y2aQhLCAj8Sl
	MyvBGlgEVCXabs8EW8Er4CZx+uBcZoh1chJbbj1iB2mWEFjGLjHj0wlWiAYBiW+TD7FA3C0r
	sekAVL2kxMEVN1gmMAouYGRYxSiaWpBcUJyUXmSoV5yYW1yal66XnJ+7iREY6qf/PevdwXj7
	gPUhRgEORiUeXob/vSFCrIllxZW5hxhNgTZMZJYSTc4HRlReSbyhsZmRhamJqbGRuaWZkjiv
	otTPYCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MscWRX36tFVolV5fq9/PA9tSrzffue3d9
	EzrS+f/97T+GUxt72V4febBugt3ue4nPH06w+q22z0Gseru2DLfBKtltx4R0JBM+bVqoEB60
	e3XUa/6AQ5tZ/lerhXyvMyz2Y+g8aixvYOMjXlV9YvKCuVP8AuW4NXTvm/MKetWvOyLl++hD
	/lF7JZbijERDLeai4kQA+bNEQnACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t9jQd2OyL4Qg2+3RCwaroZYzJ09idHi
	6+EVjBazpuxlstj0+BqrxeVdc9gsPvceYbS4e+oom8WZ05dYLY6vDXfg8ph4Vtdj8Z6XTB53
	ru1h89i8pN5jy9V2Fo++LasYPVas/s7u8XmTXABHVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8
	c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QhUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0
	fUOC4HqMDNBAwhrGjHV/b7MVvBSt2NZj3sC4XaiLkZNDQsBEYvPaI4wQtpjEhXvr2boYuTiE
	BKYzSjx69IcFwpnAJHH19SU2kCo2AWOJnzv3s4PYIgIyElOv7GcFKWIWuMsk8XT9Y2aQhLCA
	j8SlMyvBGlgEVCXabs8EW8Er4CZx+uBcZoh1chJbbj1in8DIvYCRYRWjaGpBckFxUnqukV5x
	Ym5xaV66XnJ+7iZGcCw9k97BuKrB4hCjAAejEg8vw//eECHWxLLiytxDjBIczEoivFOY+kKE
	eFMSK6tSi/Lji0pzUosPMZoCbZ/ILCWanA+M87ySeENjE3NTY1NLEwsTM0slcV4l+7YQIYH0
	xJLU7NTUgtQimD4mDk6pBkbHlqww54L/Fp2Vgd2XlwmvmVRtez4qXtTh0HEJ4WWiKxpM+JOU
	S94eqz/JcS6I5wPjmxvipcYVlr8EpfS9OctMTsdouX77GneH8WmWEc+NGwd/3ih/3NHPwHxS
	4ZFX5ZznpzWfykY5iRiVegc0fzqSJl0X+3e76TmPq8pXF8z3+5C7dH35diWW4oxEQy3mouJE
	ALtJKpe7AgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function looks up a PM domain form the provider. This will be
useful to add parent/child domain relationship from the SoC specific
code. The caller of the function must make sure that PM domain provider
is already registered.

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
Changes from v1:
* Added Ulf Hansson Reviewed by.
* Cc'd to linux-pm

This patch may solve the same purpose which is done by earlier posts
1) https://lkml.org/lkml/2014/11/24/319 - In this there were comments
for not using the PM domain name.

2) Ulf Hansson posted a patch
http://www.spinics.net/lists/linux-samsung-soc/msg39745.html which also solves
similar purpose but I feel this is slightly complex and involves changing
the genpd structure.

 drivers/base/power/domain.c | 3 ++-
 include/linux/pm_domain.h   | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 6a103a3..0d8780c 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2088,7 +2088,7 @@ EXPORT_SYMBOL_GPL(of_genpd_del_provider);
  * Returns a valid pointer to struct generic_pm_domain on success or ERR_PTR()
  * on failure.
  */
-static struct generic_pm_domain *of_genpd_get_from_provider(
+struct generic_pm_domain *of_genpd_get_from_provider(
 					struct of_phandle_args *genpdspec)
 {
 	struct generic_pm_domain *genpd = ERR_PTR(-ENOENT);
@@ -2108,6 +2108,7 @@ static struct generic_pm_domain *of_genpd_get_from_provider(
 
 	return genpd;
 }
+EXPORT_SYMBOL_GPL(of_genpd_get_from_provider);
 
 /**
  * genpd_dev_pm_detach - Detach a device from its PM domain.
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 6cd20d5..a9edab2 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -271,6 +271,8 @@ typedef struct generic_pm_domain *(*genpd_xlate_t)(struct of_phandle_args *args,
 int __of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
 			void *data);
 void of_genpd_del_provider(struct device_node *np);
+struct generic_pm_domain *of_genpd_get_from_provider(
+			struct of_phandle_args *genpdspec);
 
 struct generic_pm_domain *__of_genpd_xlate_simple(
 					struct of_phandle_args *genpdspec,
@@ -288,6 +290,12 @@ static inline int __of_genpd_add_provider(struct device_node *np,
 }
 static inline void of_genpd_del_provider(struct device_node *np) {}
 
+static inline struct generic_pm_domain *of_genpd_get_from_provider(
+			struct of_phandle_args *genpdspec)
+{
+	return NULL;
+}
+
 #define __of_genpd_xlate_simple		NULL
 #define __of_genpd_xlate_onecell	NULL
 
-- 
2.2.0

