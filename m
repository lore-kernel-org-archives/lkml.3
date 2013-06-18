Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab3FRWph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 18:45:37 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:53163 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933741Ab3FRWpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 18:45:31 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Clement Chauplannaz <chauplac@gmail.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 08/14] scripts/config: replace hard-coded script name by a dynamic value
Date: Wed, 19 Jun 2013 00:45:04 +0200
Message-Id: <7387778510b7deaff866277877c5550c3a14f1fb.1371595499.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1371595499.git.yann.morin.1998@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Clement Chauplannaz <chauplac@gmail.com>

The script `config' prints its name in usage() function. It is currently
hard-coded to value `config'. However, the script may be reused under
a different name in contexts other than the Linux Kernel.

Replace the hard-coded value `config' by the name of the script at runtime.

Signed-off-by: Clement Chauplannaz <chauplac@gmail.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Yann E. MORIN <yann.morin.1998@free.fr>
---
 scripts/config | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/scripts/config b/scripts/config
index bb4d3de..6b3272e 100755
--- a/scripts/config
+++ b/scripts/config
@@ -1,6 +1,8 @@
 #!/bin/bash
 # Manipulate options in a .config file from the command line
 
+myname=${0##*/}
+
 # If no prefix forced, use the default CONFIG_
 CONFIG_="${CONFIG_-CONFIG_}"
 
@@ -8,7 +10,7 @@ usage() {
 	cat >&2 <<EOL
 Manipulate options in a .config file from the command line.
 Usage:
-config options command ...
+$myname options command ...
 commands:
 	--enable|-e option   Enable option
 	--disable|-d option  Disable option
@@ -33,14 +35,14 @@ options:
 	--file config-file   .config file to change (default .config)
 	--keep-case|-k       Keep next symbols' case (dont' upper-case it)
 
-config doesn't check the validity of the .config file. This is done at next
+$myname doesn't check the validity of the .config file. This is done at next
 make time.
 
-By default, config will upper-case the given symbol. Use --keep-case to keep
+By default, $myname will upper-case the given symbol. Use --keep-case to keep
 the case of all following symbols unchanged.
 
-config uses 'CONFIG_' as the default symbol prefix. Set the environment
-variable CONFIG_ to the prefix to use. Eg.: CONFIG_="FOO_" config ...
+$myname uses 'CONFIG_' as the default symbol prefix. Set the environment
+variable CONFIG_ to the prefix to use. Eg.: CONFIG_="FOO_" $myname ...
 EOL
 	exit 1
 }
-- 
1.8.1.2

