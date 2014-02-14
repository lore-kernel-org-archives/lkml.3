Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaBNAiq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:38:46 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35463 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751533AbaBNAio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:38:44 -0500
Date: Fri, 14 Feb 2014 00:38:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 2/2] serial: pl011: Move uart_register_driver call to
	device probe
Message-ID: <20140214003834.GH30257@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-3-git-send-email-tushar.behera@linaro.org> <20140120100415.GX15937@n2100.arm.linux.org.uk> <20140213181216.GB24155@kroah.com> <20140213181559.GB30257@n2100.arm.linux.org.uk> <20140213182701.GA32578@kroah.com> <20140213184249.GC30257@n2100.arm.linux.org.uk> <20140213232606.GA27372@kroah.com> <20140214000717.GG30257@n2100.arm.linux.org.uk> <20140214001436.GA16287@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140214001436.GA16287@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 13, 2014 at 04:14:36PM -0800, Greg KH wrote:
> On Fri, Feb 14, 2014 at 12:07:17AM +0000, Russell King - ARM Linux wrote:
> > On Thu, Feb 13, 2014 at 03:26:06PM -0800, Greg KH wrote:
> > > On Thu, Feb 13, 2014 at 06:42:49PM +0000, Russell King - ARM Linux wrote:
> > > > We went through this before, and I stated the paths, and no one disagreed
> > > > with that.
> > > > 
> > > > It /is/ racy.
> > > 
> > > Ok, I just went and looked at the uart driver register path, and I don't
> > > see the race (note, if there is one, it's there today, regardless of
> > > this patch).
> > 
> > The race isn't the uart code, it's the driver model.
> > 
> > Consider what happens when this happens:
> > 
> > * Two pl011 devices get registered at the same time by two different
> >   threads.
> 
> How?  What two different busses will see this same device?  The amba bus
> code should prevent that from happening, right?  If not, there's bigger
> problems in that bus code :)

Where is that requirement documented?  It isn't documented.  No one
implements any kind of locking at the bus level to prevent this, not
PCI, nor platform devices.

> That's where this problem should be fixed, if there is one, otherwise
> this same issue would be there for any type of driver that calles into
> the uart core, right?

And how does bus code prevent this?  By intercepting the driver model
->probe callback and taking its own lock maybe?   Really?  What about
those buses which don't wrap the probe callback?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
