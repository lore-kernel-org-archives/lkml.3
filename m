Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3FDXO6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:14:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35415 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752923Ab3FDWmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:16 -0400
Message-Id: <20130604172133.455994743@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:46 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Malcolm Priestley <tvboxspy@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 076/184] staging: vt6656: [BUG] out of bound array reference
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 in RFbSetPower.

From: Malcolm Priestley <tvboxspy@gmail.com>

commit ab1dd9963137a1e122004d5378a581bf16ae9bc8 upstream.

Calling RFbSetPower with uCH zero value will cause out of bound array reference.

This causes 64 bit kernels to oops on boot.

Note: Driver does not function on 64 bit kernels and should be
blacklisted on them.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/staging/vt6656/rf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/staging/vt6656/rf.c b/drivers/staging/vt6656/rf.c
index 405c4f7..9d059de 100644
--- a/drivers/staging/vt6656/rf.c
+++ b/drivers/staging/vt6656/rf.c
@@ -769,6 +769,9 @@ BYTE    byPwr = pDevice->byCCKPwr;
         return TRUE;
     }
 
+	if (uCH == 0)
+		return -EINVAL;
+
     switch (uRATE) {
     case RATE_1M:
     case RATE_2M:
-- 
1.7.12.2.21.g234cd45.dirty



