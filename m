Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaFNThe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 15:37:34 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:4976 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbaFNThd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 15:37:33 -0400
X-IronPort-AV: E=Sophos;i="5.01,478,1400018400"; 
   d="scan'208";a="80080408"
Date: Sat, 14 Jun 2014 21:37:23 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Himangi Saraogi <himangi774@gmail.com>
cc: Joe Perches <joe@perches.com>, Julia Lawall <Julia.Lawall@lip6.fr>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coccinelle : Script to detect cast after memory
 allocation
In-Reply-To: <CAB78YHwDpK988sKk5pzXWhuMszyyS=wtk5ETP-B-JBGdwRPxhw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1406142136480.2018@localhost6.localdomain6>
References: <20140614154541.GA4179@himangi-Dell> <1402761961.2756.12.camel@joe-AO725> <alpine.DEB.2.02.1406141809050.1962@localhost6.localdomain6> <1402765314.2756.20.camel@joe-AO725> <CAB78YHwDpK988sKk5pzXWhuMszyyS=wtk5ETP-B-JBGdwRPxhw@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-315456137-1402774644=:2018"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-315456137-1402774644=:2018
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 15 Jun 2014, Himangi Saraogi wrote:

> Hi,
> 
> I have run the generic rule but it does not detect the cases of
> cast where the k[mzc]alloc or the kmem functions are used. I have used
> flags like recursive-includes, as suggested by Julia, but not any of the
> cases covered by the original script are detected.

Are other things detected?  You could always expand the rule to be more 
comprehensive.

julia


> Thanks
> Himangi
> 
> 
> On 14 June 2014 22:31, Joe Perches <joe@perches.com> wrote:
>       On Sat, 2014-06-14 at 18:11 +0200, Julia Lawall wrote:
>       > On Sat, 14 Jun 2014, Joe Perches wrote:
> []
> > > Perhaps make this more generic for any void *?
> > >
> > > Something like:
> > >
> > > @@
> > > void *t;
> > > type other;
> > > @@
> > >
> > > -       (other *)t
> > > +       t
> []
> > Perhaps it would be reasonable to add this among the specific
> functions.
> > That is, t could be part of the disjunctions.
> 
> You do have to make sure that the
> "casted to" type is not dereferenced.
> 
> ie: don't transform
> 
> void func(void *foo)
> {
>         unsigned long bar = *(unsigned long *)foo;
> }
> 
> Also there may be some __user cast types and
> such that may be necessary to exclude too.
> 
> 
> 
> 
> 
> 
--8323328-315456137-1402774644=:2018--
