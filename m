Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3FKTzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 15:55:45 -0400
Received: from s3.sipsolutions.net ([144.76.43.152]:38908 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896Ab3FKTzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 15:55:44 -0400
Message-ID: <1370980523.8356.70.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] mac80211: ath9k: Use RCU protection calling
 ieee80211_get_tx_rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Calvin Owens <jcalvinowens@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
        netdev@vger.kernel.org
Date: Tue, 11 Jun 2013 21:55:23 +0200
In-Reply-To: <20130611171304.GA2189@gmail.com> (sfid-20130611_191323_492868_156158C4)
References: <20130609225120.GA2789@gmail.com>
	 <20130610042959.GA1902@gmail.com>
	 <1370950926.8356.14.camel@jlt4.sipsolutions.net>
	 <20130611171304.GA2189@gmail.com> (sfid-20130611_191323_492868_156158C4)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the subject should no longer say "mac80211:" :)

However... given that ieee80211_get_tx_rates() actually *copies* the
rates into the parameter, I guess it should do the rcu_read_lock()
internally. I guess I wasn't paying attention previously. Felix?

johannes


