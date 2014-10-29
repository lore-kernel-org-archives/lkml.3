Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932503AbaJ2Kbh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:31:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40726 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198AbaJ2Kbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:31:36 -0400
Date: Wed, 29 Oct 2014 11:31:03 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: atull <atull@opensource.altera.com>, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, monstr@monstr.eu, michal.simek@xilinx.com,
        rdunlap@infradead.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, philip@balister.org,
        rubini@gnudd.com, jason@lakedaemon.net, kyle.teske@ni.com,
        nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Message-ID: <20141029103103.GD10262@pengutronix.de>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
 <20141024070042.GL10262@pengutronix.de>
 <alpine.DEB.2.02.1410281601570.11910@atx-linux-37>
 <20141029075701.GA10262@pengutronix.de>
 <20141029101632.GU18557@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029101632.GU18557@sirena.org.uk>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:20:13 up 13 days, 21:33, 88 users,  load average: 0,09, 0,07,
 0,10
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 10:16:32AM +0000, Mark Brown wrote:
> On Wed, Oct 29, 2014 at 08:57:01AM +0100, Steffen Trumtrar wrote:
> 
> > So, that shouldn't be a problem though, as I already cooked up a driver for
> > the L3 with all the ranges specified. The only thing I need to figure out
> > before I will post it, is how to nicely handle the WO remap register.
> > I think regmap might be able to handle this itself, but am not sure yet.
> 
> It's supposed to be able to, not sure if anyone really tests that or not
> though so it's possible bugs crept in.  Most write only registers can
> physically be read so actually come out as volatile rather than write
> only even if functionally there is no reason to read.

Ah, I think you might be actually right there. IIRC it IS possible to read
from that register, but you only get 0s.
So, I shot myself in the knee with specifying that register as write-only
in my driver.

Thanks,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
