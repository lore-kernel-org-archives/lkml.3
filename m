Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbaJ1RSb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 13:18:31 -0400
Received: from lists.s-osg.org ([54.187.51.154]:42243 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbaJ1RSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 13:18:30 -0400
Date: Tue, 28 Oct 2014 15:18:24 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Himangi Saraogi <himangi774@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>
Cc: Michal Marek <mmarek@suse.cz>, cocci@systeme.lip6.fr,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-kernel@vger.kernel.org
Subject: bugon.cocci: fix Options at the macro
Message-ID: <20141028151824.4b41986f@recife.lan>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

diff --git a/scripts/coccinelle/misc/bugon.cocci b/scripts/coccinelle/misc/bugon.cocci
index 556456ca761c..3b7eec24fb5a 100644
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
