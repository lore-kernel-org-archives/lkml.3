Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab3HICFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:05:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967713Ab3HIB7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [ 075/102] fanotify: info leak in copy_event_to_user()
Date: Thu,  8 Aug 2013 18:57:51 -0700
Message-Id: <20130809015027.920227529@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Luis Henriques <luis.henriques@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -122,6 +122,7 @@ static int fill_event_metadata(struct fs
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->metadata_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
+	metadata->reserved = 0;
 	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
 	if (unlikely(event->mask & FAN_Q_OVERFLOW))


