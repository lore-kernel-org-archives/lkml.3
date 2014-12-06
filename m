Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaLFRyp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:54:45 -0500
Received: from 1wt.eu ([62.212.114.60]:40665 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLFRyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:54:43 -0500
Message-Id: <20141206174148.468191041@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:49 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Andrey Ryabinin <a.ryabinin@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 01/25] net: sendmsg: fix failed backport of "fix NULL pointer
 dereference"
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Message-ID: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Willy Tarreau <w@1wt.eu>

Luis Henriques reported that while backporting commit 40eea80 ("net:
sendmsg: fix NULL pointer dereference") and applying the diff by hand,
I made a typo resulting in the same test being done twice, and msg_name
not being tested.

This fixes cf90357 ("net: sendmsg: fix NULL pointer dereference")
which was merged into 2.6.32.64.

Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/compat.c b/net/compat.c
index 71ed839..a5848ac 100644
--- a/net/compat.c
+++ b/net/compat.c
@@ -83,7 +83,7 @@ int verify_compat_iovec(struct msghdr *kern_msg, struct iovec *kern_iov,
 {
 	int tot_len;
 
-	if (kern_msg->msg_namelen && kern_msg->msg_namelen) {
+	if (kern_msg->msg_name && kern_msg->msg_namelen) {
 		if (mode==VERIFY_READ) {
 			int err = move_addr_to_kernel(kern_msg->msg_name,
 						      kern_msg->msg_namelen,
-- 
1.7.12.2.21.g234cd45.dirty



