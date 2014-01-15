Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaAOV5Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:57:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40937 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbaAOV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:14 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 135/166] drm/nouveau/bios: make jump conditional
Date: Wed, 15 Jan 2014 13:52:29 -0800
Message-Id: <1389822780-4729-136-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 6d60792ec059d9f2139828f9f017679abb81aa73 upstream.

This fixes a hang in VBIOS scripts of the form "condition; jump".
The jump used to always be executed, while now it will only be
executed if the condition is true.

See https://bugs.freedesktop.org/show_bug.cgi?id=72943

Reported-by: Darcy Brás da Silva <dardevelin@cidadecool.com>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
index ad6662c..9e0cb43 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
@@ -1262,7 +1262,11 @@ init_jump(struct nvbios_init *init)
 	u16 offset = nv_ro16(bios, init->offset + 1);
 
 	trace("JUMP\t0x%04x\n", offset);
-	init->offset = offset;
+
+	if (init_exec(init))
+		init->offset = offset;
+	else
+		init->offset += 3;
 }
 
 /**
-- 
1.8.3.2

