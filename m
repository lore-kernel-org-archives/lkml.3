Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964850Ab3CLXED (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 19:04:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60294 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3CLWdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 057/100] ipc: fix potential oops when src msg > 4k w/ MSG_COPY
Date: Tue, 12 Mar 2013 15:31:42 -0700
Message-Id: <20130312223129.130783271@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Hurley <peter@hurleysoftware.com>

commit e1082f45f1e2bbf6e25f6b614fc6616ebf709d19 upstream.

If the src msg is > 4k, then dest->next points to the
next allocated segment; resetting it just prior to dereferencing
is bad.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
Acked-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/msgutil.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/ipc/msgutil.c
+++ b/ipc/msgutil.c
@@ -117,9 +117,6 @@ struct msg_msg *copy_msg(struct msg_msg
 	if (alen > DATALEN_MSG)
 		alen = DATALEN_MSG;
 
-	dst->next = NULL;
-	dst->security = NULL;
-
 	memcpy(dst + 1, src + 1, alen);
 
 	len -= alen;


