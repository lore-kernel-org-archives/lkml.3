Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaJ0SB0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 14:01:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48998 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaJ0SBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 14:01:24 -0400
Date: Mon, 27 Oct 2014 19:00:49 +0100
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Mark Brown <broonie@kernel.org>, atull@opensource.altera.com,
        jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        Michal Simek <monstr@monstr.eu>, michal.simek@xilinx.com,
        rdunlap@infradead.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        philip@balister.org, rubini@gnudd.com, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, Felipe Balbi <balbi@ti.com>,
        m.chehab@samsung.com, davidb@codeaurora.org,
        Rob Landley <rob@landley.net>, davem@davemloft.net, cesarb@cesarb.net,
        sameo@linux.intel.com, akpm@linux-foundation.org,
        Linus Walleij <linus.walleij@linaro.org>,
        mgerlach@opensource.altera.com, Alan Tull <delicious.quinoa@gmail.com>,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Message-ID: <20141027180049.GY10262@pengutronix.de>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
 <CCE2D027-AA89-41C4-B9AA-2B92AA62129B@konsulko.com>
 <20141027150147.GX18557@sirena.org.uk>
 <31BBCD26-65E2-431A-9ADF-95D7EDC7E34E@konsulko.com>
 <20141027153205.GW10262@pengutronix.de>
 <1C42AF5D-4776-4B09-BDF4-24F001439F46@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1C42AF5D-4776-4B09-BDF4-24F001439F46@konsulko.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:49:47 up 12 days,  5:03, 60 users,  load average: 0,11, 0,06,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 05:45:03PM +0200, Pantelis Antoniou wrote:
> Hi Stefan,
> 
> > On Oct 27, 2014, at 17:32 , Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
> > 
> > On Mon, Oct 27, 2014 at 05:05:29PM +0200, Pantelis Antoniou wrote:
> >> Hi Mark,
> >> 
> >>> On Oct 27, 2014, at 17:01 , Mark Brown <broonie@kernel.org> wrote:
> >>> 
> >>> On Mon, Oct 27, 2014 at 01:48:02PM +0200, Pantelis Antoniou wrote:
> >>>>> On Oct 24, 2014, at 02:51 , atull@opensource.altera.com wrote:
> >>> 
> >>>>> + - init-val         : 0 if driver should disable bridge at startup
> >>>>> +                      1 if driver should enable bridge at startup
> >>>>> +                      driver leaves bridge in current state if property not
> >>>>> +		      specified.
> >>> 
> >>>> Isn’t init-val a boolean property? It’s not named very well.
> >>> 
> >>> It's not boolean, it's tristate - turn on, turn off or don't touch.
> >>> 
> >> 
> >> I see. Even then ‘init-val’ is cryptic. I’d prefer two booleans,
> >> enable-at-startup; disable-at-startup.
> >> 
> >>>> Along with the label, is kinda hard to defend as configuration in DT.
> >>> 
> >>> Yeah...  presumably this decision would fall out of the users?
> >> 
> >> Well, it’s the user that should make the decision, but the driver should
> >> pick it up. This works but it’s not very nice.
> >> 
> > 
> > Hm, convince me why this AXI bus is so special, that I even need an
> > "init-val" property? Other buses don't have that.
> > Why don't I add a property "init-val" to my SPI buses, so I can enable
> > it in the DT and still have it in reset, just because....
> > 
> > The bridges on the SoCFPGA are buses, from the HPS to the FPGA. If I have
> > written firmware to the FPGA and I have subnodes on that bus, I have to
> > get it out of reset and probe everything. Normal procedure, no ?!
> > 
> 
> Well, it’s not my speciality, but my understanding is that FPGAs take (considerable)
> time to be programmed. If someone has already configured the ‘bus’ it is considered
> a win to not reload the bitstream. I.e. if you boot with the bootloader having loaded
> the bitstream already, you don’t want to do it again.
> 
> I’m afraid there’s no such analogue with standard hardware busses like SPI, where
> the bus setup time is instantaneous.

Ah, okay. I see why you got confused.
The bridges are not in any way responsible for loading the FPGA nor will
resetting them reset the bitstream.

The FPGA Manager, a different IP core, is responsible for that. And AFAIK
it has a status bit, that tells you if the FPGA is programmed or not.
Loading the bitstream is in the order of milliseconds.

So from the bridges point of view, when you probe it, you can ask the
FPGA manager if is done, otherwise -EPROBE_DEFER and than go on and
probe the subdevices.


If you are bored, take a look at
http://www.altera.com/literature/hb/cyclone-v/cv_54004.pdf
page 7-2. There you can see the hardware setup.

Regards,
Steffen


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
