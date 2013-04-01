Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623Ab3DATWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 15:22:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab3DATVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 15:21:36 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Borislav Petkov <bp@alien8.de>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 24/27] kbuild: Introduce KCONFIG_AUTOCONFIGDEP variable for conf tool
Date: Mon,  1 Apr 2013 21:18:47 +0200
Message-Id: <1364843930-17974-25-git-send-email-jolsa@redhat.com>
In-Reply-To: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
References: <1364843930-17974-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introducing KCONFIG_AUTOCONFIGDEP variable for conf tool
allowing to specify custom auto.conf.cmd file.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>
---
 scripts/kconfig/confdata.c | 11 ++++++++++-
 scripts/kconfig/lkc.h      |  1 +
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index 13ddf11..435c361 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -75,6 +75,14 @@ const char *conf_get_autoconfig_name(void)
 	return name ? name : "include/config/auto.conf";
 }
 
+const char *conf_get_autoconfigdep_name(void)
+{
+	char *name = getenv("KCONFIG_AUTOCONFIGDEP");
+
+	return name ? name : "include/config/auto.conf.cmd";
+}
+
+
 static char *conf_expand_value(const char *in)
 {
 	struct symbol *sym;
@@ -948,7 +956,8 @@ int conf_write_autoconf(void)
 
 	sym_clear_all_valid();
 
-	file_write_dep("include/config/auto.conf.cmd");
+	name = conf_get_autoconfigdep_name();
+	file_write_dep(name);
 
 	if (conf_split_config())
 		return 1;
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index f8aee5f..5e370b1 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -83,6 +83,7 @@ const char *zconf_curname(void);
 /* confdata.c */
 const char *conf_get_configname(void);
 const char *conf_get_autoconfig_name(void);
+const char *conf_get_autoconfigdep_name(void);
 char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
-- 
1.7.11.7

