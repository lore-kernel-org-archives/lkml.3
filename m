Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaATM02 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:26:28 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42765 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753905AbaATM0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:26:25 -0500
Date: Mon, 20 Jan 2014 12:26:15 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
	device probe
Message-ID: <20140120122615.GB15937@n2100.arm.linux.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org> <1390208555-27770-2-git-send-email-tushar.behera@linaro.org> <20140120100530.GY15937@n2100.arm.linux.org.uk> <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 20, 2014 at 05:23:21PM +0530, Tushar Behera wrote:
> On 20 January 2014 15:35, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Jan 20, 2014 at 02:32:34PM +0530, Tushar Behera wrote:
> >> uart_register_driver call binds the driver to a specific device
> >> node through tty_register_driver call. This should typically happen
> >> during device probe call.
> >>
> >> In a multiplatform scenario, it is possible that multiple serial
> >> drivers are part of the kernel. Currently the driver registration fails
> >> if multiple serial drivers with same default major/minor numbers are
> >> included in the kernel.
> >>
> >> A typical case is observed with amba-pl011 and samsung-uart drivers.
> >
> > The samsung-uart driver is at fault here - the major/minor numbers were
> > officially registered to amba-pl011.  Samsung needs to be fixed properly.
> >
> 
> I had earlier submitted a patch [1] to remove the hard coded
> major/minor number for Samsung UART driver, but that was rejected
> because of userspace breakage. Without this patch, Samsung UART driver
> can't bind to the hard-coded device node. Changing the default
> major/minor will also not help to fix the objections raised in [1].
> 
> Would you please suggest a way forward?

I still assert that it's for Samsung people to sort out their abuse of
the major/minor numbers - we have a procedure in place to allocate these,
I followed it for the AMBA PL011 driver, they didn't.  Their problem -
and they have to suffer with the consequences of that bad decision on
their part, which is that they have to deal with the inevitable breakage
caused by having to renumber.

> [1] https://lkml.org/lkml/2013/12/27/2

lkml.org is dead at the moment - tried from two different ISPs in the UK,
it's nameservers are unreachable, and its https port refuses connections.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
