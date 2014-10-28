Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856AbaJ1HLw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:11:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45370 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755606AbaJ1DpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:45:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.16 063/127] rt2800: correct BBP1_TX_POWER_CTRL mask
Date: Tue, 28 Oct 2014 11:34:58 +0800
Message-Id: <20141028033423.618977124@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033420.925922046@linuxfoundation.org>
References: <20141028033420.925922046@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 01f7feeaf4528bec83798316b3c811701bac5d3e upstream.

Two bits control TX power on BBP_R1 register. Correct the mask,
otherwise we clear additional bit on BBP_R1 register, what can have
unknown, possible negative effect.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2800.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2039,7 +2039,7 @@ struct mac_iveiv_entry {
  * 2 - drop tx power by 12dBm,
  * 3 - increase tx power by 6dBm
  */
-#define BBP1_TX_POWER_CTRL		FIELD8(0x07)
+#define BBP1_TX_POWER_CTRL		FIELD8(0x03)
 #define BBP1_TX_ANTENNA			FIELD8(0x18)
 
 /*


