Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751587AbaA2UmD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 15:42:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaA2UmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 15:42:00 -0500
Date: Wed, 29 Jan 2014 15:00:02 -0500
From: Dave Jones <davej@redhat.com>
To: mkrufky@kernellabs.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: mlx111sf: Fix compile when CONFIG_DVB_USB_MXL111SF is unset.
Message-ID: <20140129200002.GC30316@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, mkrufky@kernellabs.com,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h:72:9: error: expected ‘;’, ‘,’ or ‘)’ before ‘struct’
         struct mxl111sf_tuner_config *cfg)

Signed-off-by: Dave Jones <davej@fedoraproject.org>

diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
index 90f583e5d6a6..a8f65d88c9e7 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf-tuner.h
@@ -68,7 +68,7 @@ struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
 #else
 static inline
 struct dvb_frontend *mxl111sf_tuner_attach(struct dvb_frontend *fe,
-					   struct mxl111sf_state *mxl_state
+					   struct mxl111sf_state *mxl_state,
 					   struct mxl111sf_tuner_config *cfg)
 {
 	printk(KERN_WARNING "%s: driver disabled by Kconfig\n", __func__);
