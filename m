Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759938Ab3LBV0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:26:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38323 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3LBTHR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:07:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tom Gundersen <teg@jklm.no>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 3.4 54/60] Input: i8042 - add PNP modaliases
Date: Mon,  2 Dec 2013 11:06:35 -0800
Message-Id: <20131202190342.103916229@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tom Gundersen <teg@jklm.no>

commit 78551277e4df57864b0b0e7f85c23ede2be2edb8 upstream.

This allows the module to be autoloaded in the common case.

In order to work on non-PnP systems the module should be compiled in or
loaded unconditionally at boot (c.f. modules-load.d(5)), as before.

Signed-off-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -765,6 +765,7 @@ static struct pnp_device_id pnp_kbd_devi
 	{ .id = "CPQA0D7", .driver_data = 0 },
 	{ .id = "", },
 };
+MODULE_DEVICE_TABLE(pnp, pnp_kbd_devids);
 
 static struct pnp_driver i8042_pnp_kbd_driver = {
 	.name           = "i8042 kbd",
@@ -786,6 +787,7 @@ static struct pnp_device_id pnp_aux_devi
 	{ .id = "SYN0801", .driver_data = 0 },
 	{ .id = "", },
 };
+MODULE_DEVICE_TABLE(pnp, pnp_aux_devids);
 
 static struct pnp_driver i8042_pnp_aux_driver = {
 	.name           = "i8042 aux",


