Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbaLSQQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 11:16:16 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37004 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaLSQQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 11:16:15 -0500
Date: Fri, 19 Dec 2014 17:15:49 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: atull <atull@opensource.altera.com>
Cc: Michal Simek <michal.simek@xilinx.com>, gregkh@linuxfoundation.org,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com, monstr@monstr.eu,
        rdunlap@infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, pantelis.antoniou@konsulko.com,
        robh+dt@kernel.org, grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v6 4/4] staging: fpga manager: add driver for socfpga
 fpga manager
Message-ID: <20141219161549.GH13070@pengutronix.de>
References: <1418941748-16111-1-git-send-email-atull@opensource.altera.com>
 <1418941748-16111-5-git-send-email-atull@opensource.altera.com>
 <20141219085516.GF13070@pengutronix.de>
 <2d65a072f8c14d1e839307465f177a1a@BY2FFO11FD046.protection.gbl>
 <20141219150714.GG13070@pengutronix.de>
 <alpine.DEB.2.02.1412190955090.16892@linuxheads99>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1412190955090.16892@linuxheads99>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:10:45 up 65 days,  3:24, 76 users,  load average: 0,08, 0,10,
 0,08
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 09:55:34AM -0600, atull wrote:
> On Fri, 19 Dec 2014, Steffen Trumtrar wrote:
> 
> > On Fri, Dec 19, 2014 at 03:05:50PM +0100, Michal Simek wrote:
> > > On 12/19/2014 09:55 AM, Steffen Trumtrar wrote:
> > > > Hi!
> > > > 
> > > > Just a minor nitpick, but...
> > > > 
> > > > On Thu, Dec 18, 2014 at 04:29:08PM -0600, atull@opensource.altera.com wrote:
> > > >> From: Alan Tull <atull@opensource.altera.com>
> > > >>
> > > >> Add driver to fpga manager framework to allow configuration
> > > >> of FPGA in Altera SoCFPGA parts.
> > > >>
> > > >> Signed-off-by: Alan Tull <atull@opensource.altera.com>
> > > >> Acked-by: Michal Simek <michal.simek@xilinx.com>
> > > >> ---
> > > >> v2: fpga_manager struct now contains struct device
> > > >>     fpga_manager_register parameters now take device
> > > >>
> > > >> v3: skip a version to align versions
> > > >>
> > > >> v4: move to drivers/staging
> > > >>
> > > >> v5: fix array_size.cocci warnings
> > > >>     fix platform_no_drv_owner.cocci warnings
> > > >>     Remove .owner = THIS_MODULE
> > > >>     include asm/irq.h
> > > >>     clean up list of includes
> > > >>     use altera_fpga_reset for ops
> > > >>     use enum fpga_mgr_states or u32 as needed
> > > >>     use devm_request_irq
> > > >>     check irq <= 0 instead of == NO_IRQ
> > > >>     Use ARRAY_SIZE
> > > >>     rename altera -> socfpga
> > > >>     static const socfpga_fpga_ops
> > > >>     header moved to linux/fpga/ folder
> > > >>     remove ifdef'ed code
> > > >>     use platform_get_resource and platform_get_irq
> > > >>     move .probe and .remove lines adjacent
> > > >>     use module_platform_driver
> > > >>     use __maybe_unused
> > > >>     only need to 'if (IS_ENABLED(CONFIG_REGULATOR))' in one fn
> > > >>     fix "unsigned 'mode' is never < 0"
> > > >>
> > > >> v6: return error for (unused) default of case statement
> > > >> ---
> > > >   ^^^
> > > > 
> > > > ...if you remove these, than that changelog will not land in the final
> > > > commit which I would prefer. Nobody cares for the changelog of a
> > > > patch once it is in its final state. And this is a rather noisy one.
> > > > When someone in the future looks at this, he will see two lines of
> > > > information and 10 times that of uninteresting noise.
> > > > 
> > > > Not a dealbreaker, but just something to consider for future patches.
> > > 
> > > 
> > > When you run git-am you will see that changelog is not there.
> > > 
> > 
> > Ah, great. It seems like git-am does indeed know now how to handle this.
> > There are some commits in mainline that have this changelog added,
> > because there where two '---' lines in the patch.
> > 
> > Then go on kind sirs with whatever you where doing and don't pay any
> > attention to my comment... :-)
> > 
> > Regards,
> > Steffen
> > 
> 
> git format-patch adds the second ---
> 

Yeah, of course. But where does the first one come from?
Do you keep a changelog in your commits?
That is what git notes is for, no?!

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
