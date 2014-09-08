Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbaIHXL4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 19:11:56 -0400
Received: from ozlabs.org ([103.22.144.67]:51409 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbaIHXLy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 19:11:54 -0400
Date: Tue, 9 Sep 2014 09:11:52 +1000
From: Anton Blanchard <anton@samba.org>
To: acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH] perf symbols: Add path to Ubuntu kernel debuginfo file
Message-ID: <20140909091152.2698c0f7@kryten>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ubuntu places the kernel debuginfo in /usr/lib/debug/boot/vmlinux-*

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: b/tools/perf/util/symbol.c
===================================================================
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1750,7 +1750,7 @@ static int vmlinux_path__init(void)
 	struct utsname uts;
 	char bf[PATH_MAX];
 
-	vmlinux_path = malloc(sizeof(char *) * 5);
+	vmlinux_path = malloc(sizeof(char *) * 6);
 	if (vmlinux_path == NULL)
 		return -1;
 
@@ -1784,6 +1784,12 @@ static int vmlinux_path__init(void)
 		 uts.release);
 	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
 	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
+		goto out_fail;
+	++vmlinux_path__nr_entries;
+	snprintf(bf, sizeof(bf), "/usr/lib/debug/boot/vmlinux-%s",
+		 uts.release);
+	vmlinux_path[vmlinux_path__nr_entries] = strdup(bf);
+	if (vmlinux_path[vmlinux_path__nr_entries] == NULL)
 		goto out_fail;
 	++vmlinux_path__nr_entries;
 

