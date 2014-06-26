Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbaFZNiw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 09:38:52 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:36230 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261AbaFZNiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 09:38:50 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Linus Walleij <linus.walleij@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mfd: ab8500-debugfs.c:  Cleaning up values that are never used
Date: Thu, 26 Jun 2014 15:40:00 +0200
Message-Id: <1403790000-11334-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove variable that are never used

This was found using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/mfd/ab8500-debugfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/ab8500-debugfs.c b/drivers/mfd/ab8500-debugfs.c
index d1a22aa..d514e36 100644
--- a/drivers/mfd/ab8500-debugfs.c
+++ b/drivers/mfd/ab8500-debugfs.c
@@ -1350,12 +1350,11 @@ static int ab8500_print_all_banks(struct seq_file *s, void *p)
 {
 	struct device *dev = s->private;
 	unsigned int i;
-	int err;
 
 	seq_printf(s, AB8500_NAME_STRING " register values:\n");
 
 	for (i = 0; i < AB8500_NUM_BANKS; i++) {
-		err = seq_printf(s, " bank 0x%02X:\n", i);
+		seq_printf(s, " bank 0x%02X:\n", i);
 
 		ab8500_registers_print(dev, i, s);
 	}
-- 
1.7.10.4

