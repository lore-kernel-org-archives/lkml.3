Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965119Ab3DJQka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:40:30 -0400
Received: from www.piware.de ([213.9.93.70]:48590 "EHLO www.piware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965067Ab3DJQk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:40:29 -0400
Date: Wed, 10 Apr 2013 18:40:27 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: mac80211_hwsim: Check return value of driver_register
Message-ID: <20130410164027.GB2884@piware.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If driver_register() fails, properly exit with the same error code.

Signed-off-by: Martin Pitt <martin.pitt@ubuntu.com>
---
 drivers/net/wireless/mac80211_hwsim.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 57361c3..a2224b7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2183,7 +2183,12 @@ static int __init init_mac80211_hwsim(void)
 	if (IS_ERR(hwsim_class))
 		return PTR_ERR(hwsim_class);
 
-	driver_register(&mac80211_hwsim_driver);
+	err = driver_register(&mac80211_hwsim_driver);
+	if (err != 0) {
+		printk(KERN_DEBUG
+		       "mac80211_hwsim: driver_register failed (%d)\n", err);
+		return err;
+	}
 
 	memset(addr, 0, ETH_ALEN);
 	addr[0] = 0x02;
-- 
1.7.2.5

-- 
Martin Pitt                        | http://www.piware.de
Ubuntu Developer (www.ubuntu.com)  | Debian Developer  (www.debian.org)
