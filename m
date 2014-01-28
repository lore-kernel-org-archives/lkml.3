Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134AbaA1TMn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 14:12:43 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:36979 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754779AbaA1TMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 14:12:42 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Corey Minyard <minyard@acm.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: openipmi-developer@lists.sourceforge.net, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] ipmi: Add missing rv in ipmi_parisc_probe()
Date: Tue, 28 Jan 2014 20:12:35 +0100
Message-Id: <1390936355-11845-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/ipmi/ipmi_si_intf.c: In function 'ipmi_parisc_probe':
drivers/char/ipmi/ipmi_si_intf.c:2752:2: error: 'rv' undeclared (first use in this function)
drivers/char/ipmi/ipmi_si_intf.c:2752:2: note: each undeclared identifier is reported only once for each function it appears in

Introduced by commit d02b3709ff8efebfca0612d0ac2a6e31a91c13f4 ("ipmi:
Cleanup error return")

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
http://kisskb.ellerman.id.au/kisskb/buildresult/10537567/

 drivers/char/ipmi/ipmi_si_intf.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 671c3852d359..03f41896d090 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2724,6 +2724,7 @@ static struct platform_driver ipmi_driver = {
 static int ipmi_parisc_probe(struct parisc_device *dev)
 {
 	struct smi_info *info;
+	int rv;
 
 	info = smi_info_alloc();
 
-- 
1.7.9.5

