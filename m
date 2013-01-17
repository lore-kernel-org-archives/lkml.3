Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab3AQKgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 05:36:19 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:54868 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759489Ab3AQKgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 05:36:16 -0500
Message-ID: <1358418917.6252.31.camel@cumari.coelho.fi>
Subject: Re: [[PATCH v2]] OMAP: omap4-panda: add WiLink shared transport
 power functions
From: Luciano Coelho <coelho@ti.com>
To: <balbi@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Date: Thu, 17 Jan 2013 12:35:17 +0200
In-Reply-To: <20130117100919.GJ10814@arwen.pp.htv.fi>
References: <1358372702-13102-1-git-send-email-coelho@ti.com>
	 <50F7C4A7.5060202@ti.com> <20130117093417.GH10814@arwen.pp.htv.fi>
	 <50F7CA82.4050509@ti.com> <20130117100510.GI10814@arwen.pp.htv.fi>
	 <20130117100919.GJ10814@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-17 at 12:09 +0200, Felipe Balbi wrote:
> On Thu, Jan 17, 2013 at 12:05:10PM +0200, Felipe Balbi wrote:
> > Hi,
> > 
> > On Thu, Jan 17, 2013 at 10:55:14AM +0100, Peter Ujfalusi wrote:
> > > On 01/17/2013 10:34 AM, Felipe Balbi wrote:
> > > >> I just wonder how this is going to work with DT... You are not going to have
> > > >> the ability to use callback in this form.
> > > >> I think the GPIO handling should be done in the driver itself rather than in
> > > >> the board file.
> > > > 
> > > > that can (should ?) be moved to ti-st eventually. In fact I don't know
> > > > why it was removed in the first place, we would need Pavan to help us
> > > > with that query.
> > > 
> > > Yes, this is a good question. I don't know what is the spacial thing platforms
> > > need to do in the callback..
> 
> hah! looks like I found the reason:
> 
> http://git.omapzoom.org/?p=kernel/omap.git;a=blob;f=arch/arm/mach-omap2/board-44xx-54xx-connectivity.c;h=e4852b93e91b6daa8f85cca91a1e7fbcc778f45b;hb=594aedd9e7da0491523411f8999efd98297f4fe4#l177
> 
> IMHO:
> 
> a) removing gpio handling wasn't necessary, we could just check
> 	if gpio_is_valid(nshutdown_gpio)
> 
> b) that whole omap_serial_ext_uart_enable() looks really hacky. I'm sure
> 	we can come up with something better.
> 

This out-of-tree code doesn't explain why we need to do the
enable/disable in the board file.  We just need to do things a bit
differently in the driver.  I'll start cleaning all this stuff up for
-next pretty soon.

For now, ie. 3.7 (stable) and 3.8, do we agree in taking this patch so
that TI-ST at least works on Panda? Simply reverting the gpio removal
patch doesn't help, because we also need to handle the UART2 muxing
(which my patch does as well).

--
Cheers,
Luca.

