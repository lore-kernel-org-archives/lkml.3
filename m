Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757833AbaHZMFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:05:11 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:40697 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757803AbaHZMFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:05:06 -0400
Subject: [RFC PATCH 2/2] modprobe: Add --lockup option to make module
 unremovable
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Date: Tue, 26 Aug 2014 12:04:56 +0000
Message-ID: <20140826120456.8223.20476.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140826120442.8223.80618.stgit@kbuild-fedora.novalocal>
References: <20140826120442.8223.80618.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu@gmail.com>

Add --lockup option for loading to make the module unremovable.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 tools/modprobe.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/modprobe.c b/tools/modprobe.c
index 6b34658..768a5bb 100644
--- a/tools/modprobe.c
+++ b/tools/modprobe.c
@@ -51,12 +51,13 @@ static int first_time = 0;
 static int ignore_commands = 0;
 static int use_blacklist = 0;
 static int force = 0;
+static int lockup = 0;
 static int strip_modversion = 0;
 static int strip_vermagic = 0;
 static int remove_dependencies = 0;
 static int quiet_inuse = 0;
 
-static const char cmdopts_s[] = "arRibfDcnC:d:S:sqvVh";
+static const char cmdopts_s[] = "arRibflDcnC:d:S:sqvVh";
 static const struct option cmdopts[] = {
 	{"all", no_argument, 0, 'a'},
 	{"remove", no_argument, 0, 'r'},
@@ -69,6 +70,7 @@ static const struct option cmdopts[] = {
 	{"force", no_argument, 0, 'f'},
 	{"force-modversion", no_argument, 0, 2},
 	{"force-vermagic", no_argument, 0, 1},
+	{"lockup", no_argument, 0, 'l'},
 
 	{"show-depends", no_argument, 0, 'D'},
 	{"showconfig", no_argument, 0, 'c'},
@@ -116,6 +118,7 @@ static void help(void)
 		"\t                            --force-vermagic\n"
 		"\t    --force-modversion      Ignore module's version\n"
 		"\t    --force-vermagic        Ignore module's version magic\n"
+		"\t-l, --lockup                Make module to unremovable.\n"
 		"\n"
 		"Query Options:\n"
 		"\t-D, --show-depends          Only print module dependencies and exit\n"
@@ -526,6 +529,8 @@ static int insmod(struct kmod_ctx *ctx, const char *alias,
 		flags |= KMOD_PROBE_FORCE_MODVERSION;
 	if (strip_vermagic || force)
 		flags |= KMOD_PROBE_FORCE_VERMAGIC;
+	if (lockup)
+		flags |= KMOD_PROBE_LOCKUP_MODULE;
 	if (ignore_commands)
 		flags |= KMOD_PROBE_IGNORE_COMMAND;
 	if (ignore_loaded)
@@ -798,6 +803,9 @@ static int do_modprobe(int argc, char **orig_argv)
 		case 1:
 			strip_vermagic = 1;
 			break;
+		case 'l':
+			lockup = 1;
+			break;
 		case 'D':
 			ignore_loaded = 1;
 			dry_run = 1;


