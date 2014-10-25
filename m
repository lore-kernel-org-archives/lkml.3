Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaJYTUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 15:20:30 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56210 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbaJYTU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 15:20:28 -0400
Date: Sat, 25 Oct 2014 16:42:29 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: atull@opensource.altera.com, jgunthorpe@obsidianresearch.com,
        hpa@zytor.com, Michal Simek <monstr@monstr.eu>,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        Grant Likely <grant.likely@linaro.org>, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, pavel@denx.de, broonie@kernel.org,
        philip@balister.org, rubini@gnudd.com, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, mgerlach@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Subject: Re: [PATCH v2 2/3] ARM: dts: socfpga: fpga bridges bindings docs
Message-ID: <20141025144229.GR10262@pengutronix.de>
References: <1414108267-22058-1-git-send-email-atull@opensource.altera.com>
 <1414108267-22058-3-git-send-email-atull@opensource.altera.com>
 <20141024070042.GL10262@pengutronix.de>
 <5FB7B7FD-7B5B-4250-BADE-85573FDBBE48@konsulko.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5FB7B7FD-7B5B-4250-BADE-85573FDBBE48@konsulko.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:00:58 up 10 days,  1:14, 50 users,  load average: 0,00, 0,03,
 0,05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pantelis!

On Fri, Oct 24, 2014 at 12:20:53PM +0300, Pantelis Antoniou wrote:
> Hi Stefan, Allan,
> 
> Sorry, haven’t had a chance to review all this yet; will do so in the weekend.
> Just wanted to pop in and comment on a few things.
> 
> > On Oct 24, 2014, at 10:00 AM, Steffen Trumtrar <s.trumtrar@pengutronix.de> wrote:
> > 
> > Hi!
> > 
> > On Thu, Oct 23, 2014 at 06:51:06PM -0500, atull@opensource.altera.com wrote:
> >> From: Alan Tull <atull@opensource.altera.com>
> > 
> > (...)
> > 
> >> diff --git a/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
> >> new file mode 100644
> >> index 0000000..bc24a2e
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/fpga/altera-hps2fpga-bridge.txt
> >> @@ -0,0 +1,53 @@
> >> +Altera FPGA/HPS Bridge Driver
> >> +
> >> +This driver manages a bridge between a FPGA and a host processor system (HPS).
> >> +User space can enable or disable the bridge by writing a "1" or a "0",
> >> +respectively, to its enable file under bridge's entry in
> >> +/sys/class/fpga-bridge.  Typically, one disables the bridges before
> >> +reprogramming the FPGA.  Once the FPGA is reprogrammed, the bridges are
> >> +reenabled.
> >> +
> > 
> > NAK.
> > 
> > This is all linux specific and doesn't belong here.
> > 
> 
> We know. The DT spec hasn’t been updated for a while, and this is going to be
> part of what we want to do with the restarting of the ePAPR spec process.
>

As we don't have a new spec yet, I go with the current state of the art.
And I don't see how "file under ... /sys/class/fpga-bridge" fits the
current spec.

> So absolutes like “DT is a hardware description only" might be too strong statements, that
> do not work in practice anymore.
> 
> There’s no such thing as pure hardware devices lately - there is always a configuration
> component; some of it OS specific, some of it not.
> 

If it really is necessary, I'm not against it, don't get me wrong.
But in the grand scheme I wouldn't say that this fits my experience.
There are some devices that need configuration and often when it is
done in the DT, it is just a shortcut or not thought through.
And can be also introspected dynamically. With some discussion on the
list these bindings often change.

Regarding OS specifics: already there, e.g. console setup in the chosen node.
And other things I saw are ethernet aliases just for u-boot. Not a problem
of the spec, just a problem of u-boot and unneccessary "configuration".
Just to fix a bad bootloader. barebox can handle this without any
such stuff. Maybe we should integrate the DT "overlays" barebox uses into
the in-kernel DTs as well...but does it really help/interest someone who
decides to use u-boot where barebox stores its environment? I guess not.

> We have to be engaged in the process and figure out how to update the spec for what is
> now the state of the art in the industry.
> 

Again, not against that if it is necessary. For example your overlay stuff might
be a good update to the spec. Would be better if it is official instead of a "hack".
I want that for SoCFPGA.

But having looked at one or two vendor kernels+DTs, the state of the art in the
industry is: using DT wrong. (And doing HW wrong, which makes some updates to the
ePAPR necessary ;-))

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
