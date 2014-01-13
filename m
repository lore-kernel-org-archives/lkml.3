Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaAMQJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:09:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53842 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754685AbaAMQFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:36 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilia Mirkin <imirkin@alum.mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 203/208] drm/nouveau/bios: make jump conditional
Date: Mon, 13 Jan 2014 16:00:44 +0000
Message-Id: <1389628849-1614-204-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit 6d60792ec059d9f2139828f9f017679abb81aa73 upstream.

This fixes a hang in VBIOS scripts of the form "condition; jump".
The jump used to always be executed, while now it will only be
executed if the condition is true.

See https://bugs.freedesktop.org/show_bug.cgi?id=72943

Reported-by: Darcy Brás da Silva <dardevelin@cidadecool.com>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/gpu/drm/nouveau/core/subdev/bios/init.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
index 8f06cca..892070a 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/bios/init.c
@@ -1294,7 +1294,11 @@ init_jump(struct nvbios_init *init)
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

