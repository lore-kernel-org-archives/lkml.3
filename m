Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbaGZOBm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 10:01:42 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:34907 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751562AbaGZOBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 10:01:40 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Chris Metcalf <cmetcalf@tilera.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] arch: tile: gxio: mpipe.c:  Cleaning up missing null-terminate in conjunction with strncpy
Date: Sat, 26 Jul 2014 16:03:05 +0200
Message-Id: <1406383386-1400-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing strncpy with strlcpy to avoid strings that lacks null terminate.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 arch/tile/gxio/mpipe.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/tile/gxio/mpipe.c b/arch/tile/gxio/mpipe.c
index 5301a9f..4f1eefb 100644
--- a/arch/tile/gxio/mpipe.c
+++ b/arch/tile/gxio/mpipe.c
@@ -511,8 +511,7 @@ int gxio_mpipe_link_instance(const char *link_name)
 	if (!context)
 		return GXIO_ERR_NO_DEVICE;
 
-	strncpy(name.name, link_name, sizeof(name.name));
-	name.name[GXIO_MPIPE_LINK_NAME_LEN - 1] = '\0';
+	strlcpy(name.name, link_name, sizeof(name.name));
 
 	return gxio_mpipe_info_instance_aux(context, name);
 }
@@ -529,7 +528,7 @@ int gxio_mpipe_link_enumerate_mac(int idx, char *link_name, uint8_t *link_mac)
 
 	rv = gxio_mpipe_info_enumerate_aux(context, idx, &name, &mac);
 	if (rv >= 0) {
-		strncpy(link_name, name.name, sizeof(name.name));
+		strlcpy(link_name, name.name, sizeof(name.name));
 		memcpy(link_mac, mac.mac, sizeof(mac.mac));
 	}
 
@@ -545,8 +544,7 @@ int gxio_mpipe_link_open(gxio_mpipe_link_t *link,
 	_gxio_mpipe_link_name_t name;
 	int rv;
 
-	strncpy(name.name, link_name, sizeof(name.name));
-	name.name[GXIO_MPIPE_LINK_NAME_LEN - 1] = '\0';
+	strlcpy(name.name, link_name, sizeof(name.name));
 
 	rv = gxio_mpipe_link_open_aux(context, name, flags);
 	if (rv < 0)
-- 
1.7.10.4

