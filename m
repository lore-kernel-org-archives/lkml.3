Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbaFPKnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 06:43:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:38730 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332AbaFPKnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 06:43:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,486,1400050800"; 
   d="scan'208";a="558158932"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] lib.c: skip --param parameters
Date: Mon, 16 Jun 2014 13:43:06 +0300
Message-Id: <1402915386-28210-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Very dumb patch to just skip --param allow-store-data-races=0 introduced in
newest Linux kernel buildsystem.

Actually the option is present in few GCC versions and probably should be
handled properly.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 lib.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/lib.c b/lib.c
index bf3e91c..e56037b 100644
--- a/lib.c
+++ b/lib.c
@@ -673,6 +673,12 @@ static char **handle_version(char *arg, char **next)
 	exit(0);
 }
 
+static char **handle_param(char *arg, char **next)
+{
+	++next;
+	return ++next;
+}
+
 struct switches {
 	const char *name;
 	char **(*fn)(char *, char **);
@@ -681,6 +687,7 @@ struct switches {
 static char **handle_long_options(char *arg, char **next)
 {
 	static struct switches cmd[] = {
+		{ "param", handle_param },
 		{ "version", handle_version },
 		{ NULL, NULL }
 	};
-- 
2.0.0

