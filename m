Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab3HGXWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 19:22:40 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51212 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933773Ab3HGXWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 19:22:37 -0400
Date: Wed, 07 Aug 2013 16:27:48 -0700 (PDT)
Message-Id: <20130807.162748.779496444843938176.davem@davemloft.net>
To: phil@nwl.cc
Cc: eric.dumazet@gmail.com, johannes@sipsolutions.net, sedat.dilek@gmail.com,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        hannes@stressinduktion.org, linux-wireless@vger.kernel.org,
        linville@tuxdriver.com
Subject: Re: linux-next: Tree for Aug 7
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130807183758.GB16263@orbit.nwl.cc>
References: <1375893609.4004.33.camel@edumazet-glaptop>
	<20130807.104713.1615549684239408926.davem@davemloft.net>
	<20130807183758.GB16263@orbit.nwl.cc>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 07 Aug 2013 16:22:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>
Date: Wed, 7 Aug 2013 20:37:58 +0200

> One could simply call skb_push(skb, ETH_HLEN) right after calling
> eth_type_trans(skb, dev) in order to undo the 'data' and 'len'
> adjustment. Not sure if this kind of hack is the right way to go here,
> or if the whole af_packet parses ethernet header discussion should be
> opened again instead.

That's completely pointless work.

Without that header pull, the only two things left that
eth_type_trans() does is set the skb->protocol field and
set skb->dev.

And even the latter has to be done already in an else
branch in the suspect AF_PACKET code.

So this eth_type_trans() call is 2/3 duplicate or unnecessary work,
it's the completely the wrong thing to do.

Look, I'm going to fix this myself, because I'm pretty tired of
waiting for the obvious fix.
