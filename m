Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042AbaKRO5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:57:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57147 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbaKROJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:49 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 096/206] drm/nouveau/bios: memset dcb struct to zero before parsing
Date: Tue, 18 Nov 2014 15:07:31 +0100
Message-Id: <5a14c978fed450baabf93cec388743b1de8b4b41.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Skeggs <bskeggs@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 595d373f1e9c9ce0fc946457fdb488e8a58972cd upstream.

Fixes type/mask calculation being based on uninitialised data for VGA
outputs.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c b/drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c
index 2d9b9d7a7992..f3edd2841f2d 100644
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
2.1.3

