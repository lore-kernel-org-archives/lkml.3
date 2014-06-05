Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752996AbaFEEVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:21:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44094 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaFEEVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:21:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Qiang Huang <h.huangqiang@huawei.com>
Subject: [PATCH 3.4 115/214] regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel
Date: Wed,  4 Jun 2014 21:17:58 -0700
Message-Id: <20140605041655.141607224@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit e8d9897ff064b1683c11c15ea1296a67a45d77b0 upstream.

commit 81d0a6ae7befb24c06f4aa4856af7f8d1f612171 upstream.

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
[bwh: Backported to 3.2: delay is done by driver, not returned to the caller]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Qiang Huang <h.huangqiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -492,7 +492,7 @@ buck2_exit:
 
 	difference = desc->min + desc->step*i - previous_vol/1000;
 	if (difference > 0)
-		udelay(difference / ((val & 0x0f) + 1));
+		udelay(DIV_ROUND_UP(difference, (val & 0x0f) + 1));
 
 	return ret;
 }


