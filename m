Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933153Ab3FEVoH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:44:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38041 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933076Ab3FEVgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:36:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Lingzhu Xiang <lxiang@redhat.com>
Subject: [ 105/127] drm/nvc0/ce: disable ce1 on a number of chipsets
Date: Wed,  5 Jun 2013 14:34:32 -0700
Message-Id: <20130605213229.973288702@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 6d5f83834dc2b064b8c1202ea281820286b675a8 upstream.

The falcon is present, but the rest of the copy engine doesn't appear to
be...  PUNITS doesn't report disabled (maybe the bits for the copy engines
got added later?), so we end up trying to use a non-functional CE1, and
bust all sorts of things.. Most notably, suspend/resume..

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Lingzhu Xiang <lxiang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/device/nvc0.c
@@ -138,7 +138,6 @@ nvc0_identify(struct nouveau_device *dev
 		device->oclass[NVDEV_ENGINE_BSP    ] = &nvc0_bsp_oclass;
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_COPY0  ] = &nvc0_copy0_oclass;
-		device->oclass[NVDEV_ENGINE_COPY1  ] = &nvc0_copy1_oclass;
 		device->oclass[NVDEV_ENGINE_DISP   ] = &nva3_disp_oclass;
 		break;
 	case 0xce:
@@ -225,7 +224,6 @@ nvc0_identify(struct nouveau_device *dev
 		device->oclass[NVDEV_ENGINE_BSP    ] = &nvc0_bsp_oclass;
 		device->oclass[NVDEV_ENGINE_PPP    ] = &nvc0_ppp_oclass;
 		device->oclass[NVDEV_ENGINE_COPY0  ] = &nvc0_copy0_oclass;
-		device->oclass[NVDEV_ENGINE_COPY1  ] = &nvc0_copy1_oclass;
 		device->oclass[NVDEV_ENGINE_DISP   ] = &nva3_disp_oclass;
 		break;
 	case 0xc8:


