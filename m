Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687AbaKIKcT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 05:32:19 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54802 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbaKIKcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 05:32:17 -0500
Message-ID: <545F42A3.5050108@gmail.com>
Date: Sun, 09 Nov 2014 18:32:03 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "cmetcalf@tilera.com" <cmetcalf@tilera.com>, rdunlap@infradead.org,
        rickard_strandqvist@spectrumdigital.se
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch: tile: gxio: Export symbols for module using in 'mpipe.c'
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'gxio_mpipe_adjust_timestamp', 'gxio_mpipe_link_instance',
'gxio_mpipe_get_timestamp', and 'gxio_mpipe_set_timestamp' may be use by
other tile modules, so export them.

The related error (with allmodconfig under tile):

    MODPOST 4002 modules
  ERROR: "gxio_mpipe_link_instance" [drivers/net/ethernet/tile/tile_net.ko] undefined!
  ERROR: "gxio_mpipe_get_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
  ERROR: "gxio_mpipe_set_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!
  ERROR: "gxio_mpipe_adjust_timestamp" [drivers/net/ethernet/tile/tile_net.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/tile/gxio/mpipe.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/tile/gxio/mpipe.c b/arch/tile/gxio/mpipe.c
index 320ff5e..6f00e985 100644
--- a/arch/tile/gxio/mpipe.c
+++ b/arch/tile/gxio/mpipe.c
@@ -463,6 +463,7 @@ int gxio_mpipe_set_timestamp(gxio_mpipe_context_t *context,
 					    (uint64_t)ts->tv_nsec,
 					    (uint64_t)cycles);
 }
+EXPORT_SYMBOL_GPL(gxio_mpipe_set_timestamp);
 
 int gxio_mpipe_get_timestamp(gxio_mpipe_context_t *context,
 			     struct timespec *ts)
@@ -485,11 +486,13 @@ int gxio_mpipe_get_timestamp(gxio_mpipe_context_t *context,
 	}
 	return ret;
 }
+EXPORT_SYMBOL_GPL(gxio_mpipe_get_timestamp);
 
 int gxio_mpipe_adjust_timestamp(gxio_mpipe_context_t *context, int64_t delta)
 {
 	return gxio_mpipe_adjust_timestamp_aux(context, delta);
 }
+EXPORT_SYMBOL_GPL(gxio_mpipe_adjust_timestamp);
 
 /* Get our internal context used for link name access.  This context is
  *  special in that it is not associated with an mPIPE service domain.
@@ -542,6 +545,7 @@ int gxio_mpipe_link_instance(const char *link_name)
 
 	return gxio_mpipe_info_instance_aux(context, name);
 }
+EXPORT_SYMBOL_GPL(gxio_mpipe_link_instance);
 
 int gxio_mpipe_link_enumerate_mac(int idx, char *link_name, uint8_t *link_mac)
 {
-- 
1.9.3
