Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab3GAUWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:22:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab3GAUKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:10:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nikolay Martynov <mar.kolya@gmail.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 09/26] iwlwifi: dvm: fix chain noise calibration
Date: Mon,  1 Jul 2013 13:10:04 -0700
Message-Id: <20130701200730.941548607@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130701200729.872850414@linuxfoundation.org>
References: <20130701200729.872850414@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/rxon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/dvm/rxon.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rxon.c
@@ -1377,7 +1377,7 @@ static void iwlagn_chain_noise_reset(str
 	struct iwl_chain_noise_data *data = &priv->chain_noise_data;
 	int ret;
 
-	if (!(priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED))
+	if (priv->calib_disabled & IWL_CHAIN_NOISE_CALIB_DISABLED)
 		return;
 
 	if ((data->state == IWL_CHAIN_NOISE_ALIVE) &&


