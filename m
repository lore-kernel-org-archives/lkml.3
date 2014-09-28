Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaI1Xfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 19:35:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:39783 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470AbaI1Xfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 19:35:41 -0400
Date: Sun, 28 Sep 2014 16:35:38 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>
Subject: [PATCH] fanotify: prove that structure size is correct
Message-ID: <20140928233538.GA31345@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When building with CONFIG_DEBUG_STRICT_USER_COPY_CHECKS, this copy_to_user
wasn't provably correct (the length was in a variable but the structure
wasn't). The compiler wasn't able to check that the length was being
statically assigned, so include a BUG_ON to notice if this ever changes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/notify/fanotify/fanotify_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b13992a41bd9..7bdb43222875 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -216,6 +216,7 @@ static ssize_t copy_event_to_user(struct fsnotify_group *group,
 
 	fd = fanotify_event_metadata.fd;
 	ret = -EFAULT;
+	BUG_ON(fanotify_event_metadata.event_len != FAN_EVENT_METADATA_LEN);
 	if (copy_to_user(buf, &fanotify_event_metadata,
 			 fanotify_event_metadata.event_len))
 		goto out_close_fd;
-- 
1.9.1


-- 
Kees Cook
Chrome OS Security
