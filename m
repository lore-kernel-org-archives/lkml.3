Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab3K0BAB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758757Ab3K0A7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:25 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Tseng <rogerable@realtek.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.12 081/116] drivers/memstick/core/ms_block.c: fix unreachable state in h_msb_read_page()
Date: Tue, 26 Nov 2013 16:57:34 -0800
Message-Id: <20131127005742.516174916@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Tseng <rogerable@realtek.com>

commit a0e5a12fd18d47aa87a7a8c60ca5bc422b136564 upstream.

In h_msb_read_page() in ms_block.c, flow never reaches case
MSB_RP_RECIVE_STATUS_REG.  This causes error when MEMSTICK_INT_ERR is
encountered and status error bits are going to be examined, but the status
will never be copied back.

Fix it by transitioning to MSB_RP_RECIVE_STATUS_REG right after
MSB_RP_SEND_READ_STATUS_REG.

Signed-off-by: Roger Tseng <rogerable@realtek.com>
Acked-by: Maxim Levitsky <maximlevitsky@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memstick/core/ms_block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/memstick/core/ms_block.c
+++ b/drivers/memstick/core/ms_block.c
@@ -401,7 +401,7 @@ again:
 			sizeof(struct ms_status_register)))
 			return 0;
 
-		msb->state = MSB_RP_RECEIVE_OOB_READ;
+		msb->state = MSB_RP_RECIVE_STATUS_REG;
 		return 0;
 
 	case MSB_RP_RECIVE_STATUS_REG:


