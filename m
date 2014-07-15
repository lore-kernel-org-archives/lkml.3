Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934107AbaGOV5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:57:16 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:52030 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031AbaGOV5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:57:09 -0400
Message-Id: <20140715215703.353177995@openvz.org>
User-Agent: quilt/0.60-1
Date: Wed, 16 Jul 2014 01:54:55 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: [patch 4/4] timerfd.2: Add ioctl method description
References: <20140715215451.499191426@openvz.org>
Content-Disposition: inline; filename=timerfd-man
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ioctl(2)
	The following commands are supported: TFD_IOC_SET_TICKS to adjust
	the number of the timer expirations that have occurred.
	It take a pointer to nonzero 8-byte integer (uint64_t*) containing
	new number of expirations. Once the number is set any waiter on
	the timer is woken up. The only purpose of this command is to restore
	the expirations in a sake of checkpoint/restore procedure.
	It requires the kernel to be built with CONFIG_CHECKPOINT_RESTORE
	support.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Andrey Vagin <avagin@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Vladimir Davydov <vdavydov@parallels.com>
CC: linux-api@vger.kernel.org
---
 man2/timerfd_create.2 |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: man-pages/man2/timerfd_create.2
===================================================================
--- man-pages.orig/man2/timerfd_create.2
+++ man-pages/man2/timerfd_create.2
@@ -260,6 +260,20 @@ multiplexing APIs:
 and
 .BR epoll (7).
 .TP
+.BR ioctl "(2)"
+The following commands are supported:
+.B TFD_IOC_SET_TICKS
+to adjust the number of the timer expirations that have occurred.
+It take a pointer to nonzero 8-byte integer
+.RI ( uint64_t *)
+containing the new number of expirations.
+Once the number is set any waiter on the timer is woken up.
+The only purpose of this command is to restore the expirations
+in a sake of checkpoint/restore procedure.
+It requires the kernel to be built with
+.BR CONFIG_CHECKPOINT_RESTORE
+support.
+.TP
 .BR close (2)
 When the file descriptor is no longer required it should be closed.
 When all file descriptors associated with the same timer object

