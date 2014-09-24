Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbaIXK0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 06:26:51 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:36149 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753820AbaIXK0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 06:26:49 -0400
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH] tty: Fix width of unsigned long bitfield padding
Date: Wed, 24 Sep 2014 06:26:21 -0400
Message-Id: <1411554381-1097-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <54227c9a.lXFXllIgMyBnEIGZ%fengguang.wu@intel.com>
References: <54227c9a.lXFXllIgMyBnEIGZ%fengguang.wu@intel.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c545b66c6922b002b5fe224a6eaec58c913650b5,
'tty: Serialize tcflow() with other tty flow control changes' and
commit 99416322dd16b810ba74098cc50ef2a844091d35,
'tty: Workaround Alpha non-atomic byte storage in tty_struct' work around
compiler bugs and non-atomic storage on multiple arches by padding
bitfields out to the declared type which is unsigned long. However, the
width varies by arch.

Pad bitfields to actual width of unsigned long (which is BITS_PER_LONG).

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 include/linux/tty.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/tty.h b/include/linux/tty.h
index 7a0a796..6b6a449 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -264,11 +264,11 @@ struct tty_struct {
 	struct winsize winsize;		/* winsize_mutex */
 	unsigned long stopped:1,	/* flow_lock */
 		      flow_stopped:1,
-		      unused:62;
+		      unused:BITS_PER_LONG - 2;
 	int hw_stopped;
 	unsigned long ctrl_status:8,	/* ctrl_lock */
 		      packet:1,
-		      unused_ctrl:55;
+		      unused_ctrl:BITS_PER_LONG - 9;
 	unsigned int receive_room;	/* Bytes free for queue */
 	int flow_change;
 
-- 
2.1.0

