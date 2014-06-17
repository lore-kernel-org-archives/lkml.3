Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaFQGyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 02:54:47 -0400
Received: from mx02.posteo.de ([89.146.194.165]:58242 "EHLO posteo.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127AbaFQGyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 02:54:45 -0400
From: Martin Kepplinger <martink@posteo.de>
To: rientjes@google.com
Cc: drbd-dev@lists.linbit.com, drbd-user@lists.linbit.com,
        linux-kernel@vger.kernel.org, Martin Kepplinger <martink@posteo.de>
Subject: [PATCH v2] drbd: change one-bit bitfield to be an unsigned int
Date: Tue, 17 Jun 2014 08:54:07 +0200
Message-Id: <1402988047-16364-1-git-send-email-martink@posteo.de>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <alpine.DEB.2.02.1406160225510.30205@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1406160225510.30205@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The one-bit bitfields are assigned true (1) or false (0) and checked
for them respectively. While it should work either way and -1 is true
as well it is more clear to see what's going on when using an unsigned int
because 1 doesn't silently become -1 behind the label true.

Signed-off-by: Martin Kepplinger <martink@posteo.de>
---
Thanks for looking at it. This is more of a question: Does this make sense
to you now? I can be mistaken. It just wasn't totally clear to me at first
sight and even though it should be, why not try to improve it.

sparse called it 'dubious' before the change.

(built but untested)

 drivers/block/drbd/drbd_interval.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_interval.h b/drivers/block/drbd/drbd_interval.h
index f38fcb0..8d670e6 100644
--- a/drivers/block/drbd/drbd_interval.h
+++ b/drivers/block/drbd/drbd_interval.h
@@ -9,8 +9,8 @@ struct drbd_interval {
 	sector_t sector;	/* start sector of the interval */
 	unsigned int size;	/* size in bytes */
 	sector_t end;		/* highest interval end in subtree */
-	int local:1		/* local or remote request? */;
-	int waiting:1;
+	unsigned int local:1;	/* local or remote request? */
+	unsigned int waiting:1;
 };
 
 static inline void drbd_clear_interval(struct drbd_interval *i)
-- 
1.7.10.4

