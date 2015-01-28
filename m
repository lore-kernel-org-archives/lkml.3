Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762070AbbA2Ksi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:48:38 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753392AbbA2I71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:59:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Matt Fleming <matt@console-pimps.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 144/176] scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore
Date: Wed, 28 Jan 2015 15:29:34 +0100
Message-Id: <c05a1326cf2a8ef3e10269213548784eea3756b7.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 1caf6aaaa47471831d77c75f094d4e00ad1ec808 upstream.

Compiling SH with gcc-4.8 fails due to the -m32 option not being
supported.

>From http://buildd.debian-ports.org/status/fetch.php?pkg=linux&arch=sh4&ver=3.16.7-ckt4-1&stamp=1421425783

      CC      init/main.o
    gcc-4.8: error: unrecognized command line option '-m32'
    ld: cannot find init/.tmp_mc_main.o: No such file or directory
    objcopy: 'init/.tmp_mx_main.o': No such file
    rm: cannot remove 'init/.tmp_mx_main.o': No such file or directory
    rm: cannot remove 'init/.tmp_mc_main.o': No such file or directory

Link: http://lkml.kernel.org/r/1421537778-29001-1-git-send-email-kernel@mkarcher.dialup.fu-berlin.de
Link: http://lkml.kernel.org/r/54BCBDD4.10102@physik.fu-berlin.de

Cc: Matt Fleming <matt@console-pimps.org>
Reported-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Signed-off-by: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 scripts/recordmcount.pl | 1 -
 1 file changed, 1 deletion(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a674fd5507c1..a27134fc3f76 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -262,7 +262,6 @@ if ($arch eq "x86_64") {
     # force flags for this arch
     $ld .= " -m shlelf_linux";
     $objcopy .= " -O elf32-sh-linux";
-    $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
     $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";
-- 
2.2.2

