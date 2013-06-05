Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887Ab3FEOAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 10:00:13 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:41637 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3FEOAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 10:00:11 -0400
Message-ID: <1370440808.24311.254.camel@edumazet-glaptop>
Subject: RE: [PATCH v9 net-next 5/7] net: simple poll/select low latency
 socket poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 05 Jun 2013 07:00:08 -0700
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B7270@saturn3.aculab.com>
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
	 <20130605103452.11172.31453.stgit@ladj378.jer.intel.com>
	 <1370439054.24311.248.camel@edumazet-glaptop>
	 <AE90C24D6B3A694183C094C60CF0A2F6026B7270@saturn3.aculab.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 14:49 +0100, David Laight wrote:
> > I am a bit uneasy with this one, because an applicatio polling() on one
> > thousand file descriptors using select()/poll(), will call sk_poll_ll()
> > one thousand times.
> 
> Anything calling poll() on 1000 fds probably has performance
> issues already! Which is why kevent schemes have been added.
> 

You'll be surprised but many applications still use poll(),
and not epoll() or whatever OS specific interface, because they
are non portable or buggy. (I played with FreeBSD and kevent crashed
easily at 64,000 fds, while the epoll() version reached 4,000,000 fds
with no problems)




