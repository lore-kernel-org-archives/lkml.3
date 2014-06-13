Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaFMHkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 03:40:13 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:52148 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbaFMHkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 03:40:11 -0400
Date: Fri, 13 Jun 2014 16:39:16 +0900
From: Daeseok Youn <daeseok.youn@gmail.com>
To: lidza.louina@gmail.com, gregkh@linuxfoundation.org
Cc: markh@compro.net, dan.carpenter@oracle.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/9] staging: dgap: remove unused paramter in dgap_parsefile()
Message-ID: <20140613073916.GA31586@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"remove" parameter is not used in dgap_parsefile().

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/dgap/dgap.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/dgap/dgap.c b/drivers/staging/dgap/dgap.c
index 38749d0..c1f2798 100644
--- a/drivers/staging/dgap/dgap.c
+++ b/drivers/staging/dgap/dgap.c
@@ -174,7 +174,7 @@ static void dgap_remove_tty_sysfs(struct device *c);
 /*
  * Function prototypes from dgap_parse.h
  */
-static int dgap_parsefile(char **in, int remove);
+static int dgap_parsefile(char **in);
 static struct cnode *dgap_find_config(int type, int bus, int slot);
 static uint dgap_config_get_num_prts(struct board_t *bd);
 static char *dgap_create_config_string(struct board_t *bd, char *string);
@@ -852,7 +852,7 @@ static int dgap_firmware_load(struct pci_dev *pdev, int card_type)
 		 */
 		tmp_ptr = dgap_config_buf;
 
-		if (dgap_parsefile(&tmp_ptr, TRUE) != 0) {
+		if (dgap_parsefile(&tmp_ptr) != 0) {
 			kfree(dgap_config_buf);
 			return -EINVAL;
 		}
@@ -6427,7 +6427,7 @@ static void dgap_remove_tty_sysfs(struct device *c)
 /*
  * Parse a configuration file read into memory as a string.
  */
-static int dgap_parsefile(char **in, int remove)
+static int dgap_parsefile(char **in)
 {
 	struct cnode *p, *brd, *line, *conc;
 	int rc;
-- 
1.7.1

