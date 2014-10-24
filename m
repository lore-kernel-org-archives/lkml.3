Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbaJXVe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 17:34:27 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:52236 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbaJXVeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 17:34:25 -0400
Date: Fri, 24 Oct 2014 14:34:18 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: linux-input@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: opencores-kbd - fix error hanling
Message-ID: <20141024213418.GA13553@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I was adjusting patch in 848d479361793edb79aa68140cb64d4ec9032d88 to
use devm_ioremap_resource() I messed it up.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/input/keyboard/opencores-kbd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/keyboard/opencores-kbd.c b/drivers/input/keyboard/opencores-kbd.c
index 62abe2c..f8502bb 100644
--- a/drivers/input/keyboard/opencores-kbd.c
+++ b/drivers/input/keyboard/opencores-kbd.c
@@ -70,7 +70,7 @@ static int opencores_kbd_probe(struct platform_device *pdev)
 
 	opencores_kbd->addr = devm_ioremap_resource(&pdev->dev, res);
 	if (IS_ERR(opencores_kbd->addr))
-		error = PTR_ERR(opencores_kbd->addr);
+		return PTR_ERR(opencores_kbd->addr);
 
 	input->name = pdev->name;
 	input->phys = "opencores-kbd/input0";
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
