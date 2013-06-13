Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3FMGsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 02:48:00 -0400
Received: from ozlabs.org ([203.10.76.45]:55373 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750762Ab3FMGr7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 02:47:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Julia Lawall <julia.lawall@lip6.fr>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Thomas Meyer <thomas@m3y3r.de>, mst@redhat.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
Subject: Re: [RFC] PTR_ERR: return 0 if ptr isn't an error value.
In-Reply-To: <alpine.DEB.2.02.1306082305220.1968@localhost6.localdomain6>
References: <1370080565.29224.29.camel@localhost.localdomain> <87mwr8sz9g.fsf@rustcorp.com.au> <20130603071526.GA5483@pengutronix.de> <alpine.DEB.2.02.1306082305220.1968@localhost6.localdomain6>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 13 Jun 2013 14:07:40 +0930
Message-ID: <87mwquzkvf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall <julia.lawall@lip6.fr> writes:
> On Mon, 3 Jun 2013, Uwe Kleine-König wrote:
> For a random example, here is a function that currently uses PTR_RET:

Heheh, nice choice: I think I wrote that code originally :)

> static int __net_init iptable_raw_net_init(struct net *net)
> {
>         struct ipt_replace *repl;
>
>         repl = ipt_alloc_initial_table(&packet_raw);
> 	if (repl == NULL)
>                 return -ENOMEM;
>         net->ipv4.iptable_raw =
>                 ipt_register_table(net, &packet_raw, repl);
> 	kfree(repl);
>         return PTR_RET(net->ipv4.iptable_raw);
> }
>
> If it becomes return PTR_ERR(...); at the end, won't it look like the 
> function always fails?

That is a valid point, though in this case the reader will know that
can't be the case.

On the other hand, there's an incremental learning curve cost to every
convenience function we add.  There are only 50 places where we use
PTR_RET(), so it's not saving us very much typing over the clearest
solution: open-coding the test.

I think using PTR_ERR() is a less bad solution than promoting PTR_RET,
which has a non-obvious name.

Cheers,
Rusty.
