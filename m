Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab3BUUQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:16:46 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:61941 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740Ab3BUUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:15:13 -0500
From: Benson Leung <bleung@chromium.org>
To: matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: olofj@chromium.org, miletus@chromium.org,
        Benson Leung <bleung@chromium.org>
Subject: [PATCH 1/6] Platform: x86: chromeos_laptop - add i915 gmbuses to adapter names
Date: Thu, 21 Feb 2013 12:14:55 -0800
Message-Id: <1361477700-26342-2-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1361477700-26342-1-git-send-email-bleung@chromium.org>
References: <1361477700-26342-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the two other i2c buses (vga and panel) from i915.
Chromebook Pixel has input and light sensor devices on these busses.

Signed-off-by: Benson Leung <bleung@chromium.org>
---
 drivers/platform/x86/chromeos_laptop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/platform/x86/chromeos_laptop.c b/drivers/platform/x86/chromeos_laptop.c
index bc6599c..d223592 100644
--- a/drivers/platform/x86/chromeos_laptop.c
+++ b/drivers/platform/x86/chromeos_laptop.c
@@ -34,11 +34,15 @@ static struct i2c_client *tp;
 
 const char *i2c_adapter_names[] = {
 	"SMBus I801 adapter",
+	"i915 gmbus vga",
+	"i915 gmbus panel",
 };
 
 /* Keep this enum consistent with i2c_adapter_names */
 enum i2c_adapter_type {
 	I2C_ADAPTER_SMBUS = 0,
+	I2C_ADAPTER_VGADDC,
+	I2C_ADAPTER_PANEL,
 };
 
 static struct i2c_board_info __initdata cyapa_device = {
-- 
1.8.1.3

