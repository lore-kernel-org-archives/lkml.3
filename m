Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757744Ab3AOTEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 14:04:44 -0500
Received: from mail.kernel.org ([198.145.19.201]:34025 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482Ab3AOSwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 13:52:10 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Stefan Lippers-Hollmann <s.l-h@gmx.de>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 006/221] rt2x00: Only specify interface combinations if more then one interface is possible
Date: Tue, 15 Jan 2013 10:48:53 -0800
Message-Id: <20130115184958.516809179@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helmut Schaa <helmut.schaa@googlemail.com>

commit f5685ba675449b072feab6a5391a9ef9f604bc94 upstream.

Otherwise rt2500* triggers a warning in cfg80211, from net/wireless/core.c:

	/* Combinations with just one interface aren't real */
	if (WARN_ON(c->max_interfaces < 2))

This was introduced in commit 55d2e9da744ba11eae900b4bfc2da72eace3c1e1:
rt2x00: Replace open coded interface checking with interface combinations.

Reported-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Tested-by: Stefan Lippers-Hollmann <s.l-h@gmx.de>
Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1123,6 +1123,9 @@ static inline void rt2x00lib_set_if_comb
 	struct ieee80211_iface_limit *if_limit;
 	struct ieee80211_iface_combination *if_combination;
 
+	if (rt2x00dev->ops->max_ap_intf < 2)
+		return;
+
 	/*
 	 * Build up AP interface limits structure.
 	 */


