Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab3BCOzi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:55:38 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34195 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753462Ab3BCOze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:55:34 -0500
Message-Id: <20130203144646.792953565@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 031/128] regulator: max8998: Ensure enough delay time for
 max8998_set_voltage_buck_time_sel
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 81d0a6ae7befb24c06f4aa4856af7f8d1f612171 upstream.

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
[bwh: Backported to 3.2: delay is done by driver, not returned to the caller]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -497,7 +497,7 @@ buck2_exit:
 
 	difference = desc->min + desc->step*i - previous_vol/1000;
 	if (difference > 0)
-		udelay(difference / ((val & 0x0f) + 1));
+		udelay(DIV_ROUND_UP(difference, (val & 0x0f) + 1));
 
 	return ret;
 }


