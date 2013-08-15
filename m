Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755614Ab3HOKfq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 06:35:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62536 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab3HOKfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 06:35:44 -0400
Message-ID: <1376562930.2626.16.camel@cr0>
Subject: Re: [PATCH] bond: Don't set skb->queue_mapping in netpoll.
From: Cong Wang <amwang@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 15 Aug 2013 18:35:30 +0800
In-Reply-To: <1376555808-6531-1-git-send-email-tm@tao.ma>
References: <1376555808-6531-1-git-send-email-tm@tao.ma>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-15 at 16:36 +0800, Tao Ma wrote:
> From: Tao Ma <boyu.mt@taobao.com>
> 
> When we are using netpoll, we don't go through the normal
> transmit process. In this case, bond_select_queue is not called
> and qdisc_skb_cb(skb)->slave_dev_queue_mapping isn't set.
> 

Yes?

In netpoll_send_skb_on_dev() we have:

        if (skb_queue_len(&npinfo->txq) == 0 && !
netpoll_owner_active(dev)) {
                struct netdev_queue *txq;

                txq = netdev_pick_tx(dev, skb);
                ...

where netdev_pick_tx() will call ->ndo_select_queue().


