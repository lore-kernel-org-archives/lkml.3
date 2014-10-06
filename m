Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbaJFSXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 14:23:45 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:40305 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753022AbaJFSXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 14:23:44 -0400
Message-ID: <1412619822.11091.73.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH V2 linux-next] net: fix rcu access on phonet_routes
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Remi Denis-Courmont <courmisch@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date: Mon, 06 Oct 2014 11:23:42 -0700
In-Reply-To: <1412619321-2212-1-git-send-email-fabf@skynet.be>
References: <1412619321-2212-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-10-06 at 20:15 +0200, Fabian Frederick wrote:
> -Add __rcu annotation on table to fix sparse warnings:
> net/phonet/pn_dev.c:279:25: warning: incorrect type in assignment (different address spaces)
> net/phonet/pn_dev.c:279:25:    expected struct net_device *<noident>
> net/phonet/pn_dev.c:279:25:    got void [noderef] <asn:4>*<noident>
> net/phonet/pn_dev.c:376:17: warning: incorrect type in assignment (different address spaces)
> net/phonet/pn_dev.c:376:17:    expected struct net_device *volatile <noident>
> net/phonet/pn_dev.c:376:17:    got struct net_device [noderef] <asn:4>*<noident>
> net/phonet/pn_dev.c:392:17: warning: incorrect type in assignment (different address spaces)
> net/phonet/pn_dev.c:392:17:    expected struct net_device *<noident>
> net/phonet/pn_dev.c:392:17:    got void [noderef] <asn:4>*<noident>
> 
> -Access table with rcu_access_pointer (fixes the following sparse errors):
> net/phonet/pn_dev.c:278:25: error: incompatible types in comparison expression (different address spaces)
> net/phonet/pn_dev.c:391:17: error: incompatible types in comparison expression (different address spaces)
> 
> Suggested-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
> V2: use rcu_access_pointer instead of rcu_dereference out of rcu_read_lock context
>     (suggested by Eric Dumazet).

Acked-by: Eric Dumazet <edumazet@google.com>


