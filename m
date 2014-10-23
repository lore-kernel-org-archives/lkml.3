Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaJWMMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:12:19 -0400
Received: from baptiste.telenet-ops.be ([195.130.132.51]:42014 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480AbaJWMMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:12:15 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 1/2] PM / Domains: Make genpd parameter of pm_genpd_present() const
Date: Thu, 23 Oct 2014 14:12:15 +0200
Message-Id: <1414066336-11168-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/base/power/domain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 40bc2f4072cc28ea..28d6e8bf746c4683 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -753,9 +753,9 @@ static inline void genpd_power_off_work_fn(struct work_struct *work) {}
  * pm_genpd_present - Check if the given PM domain has been initialized.
  * @genpd: PM domain to check.
  */
-static bool pm_genpd_present(struct generic_pm_domain *genpd)
+static bool pm_genpd_present(const struct generic_pm_domain *genpd)
 {
-	struct generic_pm_domain *gpd;
+	const struct generic_pm_domain *gpd;
 
 	if (IS_ERR_OR_NULL(genpd))
 		return false;
-- 
1.9.1

