Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363AbaEZLeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 07:34:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:44130 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337AbaEZLeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 07:34:21 -0400
Date: Mon, 26 May 2014 13:34:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: amirv@mellanox.com
cc: Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Or Gerlitz <ogerlitz@mellanox.com>, idos@mellanox.com,
        Yevgeny Petrilin <yevgenyp@mellanox.com>
Subject: Re: Extend irq_set_affinity_notifier() to use a call chain
In-Reply-To: <53832472.7070000@gmail.com>
Message-ID: <alpine.DEB.2.02.1405261327500.21720@ionos.tec.linutronix.de>
References: <5381DEDC.8050204@gmail.com> <alpine.DEB.2.02.1405261313570.21720@ionos.tec.linutronix.de> <53832472.7070000@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2014, Amir Vadai wrote:

> On 5/26/2014 2:15 PM, Thomas Gleixner wrote:
> > On Sun, 25 May 2014, Amir Vadai wrote:
> > > In order to do that, I need to add a new irq affinity notification
> > > callback (In addition to the existing cpu_rmap notification). For
> > > that I would like to extend irq_set_affinity_notifier() to have a
> > > notifier call-chain instead of a single notifier callback.
> > 
> > Why? "I would like" is a non argument.
> 
> Current implementation enables only one callback to be registered for irq
> affinity change notifications.

I'm well aware of that.
 
> cpu_rmap is registered be notified - for RFS purposes.  mlx4_en (and
> probably other network drivers) needs to be notified too, in order
> to stop the napi polling on the old cpu and move to the new one.  To
> enable more than 1 notification callbacks, I suggest to use a
> notifier call chain.

You are not describing what needs to be notified and why. Please
explain the details of that and how the RFS (whatever that is) and the
network driver are connected and why this notification cannot be
propagated inside the network stack itself.

notifier chains are almost always a clear sign for a design disaster
and I'm not going to even think about it before I do not have a
concice explanation of the problem at hand and why a notifier chain is
a good solution.

Thanks,

	tglx


