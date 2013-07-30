Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab3G3MSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:18:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:18926 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675Ab3G3MSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:18:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18YYl+Ifnn0Q3TgopYfVsgYNkEo3BzBRhA=
Date: Tue, 30 Jul 2013 08:17:43 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: David Gibson <david@gibson.dropbear.id.au>
Cc: Mark Rutland <mark.rutland@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <pawel.moll@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Dave Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] Defining schemas for Device Tree
Message-ID: <20130730121743.GB5882@titan.lakedaemon.net>
References: <2469263.vMN09Q7Tzi@flatron>
 <20130729150124.GS29916@titan.lakedaemon.net>
 <20130729164905.GB2280@localhost.localdomain>
 <20130729172339.GT29916@titan.lakedaemon.net>
 <20130730015031.GK29970@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730015031.GK29970@voom.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 11:50:31AM +1000, David Gibson wrote:
> On Mon, Jul 29, 2013 at 01:23:39PM -0400, Jason Cooper wrote:
> > On Mon, Jul 29, 2013 at 05:49:05PM +0100, Dave Martin wrote:
> > > On Mon, Jul 29, 2013 at 11:01:24AM -0400, Jason Cooper wrote:
> > > > On Mon, Jul 29, 2013 at 02:21:52AM +0200, Tomasz Figa wrote:
> > 
> > > > > b) What information should be specified in schemas? What level of 
> > > > >    granularity is required?
> > > > 
> > > > One item I don't see in this list is node ordering.  There's been some
> > > > discussion lately on deferred probing (re boot times).  If we were to
> > > > intentionally declare that DT are parsed in the order written, then a
> > > > lot of deferred probes could be avoided by moving eg the pinctrl node to
> > > > near the top of the tree.
> > > > 
> > > > This doesn't impact buses as much, since the nodes needing the bus are
> > > > already children.  However, anything accessed via phandles: pins,
> > > > clocks, regulators, etc could benefit from declaring and enforcing this.
> > > > Eg having the dtc warn when a phandle is used before it's corresponding
> > > > node is declared.
> > > > 
> > > > Not critical though, just a thought.
> > > 
> > > I don't think that siblings have any defined order in DT.  If reading a
> > > device tree, there's no guarantee you get nodes or properties out in the
> > > same order as the original .dts file.
> > 
> > That's why I raised the point.  If people think encoding initialization
> > order in the DT is a good idea, then we should change the dtc so it
> > compiles/decompiles in the same order.
> 
> I'm not actually sure what you mean by this.  dtc already preserves
> order between input and output.

This is an old comment (~ 1d, wow).  My position has evolved to seeing
if we can allow dtc to topsort nodes it can easily tell are needed first
as an optimization.  *Not* a requirement.  Deferred probing would still
be a fall back.

thx,

Jason.
