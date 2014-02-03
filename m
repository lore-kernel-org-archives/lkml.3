Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaBCTwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:52:25 -0500
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:45550
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbaBCTwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:52:23 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Support per-channel driver state
Date: Mon,  3 Feb 2014 12:42:45 -0800
Message-Id: <1391460165-30094-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we implement Virtual Receive Side Scaling on the networking side
(the VRSS patches are currently under review), it will be useful to have
per-channel state that vmbus drivers can manage. Add support for
managing per-channel state.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 include/linux/hyperv.h |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 15da677..96fb70e 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -1043,6 +1043,10 @@ struct vmbus_channel {
 	 * This will be NULL for the primary channel.
 	 */
 	struct vmbus_channel *primary_channel;
+	/*
+	 * Support per-channel state for use by vmbus drivers.
+	 */
+	void *per_channel_state;
 };
 
 static inline void set_channel_read_state(struct vmbus_channel *c, bool state)
@@ -1050,6 +1054,16 @@ static inline void set_channel_read_state(struct vmbus_channel *c, bool state)
 	c->batched_reading = state;
 }
 
+static inline void set_per_channel_state(struct vmbus_channel *c, void *s)
+{
+	c->per_channel_state = s;
+}
+
+static inline void *get_per_channel_state(struct vmbus_channel *c)
+{
+	return c->per_channel_state;
+}
+
 void vmbus_onmessage(void *context);
 
 int vmbus_request_offers(void);
-- 
1.7.4.1

