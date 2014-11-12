Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935216AbaKLCfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:35:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934896AbaKLBrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:47:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 3.14 177/203] quota: Properly return errors from dquot_writeback_dquots()
Date: Wed, 12 Nov 2014 10:17:27 +0900
Message-Id: <20141112011550.807575036@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 474d2605d119479e5aa050f738632e63589d4bb5 upstream.

Due to a switched left and right side of an assignment,
dquot_writeback_dquots() never returned error. This could result in
errors during quota writeback to not be reported to userspace properly.
Fix it.

Coverity-id: 1226884
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/quota/dquot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -637,7 +637,7 @@ int dquot_writeback_dquots(struct super_
 			dqstats_inc(DQST_LOOKUPS);
 			err = sb->dq_op->write_dquot(dquot);
 			if (!ret && err)
-				err = ret;
+				ret = err;
 			dqput(dquot);
 			spin_lock(&dq_list_lock);
 		}


