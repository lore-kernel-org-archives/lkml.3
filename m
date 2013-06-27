Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3F0Xx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 19:53:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:15274 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3F0Xx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 19:53:56 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-df-51ccd090e0ed
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: "'Jonghwan Choi'" <jhbird.choi@samsung.com>, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, "'Johannes Berg'" <johannes.berg@intel.com>,
        "'Moshe Benji'" <Moshe.Benji@intel.com>, cpgs@samsung.com
References: 
In-reply-to: 
Subject: [PATCH 3.9-stable] iwlwifi: fix rate control regression
Date: Fri, 28 Jun 2013 08:53:52 +0900
Message-id: <002601ce7391$93c61ed0$bb525c70$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4vhL6OHdYi6A9aR4m9yzeDEXJPogAflJswAu8tBWABA4TFIAFsOElwAIhNXzAAnKxWYACLd58QADUgf7AB+cfNsAAATvIgAMqg8eAAkzGCMAAA5gYwAMf3LxAFffBYYAAAYQ2g
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zfd0JF84EGlx9amLx8pCmxZJmbotH
	K2axW1zeNYfN4vii30wWCzY+YnRg81i85yWTR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGVs
	/s1SsJa/Yk/rK7YGxh7eLkZODgkBE4mz95+zQ9hiEhfurWfrYuTiEBJYxiixYvZyVpiifytn
	MUEkFjFKzN69ggXC+cso8Wn6PDaQKjYBXYlj67eAdYgIeEucmvKLGaSIWaCBUeLp2ctADgdQ
	B7fE6uYgkBpOAR6JdX86mUFsYQEHiXttr8B6WQRUJT7ffcQEYvMK2Em8uPcDyhaU+DH5HguI
	zSygJbF+53EmCFteYvOat2DjJQTUJR791QVZKyIwg1Hi/ZfT7BA1IhL7XrxjBElICFxjlzh6
	YRkjxDIBiW+TD7FANMtKbDrADPGxpMTBFTdYJjBKzEKyehaS1bOQrJ6FZMUCRpZVjKKpBckF
	xUnpRYZ6xYm5xaV56XrJ+bmbGCHR2buD8fYB60OMyUDrJzJLiSbnA6M7ryTe0NjMyMLUxNTY
	yNzSjDRhJXFetRbrQCGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2McyZrCmlHcck1V8xXYX7z
	0voZT2+K0uML1TXiB8tC9frYjrBfzs0RTMgr3MohfsT7XMmiJUJp3TaKz4LT8wutdiTrrtid
	c2Xd0YtdDTxpvYszf3d+Sf2lslGgsCLnUq3ZlUrJiWrJ/mduL2IuWHzm0XHJtdVbnq0wU5Y5
	IZbaobCLYdvlV4pKLMUZiYZazEXFiQA/Wby25AIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jAd0JF84EGhxfZWDx8pCmxZJmbotH
	K2axW1zeNYfN4vii30wWCzY+YnRg81i85yWTR9+WVYwenzfJBTBHNTDaZKQmpqQWKaTmJeen
	ZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gCtVVIoS8wpBQoFJBYXK+nbYZoQ
	GuKmawHTGKHrGxIE12NkgAYS1jFmbP7NUrCWv2JP6yu2BsYe3i5GTg4JAROJfytnMUHYYhIX
	7q1n62Lk4hASWMQoMXv3ChYI5y+jxKfp89hAqtgEdCWOrd/CCmKLCHhLnJryixmkiFmggVHi
	6dnLQA4HUAe3xOrmIJAaTgEeiXV/OplBbGEBB4l7ba/AelkEVCU+330EtplXwE7ixb0fULag
	xI/J91hAbGYBLYn1O48zQdjyEpvXvAUbLyGgLvHory7IWhGBGYwS77+cZoeoEZHY9+Id4wRG
	oVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc+8+kdzCuarA4
	xCjAwajEw9uQeCZQiDWxrLgy9xCjBAezkgjvnQVAId6UxMqq1KL8+KLSnNTiQ4zJQJ9OZJYS
	Tc4HpqW8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDkfz/7
	9t7ZmZ/exTxIfbRMW0RP96pix+uF/psyb0y7Hh3kqinaYJjyQfny7qiLhg8sr3Gc1nX7MUHg
	y/+fzXdllNVe3c2bmv+qjOFs0pmnJz4ftj+6486nMAmz/Vujq7fuLfq4ZPnTHzu32ucrL5ld
	MkNd6ajwrv883feXeDLNOzTJbsIFc6vWfUosxRmJhlrMRcWJAEBUDmFBAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Moshe Benji <Moshe.Benji@intel.com>"

commit 622ebe994f6866b8d46ee5d3bcc329ed65d3722d upstream

Since driver does not use control.rates[0].count, we have never set that
variable. But currently, after rate control API rewrite, this is required
by mac80211. Otherwise legacy rates control does not work and we transmit
always at 1Mbit/s on pre 11n networks.

[same fix as for iwlegacy, thanks Stanislaw!]

Signed-off-by: Moshe Benji <Moshe.Benji@intel.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/net/wireless/iwlwifi/dvm/rs.c |    2 +-
 drivers/net/wireless/iwlwifi/mvm/rs.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/rs.c
b/drivers/net/wireless/iwlwifi/dvm/rs.c
index abe3042..5de2dbf 100644
--- a/drivers/net/wireless/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/dvm/rs.c
@@ -2799,7 +2799,7 @@ static void rs_get_rate(void *priv_r, struct
ieee80211_sta *sta, void *priv_sta,
 		info->control.rates[0].flags = 0;
 	}
 	info->control.rates[0].idx = rate_idx;
-
+	info->control.rates[0].count = 1;
 }
 
 static void *rs_alloc_sta(void *priv_rate, struct ieee80211_sta *sta,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c
b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 56b636d..fefcbc5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2544,6 +2544,7 @@ static void rs_get_rate(void *mvm_r, struct
ieee80211_sta *sta, void *mvm_sta,
 		info->control.rates[0].flags = 0;
 	}
 	info->control.rates[0].idx = rate_idx;
+	info->control.rates[0].count = 1;
 }
 
 static void *rs_alloc_sta(void *mvm_rate, struct ieee80211_sta *sta,
-- 
1.7.9.5

