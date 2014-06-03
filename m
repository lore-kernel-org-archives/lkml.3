Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932883AbaFCPTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 11:19:17 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:52918 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286AbaFCPTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 11:19:16 -0400
Date: Tue, 3 Jun 2014 16:19:12 +0100
From: Daniel Walter <dwalter@google.com>
To: linux-kernel@vger.kernel.org
Cc: richard@nod.at, akpm@linux-foundation.org, ben-linux@fluff.org
Subject: [PATCH v2 03/11] [arch/arm/mach-s3c24xx] replace strict_strto* with
 kstrto*
Message-ID: <20140603151912.GE28580@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Walter <dwalter@google.com>
Subject: [PATCH v2 03/11] [arch/arm/mach-s3c24xx] replace strict_strto* with kstrto*

Replace obsolete strict_strto call with kstrto

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/arm/mach-s3c24xx/mach-jive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index 5faa723..a4024c2 100644
--- a/arch/arm/mach-s3c24xx/mach-jive.c
+++ b/arch/arm/mach-s3c24xx/mach-jive.c
@@ -243,7 +243,7 @@ static int __init jive_mtdset(char *options)
 	if (options == NULL || options[0] == '\0')
 		return 0;
 
-	if (strict_strtoul(options, 10, &set)) {
+	if (kstrtoul(options, 10, &set)) {
 		printk(KERN_ERR "failed to parse mtdset=%s\n", options);
 		return 0;
 	}
-- 
1.9.3

