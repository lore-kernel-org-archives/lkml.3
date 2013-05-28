Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964978Ab3E1SDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:03:40 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:64544 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964903Ab3E1SDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:03:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+R86+/0rzRMwkXqWNiNe+m/ZeeHPQ8PLY=
Date: Tue, 28 May 2013 14:02:27 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Lennert Buytenhek <buytenh@wantstofly.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 2/2] net: mv643xx_eth: proper initialization for
 Kirkwood SoCs
Message-ID: <20130528180227.GY31290@titan.lakedaemon.net>
References: <1369253042-15082-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130522201607.GA18823@obsidianresearch.com>
 <20130523160111.GP31290@titan.lakedaemon.net>
 <20130523171112.GB31281@obsidianresearch.com>
 <20130523172339.GQ31290@titan.lakedaemon.net>
 <20130523175357.GB2821@obsidianresearch.com>
 <20130523184028.GU31290@titan.lakedaemon.net>
 <20130523190140.GA4010@obsidianresearch.com>
 <20130524164636.GV31290@titan.lakedaemon.net>
 <20130524173306.GA30022@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130524173306.GA30022@obsidianresearch.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

Sorry, I meant to get back to this earlier and it slipped off of my
plate. :(

On Fri, May 24, 2013 at 11:33:06AM -0600, Jason Gunthorpe wrote:
> On Fri, May 24, 2013 at 12:46:36PM -0400, Jason Cooper wrote:
> 
> > > Why are you not keen on this? It seems like normal device driver
> > > practice, that is what the data field of of_device_id is typically
> > > used for..
> > 
> > I'm not keen on it because we don't have a document saying "All kirkwood
> > SoCs need PSC1 set to X after reset."  We know it, but have we tested
> > the 6282?
> 
> I disagree. The manul is very clear how PSC1 must be set for proper
> operation. Clk125BypassEn bit is used only for loopback testing, it
> should never set for driver operation. Similarly PortReset must be
> cleared for driver operation.
> 
> It is always safe for the driver to clear these bits, if it knows they
> are available.  In fact, I would argue the driver should always clear
> these bits so that the bootloader isn't relied on to do it. It doesn't
> matter if the SOC errantly sets the bit or not, it can *always* be
> safely cleared.

Great!

> Further, I compared my 88F6282/88F6283 manual against the public
> 88F6180/88F619x/88F6281 spec and confirmed that the PSC1 layout is the
> same.

Even better.

> So all of these SOC's can share a driver compatible string.

Ok, "marvell,kirkwood-eth" works for me then.  I think Sebastian already
has patches for that.

> AFAICT the only reason the driver doesn't touch PSC1 today is because
> the PSC1 was introduced in a later IP revision and its presence isn't
> auto-detectable.

Makes sense.

> The last bit of the puzzle to get bootloader independence on kirkwood
> is to encode the phy interface type (GMII/RGMII/BASE-X) in the DT so
> the entire PSC1 can be set by the driver..

Hmm, let's work on that separately, and later.  I've snowballed this
attempt enough ;-)

Thanks for digging into this for us,

Jason.
