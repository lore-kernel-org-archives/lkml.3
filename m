Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965373AbaLLGYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:24:46 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51733 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758809AbaLLGRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:17:11 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Stanislaw Gruszka" <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.178933043@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 031/164] rt2800: correct BBP1_TX_POWER_CTRL mask
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 01f7feeaf4528bec83798316b3c811701bac5d3e upstream.

Two bits control TX power on BBP_R1 register. Correct the mask,
otherwise we clear additional bit on BBP_R1 register, what can have
unknown, possible negative effect.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/rt2x00/rt2800.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1737,7 +1737,7 @@ struct mac_iveiv_entry {
  * 2 - drop tx power by 12dBm,
  * 3 - increase tx power by 6dBm
  */
-#define BBP1_TX_POWER_CTRL		FIELD8(0x07)
+#define BBP1_TX_POWER_CTRL		FIELD8(0x03)
 #define BBP1_TX_ANTENNA			FIELD8(0x18)
 
 /*

