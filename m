Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967775Ab3HICPy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:15:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55710 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967556Ab3HIB6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>
Subject: [ 041/102] mac80211: fix ethtool stats for non-station interfaces
Date: Thu,  8 Aug 2013 18:57:17 -0700
Message-Id: <20130809015019.491982010@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit e13bae4f807401729b3f27c7e882a96b8b292809 upstream.

As reported in https://bugzilla.kernel.org/show_bug.cgi?id=60514,
the station loop never initialises 'sinfo' and therefore adds up
a stack values, leaking stack information (the number of times it
adds values is easily obtained another way.)

Fix this by initialising the sinfo for each station to add.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/cfg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -652,6 +652,8 @@ static void ieee80211_get_et_stats(struc
 			if (sta->sdata->dev != dev)
 				continue;
 
+			sinfo.filled = 0;
+			sta_set_sinfo(sta, &sinfo);
 			i = 0;
 			ADD_STA_STATS(sta);
 		}


