Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005AbaDAQfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:35:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34709 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbaDAQfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:35:25 -0400
Date: Tue, 1 Apr 2014 09:37:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
Message-ID: <20140401163744.GE3842@kroah.com>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <20140331200620.GA13881@kroah.com>
 <533ABCEC.8040701@codethink.co.uk>
 <533ACBD0.8030209@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533ACBD0.8030209@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 04:23:12PM +0200, Sylwester Nawrocki wrote:
> On 01/04/14 15:19, Ben Dooks wrote:
> > On 31/03/14 21:06, Greg KH wrote:
> >> > On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
> [...]
> >> > I don't understand why you need the driver core to initialize this one
> >> > type of thing?  That should be in a driver, or in a class, or at worse
> >> > case, the platform code.
> >> >
> >> > What makes clocks so "unique" here?
> 
> The reason I put it in the driver core was mainly to avoid having many
> drivers doing same call to this initialization function.
> I was considering moving it to the bus code, still there are several
> buses for which it would need to be repeated.

"several" is how many?  2?  3?  10?

Please fix it "correctly" and don't put it in the driver core just
because it seems easier that way.

> Maybe really_probe() is not a best place to put this, nonetheless
> the requirements I could list were:
> 
>  1. not involving individual drivers,

Why not?

>  2. have such an initialization call done for all devices, irrespective
>     of Linux bus or class type,

Why?  Do _all_ devices that Linux supports have this issue to be
resolved?

>  3. Handle errors properly, e.g. defer driver probing if a clock for
>    a device is not yet available.

Then do it in the bus that controls that device, as it knows to defer
probing at that point in time.

> One advantage I could see from making the call from within a device
> driver is that a device could keep using the common DT bindings and
> replace the common initialization function with a private one, if
> there is a need for some quirks handled for a device. With approach
> as in this patch it's difficult to override the default behaviour.
> However then there is a question whether we strive for the clocks
> management to be possibly kept away from device drivers.
> 
> > I suppose the issue here is that a lot of drivers currently use
> > clocks and a number of systems have badly setup default clock trees
> > at start time.
> > 
> > Mark Brown and others have argued that the management of clocks which
> > is common to all devices should not live in the driver.
> 
> True, motivation behind this patch series was also replacing custom
> code in multiple drivers doing similar clock rate or parent setting
> by a common code, using standardized DT binding.

Then put it in the bus that controls these broken devices / platforms.

greg k-h
