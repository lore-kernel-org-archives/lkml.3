Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151AbaG1DJn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 23:09:43 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38716 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaG1DJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 23:09:42 -0400
From: Anil Belur <askb23@gmail.com>
X-Google-Original-From: Anil Belur
To: daeseok.youn@gmail.com, shaun@xresource.ca, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Anil Belur <askb23@gmail.com>
Subject: [PATCH 1/1] drivers: staging: cxt1e1: linux.c - missing __user annotation
Date: Mon, 28 Jul 2014 08:38:29 +0530
Message-Id: <1406516909-5338-1-git-send-email-askb23@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anil Belur <askb23@gmail.com>

- Some of the functions internally call copy_{to,from}_user() but does
  not use '__user'. this patch fixes missing __user annotations.
- this patch fixes the following sparse errors:
drivers/staging/cxt1e1/linux.c:488:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:488:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:488:33:    got void *data
drivers/staging/cxt1e1/linux.c:499:26: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/cxt1e1/linux.c:499:26:    expected void [noderef] <asn:1>*to
drivers/staging/cxt1e1/linux.c:499:26:    got void *data
drivers/staging/cxt1e1/linux.c:512:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:512:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:512:33:    got void *data
drivers/staging/cxt1e1/linux.c:534:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:534:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:534:33:    got void *data
drivers/staging/cxt1e1/linux.c:550:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:550:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:550:33:    got void *data
drivers/staging/cxt1e1/linux.c:558:26: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/cxt1e1/linux.c:558:26:    expected void [noderef] <asn:1>*to
drivers/staging/cxt1e1/linux.c:558:26:    got void *data
drivers/staging/cxt1e1/linux.c:571:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:571:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:571:33:    got void *data
drivers/staging/cxt1e1/linux.c:580:26: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/cxt1e1/linux.c:580:26:    expected void [noderef] <asn:1>*to
drivers/staging/cxt1e1/linux.c:580:26:    got void *data
drivers/staging/cxt1e1/linux.c:593:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:593:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:593:33:    got void *data
drivers/staging/cxt1e1/linux.c:601:26: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/cxt1e1/linux.c:601:26:    expected void [noderef] <asn:1>*to
drivers/staging/cxt1e1/linux.c:601:26:    got void *data
drivers/staging/cxt1e1/linux.c:612:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:612:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:612:33:    got void *data
drivers/staging/cxt1e1/linux.c:620:26: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/cxt1e1/linux.c:620:26:    expected void [noderef] <asn:1>*to
drivers/staging/cxt1e1/linux.c:620:26:    got void *data
drivers/staging/cxt1e1/linux.c:631:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:631:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:631:33:    got void *data
drivers/staging/cxt1e1/linux.c:647:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:647:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:647:33:    got void *data
drivers/staging/cxt1e1/linux.c:673:34: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:673:34:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:673:34:    got void *data
drivers/staging/cxt1e1/linux.c:681:26: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/cxt1e1/linux.c:681:26:    expected void [noderef] <asn:1>*to
drivers/staging/cxt1e1/linux.c:681:26:    got void *data
drivers/staging/cxt1e1/linux.c:691:47: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:691:47:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:691:47:    got void *data
drivers/staging/cxt1e1/linux.c:738:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:738:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:738:33:    got void *data
drivers/staging/cxt1e1/linux.c:785:33: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:785:33:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:785:33:    got void *data
drivers/staging/cxt1e1/linux.c:839:14: warning: incorrect type in assignment (different address spaces)
drivers/staging/cxt1e1/linux.c:839:14:    expected void *data
drivers/staging/cxt1e1/linux.c:839:14:    got void [noderef] <asn:1>*
drivers/staging/cxt1e1/linux.c:840:34: warning: incorrect type in argument 2 (different address spaces)
drivers/staging/cxt1e1/linux.c:840:34:    expected void const [noderef] <asn:1>*from
drivers/staging/cxt1e1/linux.c:840:34:    got void *data
drivers/staging/cxt1e1/linux.c:891:42: warning: incorrect type in argument 1 (different address spaces)
drivers/staging/cxt1e1/linux.c:891:42:    expected void [noderef] <asn:1>*to
drivers/staging/cxt1e1/linux.c:891:42:    got void *data

Signed-off-by: Anil Belur <askb23@gmail.com>
---
 drivers/staging/cxt1e1/linux.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 09f3d5c..7e16189 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -479,7 +479,7 @@ create_chan(struct net_device *ndev, ci_t *ci,
 
 /* the idea here is to get port information and pass it back (using pointer) */
 static status_t
-do_get_port(struct net_device *ndev, void *data)
+do_get_port(struct net_device *ndev, void __user *data)
 {
 	int         ret;
 	ci_t       *ci;             /* ci stands for card information */
@@ -504,7 +504,7 @@ do_get_port(struct net_device *ndev, void *data)
 
 /* this function copys the user data and then calls the real action function */
 static status_t
-do_set_port(struct net_device *ndev, void *data)
+do_set_port(struct net_device *ndev, void __user *data)
 {
 	ci_t       *ci;             /* ci stands for card information */
 	struct sbecom_port_param pp;/* copy data to kernel land */
@@ -526,7 +526,7 @@ do_set_port(struct net_device *ndev, void *data)
 
 /* work the port loopback mode as per directed */
 static status_t
-do_port_loop(struct net_device *ndev, void *data)
+do_port_loop(struct net_device *ndev, void __user *data)
 {
 	struct sbecom_port_param pp;
 	ci_t       *ci;
@@ -541,7 +541,7 @@ do_port_loop(struct net_device *ndev, void *data)
 
 /* set the specified register with the given value / or just read it */
 static status_t
-do_framer_rw(struct net_device *ndev, void *data)
+do_framer_rw(struct net_device *ndev, void __user *data)
 {
 	struct sbecom_port_param pp;
 	ci_t       *ci;
@@ -562,7 +562,7 @@ do_framer_rw(struct net_device *ndev, void *data)
 
 /* set the specified register with the given value / or just read it */
 static status_t
-do_pld_rw(struct net_device *ndev, void *data)
+do_pld_rw(struct net_device *ndev, void __user *data)
 {
 	struct sbecom_port_param pp;
 	ci_t       *ci;
@@ -584,7 +584,7 @@ do_pld_rw(struct net_device *ndev, void *data)
 
 /* set the specified register with the given value / or just read it */
 static status_t
-do_musycc_rw(struct net_device *ndev, void *data)
+do_musycc_rw(struct net_device *ndev, void __user *data)
 {
 	struct c4_musycc_param mp;
 	ci_t       *ci;
@@ -604,7 +604,7 @@ do_musycc_rw(struct net_device *ndev, void *data)
 }
 
 static status_t
-do_get_chan(struct net_device *ndev, void *data)
+do_get_chan(struct net_device *ndev, void __user *data)
 {
 	struct sbecom_chan_param cp;
 	int         ret;
@@ -623,7 +623,7 @@ do_get_chan(struct net_device *ndev, void *data)
 }
 
 static status_t
-do_set_chan(struct net_device *ndev, void *data)
+do_set_chan(struct net_device *ndev, void __user *data)
 {
 	struct sbecom_chan_param cp;
 	ci_t       *ci;
@@ -637,7 +637,7 @@ do_set_chan(struct net_device *ndev, void *data)
 }
 
 static status_t
-do_create_chan(struct net_device *ndev, void *data)
+do_create_chan(struct net_device *ndev, void __user *data)
 {
 	ci_t       *ci;
 	struct net_device *dev;
@@ -665,7 +665,7 @@ do_create_chan(struct net_device *ndev, void *data)
 }
 
 static status_t
-do_get_chan_stats(struct net_device *ndev, void *data)
+do_get_chan_stats(struct net_device *ndev, void __user *data)
 {
 	struct c4_chan_stats_wrap ccs;
 	int         ret;
@@ -684,7 +684,7 @@ do_get_chan_stats(struct net_device *ndev, void *data)
 	return 0;
 }
 static status_t
-do_set_loglevel(struct net_device *ndev, void *data)
+do_set_loglevel(struct net_device *ndev, void __user *data)
 {
 	unsigned int cxt1e1_log_level;
 
@@ -728,7 +728,7 @@ do_deluser(struct net_device *ndev, int lockit)
 }
 
 int
-do_del_chan(struct net_device *musycc_dev, void *data)
+do_del_chan(struct net_device *musycc_dev, void __user *data)
 {
 	struct sbecom_chan_param cp;
 	char        buf[sizeof(CHANNAME) + 3];
@@ -752,7 +752,7 @@ do_del_chan(struct net_device *musycc_dev, void *data)
 int c4_reset_board(void *);
 
 int
-do_reset(struct net_device *musycc_dev, void *data)
+do_reset(struct net_device *musycc_dev, void __user *data)
 {
 	const struct c4_priv *priv;
 	int         i;
@@ -778,7 +778,7 @@ do_reset(struct net_device *musycc_dev, void *data)
 }
 
 int
-do_reset_chan_stats(struct net_device *musycc_dev, void *data)
+do_reset_chan_stats(struct net_device *musycc_dev, void __user *data)
 {
 	struct sbecom_chan_param cp;
 
@@ -792,7 +792,7 @@ static status_t
 c4_ioctl(struct net_device *ndev, struct ifreq *ifr, int cmd)
 {
 	ci_t       *ci;
-	void       *data;
+	void       __user *data;
 	int         iocmd, iolen;
 	status_t    ret;
 	static struct data {
-- 
1.9.1

