Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaLALsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 06:48:32 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:40249 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753143AbaLALsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 06:48:30 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-88-547c558c205d
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        ulf.hansson@linaro.org, rjw@rjwysocki.net, len.brown@intel.com,
        gregkh@linuxfoundation.org, khilman@linaro.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH] PM/ Domains: Export of_genpd_get_from_provider function.
Date: Mon, 01 Dec 2014 17:11:08 +0530
Message-id: <1417434068-7344-1-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <CAPDyKFpX5nXR18pKdLrtDrPK60p1y2CEqq+--3z3jczRRmKrqA@mail.gmail.com>
References: <CAPDyKFpX5nXR18pKdLrtDrPK60p1y2CEqq+--3z3jczRRmKrqA@mail.gmail.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsWyRsSkVrcntCbE4NkrYYuGqyEWzYvXs1l8
	PbyC0WLWlL1MFpseX2O1uLxrDpvFjPP7mCzOnL7EanF8bbgDp8fiPS+ZPO5c28PmsX/uGnaP
	zUvqPbZcbWfx6NuyitHj8ya5APYoLpuU1JzMstQifbsErowps1pZC86IVDz4toyxgXGdYBcj
	J4eEgInEua0HWCFsMYkL99azdTFycQgJLGWU2PrwARNM0feNcxkhEosYJf69OMIK4Uxgkug9
	9xysnU3AWOLnzv3sILaIgIbElK7H7CBFzAIvGCW2ndzJBpIQFvCU2HrkNdBYDg4WAVWJvhsC
	IGFeATeJlXcnsoOEJQQUJOZMsgEJcwoES/xfdghspJBAgMSJLy/BRkoI7GOXuPD5BNh1LAIC
	Et8mH2KB6JWV2HSAGeJoSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3IRK84Mbe4NC9dLzk/dxMj
	MBJO/3s2YQfjvQPWhxgFOBiVeHgPzKkOEWJNLCuuzD3EaAq0YSKzlGhyPjDe8kriDY3NjCxM
	TUyNjcwtzZTEeV9L/QwWEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwOgWr6xQLfss/xVPrJ7o
	j4XadUcdGeSPSP52vhTFHDSjmtNhzlaz3Zf/vBbpUGX7fvurYnIN5+0ji7Ve3/Bpma5/lz1u
	xVNJY1Evn9TWxyXM5wx4ggKfmuVXMRnslo57fm/TLwXpykmvf95rF6i6z+t8fF3XtLaFi2p+
	LKhQajdd1tPekNb+QYmlOCPRUIu5qDgRANqGI5h/AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t9jAd2e0JoQgxmPuCwaroZYNC9ez2bx
	9fAKRotZU/YyWWx6fI3V4vKuOWwWM87vY7I4c/oSq8XxteEOnB6L97xk8rhzbQ+bx/65a9g9
	Ni+p99hytZ3Fo2/LKkaPz5vkAtijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0t
	zJUU8hJzU22VXHwCdN0yc4AOU1IoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS
	1jBmTJnVylpwRqTiwbdljA2M6wS7GDk5JARMJL5vnMsIYYtJXLi3nq2LkYtDSGARo8S/F0dY
	IZwJTBK9556zglSxCRhL/Ny5nx3EFhHQkJjS9ZgdpIhZ4AWjxLaTO9lAEsICnhJbj7xm6mLk
	4GARUJXouyEAEuYVcJNYeXciO0hYQkBBYs4kG5Awp0CwxP9lh8BGCgkESJz48pJ9AiPvAkaG
	VYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBcfZMagfjygaLQ4wCHIxKPLwH51SHCLEmlhVX
	5h5ilOBgVhLhfetdEyLEm5JYWZValB9fVJqTWnyI0RToponMUqLJ+cAUkFcSb2hsYm5qbGpp
	YmFiZqkkznvjZm6IkEB6YklqdmpqQWoRTB8TB6dUA2Nl9KfZ86WzBT611Hn0T+E/rR7Lu+Z+
	9iOxeX9zuWKeq06utq3hkJnUuvNcRYDDfOlvV2d5Lg0613NkpoAWw8KfhasFqt2nTvyayGT9
	elKNZ4aPkBS78ZrLqjZKfruWm2oHzHSfuiuLq0h3rrnCkYZZYjpr5iqpubo8Zr0ze/nazUv1
	DmgdYVJiKc5INNRiLipOBAB6+MFayQIAAA==
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

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
This patch may solve the same purpose which is done by earlier posts
1) https://lkml.org/lkml/2014/11/24/319 - In this there were comments
for not using the PM domain name.

2) Ulf Hansson posted a patch 
http://www.spinics.net/lists/linux-samsung-soc/msg39745.html which also solves
similar purpose but I feel this is slightly complex and involves changing
the genpd structure.


 drivers/base/power/domain.c |    3 ++-
 include/linux/pm_domain.h   |    8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index d822753..5d7a2c1 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -2129,7 +2129,7 @@ EXPORT_SYMBOL_GPL(of_genpd_del_provider);
  * Returns a valid pointer to struct generic_pm_domain on success or ERR_PTR()
  * on failure.
  */
-static struct generic_pm_domain *of_genpd_get_from_provider(
+struct generic_pm_domain *of_genpd_get_from_provider(
 					struct of_phandle_args *genpdspec)
 {
 	struct generic_pm_domain *genpd = ERR_PTR(-ENOENT);
@@ -2149,6 +2149,7 @@ static struct generic_pm_domain *of_genpd_get_from_provider(
 
 	return genpd;
 }
+EXPORT_SYMBOL_GPL(of_genpd_get_from_provider);
 
 /**
  * genpd_dev_pm_detach - Detach a device from its PM domain.
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 9690827..4954e24 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -282,6 +282,8 @@ typedef struct generic_pm_domain *(*genpd_xlate_t)(struct of_phandle_args *args,
 int __of_genpd_add_provider(struct device_node *np, genpd_xlate_t xlate,
 			void *data);
 void of_genpd_del_provider(struct device_node *np);
+struct generic_pm_domain *of_genpd_get_from_provider(
+			struct of_phandle_args *genpdspec);
 
 struct generic_pm_domain *__of_genpd_xlate_simple(
 					struct of_phandle_args *genpdspec,
@@ -299,6 +301,12 @@ static inline int __of_genpd_add_provider(struct device_node *np,
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
1.7.9.5

