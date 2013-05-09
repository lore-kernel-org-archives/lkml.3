Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3EIWOr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 18:14:47 -0400
Received: from longford.logfs.org ([213.229.74.203]:59134 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab3EIWOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 18:14:45 -0400
From: Joern Engel <joern@logfs.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>,
        Joern Engel <joern@logfs.org>
Subject: [PATCH 14/14] netconsole: s/syslogd/cancd/ in documentation
Date: Thu,  9 May 2013 16:43:12 -0400
Message-Id: <1368132193-25817-17-git-send-email-joern@logfs.org>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1368132193-25817-1-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using syslogd to capture netconsole is known to be broken, see for
example https://bugzilla.redhat.com/show_bug.cgi?id=432160 or any of the
many other bug reports.  We should not advertise it, much less as a
first choice.  The fact that syslogd tends to initially work makes it
worse, as that creates false hope.

Cancd is a syslog-for-netconsole of sorts and in my experience works
better than any alternative for non-trivial setups, i.e. more than a
single machine sending netconsole traffic.

Since my hacked-up version of cancd is no longer compatible with
Oracle's original, I linked to both.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 Documentation/networking/netconsole.txt |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.txt
index 2e9e0ae2..c59d2bf 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.txt
@@ -54,9 +54,7 @@ address.
 The remote host has several options to receive the kernel messages,
 for example:
 
-1) syslogd
-
-2) netcat
+1) netcat
 
    On distributions using a BSD-based netcat version (e.g. Fedora,
    openSUSE and Ubuntu) the listening port must be specified without
@@ -65,10 +63,20 @@ for example:
    'nc -u -l -p <port>' / 'nc -u -l <port>' or
    'netcat -u -l -p <port>' / 'netcat -u -l <port>'
 
-3) socat
+2) socat
 
    'socat udp-recv:<port> -'
 
+3) cancd
+
+   A daemon written specifically for netconsole that is good at capturing
+   output from many machines.  Using netcat for several machines either
+   interleaves output from all machines or requires the use of per-machine
+   ports.
+
+   https://git.kernel.org/cgit/linux/kernel/git/joern/cancd.git/
+   https://oss.oracle.com/projects/cancd/
+
 Dynamic reconfiguration:
 ========================
 
-- 
1.7.10.4

