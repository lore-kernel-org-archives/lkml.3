Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab3APBID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 20:08:03 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:37151 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356Ab3APBH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 20:07:59 -0500
From: Cong Ding <dinggnu@gmail.com>
To: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Cong Ding <dinggnu@gmail.com>
Subject: [PATCH] kvm: remove redundant "if" condition
Date: Wed, 16 Jan 2013 02:07:36 +0100
Message-Id: <1358298456-18377-2-git-send-email-dinggnu@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
References: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After we check (state.kcount != 0), state.kcount has to be 0 in all the "else"
branchs.

Signed-off-by: Cong Ding <dinggnu@gmail.com>
---
 tools/kvm/hw/i8042.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/kvm/hw/i8042.c b/tools/kvm/hw/i8042.c
index 9f8be6a..9035732 100644
--- a/tools/kvm/hw/i8042.c
+++ b/tools/kvm/hw/i8042.c
@@ -189,7 +189,7 @@ static u32 kbd_read_data(void)
 		state.mcount--;
 		kvm__irq_line(state.kvm, AUX_IRQ, 0);
 		kbd_update_irq();
-	} else if (state.kcount == 0) {
+	} else {
 		i = state.kread - 1;
 		if (i < 0)
 			i = QUEUE_SIZE;
-- 
1.7.10.4

