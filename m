Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab3CWM5s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 08:57:48 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:40379 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750806Ab3CWM5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 08:57:46 -0400
Date: Sat, 23 Mar 2013 13:57:42 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?iso-8859-1?Q?P=E1draig?= Brady <P@draigBrady.com>
Subject: Re: [PATCH v2 0/8] watchdog: w83627hf: Convert to watchdog infrastructure
Message-ID: <20130323125742.GG7867@spo001.leaseweb.com>
References: <1362957300-18223-1-git-send-email-linux@roeck-us.net> <20130322205258.GE7867@spo001.leaseweb.com> <20130323002810.GA26245@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323002810.GA26245@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> > In 2011 I started something similar but then with the MFD approach in mind.
> > Goal was also to clean-up the w836* watchdog drivers and get a clean driver that
> > supports all Winbond super-I/O based watchdog drivers.
> > 
> > I dug op the development code again. I'll post it in a next e-mail so that we can
> > see what the best way forward is. Note: I took the MFD approach because:
> > 1) all superio shares the similar functions for using the Super-I/O registers.
> > 2) Goal is to have low-level driver that support the specific super-I/O chipsets
> > and that does the platform stuff for hwmon, watchdog, gpio, ...
> > 
> Hi Wim,
> 
> I started with a similar approach, only I used mfd cells to pass on platform
> specific information such as the device type and the superio base address.
> I still have the patchset for the mfd driver, in case you are interested.
> My code is based on the patches submitted by Rodolfo Giometti a couple
> of years ago. Want me to post it ?

If it's not v1 then I am interested.
I think it depends on the super-I/O chipset of what info you can pass. I would
not use mfd cells for the winbond driver but use platform data (similar to
drivers/mfd/adp5520.c) because you don't need more then just pass some data.

> What I noticed in my testing is that the superio address range (2e or 4e),
> which the drivers currently take as granted, is at least on my systems
> (all three of them) reserved by ACPI. Unfortunately that means one can not
> use the mfd infrastructure to pass on the superio memory region,
> since it checks for acpi conflicts. With that I gave up on the idea and
> reverted to using request_muxed_region. That seemed simpler and accomplish
> the same as long as all drivers actually use it.

Noticed the same. That's why passing the platform data together with the
superio-address and type seems the best way to go. I also kept the superio_enter
and superio_exit a function in the low level driver because I used a lock to
make sure that the hwmon code doesn't start doing things when the watchdog is
doing things. But I think that the request_muxed_region is doing something similar
also.

Kind regards,
Wim.

