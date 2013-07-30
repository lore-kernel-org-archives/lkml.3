Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462Ab3G3MNd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:13:33 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:13807 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752257Ab3G3MNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:13:30 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX199x4KvP6042qc8wVsYV4z8+yVK8k8yTxU=
Date: Tue, 30 Jul 2013 08:12:59 -0400
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
Message-ID: <20130730121259.GA5882@titan.lakedaemon.net>
References: <2469263.vMN09Q7Tzi@flatron>
 <20130729150124.GS29916@titan.lakedaemon.net>
 <20130729164905.GB2280@localhost.localdomain>
 <20130729172339.GT29916@titan.lakedaemon.net>
 <20130729222920.GF29970@voom.fritz.box>
 <20130729224840.GZ29916@titan.lakedaemon.net>
 <20130729234532.GH29970@voom.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130729234532.GH29970@voom.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 09:45:32AM +1000, David Gibson wrote:
> On Mon, Jul 29, 2013 at 06:48:40PM -0400, Jason Cooper wrote:
> > On Tue, Jul 30, 2013 at 08:29:20AM +1000, David Gibson wrote:
> > > On Mon, Jul 29, 2013 at 01:23:39PM -0400, Jason Cooper wrote:
> > > > On Mon, Jul 29, 2013 at 05:49:05PM +0100, Dave Martin wrote:
> > > > > On Mon, Jul 29, 2013 at 11:01:24AM -0400, Jason Cooper wrote:
> > > > > > On Mon, Jul 29, 2013 at 02:21:52AM +0200, Tomasz Figa wrote:
> > > > 
> > > > > > > b) What information should be specified in schemas? What level of 
> > > > > > >    granularity is required?
> > > > > > 
> > > > > > One item I don't see in this list is node ordering.  There's been some
> > > > > > discussion lately on deferred probing (re boot times).  If we were to
> > > > > > intentionally declare that DT are parsed in the order written, then a
> > > > > > lot of deferred probes could be avoided by moving eg the pinctrl node to
> > > > > > near the top of the tree.
> > > > > > 
> > > > > > This doesn't impact buses as much, since the nodes needing the bus are
> > > > > > already children.  However, anything accessed via phandles: pins,
> > > > > > clocks, regulators, etc could benefit from declaring and enforcing this.
> > > > > > Eg having the dtc warn when a phandle is used before it's corresponding
> > > > > > node is declared.
> > > > > > 
> > > > > > Not critical though, just a thought.
> > > > > 
> > > > > I don't think that siblings have any defined order in DT.  If reading a
> > > > > device tree, there's no guarantee you get nodes or properties out in the
> > > > > same order as the original .dts file.
> > > > 
> > > > That's why I raised the point.  If people think encoding initialization
> > > > order in the DT is a good idea, then we should change the dtc so it
> > > > compiles/decompiles in the same order.
> > > 
> > > I've always considered the DT to be unordered, although the flattened
> > > representation obviously has to have some order.  It is much safer to
> > > explicitly represent any required orderings with properties, rather
> > > than to rely on the flattened tree order.  I really don't think trying
> > > to have dtc magically understand device initialization ordering in
> > > this way is a good idea.
> > > 
> > > Fwiw, dtc generally preserves order between input and output, with the
> > > exception of the -s option, which sorts the subnodes of each node by
> > > name (useful for dtdiff).
> > > 
> > > > > Provided child/parent relationships are maintained and the set of nodes
> > > > > and values is the same, I think completely rearranging a .dts file does
> > > > > not change its meaning.
> > > > > 
> > > > > "depends-on" relationships mostly have to come from the semantics of
> > > > > the bindings themselves: for example, if a device is connected to some
> > > > > clocks and regulators, the kernel may need to probe those first.
> > > > 
> > > > true, the answer to this problem may be to create a depgraph of the
> > > > nodes based on phandles and child status, then init.  However, if the
> > > > goal is to accelerate boot times, then that should not be calculated
> > > > during each boot, especially since it doesn't likely change from boot to
> > > > boot.
> > > > 
> > > > Which means it would either go in the dtc (dts node ordering is
> > > > irrelevant), or in the dts.  I'm inclined to say dtc should do it, but I
> > > > like the aesthetics of things being in the proper order in something I
> > > > can read.  After all, C requires functions to be declared before use,
> > > > even though the compiler could figure it out.
> > > 
> > > It's not necessarily possible to encode device initialization order in
> > > flattened tree order.  Suppose you have bus A with devices A1 and A2,
> > > and bus B with devices B1 and B2.  A1 must be initialized before B1,
> > > but B2 must be initialized before A2.  There are no loops there, it's
> > > a valid set of initialization order constraints, but you can't get
> > > both of them right in the flat tree ordering.
> > 
> > True, but is there a real scenario where this is the case?  In any
> > event, this could still fall back to deferred probing.
> 
> I never count on weird and wonderful arrangements _not_ appearing in
> embedded.

:-)

> But, in regards to falling back do deferred probing.  If you're
> thinking of the fdt ordering as purely an optimization, rather than
> _required_ to get device init correct, then that's a very different
> matter.  I have no problem with optimizing the ordering, as long as
> its expected that the kernel will still be correct with arbitrary
> ordering.

Yes, after sleeping on it a night, I agree.

> > As I think about it more, working with only what dtc can definitely see,
> > eg busses and phandles, some ordering optimization could be done to
> > reduce the number of probe deferrals.
> 
> Well.  It depends what you mean here.  To do this fully would require
> dtc to interpret properties much more than it currently does - in
> nearly all cases it treats them as opaque blobs, whereas many
> different kinds of properties can potentially include phandles, and
> you have to know how to parse them to discover them.
> 
> On the other hand, if what you're referring to is dtc's &-syntax for
> phandle references, then I guess we could topsort on that.  As long as
> we bear in mind that that can miss cases, if people hand craft their
> phandles, instead of using references.

Just this would eliminate a majority of probe deferrals.

For example, on the Seagate Wireless Plus I was recently trying to put a
mainline kernel on, all of the probe deferrals were pinctrl related.
Just topsorting that node would've fixed the problem.

thx,

Jason.
