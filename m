Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbaFDXVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:21:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39741 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435AbaFDXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:21:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eyal Shapira <eyalx.shapira@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 023/228] iwlwifi: mvm: avoid searching unnecessary columns
Date: Wed,  4 Jun 2014 16:20:52 -0700
Message-Id: <20140604232348.837748810@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eyal Shapira <eyal@wizery.com>

commit d8fff919ecd7820084675c2814913445e95640ac upstream.

Don't search columns which are unlikely to succeed as previous
columns searched with less aggressive modulation failed.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/rs.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -212,8 +212,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_LEGACY_ANT_B,
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_MIMO2,
-			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 		},
@@ -225,8 +225,8 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_SISO_ANT_A,
 			RS_COLUMN_SISO_ANT_B,
-			RS_COLUMN_MIMO2,
-			RS_COLUMN_MIMO2_SGI,
+			RS_COLUMN_INVALID,
+			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 			RS_COLUMN_INVALID,
 		},
@@ -239,9 +239,9 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_A_SGI,
 			RS_COLUMN_SISO_ANT_B_SGI,
-			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,
@@ -255,9 +255,9 @@ static const struct rs_tx_column rs_tx_c
 			RS_COLUMN_MIMO2,
 			RS_COLUMN_SISO_ANT_B_SGI,
 			RS_COLUMN_SISO_ANT_A_SGI,
-			RS_COLUMN_MIMO2_SGI,
 			RS_COLUMN_LEGACY_ANT_A,
 			RS_COLUMN_LEGACY_ANT_B,
+			RS_COLUMN_INVALID,
 		},
 		.checks = {
 			rs_siso_allow,


