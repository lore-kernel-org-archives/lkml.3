Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaHIXoK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 19:44:10 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:58181 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaHIXoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 19:44:08 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: ti-st: st_kim.c:  Cleaning up missing null-terminate after strncpy call
Date: Sun, 10 Aug 2014 01:45:38 +0200
Message-Id: <1407627938-24614-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
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
index 9d3dbb2..bce4468 100644
--- a/drivers/misc/ti-st/st_kim.c
+++ b/drivers/misc/ti-st/st_kim.c
@@ -593,6 +593,7 @@ static ssize_t store_dev_name(struct device *dev,
 	struct kim_data_s *kim_data = dev_get_drvdata(dev);
 	pr_debug("storing dev name >%s<", buf);
 	strncpy(kim_data->dev_name, buf, count);
+	kim_data->dev_name[count - 1] = '\n';
 	pr_debug("stored dev name >%s<", kim_data->dev_name);
 	return count;
 }
-- 
1.7.10.4

