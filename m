Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757597Ab3DXDZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 23:25:59 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:59903 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757402Ab3DXDZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 23:25:57 -0400
From: Chao Xie <chao.xie@marvell.com>
To: <linux-kernel@vger.kernel.org>, <linux-input@vger.kernel.org>,
        <dmitry.torokhov@gmail.com>, <haojian.zhuang@gmail.com>,
        <xiechao.mail@gmail.com>
CC: Chao Xie <chao.xie@marvell.com>
Subject: [PATCH 4/6] arm: mmp: use matrix_keymap for teton_bga
Date: Tue, 23 Apr 2013 23:20:31 -0400
Message-ID: <1366773633-7727-5-git-send-email-chao.xie@marvell.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
References: <1366773633-7727-1-git-send-email-chao.xie@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chao Xie <chao.xie@marvell.com>
---
 arch/arm/mach-mmp/teton_bga.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-mmp/teton_bga.c b/arch/arm/mach-mmp/teton_bga.c
index 8609967..d8967fa 100644
--- a/arch/arm/mach-mmp/teton_bga.c
+++ b/arch/arm/mach-mmp/teton_bga.c
@@ -56,11 +56,15 @@ static unsigned int teton_bga_matrix_key_map[] = {
 	KEY(1, 7, KEY_RIGHT),
 };
 
+static struct matrix_keymap_data teton_bga_matrix_keymap_data = {
+	.keymap			= teton_bga_matrix_key_map,
+	.keymap_size		= ARRAY_SIZE(teton_bga_matrix_key_map),
+};
+
 static struct pxa27x_keypad_platform_data teton_bga_keypad_info __initdata = {
 	.matrix_key_rows        = 2,
 	.matrix_key_cols        = 8,
-	.matrix_key_map         = teton_bga_matrix_key_map,
-	.matrix_key_map_size    = ARRAY_SIZE(teton_bga_matrix_key_map),
+	.matrix_keymap_data	= &teton_bga_matrix_keymap_data,
 	.debounce_interval      = 30,
 };
 
-- 
1.7.4.1

