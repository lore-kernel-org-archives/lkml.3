Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756210Ab3DPIzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 04:55:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab3DPIyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 04:54:49 -0400
From: Michal Marek <mmarek@suse.cz>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Simon Glass <sjg@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] input: Export matrix_keypad_parse_of_params()
Date: Tue, 16 Apr 2013 10:50:54 +0200
Message-Id: <1366102254-12440-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of input drivers depend on this symbol:

ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/tca8418_keypad.ko] undefined!
ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/cros_ec_keyb.ko] undefined!

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 drivers/input/matrix-keymap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/matrix-keymap.c b/drivers/input/matrix-keymap.c
index 619b382..08b61f5 100644
--- a/drivers/input/matrix-keymap.c
+++ b/drivers/input/matrix-keymap.c
@@ -68,6 +68,7 @@ int matrix_keypad_parse_of_params(struct device *dev,
 
 	return 0;
 }
+EXPORT_SYMBOL_GPL(matrix_keypad_parse_of_params);
 
 static int matrix_keypad_parse_of_keymap(const char *propname,
 					 unsigned int rows, unsigned int cols,
-- 
1.8.2.1

