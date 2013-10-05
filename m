Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab3JEUqe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 16:46:34 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:40004 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab3JEUqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 16:46:33 -0400
Date: Sat, 5 Oct 2013 22:42:08 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: provide public clk_is_enabled function
Message-ID: <20131005204208.GB28106@lunn.ch>
References: <1380881310-24345-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20131005202430.GI10079@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131005202430.GI10079@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 05, 2013 at 10:24:30PM +0200, Uwe Kleine-König wrote:
> On Fri, Oct 04, 2013 at 12:08:30PM +0200, Sebastian Hesselbarth wrote:
> > To determine if a clk has been previously enabled, provide a public
> > clk_is_enabled function. This is especially helpful to check the state
> > of clk-gate without actually changing the state of the gate.
> I wonder what you want to do with the return value.
> 
> When doing
> 
> 	if (clk_is_enabled(someclk))
> 		do_something();
> 
> you cannot in general know if the clock is still on when you start to
> do_something.

Hi Uwe

At least in the use case Sebastian needs it for, we don't need an "in
general" solution. It is used early boot time to see if the boot
loader left the clock running. The other user of the clock is the
ethernet driver, which we know cannot change it yet, because driver
probing has not started yet.

	Andrew
