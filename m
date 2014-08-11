Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaHKUGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 16:06:01 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37671 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641AbaHKUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 16:05:59 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2] misc: ti-st: st_kim.c:  Cleaning up missing null-terminate after strncpy call
Date: Mon, 11 Aug 2014 22:07:30 +0200
Message-Id: <1407787650-32102-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added a guaranteed null-terminate after call to strncpy.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/misc/ti-st/st_kim.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/ti-st/st_kim.c b/drivers/misc/ti-st/st_kim.c
index 9d3dbb2..d050f53 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -593,6 +593,7 @@ static ssize_t store_dev_name(struct device *dev,
 	struct kim_data_s *kim_data = dev_get_drvdata(dev);
 	pr_debug("storing dev name >%s<", buf);
 	strncpy(kim_data->dev_name, buf, count);
+	kim_data->dev_name[count - 1] = '\0';
 	pr_debug("stored dev name >%s<", kim_data->dev_name);
 	return count;
 }
-- 
1.7.10.4

