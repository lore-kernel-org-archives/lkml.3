Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3H1UeZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:34:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39290 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3H1UeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:34:24 -0400
Date: Wed, 28 Aug 2013 22:34:19 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] imx-drm: Fix probe failure
Message-ID: <20130828203418.GW30088@pengutronix.de>
References: <1377657163-6606-1-git-send-email-festevam@gmail.com>
 <20130828052758.GQ30088@pengutronix.de>
 <CAOMZO5BiE7tqja9p51gOGEwtWsKjyX23qZ3=ewyuubMwsgXcLA@mail.gmail.com>
 <20130828185459.GV30088@pengutronix.de>
 <CAOMZO5CuGAH+5+8cE7tjzZTXhLbFxMRt13mhimuBLJkRQz6+7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMZO5CuGAH+5+8cE7tjzZTXhLbFxMRt13mhimuBLJkRQz6+7Q@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 22:32:37 up 4 days,  6:03, 28 users,  load average: 0.00, 0.08, 0.10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 05:10:16PM -0300, Fabio Estevam wrote:
> On Wed, Aug 28, 2013 at 3:54 PM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Do the open/close callbacks work?
> 
> The 'open' callback maps to the generic 'drm_open', so we cannot use it.

We could replace this, but...

> 
> Shouldn't we rely on the refcount done by the drm core instead of
> doing this manually in imx-drm?

...This could be a better solution.

you mean (struct drm_device)->open_count, right?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
