Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758459AbaGAQxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 12:53:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28021 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbaGAQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 12:53:32 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18DNxBx2y8pCgt8Tn1onzo0xTqOHTS8f6o=
X-DKIM: OpenDKIM Filter v2.0.1 titan 1A21B59F8C2
Date: Tue, 1 Jul 2014 12:53:19 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: mvebu: add armada drm init to Dove board setup
Message-ID: <20140701165319.GH23978@titan.lakedaemon.net>
References: <1404219871-18419-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1404219871-18419-5-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140701131026.GO32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701131026.GO32514@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On Tue, Jul 01, 2014 at 02:10:26PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 01, 2014 at 03:04:31PM +0200, Sebastian Hesselbarth wrote:
> > +	pdev = platform_device_register_full(&armada_drm_dev_info);
> > +	/* assign last found lcd node to drm device for clk lookup */
> > +	pdev->dev.of_node = clknp;
> 
> NAK.  This really isn't a good way to deal with this, even in a
> temporary basis.  While assigning a DT node to a manually created
> platform device does solve that problem, it also introduces the
> problem that this platform device will now match any platform driver
> which recognises the "marvell,dove-lcd" compatible type, which may
> occur _before_ we find the driver to match using the legacy strings.
> 
> There really isn't an easy solution to this other than doing the thing
> properly.

And this creates our current deadlock.

> The other problem in this series is that while you introduce some
> bindings which may work today, they're not going to work tomorrow, and
> that's a problem.  Don't do DT piecemeal like this and end up having to
> break the bindings (which we will have to do to add the endpoints.)

Seriously, we've got to do something to get off of the X.  Why not just
declare the binding Sebastian just sent as unstable?  Then we change it
as needed until we get all the pieces in place.

At KS2013, we discussed, and agreed upon the fact that we _can_ have
unstable bindings to keep the bus moving.  Perfection being the enemy of
getting it done and all.

Once we reach the goal of how we want the bindings to look, then we
declare it stable.  I know it's not ideal, but "plan it out perfectly
before pushing anything" isn't realistic either.

thx,

Jason.
