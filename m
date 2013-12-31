Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3LaQJi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 11:09:38 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:11345 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639Ab3LaQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 11:09:36 -0500
X-IronPort-AV: E=Sophos;i="4.95,581,1384297200"; 
   d="scan'208";a="51218170"
Date: Tue, 31 Dec 2013 17:09:20 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Ben Greear <greearb@candelatech.com>
cc: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        kernel-janitors@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/11]  use ether_addr_equal_64bits
In-Reply-To: <52C2E8BA.6000800@candelatech.com>
Message-ID: <alpine.DEB.2.10.1312311704320.2074@hadrien>
References: <1388427307-8691-1-git-send-email-Julia.Lawall@lip6.fr>  <1388427307-8691-5-git-send-email-Julia.Lawall@lip6.fr>  <1388429761.4410.1.camel@jlt4.sipsolutions.net>  <alpine.DEB.2.02.1312302057420.2209@localhost6.localdomain6> 
 <1388438724.4573.2.camel@jlt4.sipsolutions.net>  <20131230215701.GA4938@khazad-dum.debian.net>  <1388445188.18164.0.camel@jlt4.sipsolutions.net> <1388445422.26796.38.camel@joe-AO722> <alpine.DEB.2.02.1312310726540.1930@localhost6.localdomain6>
 <52C2E8BA.6000800@candelatech.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 31 Dec 2013, Ben Greear wrote:

> On 12/30/2013 10:32 PM, Julia Lawall wrote:
> > > > > > I'm just thinking of a programmer, e.g. changing a struct like this:
> > > > > >
> > > > > >   struct foo {
> > > > > >     u8 addr[ETH_ALEN];
> > > > > > -  u16 dummy;
> > > > > >   };
> > >
> > > I don't know of a way to catch that.
> > > Anyone else?
> >
> > Well, one could have a semantic patch that checks for that.  But the
> > problem is that it is very slow, and it only covers the cases that I can
> > transform automatically, which currently means no pointers, only explicit
> > arrays.
> >
> > On the other hand, I am finding the structure definition, so I can easily
> > update the structure definition with an appropriate comment.
> >
> > struct foo {
> >      u8 addr[ETH_ALEN]; /* must be followed by two bytes in the structure */
> >      u16 dummy;
> > };
> >
> > Unfortunately it is kind of verbose.  Could there be an attribute?  That
> > could even easily be checked.
>
> Can you not just add a build-time macro to check that sizeof(foo) >= 8
> for each of these struct foos?  Or, is it required that the dummy field
> be there and be not used by anything else?

It doesn't matter what the field is used for.  The problem is that is it
necessary to ensure a property of the position of addr within the
structure.  It has to have at least 16 bytes after it.

But maybe something with sizeof(foo) and offset_of would do?

Could the macro be put near the declaration of the structure somehow?

julia
