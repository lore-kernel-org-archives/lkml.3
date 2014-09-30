Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaI3Ffm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 01:35:42 -0400
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:12789 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbaI3Ffj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 01:35:39 -0400
X-IronPort-AV: E=McAfee;i="5600,1067,7576"; a="75173761"
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="760236013"
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <ath10k@lists.infradead.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Dan Carpenter <error27@gmail.com>
Subject: Re: checkpatch: CHECK: No space is necessary after a cast
References: <874mvq1w9v.fsf@kamboji.qca.qualcomm.com>
	<1412013755.4302.45.camel@joe-AO725>
Date: Tue, 30 Sep 2014 08:35:32 +0300
In-Reply-To: <1412013755.4302.45.camel@joe-AO725> (Joe Perches's message of
	"Mon, 29 Sep 2014 11:02:35 -0700")
Message-ID: <87bnpxy8kb.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: NASANEXM01B.na.qualcomm.com (129.46.53.226) To
 NASANEXM01G.na.qualcomm.com (10.46.200.111)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> On Mon, 2014-09-29 at 14:49 +0300, Kalle Valo wrote:
>> Hi Joe,
>> 
>> I have a problem with checkpatch. On ath10k we have this function:
>> 
>> static inline struct ath10k_skb_cb *ATH10K_SKB_CB(struct sk_buff *skb)
>> {
>> 	BUILD_BUG_ON(sizeof(struct ath10k_skb_cb) >
>> 		     IEEE80211_TX_INFO_DRIVER_DATA_SIZE);
>> 	return (struct ath10k_skb_cb *)&IEEE80211_SKB_CB(skb)->driver_data;
>> }
>> 
>> And the BUILD_BUG_ON triggers this warning:
>> 
>> drivers/net/wireless/ath/ath10k/core.h:85: CHECK: No space is necessary after a cast
>> 
>> Any advice how to handle that?
>
> It's a checkpatch false positive that could be fixed.
>
> It needs something like another test to look for
> sizeof(type) as not a cast and more arithmetic/comparison
> uses.
>
> Maybe you can test this?

It works, thank you!

Tested-by: Kalle Valo <kvalo@qca.qualcomm.com>

-- 
Kalle Valo
