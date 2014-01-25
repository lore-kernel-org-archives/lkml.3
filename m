Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbaAYOY3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jan 2014 09:24:29 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaAYOXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jan 2014 09:23:37 -0500
Date: Sat, 25 Jan 2014 06:23:07 -0800
From: tip-bot for Josh Boyer <tipbot@zytor.com>
Message-ID: <tip-b935a58dbff457c27fd63e1e1bb29db20b2ee6a8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@redhat.com, jwboyer@fedoraproject.org,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jolsa@redhat.com, jwboyer@fedoraproject.org,
        rostedt@goodmis.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20140122150147.GK16455@hansolo.jdub.homelinux.org>
References: <20140122150147.GK16455@hansolo.jdub.homelinux.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix traceevent plugin path definitions
Git-Commit-ID: b935a58dbff457c27fd63e1e1bb29db20b2ee6a8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 25 Jan 2014 06:23:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b935a58dbff457c27fd63e1e1bb29db20b2ee6a8
Gitweb:     http://git.kernel.org/tip/b935a58dbff457c27fd63e1e1bb29db20b2ee6a8
Author:     Josh Boyer <jwboyer@fedoraproject.org>
AuthorDate: Wed, 22 Jan 2014 10:01:48 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 23 Jan 2014 15:48:12 -0300

perf tools: Fix traceevent plugin path definitions

The plugindir_SQ definition contains $(prefix) which is not needed as
the $(libdir) definition already contains prefix in it.  This leads to
the path including an extra prefix in it, e.g. /usr/usr/lib64.

The -DPLUGIN_DIR defintion includes DESTDIR.  This is incorrect, as it
sets the plugin search path to include the value of DESTDIR.  DESTDIR is
a mechanism to install in a non-standard location such as a chroot or an
RPM build root.  In the RPM case, this leads to the search path being
incorrect after the resulting RPM is installed (or in some cases an RPM
build failure).

Remove both of these unnecessary inclusions.

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/20140122150147.GK16455@hansolo.jdub.homelinux.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/Makefile | 2 +-
 tools/perf/config/Makefile    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
index 56d52a3..005c9cc 100644
--- a/tools/lib/traceevent/Makefile
+++ b/tools/lib/traceevent/Makefile
@@ -63,7 +63,7 @@ endif
 endif
 
 ifeq ($(set_plugin_dir),1)
-PLUGIN_DIR = -DPLUGIN_DIR="$(DESTDIR)/$(plugin_dir)"
+PLUGIN_DIR = -DPLUGIN_DIR="$(plugin_dir)"
 PLUGIN_DIR_SQ = '$(subst ','\'',$(PLUGIN_DIR))'
 endif
 
diff --git a/tools/perf/config/Makefile b/tools/perf/config/Makefile
index d604e50..c48d449 100644
--- a/tools/perf/config/Makefile
+++ b/tools/perf/config/Makefile
@@ -600,5 +600,5 @@ perfexec_instdir_SQ = $(subst ','\'',$(perfexec_instdir))
 # Otherwise we install plugins into the global $(libdir).
 ifdef DESTDIR
 plugindir=$(libdir)/traceevent/plugins
-plugindir_SQ= $(subst ','\'',$(prefix)/$(plugindir))
+plugindir_SQ= $(subst ','\'',$(plugindir))
 endif
