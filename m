Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaGHALF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 20:11:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaGHADV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 20:03:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.4 25/44] tools: ffs-test: fix header values endianess
Date: Mon,  7 Jul 2014 17:07:15 -0700
Message-Id: <20140707235859.399781859@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140707235858.652771077@linuxfoundation.org>
References: <20140707235858.652771077@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Nazarewicz <mina86@mina86.com>

commit f35f71244da6e51db4e1f2c7e318581f498ececf upstream.

It appears that no one ever run ffs-test on a big-endian machine,
since it used cpu-endianess for fs_count and hs_count fields which
should be in little-endian format.  Fix by wrapping the numbers in
cpu_to_le32.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/usb/ffs-test.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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


