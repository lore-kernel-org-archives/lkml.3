Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967778Ab3HICQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:16:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55699 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967543Ab3HIB6x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 038/102] mac80211/minstrel: fix NULL pointer dereference issue
Date: Thu,  8 Aug 2013 18:57:14 -0700
Message-Id: <20130809015018.780006959@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 5c9fc93bc9bc417418fc1b6366833ae6a07b804d upstream.

When priv_sta == NULL, mi->prev_sample is dereferenced too early. Move
the assignment further down, after the rate_control_send_low call.

Reported-by: Krzysztof Mazur <krzysiek@podlesie.net>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/rc80211_minstrel.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/rc80211_minstrel.c
+++ b/net/mac80211/rc80211_minstrel.c
@@ -290,7 +290,7 @@ minstrel_get_rate(void *priv, struct iee
 	struct minstrel_rate *msr, *mr;
 	unsigned int ndx;
 	bool mrr_capable;
-	bool prev_sample = mi->prev_sample;
+	bool prev_sample;
 	int delta;
 	int sampling_ratio;
 
@@ -314,6 +314,7 @@ minstrel_get_rate(void *priv, struct iee
 			(mi->sample_count + mi->sample_deferred / 2);
 
 	/* delta < 0: no sampling required */
+	prev_sample = mi->prev_sample;
 	mi->prev_sample = false;
 	if (delta < 0 || (!mrr_capable && prev_sample))
 		return;


