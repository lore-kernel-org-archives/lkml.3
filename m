Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbaJVQsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:48:51 -0400
Received: from mout.web.de ([212.227.17.12]:52518 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbaJVQss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:48:48 -0400
Message-ID: <5447DFD5.5020905@users.sourceforge.net>
Date: Wed, 22 Oct 2014 18:48:21 +0200
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Matt Roper <matthew.d.roper@intel.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Thomas Wood <thomas.wood@intel.com>, Rob Clark <robdclark@gmail.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Arthur Borsboom <arthurborsboom@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        Benoit Taine <benoit.taine@lip6.fr>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, trivial@kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] GPU-DRM-GMA500: Deletion of unnecessary checks before
 two function calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:I1N/CwFQ5zuvv9QFxD79crt/q+OayaAHAdtUaUEsVK2pi5t/G0E
 ZcncdAw7BEP3n/gbF7LcWHu6grojgRRA+gB21BSgmk6DMSFpXNE+TYLPC+GZiyFwrX3cXHs
 bKhdbZlX0qfIxic7x1gG5QSiJsJDiqoXydd0x6cqwJPv3opVXWz7mb5nmj8vXIP8V/tnhJ7
 cKOgCqTXEMizjb85C27Ww==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If you are convinced that dropping the null tests is a good idea, then you 
>> can submit the patch that makes the change to the relevant maintainers and 
>> mailing lists.

Would you like to integrate the following proposal into your source code repository?

Regards,
Markus


>From e61965bbcb143a54696fbd468989110519e41497 Mon Sep 17 00:00:00 2001
From: Markus Elfring <elfring@users.sourceforge.net>
Date: Wed, 22 Oct 2014 18:28:12 +0200
Subject: [PATCH] GPU-DRM-GMA500: Deletion of unnecessary checks before two
 function calls

A semantic patch approach was proposed with the subject "[PATCH with
Coccinelle?] Deletion of unnecessary checks before specific function calls"
on 2014-03-05.
https://lkml.org/lkml/2014/3/5/344
http://article.gmane.org/gmane.comp.version-control.coccinelle/3513/

This patch pattern application was repeated with the help of the software
"Coccinelle 1.0.0-rc22" on the source files for Linux 3.17.1. An extract
of the automatically generated update suggestions is shown here.

It was determined that the affected source code places call functions
which perform input parameter validation already. It is therefore not
needed that a similar safety check is repeated at the call site.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/gpu/drm/gma500/cdv_intel_hdmi.c | 3 +--
 drivers/gpu/drm/gma500/cdv_intel_lvds.c | 9 +++------
 drivers/gpu/drm/gma500/oaktrail_lvds.c  | 3 +--
 drivers/gpu/drm/gma500/psb_drv.c        | 3 +--
 drivers/gpu/drm/gma500/psb_intel_lvds.c | 9 +++------
 5 files changed, 9 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
index 4268bf2..0d69624 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_hdmi.c
@@ -246,8 +246,7 @@ static void cdv_hdmi_destroy(struct drm_connector *connector)
 {
 	struct gma_encoder *gma_encoder = gma_attached_encoder(connector);

-	if (gma_encoder->i2c_bus)
-		psb_intel_i2c_destroy(gma_encoder->i2c_bus);
+	psb_intel_i2c_destroy(gma_encoder->i2c_bus);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
diff --git a/drivers/gpu/drm/gma500/cdv_intel_lvds.c
b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
index 0b77039..8f24013 100644
--- a/drivers/gpu/drm/gma500/cdv_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/cdv_intel_lvds.c
@@ -444,8 +444,7 @@ static void cdv_intel_lvds_destroy(struct drm_connector
*connector)
 {
 	struct gma_encoder *gma_encoder = gma_attached_encoder(connector);

-	if (gma_encoder->i2c_bus)
-		psb_intel_i2c_destroy(gma_encoder->i2c_bus);
+	psb_intel_i2c_destroy(gma_encoder->i2c_bus);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -780,12 +779,10 @@ out:
 failed_find:
 	mutex_unlock(&dev->mode_config.mutex);
 	printk(KERN_ERR "Failed find\n");
-	if (gma_encoder->ddc_bus)
-		psb_intel_i2c_destroy(gma_encoder->ddc_bus);
+	psb_intel_i2c_destroy(gma_encoder->ddc_bus);
 failed_ddc:
 	printk(KERN_ERR "Failed DDC\n");
-	if (gma_encoder->i2c_bus)
-		psb_intel_i2c_destroy(gma_encoder->i2c_bus);
+	psb_intel_i2c_destroy(gma_encoder->i2c_bus);
 failed_blc_i2c:
 	printk(KERN_ERR "Failed BLC\n");
 	drm_encoder_cleanup(encoder);
diff --git a/drivers/gpu/drm/gma500/oaktrail_lvds.c
b/drivers/gpu/drm/gma500/oaktrail_lvds.c
index 0d39da6..49c5c415 100644
--- a/drivers/gpu/drm/gma500/oaktrail_lvds.c
+++ b/drivers/gpu/drm/gma500/oaktrail_lvds.c
@@ -411,8 +411,7 @@ failed_find:
 	mutex_unlock(&dev->mode_config.mutex);

 	dev_dbg(dev->dev, "No LVDS modes found, disabling.\n");
-	if (gma_encoder->ddc_bus)
-		psb_intel_i2c_destroy(gma_encoder->ddc_bus);
+	psb_intel_i2c_destroy(gma_encoder->ddc_bus);

 /* failed_ddc: */

diff --git a/drivers/gpu/drm/gma500/psb_drv.c b/drivers/gpu/drm/gma500/psb_drv.c
index 6ec3a90..0efe165 100644
--- a/drivers/gpu/drm/gma500/psb_drv.c
+++ b/drivers/gpu/drm/gma500/psb_drv.c
@@ -210,8 +210,7 @@ static int psb_driver_unload(struct drm_device *dev)
 			iounmap(dev_priv->aux_reg);
 			dev_priv->aux_reg = NULL;
 		}
-		if (dev_priv->aux_pdev)
-			pci_dev_put(dev_priv->aux_pdev);
+		pci_dev_put(dev_priv->aux_pdev);

 		/* Destroy VBT data */
 		psb_intel_destroy_bios(dev);
diff --git a/drivers/gpu/drm/gma500/psb_intel_lvds.c
b/drivers/gpu/drm/gma500/psb_intel_lvds.c
index 88aad95..e73c3f9 100644
--- a/drivers/gpu/drm/gma500/psb_intel_lvds.c
+++ b/drivers/gpu/drm/gma500/psb_intel_lvds.c
@@ -561,8 +561,7 @@ void psb_intel_lvds_destroy(struct drm_connector *connector)
 	struct gma_encoder *gma_encoder = gma_attached_encoder(connector);
 	struct psb_intel_lvds_priv *lvds_priv = gma_encoder->dev_priv;

-	if (lvds_priv->ddc_bus)
-		psb_intel_i2c_destroy(lvds_priv->ddc_bus);
+	psb_intel_i2c_destroy(lvds_priv->ddc_bus);
 	drm_connector_unregister(connector);
 	drm_connector_cleanup(connector);
 	kfree(connector);
@@ -834,11 +833,9 @@ out:

 failed_find:
 	mutex_unlock(&dev->mode_config.mutex);
-	if (lvds_priv->ddc_bus)
-		psb_intel_i2c_destroy(lvds_priv->ddc_bus);
+	psb_intel_i2c_destroy(lvds_priv->ddc_bus);
 failed_ddc:
-	if (lvds_priv->i2c_bus)
-		psb_intel_i2c_destroy(lvds_priv->i2c_bus);
+	psb_intel_i2c_destroy(lvds_priv->i2c_bus);
 failed_blc_i2c:
 	drm_encoder_cleanup(encoder);
 	drm_connector_cleanup(connector);
-- 
2.1.2


