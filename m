Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaFEABN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:01:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40415 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaFDXXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 3.14 185/228] iwlwifi: mvm: BT Coex - fix Look Up Table
Date: Wed,  4 Jun 2014 16:23:34 -0700
Message-Id: <20140604232353.975010451@linuxfoundation.org>
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

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

commit a6bc92803e7f765e02c923cf37c8e280e729642a upstream.

A few entries were wrong and this caused throughput issues.

Fixes: dac94da8dba3 ("iwlwifi: mvm: new BT Coex API")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
+++ b/drivers/net/wireless/iwlwifi/mvm/bt-coex.c
@@ -188,7 +188,7 @@ static const __le32 iwl_combined_lookup[
 		cpu_to_le32(0xcc00aaaa),
 		cpu_to_le32(0x0000aaaa),
 		cpu_to_le32(0xc0004000),
-		cpu_to_le32(0x00000000),
+		cpu_to_le32(0x00004000),
 		cpu_to_le32(0xf0005000),
 		cpu_to_le32(0xf0005000),
 	},
@@ -211,16 +211,16 @@ static const __le32 iwl_combined_lookup[
 		/* Tx Tx disabled */
 		cpu_to_le32(0xaaaaaaaa),
 		cpu_to_le32(0xaaaaaaaa),
-		cpu_to_le32(0xaaaaaaaa),
+		cpu_to_le32(0xeeaaaaaa),
 		cpu_to_le32(0xaaaaaaaa),
 		cpu_to_le32(0xcc00ff28),
 		cpu_to_le32(0x0000aaaa),
 		cpu_to_le32(0xcc00aaaa),
 		cpu_to_le32(0x0000aaaa),
-		cpu_to_le32(0xC0004000),
-		cpu_to_le32(0xC0004000),
-		cpu_to_le32(0xF0005000),
-		cpu_to_le32(0xF0005000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xc0004000),
+		cpu_to_le32(0xf0005000),
+		cpu_to_le32(0xf0005000),
 	},
 };
 


