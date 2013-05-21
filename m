Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3EUTaA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 15:30:00 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38073 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674Ab3EUT36 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 15:29:58 -0400
Message-ID: <1369164596.3301.249.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 net-next 1/4] net: implement support for low latency
 socket polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Pekka Riikonen <priikone@iki.fi>, Dave Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 12:29:56 -0700
In-Reply-To: <519BCA37.4020707@linux.intel.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	  <20130520101601.14133.874.stgit@ladj378.jer.intel.com>
	  <1369063764.3301.182.camel@edumazet-glaptop>
	  <519B2237.20204@linux.intel.com>
	  <1369142926.3301.213.camel@edumazet-glaptop>
	  <alpine.GSO.2.00.1305211855120.9230@git.silcnet.org>
	  <1369158499.3301.236.camel@edumazet-glaptop>
	 <1369158686.3301.237.camel@edumazet-glaptop>
	 <519BCA37.4020707@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 22:25 +0300, Eliezer Tamir wrote:
> On 21/05/2013 20:51, Eric Dumazet wrote:
> > On Tue, 2013-05-21 at 10:48 -0700, Eric Dumazet wrote:
> >
> >> We do not keep skb->dev information once a packet leaves the rcu
> >> protected region.
> >>
> >> Once packet is queued to tcp input queues, skb->dev is NULL.
> >
> > This is done in tcp_v4_rcv() & tcp_v6_rcv()
> 
> So if we move calling sk_mark_ll() into the rcu protected region,
> We would not need the gen id in the skb.
> We could save skb->dev and skb->queue_mapping along with the generation 
> id in the socket.
> 
> then we don't need to change the skb struct at all.
> skb_mark_ll() can go away.
> we also call sk_mark_ll in one central place in net_protocol->handler 
> instead of all over the place.
> 
> or am I missing something?


You cannot keep a pointer to some object without taking a reference on
the object.

Thats why I suggested to use an napi identifier instead, this is safe
and cheap.



