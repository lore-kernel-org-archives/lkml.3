Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022Ab3HZPdg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 11:33:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34163 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab3HZPdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 11:33:35 -0400
Date: Mon, 26 Aug 2013 17:33:29 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: =?iso-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Michal Simek <monstr@monstr.eu>, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
Message-ID: <20130826153329.GE24795@pengutronix.de>
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com>
 <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local>
 <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local>
 <20130823073250.GB30135@pengutronix.de>
 <521B38BF.6040400@monstr.eu>
 <20130826120716.GB24795@pengutronix.de>
 <521B4FCF.5000904@gmail.com>
 <c46b466a-1f8a-4b22-9dad-9d2419100b06@TX2EHSMHS043.ehs.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c46b466a-1f8a-4b22-9dad-9d2419100b06@TX2EHSMHS043.ehs.local>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:31:47 up 2 days,  1:02, 42 users,  load average: 0,00, 0,19, 0,50
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 08:16:29AM -0700, Sören Brinkmann wrote:
> On Mon, Aug 26, 2013 at 02:53:35PM +0200, Sebastian Hesselbarth wrote:
> > On 08/26/13 14:07, Steffen Trumtrar wrote:
> > >On Mon, Aug 26, 2013 at 01:15:11PM +0200, Michal Simek wrote:
> > >>I agree with Soren - let's fix the current problem and then when Steffen has patches with syscon
> > >>we can look at them.
> > >>
> > >>If there is any discussion about early syscon registration please let me know.
> > >>
> > >
> > >Where I'm stuck at the moment is: if I map the whole register space to the
> > >parent node, how do I get its mapped address in the clkc?
> > 
> > Steffen,
> > 
> > if slcr is such an essential part of the SoC, you can choose to provide
> > zynq_slcr_readl/writel callbacks. You can then use those callback in the
> > clock driver without knowing the base address. Also, it allows you to
> > hide slcr specific locking details from subsequent drivers using the
> > callbacks.
> 
> I don't think that'll work. The clkc just wraps the cock primitives and
> does not provide a lot of own clock drivers - actually only one. Those
> clock primitives receive an iomapped address for the clock control which
> is then accessed using readl/writel(). So, wrapping all SLCR accesses in
> special accessors would mean to have almost identical reimplementations
> of all used clock primitives, just to replace readl/writel with
> zynq_slcr_write/read. Or is there some way to make this actually work?

This is exactly my understanding, why I can't use a callback here. At least
not for the clkc.

str

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
