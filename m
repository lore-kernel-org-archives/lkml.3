Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982AbaB0MR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:17:27 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62550 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbaB0MRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:17:13 -0500
Date: Thu, 27 Feb 2014 17:47:04 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Aaron Tomlin <atomlin@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Li Zefan <lizefan@huawei.com>,
        josh@joshtriplett.org
Subject: [PATCH 34/46] kernel: Include appropriate header file in hung_task.c
Message-ID: <924c0b5b5df9a890b1bc24f70f9aa9a8a5c39d7f.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/linux/sched/sysctl.h in
kernel/hung_task.c because it has function declaration of function
defined in kernel/hung_task.c.

This elimiantes the following warning in kernel/hung_task.c:
kernel/hung_task.c:195:5: warning: no previous prototype for ‘proc_dohung_task_timeout_secs’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/hung_task.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/hung_task.c b/kernel/hung_task.c
index 0b9c169..2704c36 100644
--- a/kernel/hung_task.c
+++ b/kernel/hung_task.c
@@ -16,6 +16,7 @@
 #include <linux/export.h>
 #include <linux/sysctl.h>
 #include <linux/utsname.h>
+#include <linux/sched/sysctl.h>
 #include <trace/events/sched.h>
 
 /*
-- 
1.7.9.5

