Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758258AbbAYSpZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:45:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57564 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754375AbbAYSKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Julia Lawall <julia.lawall@lip6.fr>, Wolfram Sang <wsa@the-dreams.de>,
        Michal Marek <mmarek@suse.cz>
Subject: [PATCH 3.18 095/183] bugon.cocci: fix Options at the macro
Date: Sun, 25 Jan 2015 10:06:57 -0800
Message-Id: <20150125180814.294339824@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit 7426977c8efeaedf0a7ca00e1c1a5f52ef6b950f upstream.

The comma after --no-includes makes coccinelle to not run the script:

/usr/bin/spatch -D report --very-quiet --no-show-diff --cocci-file ./scripts/coccinelle/misc/bugon.cocci --no-includes, --include-headers --patch . --dir drivers/media/platform/coda/ -I ./arch/x86/include -I arch/x86/include/generated -I include -I ./arch/x86/include/uapi -I arch/x86/include/generated/uapi -I ./include/uapi -I include/generated/uapi -I ./include/linux/kconfig.h
Usage: spatch.opt --sp-file <SP> <infile> [-o <outfile>] [--iso-file <iso>] [options]
Options are:
  --sp-file                    <file> the semantic patch file
  -o                           <file> the output file
  --in-place                   do the modification on the file directly
  --backup-suffix              suffix to use when making a backup for inplace
...

At least with Fedora 20 coccinelle package:
	coccinelle-1.0.0-0.rc20.1.fc21.x86_64

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
Tested-by: Wolfram Sang <wsa@the-dreams.de>
Fixes: 5be1df66 (Coccinelle: Script to replace if and BUG with BUG_ON)
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/coccinelle/misc/bugon.cocci |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/coccinelle/misc/bugon.cocci
+++ b/scripts/coccinelle/misc/bugon.cocci
@@ -8,7 +8,7 @@
 // Confidence: High
 // Copyright: (C) 2014 Himangi Saraogi.  GPLv2.
 // Comments:
-// Options: --no-includes, --include-headers
+// Options: --no-includes --include-headers
 
 virtual patch
 virtual context


