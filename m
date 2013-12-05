Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496Ab3LERis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:38:48 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38491 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991Ab3LERiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:38:24 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tom Gundersen <teg@jklm.no>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 89/90] Input: i8042 - add PNP modaliases
Date: Thu,  5 Dec 2013 17:36:11 +0000
Message-Id: <1386264972-5399-90-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
References: <1386264972-5399-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Gundersen <teg@jklm.no>

commit 78551277e4df57864b0b0e7f85c23ede2be2edb8 upstream.

This allows the module to be autoloaded in the common case.

In order to work on non-PnP systems the module should be compiled in or
loaded unconditionally at boot (c.f. modules-load.d(5)), as before.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/input/serio/i8042-x86ia64io.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index 5f306f7..0ec9abb 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -765,6 +765,7 @@ static struct pnp_device_id pnp_kbd_devids[] = {
 	{ .id = "CPQA0D7", .driver_data = 0 },
 	{ .id = "", },
 };
+MODULE_DEVICE_TABLE(pnp, pnp_kbd_devids);
 
 static struct pnp_driver i8042_pnp_kbd_driver = {
 	.name           = "i8042 kbd",
@@ -786,6 +787,7 @@ static struct pnp_device_id pnp_aux_devids[] = {
 	{ .id = "SYN0801", .driver_data = 0 },
 	{ .id = "", },
 };
+MODULE_DEVICE_TABLE(pnp, pnp_aux_devids);
 
 static struct pnp_driver i8042_pnp_aux_driver = {
 	.name           = "i8042 aux",
-- 
1.8.3.2

