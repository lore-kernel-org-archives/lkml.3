Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaEXO2O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 10:28:14 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:48873 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaEXO2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 10:28:13 -0400
Date: Sat, 24 May 2014 10:28:07 -0400
From: Niv Yehezkel <executerx@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: Brian Swetland <swetland@google.com>
Subject: [PATCH] staging: android: describe use of memory barrier on sync.c
Message-ID: <20140524142807.GA17881@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added comments describing the purpose of using write memory
barrier in the context of sync_timeline_destory.

Signed-off-by: Niv Yehezkel <executerx@gmail.com>
---
 drivers/staging/android/sync.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/android/sync.c b/drivers/staging/android/sync.c
index 1f88c5d..18174f7 100644
--- a/drivers/staging/android/sync.c
+++ b/drivers/staging/android/sync.c
@@ -92,6 +92,10 @@ static void sync_timeline_free(struct kref *kref)
 void sync_timeline_destroy(struct sync_timeline *obj)
 {
 	obj->destroyed = true;
+	/*
+	 * Ensure timeline is marked as destroyed before
+	 * changing timeline's fences status.
+	 */
 	smp_wmb();
 
 	/*
-- 
1.7.10.4

