Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab3AOWfU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:35:20 -0500
Received: from mail.kernel.org ([198.145.19.201]:43437 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756520Ab3AOWfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:35:14 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@ingics.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 183/221] regulator: max8998: Ensure enough delay time for max8998_set_voltage_buck_time_sel
Date: Tue, 15 Jan 2013 10:51:50 -0800
Message-Id: <20130115185011.219262776@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit 81d0a6ae7befb24c06f4aa4856af7f8d1f612171 upstream.

Use DIV_ROUND_UP to prevent truncation by integer division issue.
This ensures we return enough delay time.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -447,7 +447,7 @@ static int max8998_set_voltage_buck_time
 
 	difference = (new_selector - old_selector) * desc->step / 1000;
 	if (difference > 0)
-		return difference / ((val & 0x0f) + 1);
+		return DIV_ROUND_UP(difference, (val & 0x0f) + 1);
 
 	return 0;
 }


