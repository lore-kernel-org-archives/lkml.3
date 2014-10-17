Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaJQVT1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 17:19:27 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50320 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbaJQVT0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 17:19:26 -0400
Message-ID: <1413580764.27176.12.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: getaddrinfo slowdown in 3.17.1, due to getifaddrs
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: tgraf@suug.ch, sgunderson@bigfoot.com, linux-kernel@vger.kernel.org,
        nikolay@redhat.com
Date: Fri, 17 Oct 2014 14:19:24 -0700
In-Reply-To: <20141017.123055.1381956207136104867.davem@davemloft.net>
References: <20141017003430.GB29584@sesse.net>
	 <20141017062517.GA11584@casper.infradead.org>
	 <1413563283.24953.30.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141017.123055.1381956207136104867.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-17 at 12:30 -0400, David Miller wrote:

> Can I ask a serious question?  What is the synchronize_net() in AF_NETLINK
> exactly needed for?

__netlink_lookup() calls rhashtable_lookup_compare()

So you really want that any object found in this lookup respects
rcu grace period before being freed.

RCU contract is pretty clear about deletions of objects.



