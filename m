Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab3FMH4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:56:19 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:28860 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755531Ab3FMH4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:56:18 -0400
X-IronPort-AV: E=Sophos;i="4.87,857,1363129200"; 
   d="scan'208";a="21612731"
Date: Thu, 13 Jun 2013 09:56:11 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: Rusty Russell <rusty@rustcorp.com.au>, Julia Lawall <julia.lawall@lip6.fr>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Meyer <thomas@m3y3r.de>, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
In-Reply-To: <20130613073046.GB10326@redhat.com>
Message-ID: <alpine.DEB.2.02.1306130955380.2260@hadrien>
References: <1370080565.29224.29.camel@localhost.localdomain> <87mwr8sz9g.fsf@rustcorp.com.au> <20130603071526.GA5483@pengutronix.de> <alpine.DEB.2.02.1306082305220.1968@localhost6.localdomain6> <87mwquzkvf.fsf@rustcorp.com.au>
 <20130613073046.GB10326@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-818502900-1371110171=:2260"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-818502900-1371110171=:2260
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Thu, 13 Jun 2013, Michael S. Tsirkin wrote:

> On Thu, Jun 13, 2013 at 02:07:40PM +0930, Rusty Russell wrote:
> > Julia Lawall <julia.lawall@lip6.fr> writes:
> > > On Mon, 3 Jun 2013, Uwe Kleine-König wrote:
> > > For a random example, here is a function that currently uses PTR_RET:
> >
> > Heheh, nice choice: I think I wrote that code originally :)
> >
> > > static int __net_init iptable_raw_net_init(struct net *net)
> > > {
> > >         struct ipt_replace *repl;
> > >
> > >         repl = ipt_alloc_initial_table(&packet_raw);
> > > 	if (repl == NULL)
> > >                 return -ENOMEM;
> > >         net->ipv4.iptable_raw =
> > >                 ipt_register_table(net, &packet_raw, repl);
> > > 	kfree(repl);
> > >         return PTR_RET(net->ipv4.iptable_raw);
> > > }
> > >
> > > If it becomes return PTR_ERR(...); at the end, won't it look like the
> > > function always fails?
> >
> > That is a valid point, though in this case the reader will know that
> > can't be the case.
> >
> > On the other hand, there's an incremental learning curve cost to every
> > convenience function we add.  There are only 50 places where we use
> > PTR_RET(), so it's not saving us very much typing over the clearest
> > solution: open-coding the test.
> >
> > I think using PTR_ERR() is a less bad solution than promoting PTR_RET,
> > which has a non-obvious name.
> >
> > Cheers,
> > Rusty.
>
> Will a longer name make the function more obvious?
> 	PTR_ERR_OR_ZERO() ?
> 	PTR_ERR0() ?
> PTR_ERR() can then stay simple for cases where we know we
> are on the error path.

I was thinking of something along those lines.  And in that case, PTR_ERR
could stay without the additional test.

julia
--8323329-818502900-1371110171=:2260--
