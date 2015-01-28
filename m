Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934268AbbA1CYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:24:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbbA1B2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Matt Fleming <matt@console-pimps.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 3.10 06/32] scripts/recordmcount.pl: There is no -m32 gcc option on Super-H anymore
Date: Tue, 27 Jan 2015 17:26:36 -0800
Message-Id: <20150128012627.996535068@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Karcher <kernel@mkarcher.dialup.fu-berlin.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/recordmcount.pl |    1 -
 1 file changed, 1 deletion(-)

--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -262,7 +262,6 @@ if ($arch eq "x86_64") {
     # force flags for this arch
     $ld .= " -m shlelf_linux";
     $objcopy .= " -O elf32-sh-linux";
-    $cc .= " -m32";
 
 } elsif ($arch eq "powerpc") {
     $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\.?\\S+)";


