Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3H0DW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 23:22:58 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:26064 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752090Ab3H0DW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 23:22:57 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19s2NBcVMbipYlB42Jz5mmOyaRnxDihw6E=
Date: Mon, 26 Aug 2013 23:22:37 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Jisheng Zhang <jszhang@marvell.com>
Cc: "andrew@lunn.ch" <andrew@lunn.ch>,
        "gregory.clement@free-electrons.com" 
	<gregory.clement@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "ezequiel.garcia@free-electrons.com" 
	<ezequiel.garcia@free-electrons.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 0/3] arm: mvebu: fix resource leak
Message-ID: <20130827032237.GA19598@titan.lakedaemon.net>
References: <1377517018-7716-1-git-send-email-jszhang@marvell.com>
 <20130826204523.GD24470@titan.lakedaemon.net>
 <20130827110120.0a9fab2a@xhacker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130827110120.0a9fab2a@xhacker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 11:01:20AM +0800, Jisheng Zhang wrote:
> Dear Jason,
> 
> On Mon, 26 Aug 2013 13:45:23 -0700
> Jason Cooper <jason@lakedaemon.net> wrote:
> 
> > On Mon, Aug 26, 2013 at 07:36:55PM +0800, Jisheng Zhang wrote:
> > > These patches try to fix resource leak by adding missing of_node_put(),
> > > iounmap or using devm_ioremap_resource() if available.
> > > 
> > > v4:
> > >   - re-generate since Ezequiel's patches add DT support to the
> > > mvebu-mbus driver
> > 
> > grrr.  I hate to ask this, but can you please rebase patches 1 and 2
> > against mvebu/fixes-non-critical?  No need to add back in the mvebu-mbus
> > hunk.
> 
> patch 1 also fixes one similar trivial issue introduced since 994c8c94b419e
> "ARM: mvebu: Remove the harcoded BootROM window allocation" in linux-next tree
> 
> patch 2 is updated to fix similar trivial issue introduce since 6839cfa82f99
> "bus: mvebu-mbus: Introduce device tree binding"
> 
> These two commits aren't included in mvebu/fixes-non-criticial yet. Could you
> please give suggestion?

Yes, that's correct.  We prefer to have patch submitters base off of a
mainline tag (eg v3.11-rc7).  conflicts between patchsets are then
caught and resolved when branches are merged.  If done correctly, the
merge resolution should be obvious in most cases.

The upstream maintainers _prefer_ to see those conflicts because it
gives them a better sense of who is tinkering in the same code-paths.

Trying to base patches off of disparate branches in order to
'pre-resolve' those conflicts creates unnecessary dependencies and
non-obvious merge-resolutions.

In this case I asked you base off of mvebu/fixes-non-critical because
that is where I will be applying them for queueing to arm-soc.  You
could also base off of v3.11-rc7, there's nothing in
mvebu/fixes-non-critical that should conflict with your changes.

thx,

Jason.
