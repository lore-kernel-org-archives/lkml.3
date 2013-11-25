Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab3KYVRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 16:17:06 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55906 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab3KYVRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 16:17:02 -0500
From: Olof Johansson <olof@lixom.net>
To: linux-kernel@vger.kernel.org
Cc: Olof Johansson <olof@lixom.net>, Benson Leung <bleung@chromium.org>
Subject: [PATCH] platform/chrome: Make i2c_adapter_names static
Date: Mon, 25 Nov 2013 13:14:33 -0800
Message-Id: <1385414073-24074-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.4.1.601.g02b3b1d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not used outside of the file, so declaration should be static. Picked up by
sparse:

drivers/platform/chrome/chromeos_laptop.c:44:12: warning: symbol
    'i2c_adapter_names' was not declared. Should it be static?

Signed-off-by: Olof Johansson <olof@lixom.net>
Cc: Benson Leung <bleung@chromium.org>
---
 drivers/platform/chrome/chromeos_laptop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/chromeos_laptop.c b/drivers/platform/chrome/chromeos_laptop.c
index 1c2747f119d1..446ef0f9c256 100644
--- a/drivers/platform/chrome/chromeos_laptop.c
+++ b/drivers/platform/chrome/chromeos_laptop.c
@@ -41,7 +41,7 @@ static struct i2c_client *als;
 static struct i2c_client *tp;
 static struct i2c_client *ts;
 
-const char *i2c_adapter_names[] = {
+static const char *i2c_adapter_names[] = {
 	"SMBus I801 adapter",
 	"i915 gmbus vga",
 	"i915 gmbus panel",
-- 
1.8.4.1.601.g02b3b1d

