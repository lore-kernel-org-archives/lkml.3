Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbbALVoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 16:44:21 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:37274 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbbALVoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 16:44:18 -0500
Date: Mon, 12 Jan 2015 14:43:14 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Pavel Machek <pavel@denx.de>, atull <atull@opensource.altera.com>,
        gregkh@linuxfoundation.org, hpa@zytor.com, monstr@monstr.eu,
        michal.simek@xilinx.com, rdunlap@infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        pantelis.antoniou@konsulko.com, robh+dt@kernel.org,
        grant.likely@linaro.org, iws@ovro.caltech.edu,
        linux-doc@vger.kernel.org, broonie@kernel.org, philip@balister.org,
        rubini@gnudd.com, s.trumtrar@pengutronix.de, jason@lakedaemon.net,
        kyle.teske@ni.com, nico@linaro.org, balbi@ti.com, m.chehab@samsung.com,
        davidb@codeaurora.org, rob@landley.net, davem@davemloft.net,
        cesarb@cesarb.net, sameo@linux.intel.com, akpm@linux-foundation.org,
        linus.walleij@linaro.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devel@driverdev.osuosl.org, delicious.quinoa@gmail.com,
        dinguyen@opensource.altera.com, yvanderv@opensource.altera.com
Subject: Re: [PATCH v8 2/4] fpga manager: add sysfs interface document
Message-ID: <20150112214314.GA18610@obsidianresearch.com>
References: <1420575219-27061-1-git-send-email-atull@opensource.altera.com>
 <1420575219-27061-3-git-send-email-atull@opensource.altera.com>
 <20150107084819.GA1887@amd>
 <alpine.DEB.2.02.1501091302370.30067@linuxheads99>
 <20150109205643.GA5761@amd>
 <20150112210134.687176ed@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112210134.687176ed@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 09:01:34PM +0000, One Thousand Gnomes wrote:
> There are plenty of people today who treat the FPGA as an entirely
> dynamic resource. It's not like flashing a controller, its near
> immediate.

But this is a completely different use case. Remember, there are
*megabytes* of internal state in a FPGA, and it isn't really feasible
to dump/restore that state.

It is one thing to context switch a maths algorithm that is built to
be stateless, it is quite another to context switch between, say an
ethernet core with an operating Linux Net driver doing DMA and a maths
algorithm.

A DT overlay approach where the overlay has to be unloaded to 'free'
the FPGA makes alot of sense to me for the stateful kernel driver
environment, and open/close/etc makes alot of sense for the stateless
switchable userspace environment - other than sharing configuration
code, is there any overlap between these use cases????

> Its completely dynamic and it will get more so as we switch from the
> painful world of VHDL and friends to high level parallel aware language
> compilers for FPGAs and everyone will be knocking up quick FPGA hacks.

Only for some users. In my world FPGAs are filled with bus interface
logic, ethernet controllers, memory controllers, packet processing
engines, etc. This is all incredibly stateful - both in the FPGA
itself, and in the Linux side w/ drviers. It certainly will not ever
work in the model you are talking about.

Even if the digital state could somehow be frozen, dumped and
restored, all the FPGA external interface logic has *ANALOG* state
that cannot ever be dump/restored. It just isn't feasible for that
class of application.

Jason
