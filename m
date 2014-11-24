Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbaKXNRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:17:40 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36072 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbaKXNRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:17:38 -0500
X-AuditID: cbfee690-f79ab6d0000046f7-46-54732ff03f18
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, pankaj.dubey@samsung.com,
        ulf.hansson@linaro.org, khilman@kernel.org, linux-pm@vger.kernel.org,
        geert@linux-m68k.org, rjw@rjwysocki.net, devicetree@vger.kernel.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH RFC v2 07/12] PM / Domains: export pm_genpd_lookup_name
Date: Mon, 24 Nov 2014 18:34:11 +0530
Message-id: <1416834256-11225-7-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
References: <1416833572-6880-1-git-send-email-amit.daniel@samsung.com>
 <1416834256-11225-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPLMWRmVeSWpSXmKPExsWyRsSkVveDfnGIwZb1/BYNV0Ms5h85x2rx
	7NZeJoveBVfZLJ5ufsxksenxNVaLy7vmsFl87j3CaDHj/D4mi0Vbv7BbnDl9idXi8Jt2Vovj
	a8MdeD02repk87hzbQ+bx6HDHYwem5fUe2y52s7i0bdlFaPH501yAexRXDYpqTmZZalF+nYJ
	XBk3ltkVbBaoWHa2jamB8S9vFyMnh4SAicT3/e8ZIWwxiQv31rN1MXJxCAksZZR43dHDClN0
	79xWJojEdKDEkZ8sIAkhgQlMEm2bikBsNgFjiZ8797N3MXJwiAh4Syy/pghSzyywmklia/sH
	JpAaYQF3iSUTjoLZLAKqEt2737OB2LxA8Xk938B6JQQUJOZMsgEJcwp4SLw42MIMsbeFUeLS
	47msII6EwCV2iZurmxghBglIfJt8iAWiWVZi0wFmiKMlJQ6uuMEygVF4ASPDKkbR1ILkguKk
	9CITveLE3OLSvHS95PzcTYzAeDn979mEHYz3DlgfYhTgYFTi4f2wsShEiDWxrLgy9xCjKdCG
	icxSosn5wKjMK4k3NDYzsjA1MTU2Mrc0UxLnfS31M1hIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QDY7kFA7/4hv9zzp043n5cRy1Bu3j1HEGTUxN7fQ87rTl7TMNhiVzBffPw4lymaHFjHoW0
	OEO5zZeEn6z68r6h8cirsxa1/1J3He7yn+1/7p3G3o05Sz8v5hc2d/phFM/5KJiblYM1vPVW
	yHofrftPPm1RnpLzrzw2++QEW8VUG4lTy0xiC5qclViKMxINtZiLihMBql3D8ZICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t9jQd0P+sUhBh9Xsls0XA2xmH/kHKvF
	s1t7mSx6F1xls3i6+TGTxabH11gtLu+aw2bxufcIo8WM8/uYLBZt/cJuceb0JVaLw2/aWS2O
	rw134PXYtKqTzePOtT1sHocOdzB6bF5S77HlajuLR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTm
	JeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAdq6RQlphTChQKSCwuVtK3
	wzQhNMRN1wKmMULXNyQIrsfIAA0krGHMuLHMrmCzQMWys21MDYx/ebsYOTkkBEwk7p3bygRh
	i0lcuLeerYuRi0NIYDqjxOsjP1lAEkICE5gk2jYVgdhsAsYSP3fuZ+9i5OAQEfCWWH5NEaSe
	WWA1k8TW9g9gg4QF3CWWTDgKZrMIqEp0737PBmLzAsXn9XwD65UQUJCYM8kGJMwp4CHx4mAL
	M8TeFkaJS4/nsk5g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgan0nvYFzVYHGI
	UYCDUYmHd8b6ohAh1sSy4srcQ4wSHMxKIrxiYsUhQrwpiZVVqUX58UWlOanFhxhNga6ayCwl
	mpwPTBR5JfGGxibmpsamliYWJmaWSuK8N27mhggJpCeWpGanphakFsH0MXFwSjUwqhwXLi47
	6n25z6Q28nRT3aY3XVcsWFf6nMn+tFhu+3/3nAOxT7JXNyyy5p0U5cpRX6tf3HxQ+0LgJFFm
	6SKx0qQP86p5bIKLvpls7vc7VsaaWv/+6DrHAI/k1EDl6/WKUjds3oUbK+3W6ZDc7fJvmcXR
	kCPejAX3L7/8OXN+gcyMg07mfxKVWIozEg21mIuKEwEUF9HM3AIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This API may be needed to set the power domain parent/child relationship
in the power domain platform driver. The parent relationship is
generally set after the child power domain is registered with the power
domain subsystem. In this case, pm_genpd_lookup_name API might be
useful.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/base/power/domain.c |    3 ++-
 include/linux/pm_domain.h   |    7 +++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index fb83d4a..b0e1c2f 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -49,7 +49,7 @@
 static LIST_HEAD(gpd_list);
 static DEFINE_MUTEX(gpd_list_lock);
 
-static struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
+struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
 {
 	struct generic_pm_domain *genpd = NULL, *gpd;
 
@@ -66,6 +66,7 @@ static struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
 	mutex_unlock(&gpd_list_lock);
 	return genpd;
 }
+EXPORT_SYMBOL_GPL(pm_genpd_lookup_name);
 
 struct generic_pm_domain *dev_to_genpd(struct device *dev)
 {
diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 2e0e06d..aedcec3 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -150,6 +150,8 @@ extern int pm_genpd_name_poweron(const char *domain_name);
 
 extern struct dev_power_governor simple_qos_governor;
 extern struct dev_power_governor pm_domain_always_on_gov;
+
+extern struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name);
 #else
 
 static inline struct generic_pm_domain_data *dev_gpd_data(struct device *dev)
@@ -221,6 +223,11 @@ static inline int pm_genpd_name_poweron(const char *domain_name)
 {
 	return -ENOSYS;
 }
+static inline
+struct generic_pm_domain *pm_genpd_lookup_name(const char *domain_name)
+{
+	return NULL;
+}
 #define simple_qos_governor NULL
 #define pm_domain_always_on_gov NULL
 #endif
-- 
1.7.9.5

