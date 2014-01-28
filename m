Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaA1Sly (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:41:54 -0500
Received: from smtprelay0212.hostedemail.com ([216.40.44.212]:59091 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755172AbaA1Slx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:41:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:1981:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3865:3871:4384:5007:7652:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pets76_4a620af4ac15e
X-Filterd-Recvd-Size: 1394
Message-ID: <1390934510.11756.14.camel@joe-AO722>
Subject: [PATCH] fmc: Fix decimal permissions
From: Joe Perches <joe@perches.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 28 Jan 2014 10:41:50 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This 444 should have been octal.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/fmc/fmc-write-eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/fmc/fmc-write-eeprom.c b/drivers/fmc/fmc-write-eeprom.c
index 30e451e..1f107fb 100644
--- a/drivers/fmc/fmc-write-eeprom.c
+++ b/drivers/fmc/fmc-write-eeprom.c
@@ -26,7 +26,7 @@ FMC_PARAM_BUSID(fwe_drv);
 /* The "file=" is like the generic "gateware=" used elsewhere */
 static char *fwe_file[FMC_MAX_CARDS];
 static int fwe_file_n;
-module_param_array_named(file, fwe_file, charp, &fwe_file_n, 444);
+module_param_array_named(file, fwe_file, charp, &fwe_file_n, 0444);
 
 static int fwe_run_tlv(struct fmc_device *fmc, const struct firmware *fw,
 	int write)


