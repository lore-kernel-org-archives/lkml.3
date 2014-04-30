Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbaD3FAt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 01:00:49 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:59721 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaD3E7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:59:49 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-c1-5360833bfd02
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, linux@arm.linux.org.uk, t.figa@samsung.com,
        chow.kim@samsung.com, yg1004.jang@samsung.com,
        vikas.sajjan@samsung.com, Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3 02/12] ARM: EXYNOS: Move cpufreq and cpuidle device
 registration to init_machine
Date: Wed, 30 Apr 2014 14:17:27 +0900
Message-id: <1398835057-3860-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
References: <1398835057-3860-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHLMWRmVeSWpSXmKPExsVy+t8zQ13r5oRgg9/9uhbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8XNZ9uZLHa0rGZx4PJoae5h89i8pN6j
	b8sqRo/Pm+QCWKK4bFJSczLLUov07RK4MhouT2ApmMtT8eLodZYGxiVcXYycHBICJhLN6xYw
	Q9hiEhfurWfrYuTiEBJYxiixcPNjFpii7S/vs0IkFjFKPJo7ixnCaWOS2Hr3GDtIFZuArsST
	93PBRokIZEtcabwPVsQssJtRorFxHtBcDg5hgVSJaz9YQWpYBFQllq9czghi8wq4S/Sv+cYO
	UiIhoCAxZ5INSJhTwENi4e3fYOVCQCUNDT2MICMlBFaxSxy+/5wZYo6AxLfJh1ggemUlNh2A
	+kZS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLWK07MLS7NS9dLzs/dxAgJ+/4djHcPWB9iTAYa
	N5FZSjQ5Hxg3eSXxhsZmRhamJqbGRuaWZqQJK4nz3n+YFCQkkJ5YkpqdmlqQWhRfVJqTWnyI
	kYmDU6qBcZtdVO8kaYWPvdce1VZvK1WdGRdnKbhd4+GBt9NmH5eelDS35vf+92zLC01dlm0s
	Epy9b81s3S+SW1XzV93mkgoVO3Nq7RSFe1L369S95sX+5J05u8ZylYFA8aqkSdsUlzrfbwkK
	8dsb4ude277qwsnL+wz3Xvb0aVjDG6kS9/BZ6OZ/tQYXziuxFGckGmoxFxUnAgBe9K4dkQIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t9jAV3r5oRgg6vNmhbLJt1ls+hdcJXN
	YtPja6wWl3fNYbOYcX4fk8Xty7wWi7Z+YbdYP+M1i8XNZ9uZLHa0rGZx4PJoae5h89i8pN6j
	b8sqRo/Pm+QCWKIaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVc
	fAJ03TJzgO5RUihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMWY0XJ7AUjCX
	p+LF0essDYxLuLoYOTkkBEwktr+8zwphi0lcuLeerYuRi0NIYBGjxKO5s5ghnDYmia13j7GD
	VLEJ6Eo8eT+XGcQWEciWuNJ4H6yIWWA3o0Rj4zygdg4OYYFUiWs/wKayCKhKLF+5nBHE5hVw
	l+hf840dpERCQEFiziQbkDCngIfEwtu/wcqFgEoaGnoYJzDyLmBkWMUomlqQXFCclJ5rqFec
	mFtcmpeul5yfu4kRHFXPpHYwrmywOMQowMGoxMMrsDU+WIg1say4MvcQowQHs5II7/nKhGAh
	3pTEyqrUovz4otKc1OJDjMlAR01klhJNzgdGfF5JvKGxiZmRpZGZhZGJuTlpwkrivAdarQOF
	BNITS1KzU1MLUotgtjBxcEo1MOb9NmA679zwQcdoivH1rriF/ad1DjT/1/A687XnhUr+j6j7
	y3QWmDc/kMm98MPp2zSl8p6/2qskQhZxLqg4ceWQxGO78ufR2unM1Xozcu4nMR7V12XfUM7P
	cfHBh4hQoz0vLrbL9CgHKE5T7Cz+w//4NpvQ99vVM7kE0trCztkEbEs9c1aHRYmlOCPRUIu5
	qDgRAJoQBm3uAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As exynos_cpuidle_init and exynos_cpufreq_init function have just one lines
of code for registering platform devices. We can move these lines to
exynos_dt_machine_init and delete exynos_cpuidle_init and exynos_cpufreq_init
function. This will help in reducing lines of code in exynos.c, making it
more cleaner.

Suggested-by: Tomasz Figa <t.figa@samsung.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-exynos/exynos.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 06dcce5..9315bd8 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -226,19 +226,6 @@ static struct platform_device exynos_cpuidle = {
 	.id                = -1,
 };
 
-void __init exynos_cpuidle_init(void)
-{
-	if (soc_is_exynos5440())
-		return;
-
-	platform_device_register(&exynos_cpuidle);
-}
-
-void __init exynos_cpufreq_init(void)
-{
-	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
-}
-
 static void __init exynos_init_late(void)
 {
 	if (of_machine_is_compatible("samsung,exynos5440"))
@@ -367,8 +354,10 @@ static void __init exynos_dt_machine_init(void)
 		}
 	}
 
-	exynos_cpuidle_init();
-	exynos_cpufreq_init();
+	if (!soc_is_exynos5440())
+		platform_device_register(&exynos_cpuidle);
+
+	platform_device_register_simple("exynos-cpufreq", -1, NULL, 0);
 
 	of_platform_populate(NULL, of_default_bus_match_table, NULL, NULL);
 }
-- 
1.7.10.4

