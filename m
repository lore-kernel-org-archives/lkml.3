Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561Ab3A2B7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:59:10 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:52266 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755388Ab3A2B7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:59:07 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH v3 3/6] staging/fwserial: Simplify max payload calculation
Date: Mon, 28 Jan 2013 20:57:46 -0500
Message-Id: <1359424669-5723-4-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
References: <20130107232206.GA15244@kroah.com>
 <1359424669-5723-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index e157318..953ece6 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -377,8 +377,8 @@ static inline void fwtty_bind_console(struct fwtty_port *port,
  */
 static inline int link_speed_to_max_payload(unsigned speed)
 {
-	speed = clamp(speed, (unsigned) SCODE_100, (unsigned) SCODE_800);
-	return 1 << (speed + 9);
+	/* Max async payload is 4096 - see IEEE 1394-2008 tables 6-4, 16-18 */
+	return min(512 << speed, 4096);
 }
 
 #endif /* _FIREWIRE_FWSERIAL_H */
-- 
1.8.1.1

