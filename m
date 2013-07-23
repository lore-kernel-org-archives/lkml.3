Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934900Ab3GWW16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41846 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934856Ab3GWW1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>, Ben Skeggs <bskeggs@redhat.com>
Subject: [ 086/103] drm/nva3/disp: Fix HDMI audio regression
Date: Tue, 23 Jul 2013 15:26:37 -0700
Message-Id: <20130723220430.379954739@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

commit bf03d1b293cc556df53545e318110505014d805e upstream.

This is the nva3 counterpart to commit beba44b17 (drm/nv84/disp: Fix
HDMI audio regression). The regression happened as a result of
refactoring in commit 8e9e3d2de (drm/nv84/disp: move hdmi control into
core).

Reported-and-tested-by: Max Baldwin <archerseven@gmail.com>
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c
+++ b/drivers/gpu/drm/nouveau/core/engine/disp/hdminva3.c
@@ -55,6 +55,10 @@ nva3_hdmi_ctrl(struct nv50_disp_priv *pr
 	nv_wr32(priv, 0x61c510 + soff, 0x00000000);
 	nv_mask(priv, 0x61c500 + soff, 0x00000001, 0x00000001);
 
+	nv_mask(priv, 0x61c5d0 + soff, 0x00070001, 0x00010001); /* SPARE, HW_CTS */
+	nv_mask(priv, 0x61c568 + soff, 0x00010101, 0x00000000); /* ACR_CTRL, ?? */
+	nv_mask(priv, 0x61c578 + soff, 0x80000000, 0x80000000); /* ACR_0441_ENABLE */
+
 	/* ??? */
 	nv_mask(priv, 0x61733c, 0x00100000, 0x00100000); /* RESETF */
 	nv_mask(priv, 0x61733c, 0x10000000, 0x10000000); /* LOOKUP_EN */


