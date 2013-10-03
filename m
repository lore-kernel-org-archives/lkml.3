Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3JCEUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:20:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47218 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753960Ab3JCET6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:19:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 03/57] bcache: Fix a dumb journal discard bug
Date: Wed,  2 Oct 2013 21:08:29 -0700
Message-Id: <20131003040636.840325380@linuxfoundation.org>
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

commit 6d9d21e35fbfa2934339e96934f862d118abac23 upstream.

That switch statement was obviously wrong, leading to some sort of weird
spinning on rare occasion with discards enabled...

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/journal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -428,7 +428,7 @@ static void do_journal_discard(struct ca
 		return;
 	}
 
-	switch (atomic_read(&ja->discard_in_flight) == DISCARD_IN_FLIGHT) {
+	switch (atomic_read(&ja->discard_in_flight)) {
 	case DISCARD_IN_FLIGHT:
 		return;
 


