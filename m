Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaIVS5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:57:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52943 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbaIVS5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:57:39 -0400
Date: Mon, 22 Sep 2014 14:57:36 -0400 (EDT)
Message-Id: <20140922.145736.1677768375039003963.davem@davemloft.net>
To: jasowang@redhat.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH net-next V2] net: keep original skb which only needs
 header checking during software GSO
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411113878-11910-1-git-send-email-jasowang@redhat.com>
References: <1411113878-11910-1-git-send-email-jasowang@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 22 Sep 2014 11:57:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wang <jasowang@redhat.com>
Date: Fri, 19 Sep 2014 16:04:38 +0800

> Commit ce93718fb7cdbc064c3000ff59e4d3200bdfa744 ("net: Don't keep
> around original SKB when we software segment GSO frames") frees the
> original skb after software GSO even for dodgy gso skbs. This breaks
> the stream throughput from untrusted sources, since only header
> checking was done during software GSO instead of a true
> segmentation. This patch fixes this by freeing the original gso skb
> only when it was really segmented by software.
> 
> Fixes ce93718fb7cdbc064c3000ff59e4d3200bdfa744 ("net: Don't keep
> around original SKB when we software segment GSO frames.")
> 
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Applied, thanks Jeff.
