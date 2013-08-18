Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab3HRMnj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 08:43:39 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:56213 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3HRMni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 08:43:38 -0400
Message-ID: <1376829813.3391.7.camel@phoenix>
Subject: [PATCH] Documentation: pinctrl: Fix example code for
 pinctrl_register
From: Axel Lin <axel.lin@ingics.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 18 Aug 2013 20:43:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pinctrl_register() returns NULL on error, fix it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 Documentation/pinctrl.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/pinctrl.txt b/Documentation/pinctrl.txt
index e7bee9b..c0ffd30 100644
--- a/Documentation/pinctrl.txt
+++ b/Documentation/pinctrl.txt
@@ -81,7 +81,7 @@ int __init foo_probe(void)
 	struct pinctrl_dev *pctl;
 
 	pctl = pinctrl_register(&foo_desc, <PARENT>, NULL);
-	if (IS_ERR(pctl))
+	if (!pctl)
 		pr_err("could not register foo pin driver\n");
 }
 
-- 
1.8.1.2



