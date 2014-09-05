Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932336AbaIEMf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 08:35:58 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:20630 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756877AbaIEMfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 08:35:11 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-46-5409adfbca8a
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 RESEND 2/3] ARM: EXYNOS: Remove unneeded __ref annotation
 for cpu_die function
Date: Fri, 05 Sep 2014 14:34:54 +0200
Message-id: <1409920495-16533-2-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com>
References: <1409920495-16533-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprILMWRmVeSWpSXmKPExsVy+t/xK7q/13KGGJw4ZWyxccZ6Vot5n2Ut
	Xr8wtOhdcJXN4mzTG3aLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLkn15Gi1W7/jA68Hi0
	NPeweeycdZfd4861PWwem5fUe/RtWcXo8XmTXABbFJdNSmpOZllqkb5dAldG056dzAVN7BUt
	W26xNDB+YO1i5OSQEDCRmLdjITuELSZx4d56ti5GLg4hgaWMEvsOzGKEcPqYJHbuaGcDqWIT
	MJbYvHwJWJWIwA5GieX3LrODOMwCR5gklp3YzARSJSyQLDHjxAGgBAcHi4CqRPOLcJAwr4C7
	xPYrxxgh1slJnDw2GewMTgEPib8dzSwgthBQzeR365gnMPIuYGRYxSiaWppcUJyUnmuoV5yY
	W1yal66XnJ+7iRESjF92MC4+ZnWIUYCDUYmH94URZ4gQa2JZcWXuIUYJDmYlEV73KUAh3pTE
	yqrUovz4otKc1OJDjEwcnFINjAXq1gc6WvibzN1cy/qfMPdez9Jt7vspe4S1zV2dcfmpqUf4
	5K6o7v+bJJ2lV7V0u+jdJpHKrQduh2ZsfRzfJf1y9gROhkvNncq5+wPevtXjM9vcIcNSmvhc
	/her3TH1wv0mvsx7exXetE/RFi38/nvyjTmT7iRIsJwU+Ruhq/bwrUizRhCTEktxRqKhFnNR
	cSIAYfqWNyQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The __ref annotation for exynos_cpu_die() is not needed because the
function does not reference any __init/__exit symbol or call.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Reviewed-by: Tomasz Figa <t.figa@samsung.com>

---
Changes since v4:
1. Rebase on linux-next-20140804.
2. Add Reviewed-by Tomasz Figa.
---
 arch/arm/mach-exynos/platsmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/platsmp.c b/arch/arm/mach-exynos/platsmp.c
index a809f76c8160..83b20a38a598 100644
--- a/arch/arm/mach-exynos/platsmp.c
+++ b/arch/arm/mach-exynos/platsmp.c
@@ -373,7 +373,7 @@ static void __init exynos_smp_prepare_cpus(unsigned int max_cpus)
  *
  * Called with IRQs disabled
  */
-static void __ref exynos_cpu_die(unsigned int cpu)
+static void exynos_cpu_die(unsigned int cpu)
 {
 	int spurious = 0;
 
-- 
1.9.1

