Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaFFJNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:13:23 -0400
Received: from mail-la0-f74.google.com ([209.85.215.74]:48135 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbaFFJNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:13:01 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Felipe Balbi <balbi@ti.com>, Krzysztof Opasiak <k.opasiak@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 2/5] tools: ffs-test: fix header values endianess
Date: Fri,  6 Jun 2014 11:12:53 +0200
Message-Id: <1402045976-26580-2-git-send-email-mina86@mina86.com>
X-Mailer: git-send-email 2.0.0.526.g5318336
In-Reply-To: <1402045976-26580-1-git-send-email-mina86@mina86.com>
References: <1402045976-26580-1-git-send-email-mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears that no one ever run ffs-test on a big-endian machine,
since it used cpu-endianess for fs_count and hs_count fields which
should be in little-endian format.  Fix by wrapping the numbers in
cpu_to_le32.

Cc: stable@vger.kernel.org
Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 tools/usb/ffs-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/usb/ffs-test.c b/tools/usb/ffs-test.c
index fe1e66b..a87e99f 100644
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
2.0.0.526.g5318336

