Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbaF1Vd3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 17:33:29 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35133 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbaF1Vd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 17:33:28 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: ab8500-debugfs.c:  Cleaning up unnecessary to test, unsigned can't be negative.
Date: Sat, 28 Jun 2014 23:34:38 +0200
Message-Id: <1403991279-7109-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unsigned variable can't be negative so it is unnecessary to test it

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/mfd/ab8500-debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index d1a22aa..0793a10 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -2504,7 +2504,7 @@ static ssize_t ab8500_gpadc_trig_timer_write(struct file *file,
 	if (err)
 		return err;
 
-	if ((user_trig_timer >= 0) && (user_trig_timer <= 255)) {
+	if (user_trig_timer <= 255) {
 		trig_timer = (u8) user_trig_timer;
 	} else {
 		dev_err(dev, "debugfs error input: "
-- 
1.7.10.4

