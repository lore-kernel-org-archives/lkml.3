Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaKYGuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 01:50:11 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34804 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaKYGuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 01:50:09 -0500
Date: Tue, 25 Nov 2014 07:49:58 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, grant.likely@linaro.org, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org
Subject: Re: [PATCH] of: support passing console options with stdout-path
Message-ID: <20141125064958.GK30369@pengutronix.de>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
 <20141124230016.GP20238@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141124230016.GP20238@lunn.ch>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 07:46:17 up 40 days, 18:00, 79 users,  load average: 0.04, 0.05,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 12:00:16AM +0100, Andrew Lunn wrote:
> On Mon, Nov 24, 2014 at 10:23:58PM +0000, Leif Lindholm wrote:
> > Support specifying console options (like with console=ttyXN,<options>)
> > by appending them to the stdout-path property after a separating ':'.
> > 
> > Example:
> > 	stdout-path = "uart0:115200";
> > 
> > This patch also modifies of_find_node_by_path() to match only the
> > portion of the path before a ':'.
> 
> Hi Leif
> 
> These appears to somewhat conform to ePAPR, which says:
> 
>       A string that specifies the full path to the node representing
>       the device to be used for boot console output. If the character
>       ":" is present in the value it terminates the path.
> 
> So you can put any random junk after the :. However, are we going to
> have backward/forward compatibility problems, and problems with
> bootloaders? The current kernel code does not look for the :. So a new
> DT blob on an old kernel will not work so well.
> 
> More worrying, barebox does not support the : either. So there is a
> danger your bootloader suddenly goes silent after a dt blob update.

Since in barebox we use the upstream Kernel devicetrees it will be under
our control when they arrive, so we can add support for that ':'
before the new devicetrees arrive.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
