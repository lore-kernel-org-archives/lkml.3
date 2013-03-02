Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752353Ab3CBNhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 08:37:36 -0500
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:60955 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3CBNhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 08:37:35 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH mmotm] ipc: find_msg can be static
Date: Sat,  2 Mar 2013 08:37:02 -0500
Message-Id: <1362231422-5192-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <20130302130742.GA13966@localhost>
References: <20130302130742.GA13966@localhost>
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fengguang Wu <fengguang.wu@intel.com>

Fixes sparse warning identified by Fengguang's test robot:
   ipc/msg.c:810:16: sparse: symbol 'find_msg' was not declared. Should it be static?

CC: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Reported-by: Fengguang Wu <fengguang.wu@intel.com>
---
 msg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index daeca13..309583c 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -807,7 +807,7 @@ static inline void free_copy(struct msg_msg *copy)
 }
 #endif
 
-struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
+static struct msg_msg *find_msg(struct msg_queue *msq, long *msgtyp, int mode)
 {
 	struct msg_msg *msg;
 	long count = 0;
