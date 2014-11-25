Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751036AbaKYPo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:44:27 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40648 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750786AbaKYPoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:44:25 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 104.193.169.186
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1852LoZ9iawOWAfTS46gPnL
Date: Tue, 25 Nov 2014 07:41:50 -0800
From: Tony Lindgren <tony@atomide.com>
To: Alexander Kochetkov <al.kochet@gmail.com>
Cc: Kevin Hilman <khilman@kernel.org>, Felipe Balbi <balbi@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        linux-omap <linux-omap@vger.kernel.org>, linux-i2c@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/4] i2c: omap: implement workaround for handling
 invalid BB-bit values
Message-ID: <20141125154150.GI2817@atomide.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-3-git-send-email-al.kochet@gmail.com>
 <CAMAWPa8whctBR6fBFaSzPvm3qn+QK06CimRrxFxxH=0kNkF4UA@mail.gmail.com>
 <47A1A441-952C-4AC3-859C-5A8E405767E0@gmail.com>
 <20141124194759.GG2757@atomide.com>
 <47749B61-5924-4E56-9931-77B0CFC0AAA0@gmail.com>
 <06376010-5DED-49AA-9494-A9546567E7CA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <06376010-5DED-49AA-9494-A9546567E7CA@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexander Kochetkov <al.kochet@gmail.com> [141124 16:11]:
> 
> 24 нояб. 2014 г., в 23:05, Alexander Kochetkov <al.kochet@gmail.com> написал(а):
> 
> > Something (u-boot, may be) leave the bus in the wrong state.
> > Really strange.
> 
> Actually something wrong with i2c-pullups on i2c.1 bus on fault boards.
> May be these are boards without pull-ups?

It could be. Boards that use external i2c pulls should have all the
internal pulls disabled as the pulls get connected in parallel and
the total resistance decreases. And then the i2c signals may not be
up to the spec.

Note that there are internal pulls in the i2c controller, and in the
i2c padconf registers.

> All beagles doesn't have internal pull-ups on i2c.1 since u-boot 2011.x.

The pulls should be enabled based on the board and possibly based
on the board revision.
 
> Here is the bug in the u-boot related to beagle:
> http://git.denx.de/?p=u-boot.git;a=commit;h=04e2a13336f0e507ef416bbede3be92b79c46594
> 
> Yes, I made fix, but keep that in mind.
> 
> For example one of the boards (omap3-beagle):
> http://status.armcloud.us/boot/omap3-beagle/job/next/kernel/next-20141124/defconfig/arm-omap2plus_defconfig/
> http://status.armcloud.us/boot/omap3-beagle,legacy/job/next/kernel/next-20141124/defconfig/arm-omap2plus_defconfig/
> http://status.armcloud.us/boot/omap3-beagle/job/next/kernel/next-20141124/defconfig/arm-multi_v7_defconfig/
> 
> has following warning message in the u-boot log:
> > U-Boot 2014.07 (Aug 21 2014 - 11:03:05)
> > 
> > OMAP3530-GP ES3.0, CPU-OPP2, L3-165MHz, Max CPU Clock 600 MHz
> > OMAP3 Beagle board + LPDDR/NAND
> > ....
> > Beagle Rev C1/C2/C3
> > Timed out in wait_for_event: status=1000
> > Check if pads/pull-ups of bus 1 are properly configured
> 
> Also beagle schematic has following log entry for A3:
> 4. Added optional pullup resistors on I2C2_SCL and I2C_SDA into the layout.
> 
> Is the fault beagle is pre A3 revision?

Seems to be C1/C2/C3 based on the above logs?
 
> I can't tell anything about second one board (omap3-overo-tobi), because I could not get it schematic.
> 
> And how you have i2c.1 working without pull-ups I don't know.

I checked on the LDP and it seems to have external pulls for i2c.
I also tested n900 without your fix, and it's failing too. On n900
there are external pulls and all the internal pulls should be
disabled.

Regards,

Tony
