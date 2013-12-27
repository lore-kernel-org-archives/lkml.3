Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab3L0AvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:51:09 -0500
Received: from mail-ob0-f202.google.com ([209.85.214.202]:57300 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab3L0AvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:51:08 -0500
From: Andrew Bresticker <abrestic@chromium.org>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 7/7] clk: tegra: use max divider if divider overflows
Date: Thu, 26 Dec 2013 16:44:27 -0800
Message-Id: <1388105067-24438-8-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 1.8.5.1
In-Reply-To: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
References: <1388105067-24438-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When requesting a rate less than the minimum clock rate for a divider,
use the maximum divider value instead of bailing out with an error.
This matches the behavior of the generic clock divider.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/clk/tegra/clk-divider.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/tegra/clk-divider.c b/drivers/clk/tegra/clk-divider.c
index 4d75b1f..290f9c1 100644
--- a/drivers/clk/tegra/clk-divider.c
+++ b/drivers/clk/tegra/clk-divider.c
@@ -59,7 +59,7 @@ static int get_div(struct tegra_clk_frac_div *divider, unsigned long rate,
 		return 0;
 
 	if (divider_ux1 > get_max_div(divider))
-		return -EINVAL;
+		return get_max_div(divider);
 
 	return divider_ux1;
 }
-- 
1.8.5.1

