Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562Ab3ISIkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 04:40:35 -0400
Received: from mx-rz-1.rrze.uni-erlangen.de ([131.188.11.20]:46237 "EHLO
	mx-rz-1.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751804Ab3ISIkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 04:40:33 -0400
X-RRZE-Submit-IP: 131.188.42.159
From: Dominik Paulus <dominik.paulus@fau.de>
To: usbip-devel@lists.sourceforge.net
Cc: linux-kernel@i4.cs.fau.de, Tobias Polzer <tobias.polzer@fau.de>,
        Dominik Paulus <dominik.paulus@fau.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stefan Reif <ke42caxa@cip.cs.fau.de>,
        Anthony Foiani <anthony.foiani@gmail.com>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: Fix build on Debian ppc
Date: Thu, 19 Sep 2013 10:39:38 +0200
Message-Id: <1379579978-2570-1-git-send-email-dominik.paulus@fau.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Polzer <tobias.polzer@fau.de>

One missing include was added.

Signed-off-by: Dominik Paulus <dominik.paulus@fau.de>
Signed-off-by: Tobias Polzer <tobias.polzer@fau.de>
---
 drivers/staging/usbip/userspace/src/usbip_network.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/staging/usbip/userspace/src/usbip_network.c b/drivers/staging/usbip/userspace/src/usbip_network.c
index f5955c2..799a68f 100644
--- a/drivers/staging/usbip/userspace/src/usbip_network.c
+++ b/drivers/staging/usbip/userspace/src/usbip_network.c
@@ -31,6 +31,10 @@
 #include <gnutls/gnutls.h>
 #endif
 
+#ifdef HAVE_LIBWRAP
+#include <tcpd.h>
+#endif
+
 #include "usbip_common.h"
 #include "usbip_network.h"
 
-- 
1.8.4

