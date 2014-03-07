Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaCGVpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:45:34 -0500
Received: from smtprelay0048.hostedemail.com ([216.40.44.48]:35438 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143AbaCGVpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:45:32 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3868:3870:3872:3874:4078:4081:4321:5007:6120:7576:7652:7901:8957:10004:10226:10400:10471:10848:10967:11026:11232:11473:11658:11914:12043:12517:12519:12740:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,
X-HE-Tag: frame13_69f7b5d76822c
X-Filterd-Recvd-Size: 3268
Message-ID: <1394228725.16156.102.camel@joe-AO722>
Subject: Re: rfc: checkpatch logical line continuations (was IBM Akebono:
 Add support for a new PHY interface to the IBM emac driver)
From: Joe Perches <joe@perches.com>
To: josh@joshtriplett.org
Cc: David Miller <davem@davemloft.net>, alistair@popple.id.au,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>
Date: Fri, 07 Mar 2014 13:45:25 -0800
In-Reply-To: <20140307213017.GA18769@cloud>
References: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
	 <1394077948-8395-3-git-send-email-alistair@popple.id.au>
	 <20140307.154142.488351276799532264.davem@davemloft.net>
	 <1394226164.16156.96.camel@joe-AO722> <20140307213017.GA18769@cloud>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 13:30 -0800, josh@joshtriplett.org wrote:
> On Fri, Mar 07, 2014 at 01:02:44PM -0800, Joe Perches wrote:
> > On Fri, 2014-03-07 at 15:41 -0500, David Miller wrote:
> > > From: Alistair Popple <alistair@popple.id.au>
> > > Date: Thu,  6 Mar 2014 14:52:25 +1100
> > > 
> > > > +	out_be32(dev->reg, in_be32(dev->reg) | WKUP_ETH_RGMIIEN
> > > > +		 | WKUP_ETH_TX_OE | WKUP_ETH_RX_IE);
> > > 
> > > When an expression spans multiple lines, the lines should end with
> > > operators rather than begin with them.
> > 
> > That's not in CodingStyle currently.
> 
> It's also not even remotely consistent across existing kernel code, and
> it isn't obvious that there's a general developer consensus on the
> "right" way to write it.

I agree with that.  Stuff that's not in CodingStyle generally
doesn't have a developer consensus.

> > Right now, checkpatch emits a --strict only warning on "&&" or "||"
> > at the beginning of line but that could be changed to any "$Operators"
> > 
> > our $Arithmetic = qr{\+|-|\*|\/|%};
> > our $Operators	= qr{
> > 			<=|>=|==|!=|
> > 			=>|->|<<|>>|<|>|!|~|
> > 			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
> > 		  }x;
> > 
> > The ones that likely have a too high false positive rates
> > are the negation "!" and bitwise "~".
> 
> I don't think warning about operators at start of line seems like a good
> idea at all.  There are plenty of cases where putting the operator at
> the start of the line will produce a better result.  (I'd actually
> suggest that in *most* cases.)
> 
> > Also, using perl, it's hard to distinguish between a
> > logical "&" and the address-of "&" as well as the
> > multiplication "*" and indirection "*" so maybe those
> > should be excluded too.
> > 
> > And I think it should only be added as a --strict test.
> 
> Agreed, if even that.

And probably made specific to net/ and drivers/net like
a few other comment style tests until such time as a
consensus exists.


