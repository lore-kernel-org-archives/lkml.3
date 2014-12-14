Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaLNOaI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:30:08 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:45695 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbaLNOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:30:06 -0500
From: Yannis Damigos <giannis.damigos@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Jes Sorensen <Jes.Sorensen@redhat.com>, linux-wireless@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Yannis Damigos <giannis.damigos@gmail.com>
Subject: [PATCH 1/1] staging: rtl8723au: Fix sparse warnings invalid assignment |=
Date: Sun, 14 Dec 2014 16:29:25 +0200
Message-Id: <1418567365-18168-1-git-send-email-giannis.damigos@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the hal/rtl8723au_xmit.c file that fixes various
warnings:
"invalid warning: invalid assignment: |=
 left side has type unsigned int
 right side has type restricted __le32"

found by sparse tool.

Signed-off-by: Yannis Damigos <giannis.damigos@gmail.com>
---
 drivers/staging/rtl8723au/hal/rtl8723au_xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
index 6070510..e7e796e 100644
--- a/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
+++ b/drivers/staging/rtl8723au/hal/rtl8723au_xmit.c
@@ -79,7 +79,7 @@ static void fill_txdesc_sectype(struct pkt_attrib *pattrib, struct tx_desc *ptxd
 	}
 }
 
-static void fill_txdesc_vcs(struct pkt_attrib *pattrib, u32 *pdw)
+static void fill_txdesc_vcs(struct pkt_attrib *pattrib, __le32 *pdw)
 {
 	/* DBG_8723A("cvs_mode =%d\n", pattrib->vcs_mode); */
 
-- 
2.1.3

