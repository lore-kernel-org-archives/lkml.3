Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbaLDV3E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 16:29:04 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:58598 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbaLDV3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 16:29:02 -0500
Subject: [PATCH 1/5] pcmcia: correct types
From: Alan Cox <alan@linux.intel.com>
To: linux-kernel@vger.kernel.org, linux-pcmica@lists.infradead.org
Date: Thu, 04 Dec 2014 21:28:53 +0000
Message-ID: <20141204212843.1351.14921.stgit@localhost.localdomain>
In-Reply-To: <20141204212746.1351.89165.stgit@localhost.localdomain>
References: <20141204212746.1351.89165.stgit@localhost.localdomain>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should be using resource_size_t and unsigned types correctly, otherwise
we sign extend the flags on a 64bit box, which is not what we want.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/pcmcia/cs_internal.h |    6 +++---
 drivers/pcmcia/rsrc_mgr.c    |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/pcmcia/cs_internal.h b/drivers/pcmcia/cs_internal.h
index 7f1953f..e86cd6b 100644
--- a/drivers/pcmcia/cs_internal.h
+++ b/drivers/pcmcia/cs_internal.h
@@ -80,9 +80,9 @@ struct pccard_resource_ops {
  * Stuff internal to module "pcmcia_rsrc":
  */
 extern int static_init(struct pcmcia_socket *s);
-extern struct resource *pcmcia_make_resource(unsigned long start,
-					unsigned long end,
-					int flags, const char *name);
+extern struct resource *pcmcia_make_resource(resource_size_t start,
+					resource_size_t end,
+					unsigned long flags, const char *name);
 
 /*
  * Stuff internal to module "pcmcia_core":
diff --git a/drivers/pcmcia/rsrc_mgr.c b/drivers/pcmcia/rsrc_mgr.c
index aa628ed..df2cb70 100644
--- a/drivers/pcmcia/rsrc_mgr.c
+++ b/drivers/pcmcia/rsrc_mgr.c
@@ -30,8 +30,9 @@ int static_init(struct pcmcia_socket *s)
 	return 0;
 }
 
-struct resource *pcmcia_make_resource(unsigned long start, unsigned long end,
-				int flags, const char *name)
+struct resource *pcmcia_make_resource(resource_size_t start,
+					resource_size_t end,
+					unsigned long flags, const char *name)
 {
 	struct resource *res = kzalloc(sizeof(*res), GFP_KERNEL);
 

