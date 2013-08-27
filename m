Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab3H0BZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:25:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab3H0BG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:06:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 16/74] iwlwifi: mvm: adjust firmware D3 configuration API
Date: Mon, 26 Aug 2013 18:08:14 -0700
Message-Id: <20130827010427.894769347@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit dfcb4c3aacedee6838e436fb575b31e138505203 upstream.

The D3 firmware API changed to include a new field, adjust
the driver to it to avoid getting an NMI when configuring.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-d3.h
@@ -75,13 +75,15 @@ enum iwl_d3_wakeup_flags {
  * struct iwl_d3_manager_config - D3 manager configuration command
  * @min_sleep_time: minimum sleep time (in usec)
  * @wakeup_flags: wakeup flags, see &enum iwl_d3_wakeup_flags
+ * @wakeup_host_timer: force wakeup after this many seconds
  *
  * The structure is used for the D3_CONFIG_CMD command.
  */
 struct iwl_d3_manager_config {
 	__le32 min_sleep_time;
 	__le32 wakeup_flags;
-} __packed; /* D3_MANAGER_CONFIG_CMD_S_VER_3 */
+	__le32 wakeup_host_timer;
+} __packed; /* D3_MANAGER_CONFIG_CMD_S_VER_4 */
 
 
 /* TODO: OFFLOADS_QUERY_API_S_VER_1 */


