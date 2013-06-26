Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3FZVFK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 17:05:10 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:56885 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3FZVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 17:05:08 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH] proc: Document that /proc/<pid>/task/<tid>/children really is per-thread
Date: Wed, 26 Jun 2013 14:05:01 -0700
Message-Id: <5f9a6b3ab75b12f2c5ba61ea1f6f3b08e9952b55.1372280661.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <20130626155728.GA2141@redhat.com>
References: <20130626155728.GA2141@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was surprised to discover that a process can have a parent that isn't
a thread group leader.  (The usual ppid interfaces hide this, but the
children list exposes it.)

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 Documentation/filesystems/proc.txt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index fd8d0d5..205796a 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1623,6 +1623,12 @@ This file provides a fast way to retrieve first level children pids
 of a task pointed by <pid>/<tid> pair. The format is a space separated
 stream of pids.
 
+This really is a per-thread list.  If a process's parent is a thread,
+then that process will appear in that thread's children list.  (This
+means that, for any pid, /proc/pid/task/*/children are disjoint lists.)
+This may be surprising, as /proc/pid/status's PPid field is parent's
+tgid as opposed to the parent's tid.
+
 Note the "first level" here -- if a child has own children they will
 not be listed here, one needs to read /proc/<children-pid>/task/<tid>/children
 to obtain the descendants.
-- 
1.8.1.4

