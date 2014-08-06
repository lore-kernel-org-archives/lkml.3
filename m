Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbaHFM3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 08:29:54 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:57511 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaHFM3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 08:29:52 -0400
Date: Wed, 6 Aug 2014 17:59:48 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] pcmcia: Remove typedef tuple_flags
Message-ID: <20140806122948.GA7693@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for tuple_flags.

The following Coccinelle semantic patch makes the transformation.

@tn@
identifier i;
type td;
@@

-typedef
 struct i { ... }
-td
 ;

@@
type tn.td;
identifier tn.i;
@@

-td
+ struct i

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/pcmcia/cistpl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/pcmcia/cistpl.c b/drivers/pcmcia/cistpl.c
index 884a984..0a4c165 100644
--- a/drivers/pcmcia/cistpl.c
+++ b/drivers/pcmcia/cistpl.c
@@ -431,17 +431,17 @@ int pcmcia_replace_cis(struct pcmcia_socket *s,
 
 /* The high-level CIS tuple services */
 
-typedef struct tuple_flags {
+struct tuple_flags {
 	u_int		link_space:4;
 	u_int		has_link:1;
 	u_int		mfc_fn:3;
 	u_int		space:4;
-} tuple_flags;
+};
 
-#define LINK_SPACE(f)	(((tuple_flags *)(&(f)))->link_space)
-#define HAS_LINK(f)	(((tuple_flags *)(&(f)))->has_link)
-#define MFC_FN(f)	(((tuple_flags *)(&(f)))->mfc_fn)
-#define SPACE(f)	(((tuple_flags *)(&(f)))->space)
+#define LINK_SPACE(f)	(((struct tuple_flags *)(&(f)))->link_space)
+#define HAS_LINK(f)	(((struct tuple_flags *)(&(f)))->has_link)
+#define MFC_FN(f)	(((struct tuple_flags *)(&(f)))->mfc_fn)
+#define SPACE(f)	(((struct tuple_flags *)(&(f)))->space)
 
 int pccard_get_first_tuple(struct pcmcia_socket *s, unsigned int function,
 			tuple_t *tuple)
-- 
1.9.1

