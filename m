Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab3AYLa5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:30:57 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41699 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755872Ab3AYLaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:30:55 -0500
Date: Fri, 25 Jan 2013 03:30:35 -0800
From: tip-bot for Thomas Jarosch <thomas.jarosch@intra2net.com>
Message-ID: <tip-a65c23420668f7112395abf9c6f22c6450567bf0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, thomas.jarosch@intra2net.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, thomas.jarosch@intra2net.com, tglx@linutronix.de
In-Reply-To: <50D9D30B.8090002@intra2net.com>
References: <50D9D30B.8090002@intra2net.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix possible (unlikely)
  buffer overflow
Git-Commit-ID: a65c23420668f7112395abf9c6f22c6450567bf0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:30:42 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a65c23420668f7112395abf9c6f22c6450567bf0
Gitweb:     http://git.kernel.org/tip/a65c23420668f7112395abf9c6f22c6450567bf0
Author:     Thomas Jarosch <thomas.jarosch@intra2net.com>
AuthorDate: Tue, 25 Dec 2012 17:23:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:18 -0300

perf tools: Fix possible (unlikely) buffer overflow

cppcheck reported:
[tools/perf/util/sysfs.c:50]: (error) Width 4096 given in format string
(no. 1) is larger than destination buffer 'sysfs_mountpoint[4096]',
use %4095s to prevent overflowing it

-> All other places in the kernel that use STR(PATH_MAX)
   have a buffer size of PATH_MAX + 1.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/50D9D30B.8090002@intra2net.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sysfs.c b/tools/perf/util/sysfs.c
index 48c6902..f71e9ea 100644
--- a/tools/perf/util/sysfs.c
+++ b/tools/perf/util/sysfs.c
@@ -8,7 +8,7 @@ static const char * const sysfs_known_mountpoints[] = {
 };
 
 static int sysfs_found;
-char sysfs_mountpoint[PATH_MAX];
+char sysfs_mountpoint[PATH_MAX + 1];
 
 static int sysfs_valid_mountpoint(const char *sysfs)
 {
