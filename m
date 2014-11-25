Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbaKYMyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:54:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60112 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbaKYMyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:54:31 -0500
Date: Tue, 25 Nov 2014 13:54:24 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "ijc@debian.org" <ijc@debian.org>
Subject: Re: [PATCH] of: support passing console options with stdout-path
Message-ID: <20141125125424.GN14482@pengutronix.de>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
 <20141125103504.GA21525@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141125103504.GA21525@leverpostej>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:50:12 up 41 days, 3 min, 96 users,  load average: 0.00, 0.02,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2014 at 10:35:04AM +0000, Mark Rutland wrote:
> Hi Leif,
> 
> On Mon, Nov 24, 2014 at 10:23:58PM +0000, Leif Lindholm wrote:
> > Support specifying console options (like with console=ttyXN,<options>)
> > by appending them to the stdout-path property after a separating ':'.
> > 
> > Example:
> > 	stdout-path = "uart0:115200";
> 
> I would very much like to be able to use this -- it will allow
> distributions to boot on a board without having to know _anything_ about
> the console UART until userspace is up, which would make it possible to
> have a completely generic installer image, without requiring the
> platform to provide bootargs.

Note there are several serial drivers that read back the console options
from the hardware assuming it has been initialized correctly by the
bootloader already. So when your bootloader already made some output
on the console (which is likely) you can do that already. Of course
this doesn't solve all problems, like if you want to use a different
console for the kernel than for the bootloader.
Anyway, this behaviour is very nice since the kernel always uses the
same speed for the console as the bootloader does.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
