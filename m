Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab3CLFFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:05:12 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:29206 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab3CLFFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:05:10 -0400
X-IronPort-AV: E=Sophos;i="4.84,827,1355068800"; 
   d="scan'208";a="6856278"
Message-ID: <513EB727.2070000@cn.fujitsu.com>
Date: Tue, 12 Mar 2013 13:03:35 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: devel@driverdev.osuosl.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 05/18] driver: staging: csr: remove cast for kmalloc return
 value
References: <513EB23D.7020303@cn.fujitsu.com>
In-Reply-To: <513EB23D.7020303@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:03:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/12 13:03:56,
	Serialize complete at 2013/03/12 13:03:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

remove cast for kmalloc return value.

Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: devel@driverdev.osuosl.org
---
 drivers/staging/csr/drv.c                  |    4 ++--
 drivers/staging/csr/netdev.c               |    2 +-
 drivers/staging/csr/sdio_mmc.c             |    3 +--
 drivers/staging/csr/sme_native.c           |    2 +-
 drivers/staging/csr/unifi_pdu_processing.c |    4 ++--
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/csr/drv.c b/drivers/staging/csr/drv.c
index 3bd52fd..5520d65 100644
--- a/drivers/staging/csr/drv.c
+++ b/drivers/staging/csr/drv.c
@@ -1815,7 +1815,7 @@ udi_log_event(ul_client_t *pcli,
     }
 
     /* Allocate log structure plus actual signal. */
-    logptr = (udi_log_t *)kmalloc(sizeof(udi_log_t) + total_len, GFP_KERNEL);
+    logptr = kmalloc(sizeof(udi_log_t) + total_len, GFP_KERNEL);
 
     if (logptr == NULL) {
         printk(KERN_ERR
@@ -1890,7 +1890,7 @@ uf_sme_queue_message(unifi_priv_t *priv, u8 *buffer, int length)
     }
 
     /* Allocate log structure plus actual signal. */
-    logptr = (udi_log_t *)kmalloc(sizeof(udi_log_t) + length, GFP_ATOMIC);
+    logptr = kmalloc(sizeof(udi_log_t) + length, GFP_ATOMIC);
     if (logptr == NULL) {
         unifi_error(priv, "Failed to allocate %d bytes for an SME message\n",
                     sizeof(udi_log_t) + length);
diff --git a/drivers/staging/csr/netdev.c b/drivers/staging/csr/netdev.c
index 7dad26f..a0177d9 100644
--- a/drivers/staging/csr/netdev.c
+++ b/drivers/staging/csr/netdev.c
@@ -2365,7 +2365,7 @@ unifi_rx(unifi_priv_t *priv, CSR_SIGNAL *signal, bulk_data_param_t *bulkdata)
         rx_buffered_packets_t *rx_q_item;
         struct list_head *rx_list;
 
-        rx_q_item = (rx_buffered_packets_t *)kmalloc(sizeof(rx_buffered_packets_t),
+        rx_q_item = kmalloc(sizeof(rx_buffered_packets_t),
                 GFP_KERNEL);
         if (rx_q_item == NULL) {
             unifi_error(priv, "%s: Failed to allocate %d bytes for rx packet record\n",
diff --git a/drivers/staging/csr/sdio_mmc.c b/drivers/staging/csr/sdio_mmc.c
index b6a16de..30271d3 100644
--- a/drivers/staging/csr/sdio_mmc.c
+++ b/drivers/staging/csr/sdio_mmc.c
@@ -1031,8 +1031,7 @@ uf_glue_sdio_probe(struct sdio_func *func,
            sdio_func_id(func), instance);
 
     /* Allocate context */
-    sdio_ctx = (CsrSdioFunction *)kmalloc(sizeof(CsrSdioFunction),
-                                          GFP_KERNEL);
+    sdio_ctx = kmalloc(sizeof(CsrSdioFunction), GFP_KERNEL);
     if (sdio_ctx == NULL) {
         sdio_release_host(func);
         return -ENOMEM;
diff --git a/drivers/staging/csr/sme_native.c b/drivers/staging/csr/sme_native.c
index 525fe1b..ca55249 100644
--- a/drivers/staging/csr/sme_native.c
+++ b/drivers/staging/csr/sme_native.c
@@ -273,7 +273,7 @@ sme_native_log_event(ul_client_t *pcli,
     }
 
     /* Allocate log structure plus actual signal. */
-    logptr = (udi_log_t *)kmalloc(sizeof(udi_log_t) + total_len, GFP_KERNEL);
+    logptr = kmalloc(sizeof(udi_log_t) + total_len, GFP_KERNEL);
 
     if (logptr == NULL) {
         unifi_error(priv,
diff --git a/drivers/staging/csr/unifi_pdu_processing.c b/drivers/staging/csr/unifi_pdu_processing.c
index 95efc36..bf7c00a 100644
--- a/drivers/staging/csr/unifi_pdu_processing.c
+++ b/drivers/staging/csr/unifi_pdu_processing.c
@@ -403,7 +403,7 @@ CsrResult enque_tx_data_pdu(unifi_priv_t *priv, bulk_data_param_t *bulkdata,
 
 
 
-    tx_q_item = (tx_buffered_packets_t *)kmalloc(sizeof(tx_buffered_packets_t), GFP_ATOMIC);
+    tx_q_item = kmalloc(sizeof(tx_buffered_packets_t), GFP_ATOMIC);
     if (tx_q_item == NULL) {
         unifi_error(priv,
                 "Failed to allocate %d bytes for tx packet record\n",
@@ -3282,7 +3282,7 @@ void add_to_send_cfm_list(unifi_priv_t * priv,
 {
     tx_buffered_packets_t *send_cfm_list_item = NULL;
 
-    send_cfm_list_item = (tx_buffered_packets_t *) kmalloc(sizeof(tx_buffered_packets_t), GFP_ATOMIC);
+    send_cfm_list_item = kmalloc(sizeof(tx_buffered_packets_t), GFP_ATOMIC);
 
     if(send_cfm_list_item == NULL){
         unifi_warning(priv, "%s: Failed to allocate memory for new list item \n");
-- 
1.7.1
