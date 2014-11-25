Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbaKYKlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:41:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58244 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbaKYKk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Skeggs <bskeggs@redhat.com>, Sven Joachim <svenjoac@gmx.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 056/254] drm/nouveau/bios: memset dcb struct to zero before parsing
Date: Tue, 25 Nov 2014 10:36:46 +0000
Message-Id: <1416912004-5928-57-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 595d373f1e9c9ce0fc946457fdb488e8a58972cd upstream.

Fixes type/mask calculation being based on uninitialised data for VGA
outputs.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Sven Joachim <svenjoac@gmx.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c b/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c
index 88606bfaf847..bd8d348385b3 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c
@@ -124,6 +124,7 @@ dcb_outp_parse(struct nouveau_bios *bios, u8 idx, u8 *ver, u8 *len,
 	       struct dcb_output *outp)
 {
 	u16 dcb = dcb_outp(bios, idx, ver, len);
+	memset(outp, 0x00, sizeof(*outp));
 	if (dcb) {
 		if (*ver >= 0x20) {
 			u32 conn = nv_ro32(bios, dcb + 0x00);
-- 
2.1.0

