Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077AbaDBIBL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:01:11 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:15697 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaDBIBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:01:07 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 02 Apr 2014 00:54:28 -0700
Date: Wed, 2 Apr 2014 11:01:02 +0300
From: Peter De Schrijver <pdeschrijver@nvidia.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "sw0312.kim@samsung.com" <sw0312.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "laurent.pinchart@ideasonboard.com" 
	<laurent.pinchart@ideasonboard.com>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
Subject: Re: [PATCH RFC v4 2/2] clk: Add handling of clk parent and rate
 assigned from DT
Message-ID: <20140402080102.GK2931@tbergstrom-lnx.Nvidia.com>
References: <1396284116-19178-1-git-send-email-s.nawrocki@samsung.com>
 <1396284116-19178-3-git-send-email-s.nawrocki@samsung.com>
 <20140331200620.GA13881@kroah.com>
 <533ABCEC.8040701@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <533ABCEC.8040701@codethink.co.uk>
X-NVConfidentiality: public
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 03:19:40PM +0200, Ben Dooks wrote:
> On 31/03/14 21:06, Greg KH wrote:
> > On Mon, Mar 31, 2014 at 06:41:56PM +0200, Sylwester Nawrocki wrote:
> >> This function adds a helper function to configure clock parents and rates
> >> as specified in clock-parents, clock-rates DT properties for a consumer
> >> device and a call to it before driver is bound to a device.
> >>
> >> Signed-off-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> 
> [snip]
> 
> >
> > I don't understand why you need the driver core to initialize this one
> > type of thing?  That should be in a driver, or in a class, or at worse
> > case, the platform code.
> >
> > What makes clocks so "unique" here?
> 
> I suppose the issue here is that a lot of drivers currently use
> clocks and a number of systems have badly setup default clock trees
> at start time.
> 
> Mark Brown and others have argued that the management of clocks which
> is common to all devices should not live in the driver.

Exactly, this data should be part of the clock provider DT nodes, not
of the device nodes. 

Cheers,

Peter.
