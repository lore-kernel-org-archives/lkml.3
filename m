Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933323Ab3FRQWc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:22:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187Ab3FRQSE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:18:04 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [ 33/48] drm/nv50/kms: use dac loadval from vbios, where its available
Date: Tue, 18 Jun 2013 09:17:59 -0700
Message-Id: <20130618161730.688635361@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit d40ee48acde16894fb3b241d7e896d5fa84e0f10 upstream.

Regression from merging the old nv50/nvd9 code together, and may be
needed to fully fix fdo#64904.

The value is ignored completely by the hardware starting from nva3.

Reported-by: Emil Velikov <emil.l.velikov@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>

---
 drivers/gpu/drm/nouveau/nv50_display.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -1554,7 +1554,9 @@ nv50_dac_detect(struct drm_encoder *enco
 {
 	struct nv50_disp *disp = nv50_disp(encoder->dev);
 	int ret, or = nouveau_encoder(encoder)->or;
-	u32 load = 0;
+	u32 load = nouveau_drm(encoder->dev)->vbios.dactestval;
+	if (load == 0)
+		load = 340;
 
 	ret = nv_exec(disp->core, NV50_DISP_DAC_LOAD + or, &load, sizeof(load));
 	if (ret || load != 7)


