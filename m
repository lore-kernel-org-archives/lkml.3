Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab3FEPUO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 11:20:14 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:65069 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514Ab3FEPUM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 11:20:12 -0400
Message-ID: <1370445606.24311.265.camel@edumazet-glaptop>
Subject: Re: [PATCH v9 net-next 5/7] net: simple poll/select low latency
 socket poll
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 05 Jun 2013 08:20:06 -0700
In-Reply-To: <51AF401C.2030506@linux.intel.com>
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
	  <20130605103452.11172.31453.stgit@ladj378.jer.intel.com>
	 <1370439054.24311.248.camel@edumazet-glaptop>
	 <51AF401C.2030506@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 16:41 +0300, Eliezer Tamir wrote:
> On 05/06/2013 16:30, Eric Dumazet wrote:

> > I am a bit uneasy with this one, because an applicatio polling() on one
> > thousand file descriptors using select()/poll(), will call sk_poll_ll()
> > one thousand times.
> 
> But we call sk_poll_ll() with nonblock set, so it will only test once
> for each socket and not loop.
> 
> I think this is not as bad as it sounds.
> We still honor the time limit on how long to poll.

We still call ndo_ll_poll() a thousand times, and probably do a
spinlock/unlock a thousand times in the driver.

I would definitely be convinced if you give us some performance numbers
of a poll() on a thousand tcp sockets for example.

See my following mail about sk_poll_ll()

