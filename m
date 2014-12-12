Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965734AbaLLIUI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:20:08 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43250 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965701AbaLLIUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:20:04 -0500
Date: Fri, 12 Dec 2014 00:19:24 -0800
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-nay9j62ztxpytt4ew1tkl4op@git.kernel.org>
Cc: paulus@samba.org, tglx@linutronix.de, namhyung@kernel.org,
        dzickus@redhat.com, acme@redhat.com, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, dsahern@gmail.com,
        fweisbec@gmail.com, jolsa@redhat.com, adrian.hunter@intel.com,
        bp@suse.de, efault@gmx.de, peterz@infradead.org
Reply-To: eranian@google.com, acme@redhat.com, dzickus@redhat.com,
        namhyung@kernel.org, tglx@linutronix.de, paulus@samba.org,
        efault@gmx.de, peterz@infradead.org, bp@suse.de,
        adrian.hunter@intel.com, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        hpa@zytor.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib fs: Add sysctl__read_int helper
Git-Commit-ID: 42e3c4a1274d49b42e9d4306ec096b282a6e14aa
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

Commit-ID:  42e3c4a1274d49b42e9d4306ec096b282a6e14aa
Gitweb:     http://git.kernel.org/tip/42e3c4a1274d49b42e9d4306ec096b282a6e14aa
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 11 Dec 2014 13:37:10 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 11 Dec 2014 17:53:00 -0300

tools lib fs: Add sysctl__read_int helper

Will come in handy for tools, see next patches.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-nay9j62ztxpytt4ew1tkl4op@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/fs.c | 13 +++++++++++++
 tools/lib/api/fs/fs.h |  1 +
 2 files changed, 14 insertions(+)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index b8d0df8..65d9be3 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -184,3 +184,16 @@ int filename__read_int(const char *filename, int *value)
 	close(fd);
 	return err;
 }
+
+int sysctl__read_int(const char *sysctl, int *value)
+{
+	char path[PATH_MAX];
+	const char *procfs = procfs__mountpoint();
+
+	if (!procfs)
+		return -1;
+
+	snprintf(path, sizeof(path), "%s/sys/%s", procfs, sysctl);
+
+	return filename__read_int(path, value);
+}
diff --git a/tools/lib/api/fs/fs.h b/tools/lib/api/fs/fs.h
index 4d0aef6..6caa2bb 100644
--- a/tools/lib/api/fs/fs.h
+++ b/tools/lib/api/fs/fs.h
@@ -13,4 +13,5 @@ const char *sysfs__mountpoint(void);
 const char *procfs__mountpoint(void);
 
 int filename__read_int(const char *filename, int *value);
+int sysctl__read_int(const char *sysctl, int *value);
 #endif /* __API_FS__ */
