Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbaLFOCW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 09:02:22 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56983 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaLFOCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 09:02:20 -0500
Date: Sat, 6 Dec 2014 15:02:18 +0100
From: Pavel Machek <pavel@denx.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: atull@opensource.altera.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Simek <monstr@monstr.eu>,
        Michal Simek <michal.simek@xilinx.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>, Ira Snyder <iws@ovro.caltech.edu>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>, philip@balister.org,
        rubini <rubini@gnudd.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Jason <jason@lakedaemon.net>, kyle.teske@ni.com,
        Nicolas Pitre <nico@linaro.org>, "Balbi, Felipe" <balbi@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        David Brown <davidb@codeaurora.org>, Rob Landley <rob@landley.net>,
        David Miller <davem@davemloft.net>, cesarb@cesarb.net,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alan Tull <delicious.quinoa@gmail.com>, dinguyen@opensource.altera.com,
        Yves Vandervennet <yvanderv@opensource.altera.com>
Subject: Re: [PATCH v2 2/3] fpga manager: framework core
Message-ID: <20141206140218.GB19672@amd>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
 <1414007405-32186-3-git-send-email-atull@opensource.altera.com>
 <20141024105200.GA20775@amd>
 <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-12-06 13:00:17, Grant Likely wrote:
> On Fri, Oct 24, 2014 at 11:52 AM, Pavel Machek <pavel@denx.de> wrote:
> > Hi!
> >
> >> * /sys/class/fpga_manager/<fpga>/firmware
> >>   Name of FPGA image file to load using firmware class.
> >>   $ echo image.rbf > /sys/class/fpga_manager/<fpga>/firmware
> >
> > I .. still don't think this is good idea. What about namespaces?
> > The path corresponds to path in which namespace?
> 
> I don't understand your concern here. This allows userspace to name
> the FPGA bitstream that the kernel will use during request_firmware(),
> and it will show up as the $FIRMWARE value in the uevent file, but it
> is still the responsibility of userspace to choose what to load, and
> it can freely ignore the setting of $FIRMWARE if it needs to.

Well, consider chroot. I echo some filename but the file does not
exist for the userspace listening for the uevent.

> The process that actually loads the firmware into the kernel pretty
> much has to run in the normal linux environment. How do namespaces
> come into it? What exact problem do you see?

> > This shows why the interface is not right... Valid filename may
> > contain \n, right? It may even end with \n.
> 
> That's not an interface problem, it implementation problem. The
> function absolutely should scrub and validate it's input. It should
> also make sure that the string doesn't have any special characters so
> that /bin/sh doesn't barf on it (because the string will appear in the
> uevent file). I would check other users of request_firmware() to see
> if any of them allow userspace to specify the filename.

> That said, the other way to handle this is not to specify a valid
> filename through this interface at all. Just use a dummy placeholder
> name and expect userspace to load the correct file when the request is
> posted.

I'd go for that -- "dummy" works. Kernel is not a place to know shell
limitations for all possible shells.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
