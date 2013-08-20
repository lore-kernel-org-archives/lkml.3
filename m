Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982Ab3HTJKI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:10:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49746 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab3HTJKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:10:06 -0400
Date: Tue, 20 Aug 2013 11:10:00 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 06/17] ARM: imx: remove custom .init_time hook
Message-ID: <20130820091000.GK31036@pengutronix.de>
Mail-Followup-To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
	Russell King <linux@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Sascha Hauer <kernel@pengutronix.de>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1376964271-22715-7-git-send-email-sebastian.hesselbarth@gmail.com>
 <20130820072642.GJ31036@pengutronix.de>
 <52132D6C.2080606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52132D6C.2080606@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:08:44 up 20 days, 18:12, 41 users,  load average: 0.10, 0.08,
 0.06
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 10:48:44AM +0200, Sebastian Hesselbarth wrote:
> On 08/20/2013 09:26 AM, Sascha Hauer wrote:
> >On i.MX5 the init_time hook calls mx5x_clocks_init_dt which calls
> >mx5x_clocks_init which not only calls of_clk_init() but also registers
> >all clocks in the system. You can't remove it.
> >
> >I am missing some
> >
> >CLK_OF_DECLARE(imx51, "fsl,imx51-ccm", imx51_clocks_init);
> >CLK_OF_DECLARE(imx53, "fsl,imx53-ccm", imx53_clocks_init);
> >
> >Somewhere.
> 
> Sascha,
> 
> you are right, I forgot to add the two lines above as replacement for
> the now removed direct call. If the general approach is accepted, I'll
> add them for sure.
> 
> Do imx51/imx53 still boot with CLK_OF_DECLARE added?

I can test this once the whole series arrived here. So far I only have
6/16 and 10/17. I probably need at least 1/17.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
