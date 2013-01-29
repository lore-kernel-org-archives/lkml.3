Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3A2Dfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:35:39 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:55132 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756392Ab3A2Dff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:35 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 03/11] staging/fwserial: Fix sparse build warnings
Date: Mon, 28 Jan 2013 22:34:37 -0500
Message-Id: <1359430485-5301-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reported-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.c | 4 +++-
 drivers/staging/fwserial/fwserial.h | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
index 055085d..473a2db 100644
--- a/drivers/staging/fwserial/fwserial.c
+++ b/drivers/staging/fwserial/fwserial.c
@@ -78,6 +78,8 @@ static int num_ports;
 /* slab used as pool for struct fwtty_transactions */
 static struct kmem_cache *fwtty_txn_cache;
 
+struct tty_driver *fwtty_driver;
+
 struct fwtty_transaction;
 typedef void (*fwtty_transaction_cb)(struct fw_card *card, int rcode,
 				     void *data, size_t length,
@@ -2543,7 +2545,7 @@ static struct fw_descriptor fwserial_unit_directory = {
  * The management address is in the unit space region but above other known
  * address users (to keep wild writes from causing havoc)
  */
-const struct fw_address_region fwserial_mgmt_addr_region = {
+static const struct fw_address_region fwserial_mgmt_addr_region = {
 	.start = CSR_REGISTER_BASE + 0x1e0000ULL,
 	.end = 0x1000000000000ULL,
 };
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index 953ece6..3602809 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -352,7 +352,7 @@ struct fw_serial {
 static const char tty_dev_name[] =  TTY_DEV_NAME;
 static const char loop_dev_name[] = "fwloop";
 
-struct tty_driver *fwtty_driver;
+extern struct tty_driver *fwtty_driver;
 
 #define driver_err(s, v...)	pr_err(KBUILD_MODNAME ": " s, ##v)
 
-- 
1.8.1.1

