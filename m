Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966955AbaCUBXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:23:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36525 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760366AbaCUADi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Max Stepanov <Max.Stepanov@intel.com>,
        Alexander Bondar <alexander.bondar@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.13 032/149] iwlwifi: mvm: change of listen interval from 70 to 10
Date: Thu, 20 Mar 2014 17:03:15 -0700
Message-Id: <20140321000438.080244820@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Stepanov <Max.Stepanov@intel.com>

commit e7eb65cac0720df8b3946af7f7a9dc363cf0a814 upstream.

Some APs reject STA association request if a listen interval value exceeds
a threshold of 10. Thus, for example, Cisco APs may deny STA associations
returning status code 12 (Association denied due to reason outside the scope
of 802.11 standard) in the association response frame.

Fixing the issue by setting the default IWL_CONN_MAX_LISTEN_INTERVAL value
from 70 to 10.

Signed-off-by: Max Stepanov <Max.Stepanov@intel.com>
Reviewed-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/mvm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -151,7 +151,7 @@ enum iwl_power_scheme {
 	IWL_POWER_SCHEME_LP
 };
 
-#define IWL_CONN_MAX_LISTEN_INTERVAL	70
+#define IWL_CONN_MAX_LISTEN_INTERVAL	10
 #define IWL_UAPSD_AC_INFO		(IEEE80211_WMM_IE_STA_QOSINFO_AC_VO |\
 					 IEEE80211_WMM_IE_STA_QOSINFO_AC_VI |\
 					 IEEE80211_WMM_IE_STA_QOSINFO_AC_BK |\


