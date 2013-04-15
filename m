Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab3DOMHg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:07:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35036 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab3DOMHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:07:35 -0400
From: Michal Marek <mmarek@suse.cz>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Simon Glass <sjg@chromium.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] input: Export matrix_keypad_parse_of_params()
Date: Mon, 15 Apr 2013 14:06:48 +0200
Message-Id: <1366027608-17395-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of input drivers depend on this symbol:

ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/tca8418_keypad.ko] undefined!
ERROR: "matrix_keypad_parse_of_params" [drivers/input/keyboard/cros_ec_keyb.ko] undefined!

Reported-by: Randy Dunlap <rdunlap@infradead.org>
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

