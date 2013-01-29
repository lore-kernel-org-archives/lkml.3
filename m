Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756639Ab3A2Dfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 22:35:52 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:41383 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756589Ab3A2Dfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 22:35:46 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 08/11] staging/fwserial: Remove reference to removed constant
Date: Mon, 28 Jan 2013 22:34:42 -0500
Message-Id: <1359430485-5301-8-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
References: <1359430485-5301-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWSERIAL_TTY_START_MINOR was removed. The minor_start is allocated
by tty_alloc_driver().

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/fwserial/fwserial.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
index c768aad..33a3a53 100644
--- a/drivers/staging/fwserial/fwserial.h
+++ b/drivers/staging/fwserial/fwserial.h
@@ -194,7 +194,7 @@ struct buffered_rx {
  * @port: underlying tty_port
  * @device: tty device
  * @index: index into port_table for this particular port
- *    note: minor = index + FWSERIAL_TTY_START_MINOR
+ *    note: minor = index + minor_start assigned by tty_alloc_driver()
  * @serial: back pointer to the containing fw_serial
  * @rx_handler: bus address handler for unique addr region used by remotes
  *              to communicate with this port. Every port uses
-- 
1.8.1.1

