Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030329AbaGRNJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:09:47 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17455 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761778AbaGRNJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:09:45 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>,
        Felipe Balbi <balbi@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 115/170] tools: ffs-test: fix header values endianess
Date: Fri, 18 Jul 2014 14:12:00 +0200
Message-Id: <2783cdeacf558b5a7d479643c7e42af161660e9c.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <mina86@mina86.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f35f71244da6e51db4e1f2c7e318581f498ececf upstream.

It appears that no one ever run ffs-test on a big-endian machine,
since it used cpu-endianess for fs_count and hs_count fields which
should be in little-endian format.  Fix by wrapping the numbers in
cpu_to_le32.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 tools/usb/ffs-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index fe1e66b6ef40..a87e99f37c52 100644
--- a/tools/usb/ffs-test.c
+++ b/tools/usb/ffs-test.c
@@ -116,8 +116,8 @@ static const struct {
 	.header = {
 		.magic = cpu_to_le32(FUNCTIONFS_DESCRIPTORS_MAGIC),
 		.length = cpu_to_le32(sizeof descriptors),
-		.fs_count = 3,
-		.hs_count = 3,
+		.fs_count = cpu_to_le32(3),
+		.hs_count = cpu_to_le32(3),
 	},
 	.fs_descs = {
 		.intf = {
-- 
2.0.0

