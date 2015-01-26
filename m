Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892AbbAZRtQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:49:16 -0500
Received: from mail.kernel.org ([198.145.29.136]:53200 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756869AbbAZRtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:49:10 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>, Borislav Petkov <bp@suse.de>,
        David Ahern <dsahern@gmail.com>, Don Zickus <dzickus@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 23/26] tools lib fs debugfs: Check if debugfs is mounted when handling ENOENT
Date: Mon, 26 Jan 2015 14:47:26 -0300
Message-Id: <1422294449-12735-24-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

If debugfs was already mounted, then its a matter of not finding the
tracepoint, tell the user that perhaps a CONFIG_ setting is not enabled.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6chfytoflyx3jwfqm7ebltu0@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/api/fs/debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/lib/api/fs/debugfs.c b/tools/lib/api/fs/debugfs.c
index bf9e21648894..d2b18e887071 100644
--- a/tools/lib/api/fs/debugfs.c
+++ b/tools/lib/api/fs/debugfs.c
@@ -106,6 +106,13 @@ int debugfs__strerror_open(int err, char *buf, size_t size, const char *filename
 
 	switch (err) {
 	case ENOENT:
+		if (debugfs_found) {
+			snprintf(buf, size,
+				 "Error:\tFile %s/%s not found.\n"
+				 "Hint:\tPerhaps this kernel misses some CONFIG_ setting to enable this feature?.\n",
+				 debugfs_mountpoint, filename);
+			break;
+		}
 		snprintf(buf, size, "%s",
 			 "Error:\tUnable to find debugfs\n"
 			 "Hint:\tWas your kernel compiled with debugfs support?\n"
-- 
1.9.3

