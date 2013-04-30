Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537Ab3D3At7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 20:49:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:58363 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759443Ab3D3At6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 20:49:58 -0400
Message-ID: <1367282994.8964.335.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 2/3] unix/dgram: fix peeking with an offset larger
 than data in queue
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Benjamin Poirier <bpoirier@suse.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 29 Apr 2013 17:49:54 -0700
In-Reply-To: <1367271734-14379-2-git-send-email-bpoirier@suse.de>
References: <kll5si$544$1@ger.gmane.org>
	 <1367271734-14379-1-git-send-email-bpoirier@suse.de>
	 <1367271734-14379-2-git-send-email-bpoirier@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-29 at 17:42 -0400, Benjamin Poirier wrote:
> Currently, peeking on a unix datagram socket with an offset larger than len of
> the data in the sk receive queue returns immediately with bogus data. That's
> because *off is not reset between each skb_queue_walk().
> 
> This patch fixes this so that the behavior is the same as peeking with no
> offset on an empty queue: the caller blocks.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>
> 
> ---
> 
> v2: address review feedback from Eric Dumazet
> 
> v3: address review feedback from Cong Wang
> 
>  net/core/datagram.c |   21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)

Acked-by: Eric Dumazet <edumazet@google.com>


