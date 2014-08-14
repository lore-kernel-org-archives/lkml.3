Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029AbaHNVji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:39:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60262 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876AbaHNVjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:39:36 -0400
Date: Thu, 14 Aug 2014 14:39:29 -0700 (PDT)
Message-Id: <20140814.143929.1671828120262010871.davem@redhat.com>
To: avagin@openvz.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, edumazet@google.com,
        xemul@parallels.com
Subject: Re: [PATCH] tcp: don't use timestamp from repaired skb-s to
 calculate RTT (v2)
From: David Miller <davem@redhat.com>
In-Reply-To: <1407931390-3162-1-git-send-email-avagin@openvz.org>
References: <1407931390-3162-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrey Vagin <avagin@openvz.org>
Date: Wed, 13 Aug 2014 16:03:10 +0400

> We don't know right timestamp for repaired skb-s. Wrong RTT estimations
> isn't good, because some congestion modules heavily depends on it.
> 
> This patch adds the TCPCB_REPAIRED flag, which is included in
> TCPCB_RETRANS.
> 
> Thanks to Eric for the advice how to fix this issue.
> 
> This patch fixes the warning:
 ...
> v2: moving setting of skb->when for repaired skb-s in tcp_write_xmit,
>     where it's set for other skb-s.
> 
> Fixes: 431a91242d8d ("tcp: timestamp SYN+DATA messages")
> Fixes: 740b0f1841f6 ("tcp: switch rtt estimations to usec resolution")
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Pavel Emelyanov <xemul@parallels.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Signed-off-by: Andrey Vagin <avagin@openvz.org>

Applied.
