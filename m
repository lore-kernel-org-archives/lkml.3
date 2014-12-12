Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967604AbaLLMPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 07:15:12 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35937 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966281AbaLLMPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 07:15:00 -0500
Date: Fri, 12 Dec 2014 13:14:57 +0100
From: Pavel Machek <pavel@denx.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: atull <atull@opensource.altera.com>,
        Grant Likely <grant.likely@linaro.org>,
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
Message-ID: <20141212121457.GB31659@amd>
References: <1414007405-32186-1-git-send-email-atull@opensource.altera.com>
 <1414007405-32186-3-git-send-email-atull@opensource.altera.com>
 <20141024105200.GA20775@amd>
 <CACxGe6sa=ysJAjx5TQZH5sKoas1PkoUUR4zT=Z35+uF6rrk-vw@mail.gmail.com>
 <20141208225519.64501d2d@lxorguk.ukuu.org.uk>
 <alpine.DEB.2.02.1412090958250.4875@linuxheads99>
 <20141209210248.2ca54287@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141209210248.2ca54287@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > * this causes the fpga to get programmed
> > * appropriate bridges get enabled
> > * appropriate drivers get probed
> 
> For the case of a fixed function device it's sort of equivalent to a
> firmware load (in fact it *is* just a firmware load). The fixed function
> cases don't actually even need a 'firmware manager' or an FPGA class. In
> fact they shouldn't IMHO have one because the fact version A of the
> device requires firmware bitstream X, and bitstream X is an altera FPGA
> bitstream is an implementation detail. Revision B could be a
> microcontroller or something else and you still just shove a bitstream
> down it. No FPGA class is needed or appropriate. FPGA loader helpers
> yes.

Well, you'd still like to use the FGPA class to talk to the FPGA
loader, because that makes transition to different FPGA vendor easier,
right?

> 1. Fixed function firmware - in which case the driver already handles it
> and we don't care if its FPGA bitstreams or microcode or CPU code or
> whatever
> 
> 2. Dynamic use cases where we need a resource we own, which means
> enumerate/open/close/read/write interfaces including firmware.
> 
> For use case #1 I don't believe we need magic classes for FPGA and in
> fact they are actually a mistake,

Why? Bitstream upload code is fairly complex, and it seems the high
level steps are similar between vendors. Having FPGA class people can
work with helps, and it will help in future more dynamic cases, too...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
