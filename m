Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758173Ab3APQww (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 11:52:52 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:46953 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757984Ab3APQwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:52:45 -0500
Date: Wed, 16 Jan 2013 17:52:40 +0100
From: Cong Ding <dinggnu@gmail.com>
To: Gleb Natapov <gleb@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        Asias He <asias.hejun@gmail.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] kvm tools: remove redundant "if" condition
Message-ID: <20130116165239.GB18593@gmail.com>
References: <1358298456-18377-1-git-send-email-dinggnu@gmail.com>
 <20130116113522.GR11529@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116113522.GR11529@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

