Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759437Ab3D3As0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:48:26 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33380 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757290Ab3D3AsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:48:24 -0400
Message-ID: <1367282900.8964.334.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 1/3] unix/dgram: peek beyond 0-sized skbs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Apr 2013 17:48:20 -0700
In-Reply-To: <1367271734-14379-1-git-send-email-bpoirier@suse.de>
References: <kll5si$544$1@ger.gmane.org>
	 <1367271734-14379-1-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 17:42 -0400, Benjamin Poirier wrote:
> "77c1090 net: fix infinite loop in __skb_recv_datagram()" (v3.8) introduced a
> regression:
> After that commit, recv can no longer peek beyond a 0-sized skb in the queue.
> __skb_recv_datagram() instead stops at the first skb with len == 0 and results
> in the system call failing with -EFAULT via skb_copy_datagram_iovec().
> 
> When peeking at an offset with 0-sized skb(s), each one of those is received
> only once, in sequence. The offset starts moving forward again after receiving
> datagrams with len > 0.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> 
> ---

Acked-by: Eric Dumazet <edumazet@google.com>


