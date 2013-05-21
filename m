Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633Ab3EUNhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:37:34 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:54002 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3EUNhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:37:33 -0400
Message-ID: <1369143450.3301.217.camel@edumazet-glaptop>
Subject: Re: [PATCH] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
From: Eric Dumazet <eric.dumazet@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Roman Gushchin <klamm@yandex-team.ru>,
        Dipankar Sarma <dipankar@in.ibm.com>, zhmurov@yandex-team.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>
Date: Tue, 21 May 2013 06:37:30 -0700
In-Reply-To: <20130521120906.GD3578@linux.vnet.ibm.com>
References: <519B38EC.90401@yandex-team.ru>
	 <20130521120906.GD3578@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 05:09 -0700, Paul E. McKenney wrote:
> > 
> > -#define hlist_nulls_first_rcu(head) \
> > -	(*((struct hlist_nulls_node __rcu __force **)&(head)->first))
> > +#define hlist_nulls_first_rcu(head)			\
> > +	(*((struct hlist_nulls_node __rcu __force **)	\
> > +	   &((volatile typeof(*head) *)head)->first))
> 
> Why not use ACCESS_ONCE() or (better) rcu_dereference_raw() here?
> 

+1

Very good catch Roman !

Thanks !


