Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751722AbaKJShb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 13:37:31 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:45412 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaKJSha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 13:37:30 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2] PM / Domains: Make genpd parameter of pm_genpd_present() const
Date: Mon, 10 Nov 2014 19:37:39 +0100
Message-Id: <1415644659-2531-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PM domain pointed to by the genpd parameter is never modified.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Kevin Hilman <khilman@linaro.org>
---
v2:
  - Add Acked-by
  - Add more description
---
 drivers/base/power/domain.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index b520687046d4f36a..a841bab441147b3d 100644
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

