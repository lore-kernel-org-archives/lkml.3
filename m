Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084Ab3GBLMP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 07:12:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36327 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552Ab3GBLIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 07:08:35 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikolay Martynov <mar.kolya@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 37/50] iwlwifi: dvm: fix chain noise calibration
Date: Tue,  2 Jul 2013 12:07:25 +0100
Message-Id: <1372763258-20664-38-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
References: <1372763258-20664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Martynov <mar.kolya@gmail.com>

commit b28b6dfe580ab1ab8bf08b908fd69e299b877103 upstream.

First step of chain noise calibration process had disable flag
check inverted. Chain noise calibration never started because
of this.

Tested on intel 5300 with two antennas attached. The driver
correctly disabled one chain.

Signed-off-by: Nikolay Martynov <mar.kolya@gmail.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ luis: backported to 3.5:
  - file rename: dvm/rxon.c -> iwl-agn-rxon.c ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index beaf5fa..b1100b2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -1393,7 +1393,7 @@ void iwlagn_chain_noise_reset(struct iwl_priv *priv)
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
 
-	if (!(priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED))
+	if (priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED)
 		return;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&
-- 
1.8.1.2

