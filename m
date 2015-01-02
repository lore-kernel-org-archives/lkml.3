Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751990AbbABFMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 00:12:08 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49305 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbbABFMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 00:12:03 -0500
Date: Fri, 2 Jan 2015 06:12:00 +0100
From: Pavel Machek <pavel@denx.de>
To: atull@opensource.altera.com
Cc: gregkh@linuxfoundation.org, jgunthorpe@obsidianresearch.com, hpa@zytor.com,
        monstr@monstr.eu, michal.simek@xilinx.com, rdunlap@infradead.org,
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
Subject: Re: [PATCH v7 2/4] fpga manager: add sysfs interface document
Message-ID: <20150102051200.GI4873@amd>
References: <1419007551-10040-1-git-send-email-atull@opensource.altera.com>
 <1419007551-10040-3-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419007551-10040-3-git-send-email-atull@opensource.altera.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +What:		/sys/class/fpga_manager/<fpga>/firmware
> +Date:		October 2014
> +KernelVersion:	3.18
> +Contact:	Alan Tull <atull@opensource.altera.com>
> +Description:	Name of the FPGA image file to load using firmware class.

This is wrong interface, right? The only use of this string is to pass
it to udev. We should simply pass "fpga-0" as a firware name, and let
udev figure it out, no need to to prepare name in separate component,
then pass it to kernel, which passes it back to udev.

> +What:		/sys/class/fpga_manager/<fpga>/reset
> +Date:		October 2014
> +KernelVersion:	3.18
> +Contact:	Alan Tull <atull@opensource.altera.com>
> +Description:	Write 1 to reset the FPGA

Does 0 need to be written there to pull the fpga out of reset? Is this
a suitable interface?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
