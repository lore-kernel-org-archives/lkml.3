Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933879Ab3AOXUr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 18:20:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:47330 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933858Ab3AOWxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:53:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Yehuda Sadeh <yehuda@inktank.com>
Subject: [ 156/171] rbd: kill notify_timeout option
Date: Tue, 15 Jan 2013 14:45:21 -0800
Message-Id: <20130115224324.589036545@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

The "notify_timeout" rbd device option is never used, so get rid of
it.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Yehuda Sadeh <yehuda@inktank.com>
(cherry picked from commit 84d34dcc116e117a41c6fc8be13430529fc2d9e7)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -71,7 +71,6 @@
 #define DEV_NAME_LEN		32
 #define MAX_INT_FORMAT_WIDTH	((5 * sizeof (int)) / 2 + 1)
 
-#define RBD_NOTIFY_TIMEOUT_DEFAULT	10
 #define RBD_READ_ONLY_DEFAULT		false
 
 /*
@@ -95,7 +94,6 @@ struct rbd_image_header {
 };
 
 struct rbd_options {
-	int	notify_timeout;
 	bool	read_only;
 };
 
@@ -343,7 +341,6 @@ static struct rbd_client *__rbd_client_f
  * mount options
  */
 enum {
-	Opt_notify_timeout,
 	Opt_last_int,
 	/* int args above */
 	Opt_last_string,
@@ -355,7 +352,6 @@ enum {
 };
 
 static match_table_t rbdopt_tokens = {
-	{Opt_notify_timeout, "notify_timeout=%d"},
 	/* int args above */
 	/* string args above */
 	{Opt_read_only, "read_only"},
@@ -394,9 +390,6 @@ static int parse_rbd_opts_token(char *c,
 	}
 
 	switch (token) {
-	case Opt_notify_timeout:
-		rbdopt->notify_timeout = intval;
-		break;
 	case Opt_read_only:
 		rbdopt->read_only = true;
 		break;
@@ -425,7 +418,6 @@ static struct rbd_client *rbd_get_client
 	if (!rbd_opts)
 		return ERR_PTR(-ENOMEM);
 
-	rbd_opts->notify_timeout = RBD_NOTIFY_TIMEOUT_DEFAULT;
 	rbd_opts->read_only = RBD_READ_ONLY_DEFAULT;
 
 	opt = ceph_parse_options(options, mon_addr,


