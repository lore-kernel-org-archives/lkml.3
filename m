Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224Ab3JKTrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:47:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46543 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759102Ab3JKTmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:42:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 118/135] drm/nouveau/bios/init: stub opcode 0xaa
Date: Fri, 11 Oct 2013 12:39:59 -0700
Message-Id: <20131011193958.107933140@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 5495e39fb3695182b9f2a72fe4169056cada37a1 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
@@ -579,8 +579,22 @@ static void
 init_reserved(struct nvbios_init *init)
 {
 	u8 opcode = nv_ro08(init->bios, init->offset);
-	trace("RESERVED\t0x%02x\n", opcode);
-	init->offset += 1;
+	u8 length, i;
+
+	switch (opcode) {
+	case 0xaa:
+		length = 4;
+		break;
+	default:
+		length = 1;
+		break;
+	}
+
+	trace("RESERVED 0x%02x\t", opcode);
+	for (i = 1; i < length; i++)
+		cont(" 0x%02x", nv_ro08(init->bios, init->offset + i));
+	cont("\n");
+	init->offset += length;
 }
 
 /**
@@ -2135,6 +2149,7 @@ static struct nvbios_init_opcode {
 	[0x99] = { init_zm_auxch },
 	[0x9a] = { init_i2c_long_if },
 	[0xa9] = { init_gpio_ne },
+	[0xaa] = { init_reserved },
 };
 
 #define init_opcode_nr (sizeof(init_opcode) / sizeof(init_opcode[0]))


