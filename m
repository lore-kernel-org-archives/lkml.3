Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab3FCJ3c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 05:29:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:42615 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FCJ3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 05:29:30 -0400
USER-AGENT: Mutt/1.5.21 (2010-09-15)
MIME-Version: 1.0
Message-ID: <20130603092725.GE16171@debian>
Date: Mon, 3 Jun 2013 02:27:25 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] fanotify: info leak in copy_event_to_user()
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ->reserverd field isn't cleared so we leak one byte of stack
information to userspace.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index 6c80083..77cc85d 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -122,6 +122,7 @@ static int fill_event_metadata(struct fsnotify_group *group,
 	metadata->event_len = FAN_EVENT_METADATA_LEN;
 	metadata->metadata_len = FAN_EVENT_METADATA_LEN;
 	metadata->vers = FANOTIFY_METADATA_VERSION;
+	metadata->reserved = 0;
 	metadata->mask = event->mask & FAN_ALL_OUTGOING_EVENTS;
 	metadata->pid = pid_vnr(event->tgid);
 	if (unlikely(event->mask & FAN_Q_OVERFLOW))
