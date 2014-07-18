Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934863AbaGRJwl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 05:52:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36321 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934730AbaGRJwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 05:52:34 -0400
Date: Fri, 18 Jul 2014 02:52:22 -0700
From: tip-bot for Cyrill Gorcunov <tipbot@zytor.com>
Message-ID: <tip-854d06d9fc350130617debdd9e9f49d1c4ba5206@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, avagin@openvz.org,
        akpm@linux-foundation.org, tglx@linutronix.de, vdavydov@parallels.com,
        mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        gorcunov@openvz.org, xemul@parallels.com, avagin@openvz.org,
        akpm@linux-foundation.org, tglx@linutronix.de, vdavydov@parallels.com,
        mtk.manpages@gmail.com
In-Reply-To: <20140715215703.199905126@openvz.org>
References: <20140715215703.199905126@openvz.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] docs: Procfs -- Document timerfd output
Git-Commit-ID: 854d06d9fc350130617debdd9e9f49d1c4ba5206
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  854d06d9fc350130617debdd9e9f49d1c4ba5206
Gitweb:     http://git.kernel.org/tip/854d06d9fc350130617debdd9e9f49d1c4ba5206
Author:     Cyrill Gorcunov <gorcunov@openvz.org>
AuthorDate: Wed, 16 Jul 2014 01:54:53 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 18 Jul 2014 11:49:57 +0200

docs: Procfs -- Document timerfd output

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Link: http://lkml.kernel.org/r/20140715215703.199905126@openvz.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/filesystems/proc.txt | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index ddc531a..eb8a10e 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -1743,6 +1743,25 @@ pair provide additional information particular to the objects they represent.
 	While the first three lines are mandatory and always printed, the rest is
 	optional and may be omitted if no marks created yet.
 
+	Timerfd files
+	~~~~~~~~~~~~~
+
+	pos:	0
+	flags:	02
+	mnt_id:	9
+	clockid: 0
+	ticks: 0
+	settime flags: 01
+	it_value: (0, 49406829)
+	it_interval: (1, 0)
+
+	where 'clockid' is the clock type and 'ticks' is the number of the timer expirations
+	that have occurred [see timerfd_create(2) for details]. 'settime flags' are
+	flags in octal form been used to setup the timer [see timerfd_settime(2) for
+	details]. 'it_value' is remaining time until the timer exiration.
+	'it_interval' is the interval for the timer. Note the timer might be set up
+	with TIMER_ABSTIME option which will be shown in 'settime flags', but 'it_value'
+	still exhibits timer's remaining time.
 
 ------------------------------------------------------------------------------
 Configuring procfs
