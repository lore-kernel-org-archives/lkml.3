Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaBUWqu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:46:50 -0500
Received: from smtprelay0203.hostedemail.com ([216.40.44.203]:51498 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755500AbaBUWqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:46:47 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3876:3877:4321:5007:6114:6119:6642:7652:8603:10004:10400:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: use85_7534d6f790b2c
X-Filterd-Recvd-Size: 3006
Message-ID: <1393022803.2594.27.camel@joe-AO722>
Subject: [PATCH net-next] ath9k: Use static const
From: Joe Perches <joe@perches.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 14:46:43 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivially reduces text size too.

$ size drivers/net/wireless/ath/ath9k/debug.o*
   text	   data	    bss	    dec	    hex	filename
  34436	   2528	   5128	  42092	   a46c	drivers/net/wireless/ath/ath9k/debug.o.new
  34464	   2528	   5128	  42120	   a488	drivers/net/wireless/ath/ath9k/debug.o.old

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ath9k/debug.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index ab7264c..9131175 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -135,7 +135,8 @@ static ssize_t read_file_ani(struct file *file, char __user *user_buf,
 	struct ath_softc *sc = file->private_data;
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_hw *ah = sc->sc_ah;
-	unsigned int len = 0, size = 1024;
+	unsigned int len = 0;
+	const unsigned int size = 1024;
 	ssize_t retval = 0;
 	char *buf;
 
@@ -307,13 +308,13 @@ static ssize_t read_file_antenna_diversity(struct file *file,
 	struct ath_antenna_stats *as_main = &sc->debug.stats.ant_stats[ANT_MAIN];
 	struct ath_antenna_stats *as_alt = &sc->debug.stats.ant_stats[ANT_ALT];
 	struct ath_hw_antcomb_conf div_ant_conf;
-	unsigned int len = 0, size = 1024;
+	unsigned int len = 0;
+	const unsigned int size = 1024;
 	ssize_t retval = 0;
 	char *buf;
-	char *lna_conf_str[4] = {"LNA1_MINUS_LNA2",
-				 "LNA2",
-				 "LNA1",
-				 "LNA1_PLUS_LNA2"};
+	static const char *lna_conf_str[4] = {
+		"LNA1_MINUS_LNA2", "LNA2", "LNA1", "LNA1_PLUS_LNA2"
+	};
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)
@@ -716,10 +717,13 @@ static ssize_t read_file_queues(struct file *file, char __user *user_buf,
 	struct ath_softc *sc = file->private_data;
 	struct ath_txq *txq;
 	char *buf;
-	unsigned int len = 0, size = 1024;
+	unsigned int len = 0;
+	const unsigned int size = 1024;
 	ssize_t retval = 0;
 	int i;
-	char *qname[4] = {"VO", "VI", "BE", "BK"};
+	static const char *qname[4] = {
+		"VO", "VI", "BE", "BK"
+	};
 
 	buf = kzalloc(size, GFP_KERNEL);
 	if (buf == NULL)


