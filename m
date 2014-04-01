Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaDAQcm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:32:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34696 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaDAQck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:32:40 -0400
Date: Tue, 1 Apr 2014 09:35:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        mturquette@linaro.org, linux@arm.linux.org.uk, robh+dt@kernel.org,
        grant.likely@linaro.org, mark.rutland@arm.com, galak@codeaurora.org,
        kyungmin.park@samsung.com, sw0312.kim@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        laurent.pinchart@ideasonboard.com, s.hauer@pengutronix.de
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
Message-ID: <20140401163500.GD3842@kroah.com>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <20140331200620.GA13881@kroah.com>
 <533ABCEC.8040701@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533ABCEC.8040701@codethink.co.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 02:19:40PM +0100, Ben Dooks wrote:
> On 31/03/14 21:06, Greg KH wrote:
> >On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
> >>This function adds a helper function to configure clock parents and rates
> >>as specified in clock-parents, clock-rates DT properties for a consumer
> >>device and a call to it before driver is bound to a device.
> >>
> >>Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> [snip]
> 
> >
> >I don't understand why you need the driver core to initialize this one
> >type of thing?  That should be in a driver, or in a class, or at worse
> >case, the platform code.
> >
> >What makes clocks so "unique" here?
> 
> I suppose the issue here is that a lot of drivers currently use
> clocks and a number of systems have badly setup default clock trees
> at start time.

Then they should be fixed, why should _all_ Linux devices care about
such broken devices/systems?

> Mark Brown and others have argued that the management of clocks which
> is common to all devices should not live in the driver.

Then put it in the bus that initializes the devices / drivers.

thanks,

greg k-h
