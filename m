Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646Ab3HTVrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 17:47:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3HTVrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 17:47:41 -0400
Date: Tue, 20 Aug 2013 17:47:39 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: device-mapper development <dm-devel@redhat.com>,
        Frank Mayhar <fmayhar@google.com>
cc: Mike Snitzer <msnitzer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] [PATCH] dm: Make MIN_IOS, et al, tunable via
 sysctl.
In-Reply-To: <1377034118.24869.48.camel@bobble.lax.corp.google.com>
Message-ID: <alpine.LRH.2.02.1308201745130.8826@file01.intranet.prod.int.rdu2.redhat.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com> <alpine.LRH.2.02.1308201712090.8826@file01.intranet.prod.int.rdu2.redhat.com> <1377034118.24869.48.camel@bobble.lax.corp.google.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Aug 2013, Frank Mayhar wrote:

> On Tue, 2013-08-20 at 17:22 -0400, Mikulas Patocka wrote:
> > On Fri, 16 Aug 2013, Frank Mayhar wrote:
> > > The device mapper and some of its modules allocate memory pools at
> > > various points when setting up a device.  In some cases, these pools are
> > > fairly large, for example the multipath module allocates a 256-entry
> > > pool and the dm itself allocates three of that size.  In a
> > > memory-constrained environment where we're creating a lot of these
> > > devices, the memory use can quickly become significant.  Unfortunately,
> > > there's currently no way to change the size of the pools other than by
> > > changing a constant and rebuilding the kernel.
> > I think it would be better to set the values to some low value (1 should 
> > be enough, there is 16 in some places that is already low enough). There 
> > is no need to make it user-configurable, because the user will see no 
> > additional benefit from bigger mempools.
> > 
> > Maybe multipath is the exception - but other dm targets don't really need 
> > big mempools so there is no need to make the size configurable.
> 
> The point is not to make the mempools bigger, the point is to be able to
> make them _smaller_ for memory-constrained environments.  In some cases,
> even 16 can be too big, especially when creating a large number of
> devices.
> 
> In any event, it seems unfortunate to me that these values are
> hard-coded.  One shouldn't have to rebuild the kernel to change them,
> IMHO.

So make a patch that changes 16 to 1 if it helps on your system (I'd like 
to ask - what is the configuration where this kind of change helps?). 
There is no need for that to be tunable, anyone can live with mempool size 
being 1.

Mikulas
