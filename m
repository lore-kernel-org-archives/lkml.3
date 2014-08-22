Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756515AbaHVNuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 09:50:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58067 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227AbaHVNuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 09:50:16 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>, Tero Kristo <t-kristo@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Keerthy <j-keerthy@ti.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 3/7] ARM: OMAP2+: powerdomain: pwrdm_for_each_clkdm iterate only valid clkdms
Date: Fri, 22 Aug 2014 08:49:29 -0500
Message-ID: <1408715373-25791-4-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1408715373-25791-1-git-send-email-nm@ti.com>
References: <1408715373-25791-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to invoke callback when the clkdm pointer is NULL.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/mach-omap2/powerdomain.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-omap2/powerdomain.c b/arch/arm/mach-omap2/powerdomain.c
index faebd5f..f391948 100644
--- a/arch/arm/mach-omap2/powerdomain.c
+++ b/arch/arm/mach-omap2/powerdomain.c
@@ -546,7 +546,8 @@ int pwrdm_for_each_clkdm(struct powerdomain *pwrdm,
 		return -EINVAL;
 
 	for (i = 0; i < PWRDM_MAX_CLKDMS && !ret; i++)
-		ret = (*fn)(pwrdm, pwrdm->pwrdm_clkdms[i]);
+		if (pwrdm->pwrdm_clkdms[i])
+			ret = (*fn)(pwrdm, pwrdm->pwrdm_clkdms[i]);
 
 	return ret;
 }
-- 
1.7.9.5

