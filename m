Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932603Ab3FMHqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:46:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755611Ab3FMHqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:46:42 -0400
Date: Thu, 13 Jun 2013 10:30:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Julia Lawall <julia.lawall@lip6.fr>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Meyer <thomas@m3y3r.de>, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
Message-ID: <20130613073046.GB10326@redhat.com>
References: <1370080565.29224.29.camel@localhost.localdomain>
 <87mwr8sz9g.fsf@rustcorp.com.au>
 <20130603071526.GA5483@pengutronix.de>
 <alpine.DEB.2.02.1306082305220.1968@localhost6.localdomain6>
 <87mwquzkvf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87mwquzkvf.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 02:07:40PM +0930, Rusty Russell wrote:
> Julia Lawall <julia.lawall@lip6.fr> writes:
> > On Mon, 3 Jun 2013, Uwe Kleine-König wrote:
> > For a random example, here is a function that currently uses PTR_RET:
> 
> Heheh, nice choice: I think I wrote that code originally :)
> 
> > static int __net_init iptable_raw_net_init(struct net *net)
> > {
> >         struct ipt_replace *repl;
> >
> >         repl = ipt_alloc_initial_table(&packet_raw);
> > 	if (repl == NULL)
> >                 return -ENOMEM;
> >         net->ipv4.iptable_raw =
> >                 ipt_register_table(net, &packet_raw, repl);
> > 	kfree(repl);
> >         return PTR_RET(net->ipv4.iptable_raw);
> > }
> >
> > If it becomes return PTR_ERR(...); at the end, won't it look like the 
> > function always fails?
> 
> That is a valid point, though in this case the reader will know that
> can't be the case.
> 
> On the other hand, there's an incremental learning curve cost to every
> convenience function we add.  There are only 50 places where we use
> PTR_RET(), so it's not saving us very much typing over the clearest
> solution: open-coding the test.
> 
> I think using PTR_ERR() is a less bad solution than promoting PTR_RET,
> which has a non-obvious name.
> 
> Cheers,
> Rusty.

Will a longer name make the function more obvious?
	PTR_ERR_OR_ZERO() ?
	PTR_ERR0() ?
PTR_ERR() can then stay simple for cases where we know we
are on the error path.

-- 
MST
