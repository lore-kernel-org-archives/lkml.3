Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932952Ab3EGD7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 23:59:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9852 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab3EGD6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 23:58:50 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=XdEPNoCJHPkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=FJw8SB3je9wA:10 a=M5GUcnROAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=fC4T7qsy4_4xvlMS5R0A:9 a=9RRF0ttvEvMA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=TYSfYv2iz1CDdOyj:21 a=nNAUUvfmmKrmxmGE:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035844.269232170@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:57:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stone Piao <piaoyun@marvell.com>, Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [020/126] mwifiex: limit channel number not to overflow memory
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0020-mwifiex-limit-channel-number-not-to-overflow-memory.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stone Piao <piaoyun@marvell.com>

[ Upstream commit 901ceba4e81e9dd6b4a3c4c37ee22000a6c5c65f ]

Limit the channel number in scan request, or the driver scan
config structure memory will be overflowed.

Cc: <stable@vger.kernel.org> # 3.5+
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index fe42137..b4719ea 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1487,7 +1487,8 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 		}
 	}
 
-	for (i = 0; i < request->n_channels; i++) {
+	for (i = 0; i < min_t(u32, request->n_channels,
+			      MWIFIEX_USER_SCAN_CHAN_MAX); i++) {
 		chan = request->channels[i];
 		priv->user_scan_cfg->chan_list[i].chan_number = chan->hw_value;
 		priv->user_scan_cfg->chan_list[i].radio_type = chan->band;
-- 
1.7.10.4


