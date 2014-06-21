Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933343AbaFUMFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 08:05:07 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:56679 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758208AbaFUMFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 08:05:04 -0400
Date: Sat, 21 Jun 2014 13:05:00 +0100
From: Daniel Walter <dwalter@google.com>
To: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org
Subject: [PATCH 3/9] [arch/arm/mach-s3c24xx] replace strict_strto* with
 kstrto*
Message-ID: <20140621120500.GA6288@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Replace obsolete strict_strto call with kstrto

Signed-off-by: Daniel Walter <dwalter@google.com>
---
 arch/arm/mach-s3c24xx/mach-jive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-s3c24xx/mach-jive.c b/arch/arm/mach-s3c24xx/mach-jive.c
index e81ea82..bac9bb5 100644
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
2.0.0.526.g5318336

