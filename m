Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750990Ab3LKHv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:51:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52930 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab3LKHv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:51:26 -0500
Date: Wed, 11 Dec 2013 08:51:17 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Terje =?iso-8859-15?Q?Bergstr=F6m?= <tbergstrom@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] gpu: host1x: clk_round_rate() can return a zero upon
 error
Message-ID: <20131211075117.GA24559@pengutronix.de>
References: <alpine.DEB.2.02.1312091746400.4127@tamien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312091746400.4127@tamien>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:49:47 up 108 days, 17:20, 47 users,  load average: 0.01, 0.06,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 06:00:12PM -0800, Paul Walmsley wrote:
> 
> Treat both negative and zero return values from clk_round_rate() as
> errors.  This is needed since subsequent patches will convert
> clk_round_rate()'s return value to be an unsigned type, rather than a
> signed type, since some clock sources can generate rates higher than
> (2^31)-1 Hz.
> 
> Eventually, when calling clk_round_rate(), only a return value of zero
> will be considered a error.  All other values will be considered valid
> rates.  The comparison against values less than 0 is kept to preserve
> the correct behavior in the meantime.

Shouldn't it be an error when the result is not within sensible limits
instead? What do you do with a rate of 1Hz?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
