Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246Ab3AOWb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:31:26 -0500
Received: from mail.kernel.org ([198.145.19.201]:42246 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932222Ab3AOWbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:31:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Arend Van Spriel <arend@broadcom.com>,
        Pieter-Paul Giesberts <pieterpg@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 105/221] brcmfmac: fix parsing rsn ie for ap mode.
Date: Tue, 15 Jan 2013 10:50:32 -0800
Message-Id: <20130115185005.619003798@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hante Meuleman <meuleman@broadcom.com>

commit 619c5a9ad54e6bbdafd16d1cdc6c049403710540 upstream.

RSN IEs got incorrectly parsed and therefore ap mode using WPA2
security was not working.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3730,10 +3730,11 @@ brcmf_configure_wpaie(struct net_device
 
 	len = wpa_ie->len + TLV_HDR_LEN;
 	data = (u8 *)wpa_ie;
-	offset = 0;
+	offset = TLV_HDR_LEN;
 	if (!is_rsn_ie)
 		offset += VS_IE_FIXED_HDR_LEN;
-	offset += WPA_IE_VERSION_LEN;
+	else
+		offset += WPA_IE_VERSION_LEN;
 
 	/* check for multicast cipher suite */
 	if (offset + WPA_IE_MIN_OUI_LEN > len) {


