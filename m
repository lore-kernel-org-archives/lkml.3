Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933394Ab3CHIWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 03:22:46 -0500
Received: from smtp4.mundo-r.com ([212.51.32.151]:62279 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab3CHIWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 03:22:45 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhEFAEufOVFbdWOb/2dsb2JhbABDh1u8coFYFnSCLAEFJ1IQUVcGE4gXuyWPDAeDQAOWS5Bxgwo
X-IPAS-Result: AhEFAEufOVFbdWOb/2dsb2JhbABDh1u8coFYFnSCLAEFJ1IQUVcGE4gXuyWPDAeDQAOWS5Bxgwo
X-IronPort-AV: E=Sophos;i="4.84,806,1355094000"; 
   d="scan'208";a="9268288"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 1/3] ipack: avoid double free on device->id
Date: Fri,  8 Mar 2013 09:21:45 +0100
Message-Id: <1362730907-10047-1-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <512DCB33.6030500@igalia.com>
References: <512DCB33.6030500@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/ipack/ipack.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ipack/ipack.c b/drivers/ipack/ipack.c
index 7ec6b20..599d4ff 100644
--- a/drivers/ipack/ipack.c
+++ b/drivers/ipack/ipack.c
@@ -24,6 +24,7 @@ static void ipack_device_release(struct device *dev)
 {
 	struct ipack_device *device = to_ipack_dev(dev);
 	kfree(device->id);
+	device->id = NULL;
 	device->release(device);
 }
 
-- 
1.7.10.4

