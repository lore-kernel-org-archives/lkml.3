Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3JCEUc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:20:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756243Ab3JCEUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:20:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 08/57] bcache: Fix a dumb CPU spinning bug in writeback
Date: Wed,  2 Oct 2013 21:08:34 -0700
Message-Id: <20131003040637.175658911@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20131003040636.600441214@linuxfoundation.org>
References: <20131003040636.600441214@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 79e3dab90d9f826ceca67c7890e048ac9169de49 upstream.

schedule_timeout() != schedule_timeout_uninterruptible()

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/writeback.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -397,8 +397,7 @@ static void read_dirty(struct closure *c
 		if (delay > 0 &&
 		    (KEY_START(&w->key) != dc->last_read ||
 		     jiffies_to_msecs(delay) > 50))
-			while (delay)
-				delay = schedule_timeout(delay);
+			delay = schedule_timeout_uninterruptible(delay);
 
 		dc->last_read	= KEY_OFFSET(&w->key);
 


