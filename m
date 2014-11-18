Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaKRPGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:06:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57041 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754967AbaKROJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:39 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 085/206] drm/cirrus: bind also to qemu-xen-traditional
Date: Tue, 18 Nov 2014 15:07:20 +0100
Message-Id: <579cd3110d9192bcb86b472c50253b90eb0571a9.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c0c3e735fa7bae29c6623511127fd021b2d6d849 upstream.

qemu as used by xend/xm toolstack uses a different subvendor id.
Bind the drm driver also to this emulated card.

Signed-off-by: Olaf Hering <olaf@aepfle.de>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/cirrus/cirrus_drv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/cirrus/cirrus_drv.c b/drivers/gpu/drm/cirrus/cirrus_drv.c
index bfcfd0c202ad..73fed3518581 100644
--- a/drivers/gpu/drm/cirrus/cirrus_drv.c
+++ b/drivers/gpu/drm/cirrus/cirrus_drv.c
@@ -32,6 +32,8 @@ static struct drm_driver driver;
 static DEFINE_PCI_DEVICE_TABLE(pciidlist) = {
 	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, 0x1af4, 0x1100, 0,
 	  0, 0 },
+	{ PCI_VENDOR_ID_CIRRUS, PCI_DEVICE_ID_CIRRUS_5446, PCI_VENDOR_ID_XEN,
+	  0x0001, 0, 0, 0 },
 	{0,}
 };
 
-- 
2.1.3

