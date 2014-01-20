Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaATVcU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:32:20 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:43232 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751919AbaATVcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:32:18 -0500
Date: Mon, 20 Jan 2014 21:32:06 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        jslaby@suse.cz, ben.dooks@codethink.co.uk, broonie@kernel.org
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140120213206.GJ15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <20140120211601.GB634@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140120211601.GB634@kroah.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 01:16:01PM -0800, Greg KH wrote:
> On Mon, Jan 20, 2014 at 10:05:30AM +0000, Russell King - ARM Linux wrote:
> > On Mon, Jan 20, 2014 at 02:32:34PM +0530, Tushar Behera wrote:
> > > uart_register_driver call binds the driver to a specific device
> > > node through tty_register_driver call. This should typically happen
> > > during device probe call.
> > > 
> > > In a multiplatform scenario, it is possible that multiple serial
> > > drivers are part of the kernel. Currently the driver registration fails
> > > if multiple serial drivers with same default major/minor numbers are
> > > included in the kernel.
> > > 
> > > A typical case is observed with amba-pl011 and samsung-uart drivers.
> > 
> > The samsung-uart driver is at fault here - the major/minor numbers were
> > officially registered to amba-pl011.  Samsung needs to be fixed properly.
> 
> I agree, the Samsung driver is "broken" here, but that's no reason why
> these two drivers can't register with the tty layer _after_ the hardware
> is detected, and not before.
> 
> That saves resources on systems that build the drivers in, yet do not
> have the hardware present, which is always a good thing.

Great, so what you're saying is that we need to wait until the first
device calls into the probe function.  What about removal... how does
a driver know when it's last device has been removed to de-register
that?

I guess it needs the driver model to provide some way to know when a
driver is completely unbound - but isn't that racy?

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
