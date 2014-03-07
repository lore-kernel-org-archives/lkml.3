Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955AbaCGVa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:30:29 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:45344 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaCGVaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:30:23 -0500
Date: Fri, 7 Mar 2014 13:30:17 -0800
From: josh@joshtriplett.org
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, alistair@popple.id.au,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>,
        Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: rfc: checkpatch logical line continuations (was IBM Akebono:
 Add support for a new PHY interface to the IBM emac driver)
Message-ID: <20140307213017.GA18769@cloud>
References: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
 <1394077948-8395-3-git-send-email-alistair@popple.id.au>
 <20140307.154142.488351276799532264.davem@davemloft.net>
 <1394226164.16156.96.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394226164.16156.96.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2014 at 01:02:44PM -0800, Joe Perches wrote:
> On Fri, 2014-03-07 at 15:41 -0500, David Miller wrote:
> > From: Alistair Popple <alistair@popple.id.au>
> > Date: Thu,  6 Mar 2014 14:52:25 +1100
> > 
> > > +	out_be32(dev->reg, in_be32(dev->reg) | WKUP_ETH_RGMIIEN
> > > +		 | WKUP_ETH_TX_OE | WKUP_ETH_RX_IE);
> > 
> > When an expression spans multiple lines, the lines should end with
> > operators rather than begin with them.
> 
> That's not in CodingStyle currently.

It's also not even remotely consistent across existing kernel code, and
it isn't obvious that there's a general developer consensus on the
"right" way to write it.

> Right now, checkpatch emits a --strict only warning on "&&" or "||"
> at the beginning of line but that could be changed to any "$Operators"
> 
> our $Arithmetic = qr{\+|-|\*|\/|%};
> our $Operators	= qr{
> 			<=|>=|==|!=|
> 			=>|->|<<|>>|<|>|!|~|
> 			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
> 		  }x;
> 
> The ones that likely have a too high false positive rates
> are the negation "!" and bitwise "~".

I don't think warning about operators at start of line seems like a good
idea at all.  There are plenty of cases where putting the operator at
the start of the line will produce a better result.  (I'd actually
suggest that in *most* cases.)

> Also, using perl, it's hard to distinguish between a
> logical "&" and the address-of "&" as well as the
> multiplication "*" and indirection "*" so maybe those
> should be excluded too.
> 
> And I think it should only be added as a --strict test.

Agreed, if even that.

- Josh Triplett
