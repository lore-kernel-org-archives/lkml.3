Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823AbbAJKfm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:35:42 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:60595 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754478AbbAJKfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:35:41 -0500
Date: Sat, 10 Jan 2015 16:05:32 +0530
From: Vaishali Thakkar <vthakkar1994@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] Staging: rtl8192u: Remove check of ieee in rtl819x_BAProc.c
Message-ID: <20150110103532.GA12744@vaishali-Ideapad-Z570>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes following smatch warning:

drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c:117
ieee80211_ADDBA() warn: variable dereferenced before check 'ieee' (see line 114)

As ieee can not be NULL at this point, all such checks are removed.

Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>
---
 drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
index cd196ce..a9fd2cb 100644
--- a/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
+++ b/drivers/staging/rtl8192u/ieee80211/rtl819x_BAProc.c
@@ -114,9 +114,9 @@ static struct sk_buff *ieee80211_ADDBA(struct ieee80211_device *ieee, u8 *Dst, P
 	u16 len = ieee->tx_headroom + 9;
 	//category(1) + action field(1) + Dialog Token(1) + BA Parameter Set(2) +  BA Timeout Value(2) +  BA Start SeqCtrl(2)(or StatusCode(2))
 	IEEE80211_DEBUG(IEEE80211_DL_TRACE | IEEE80211_DL_BA, "========>%s(), frame(%d) sentd to:%pM, ieee->dev:%p\n", __func__, type, Dst, ieee->dev);
-	if (pBA == NULL||ieee == NULL)
+	if (pBA == NULL)
 	{
-		IEEE80211_DEBUG(IEEE80211_DL_ERR, "pBA(%p) is NULL or ieee(%p) is NULL\n", pBA, ieee);
+		IEEE80211_DEBUG(IEEE80211_DL_ERR, "pBA is NULL\n");
 		return NULL;
 	}
 	skb = dev_alloc_skb(len + sizeof( struct ieee80211_hdr_3addr)); //need to add something others? FIXME
-- 
1.9.1

