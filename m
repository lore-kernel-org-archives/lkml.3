Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbaCGVCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 16:02:51 -0500
Received: from smtprelay0105.hostedemail.com ([216.40.44.105]:42179 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752553AbaCGVCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 16:02:48 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:3868:3870:3872:3874:4078:4081:4321:5007:6120:7576:7652:7901:8957:10004:10400:10471:10848:10967:11026:11232:11473:11658:11914:12043:12517:12519:12740:13019:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache
X-HE-Tag: smell43_1820e24102000
X-Filterd-Recvd-Size: 2314
Message-ID: <1394226164.16156.96.camel@joe-AO722>
Subject: rfc: checkpatch logical line continuations (was IBM Akebono: Add
 support for a new PHY interface to the IBM emac driver)
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: alistair@popple.id.au, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <error27@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Randy Dunlap <randy.dunlap@oracle.com>
Date: Fri, 07 Mar 2014 13:02:44 -0800
In-Reply-To: <20140307.154142.488351276799532264.davem@davemloft.net>
References: <1394077948-8395-1-git-send-email-alistair@popple.id.au>
	 <1394077948-8395-3-git-send-email-alistair@popple.id.au>
	 <20140307.154142.488351276799532264.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added some cc's)

On Fri, 2014-03-07 at 15:41 -0500, David Miller wrote:
> From: Alistair Popple <alistair@popple.id.au>
> Date: Thu,  6 Mar 2014 14:52:25 +1100
> 
> > +	out_be32(dev->reg, in_be32(dev->reg) | WKUP_ETH_RGMIIEN
> > +		 | WKUP_ETH_TX_OE | WKUP_ETH_RX_IE);
> 
> When an expression spans multiple lines, the lines should end with
> operators rather than begin with them.

That's not in CodingStyle currently.

Right now, checkpatch emits a --strict only warning on "&&" or "||"
at the beginning of line but that could be changed to any "$Operators"

our $Arithmetic = qr{\+|-|\*|\/|%};
our $Operators	= qr{
			<=|>=|==|!=|
			=>|->|<<|>>|<|>|!|~|
			&&|\|\||,|\^|\+\+|--|&|\||$Arithmetic
		  }x;

The ones that likely have a too high false positive rates
are the negation "!" and bitwise "~".

Also, using perl, it's hard to distinguish between a
logical "&" and the address-of "&" as well as the
multiplication "*" and indirection "*" so maybe those
should be excluded too.

And I think it should only be added as a --strict test.



