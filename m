Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaHFFYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:24:45 -0400
Received: from mail-bn1blp0185.outbound.protection.outlook.com ([207.46.163.185]:53256
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754113AbaHFFYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:24:44 -0400
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <arnd@arndb.de>, <gregkh@linuxfoundation.org>, <tytso@mit.edu>
CC: <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] random: remove the unused parameter to avoid the compile warning.
Date: Wed, 6 Aug 2014 13:20:39 +0800
Message-ID: <1407302439-642-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.5
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.158.2;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(189002)(199002)(2201001)(92726001)(92566001)(102836001)(93916002)(86362001)(26826002)(88136002)(62966002)(44976005)(6806004)(84676001)(19580395003)(83322001)(31966008)(21056001)(77156001)(36756003)(74662001)(85852003)(74502001)(99396002)(83072002)(19580405001)(104166001)(89996001)(50986999)(97736001)(50226001)(107046002)(87936001)(87286001)(2171001)(79102001)(104016003)(229853001)(105606002)(77982001)(47776003)(85306004)(81156004)(20776003)(106466001)(95666004)(81542001)(4396001)(81342001)(68736004)(69596002)(80022001)(46102001)(50466002)(64706001)(76482001)(48376002);DIR:OUT;SFP:;SCL:1;SRVR:BN1PR0301MB0610;H:az84smr01.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02951C14DC
Authentication-Results: spf=fail (sender IP is 192.88.158.2)
 smtp.mailfrom=Li.Xiubo@freescale.com; 
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/char/random.c: In function SYSC_getrandom:
drivers/char/random.c:1526:6: warning: unused variable r [-Wunused-variable]
  int r;
      ^
Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/char/random.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 37d8970..c18d41d 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1523,8 +1523,6 @@ const struct file_operations urandom_fops = {
 SYSCALL_DEFINE3(getrandom, char __user *, buf, size_t, count,
 		unsigned int, flags)
 {
-	int r;
-
 	if (flags & ~(GRND_NONBLOCK|GRND_RANDOM))
 		return -EINVAL;
 
-- 
1.8.5

