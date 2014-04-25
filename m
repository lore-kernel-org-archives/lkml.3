Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaDYPnS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:43:18 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:53551 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144AbaDYPnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:43:16 -0400
Message-ID: <1398440595.29914.77.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH] net: guard against coalescing packets from buggy
 network drivers
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Svenning =?ISO-8859-1?Q?S=F8rensen?= <sss@secomea.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Fri, 25 Apr 2014 08:43:15 -0700
In-Reply-To: <535A78ED.3020309@secomea.com>
References: <535A78ED.3020309@secomea.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 17:02 +0200, Svenning Sørensen wrote:
> This patch adds a guard against coalescing packets received by buggy network
> drivers that don't initialize skb->tail properly.
> 
> Coalescing such packets will corrupt data in a way that makes it hard to
> track down the real cause of the problem. Observed symptoms are a flood of
> WARNs by tcp_recvmsg at random times, leaving no clear indication as to why
> the packet buffers were corrupted. See for example this thread:
> https://groups.google.com/forum/#!topic/linux.kernel/A8ZI9aXooSU
> 
> Obviously the correct thing to do is fixing the drivers in question (eg. by
> using skb_put() instead of just setting skb->len) - this patch will 
> hopefully
> help to track them down with less effort than I had to put into it :)
> 
> NB: in my case it was an out-of-tree Bluegiga WiFi driver; a quick look 
> indicates
> that there are in-tree drivers (for hardware that I don't own) with the 
> same bug.
> 
> 
> Signed-off-by: Svenning Soerensen <sss@secomea.com>

If you want a debugging patch, this should happen way before TCP stack
or even IP stack.

Say you want to use this buggy driver on a router, this code path will
never bit hit.


