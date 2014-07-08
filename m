Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaGHVtq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:49:46 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:64877 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaGHVtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:49:45 -0400
Date: Wed, 9 Jul 2014 00:49:43 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: remove proc_tty_ldisc variable
Message-ID: <20140708214943.GB2382@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/tty/ldisc appear to be unused as a directory and
it had been always that way.

But it is userspace visible thing.

Cowardly remove only in-kernel variable holding it.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/proc_tty.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/proc/proc_tty.c
+++ b/fs/proc/proc_tty.c
@@ -18,7 +18,7 @@
 /*
  * The /proc/tty directory inodes...
  */
-static struct proc_dir_entry *proc_tty_ldisc, *proc_tty_driver;
+static struct proc_dir_entry *proc_tty_driver;
 
 /*
  * This is the handler for /proc/tty/drivers
@@ -176,7 +176,7 @@ void __init proc_tty_init(void)
 {
 	if (!proc_mkdir("tty", NULL))
 		return;
-	proc_tty_ldisc = proc_mkdir("tty/ldisc", NULL);
+	proc_mkdir("tty/ldisc", NULL);
 	/*
 	 * /proc/tty/driver/serial reveals the exact character counts for
 	 * serial links which is just too easy to abuse for inferring
