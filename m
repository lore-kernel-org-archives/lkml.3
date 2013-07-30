Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830Ab3G3JxB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:53:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758717Ab3G3Jcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:32:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 038/106] fanotify: info leak in copy_event_to_user()
Date: Tue, 30 Jul 2013 10:30:57 +0100
Message-Id: <1375176725-5825-39-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit de1e0c40aceb9d5bff09c3a3b97b2f1b178af53f upstream.

The ->reserved field isn't cleared so we leak one byte of stack
information to userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/notify/fanotify/fanotify_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 3568c8a..48bc91d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -120,6 +120,7 @@ static int fill_event_metadata(struct fsnotify_group *group,
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->metadata_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
+	metadata->reserved = 0;
 	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
 	if (unlikely(event->mask & FAN_Q_OVERFLOW))
-- 
1.8.3.2

