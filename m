Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932490AbaJNMkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 08:40:55 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:57209 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaJNMky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 08:40:54 -0400
Date: Tue, 14 Oct 2014 13:39:41 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: fix sign extension on 64bit machines
Message-ID: <20141014133941.2600222e@alan.etchedpixels.co.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you try and run pcmcia on a 64bit box the upper 32bits of the resource
flags all end up set due to a sign extension bug in the PCMCIA core

Signed-off-by: Alan Cox <alan@linux.intel.com>

diff -u --new-file --recursive --exclude-from ac/.gitignore next/drivers/pcmcia/cs_internal.h ac/drivers/pcmcia/cs_internal.h
--- next/drivers/pcmcia/cs_internal.h	2013-10-28 11:40:29.717315588 +0000
+++ ac/drivers/pcmcia/cs_internal.h	2014-09-06 17:25:32.959662243 +0100
@@ -82,7 +82,7 @@
 extern int static_init(struct pcmcia_socket *s);
 extern struct resource *pcmcia_make_resource(unsigned long start,
 					unsigned long end,
-					int flags, const char *name);
+					unsigned long flags, const char *name);
 
 /*
  * Stuff internal to module "pcmcia_core":
diff -u --new-file --recursive --exclude-from ac/.gitignore next/drivers/pcmcia/rsrc_mgr.c ac/drivers/pcmcia/rsrc_mgr.c
--- next/drivers/pcmcia/rsrc_mgr.c	2013-10-28 11:40:29.721315588 +0000
+++ ac/drivers/pcmcia/rsrc_mgr.c	2014-09-06 17:24:51.671663325 +0100
@@ -31,7 +31,7 @@
 }
 
 struct resource *pcmcia_make_resource(unsigned long start, unsigned long end,
-				int flags, const char *name)
+				unsigned long flags, const char *name)
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 

