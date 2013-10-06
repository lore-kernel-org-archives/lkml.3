Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab3JFVjx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 17:39:53 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:40159 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab3JFVjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 17:39:52 -0400
Date: Sun, 6 Oct 2013 23:35:36 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: provide public clk_is_enabled function
Message-ID: <20131006213536.GC30818@lunn.ch>
References: <1380881310-24345-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <20131005202430.GI10079@pengutronix.de>
 <20131005204208.GB28106@lunn.ch>
 <20131006090609.GK14747@book.gsilab.sittig.org>
 <20131006163011.GA30818@lunn.ch>
 <5251BD09.3050900@gmail.com>
 <20131006200223.32214.4440@quantum>
 <5251E334.2070008@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5251E334.2070008@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andrew has mentioned, that some bootloaders might disable clocks but
> leave the nodes enabled. Reading those registers would lock up
> the HW, of course. So we thought about to check clk gate status first,
> which this patch is about.
> 
> Of course, we can do clk_enable, read, clk_disable as said before - and
> given the amount of questions and misinterpretation, I think it is the
> saner way.

Hi Sebastian

I agree. As you say, too many people have asked questions or
misinterpretation what is happening, so lets go for the simpler method
people can understand.

I would also suggest in the ethernet driver, maybe set_params(), check
if we have a valid MAC address, and if not, issue a warning and call
to eth_hw_addr_random(dev) to get a random one.

   Andrew
