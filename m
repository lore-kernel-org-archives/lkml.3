Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaKCPfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:35:07 -0500
Received: from baptiste.telenet-ops.be ([195.130.132.51]:42081 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870AbaKCPfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:35:02 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>
Cc: Ulf Hansson <ulf.hansson@linaro.org>, Kevin Hilman <khilman@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 1/9] PM / Domains: Change prototype for the ->attach_dev() callback
Date: Mon,  3 Nov 2014 16:34:48 +0100
Message-Id: <1415028896-9005-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
References: <1415028896-9005-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

Convert the prototype to return and int. This is just an initial step,
needed to support error handling.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
Prerequisite

Ulf wrote:

This patch is intended as fix for 3.18 rc[n]. Why?

There are other SOC specific patches around that adds genpd support and which
implements the ->attach_dev() callback. To prevent having an "atomic" patch
during the next release cycle, let's change the prototype now instead.

Further patches will add the actual error handling in genpd and these can then
be reviewed and tested thoroughly.
---
 include/linux/pm_domain.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/pm_domain.h b/include/linux/pm_domain.h
index 73e938b7e9374c68..d44f071988a861ff 100644
--- a/include/linux/pm_domain.h
+++ b/include/linux/pm_domain.h
@@ -72,7 +72,7 @@ struct generic_pm_domain {
 	bool max_off_time_changed;
 	bool cached_power_down_ok;
 	struct gpd_cpuidle_data *cpuidle_data;
-	void (*attach_dev)(struct device *dev);
+	int (*attach_dev)(struct device *dev);
 	void (*detach_dev)(struct device *dev);
 };
 
-- 
1.9.1

