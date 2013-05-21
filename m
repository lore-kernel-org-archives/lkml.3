Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288Ab3EUNnL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:43:11 -0400
Received: from mx0.aculab.com ([213.249.233.131]:57533 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753757Ab3EUNnJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:43:09 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
Date: Tue, 21 May 2013 14:42:34 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B7242@saturn3.aculab.com>
In-Reply-To: <519B6099.1080403@yandex-team.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] rcu: fix a race in hlist_nulls_for_each_entry_rcu macro
Thread-Index: Ac5WGhBevBZ32l1sQ4a+zFGoDZUZKgADp5NQ
References: <519B38EC.90401@yandex-team.ru> <AE90C24D6B3A694183C094C60CF0A2F6026B7241@saturn3.aculab.com> <519B6099.1080403@yandex-team.ru>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Roman Gushchin" <klamm@yandex-team.ru>
Cc: "Dipankar Sarma" <dipankar@in.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        <zhmurov@yandex-team.ru>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <eric.dumazet@gmail.com>,
        "Alexey Kuznetsov" <kuznet@ms2.inr.ac.ru>,
        "James Morris" <jmorris@namei.org>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "Patrick McHardy" <kaber@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> -#define hlist_nulls_first_rcu(head) \
> >> -	(*((struct hlist_nulls_node __rcu __force **)&(head)->first))
> >> +#define hlist_nulls_first_rcu(head)			\
> >> +	(*((struct hlist_nulls_node __rcu __force **)	\
> >> +	   &((volatile typeof(*head) *)head)->first))
> >
> > I'd have thought it would be better to change hlist_nulls_first_rcu().
> 
> It's exactly what I suggest. May be I miss something? Please, clarify.

Gah - chasing through too many defines in too many header files!
Actually making the 'head' structure have volatile pointers
might be better.
Possibly in struct hlist_nulls_node itself.
There are toooo many casts for sanity :-)

	David



