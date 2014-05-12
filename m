Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbaELUmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 16:42:22 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:39164 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755120AbaELUmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 16:42:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18/xJ2UeWRPADvTVv7/ZooU
Date: Mon, 12 May 2014 13:42:13 -0700
From: Tony Lindgren <tony@atomide.com>
To: Robert Nelson <robertcnelson@gmail.com>
Cc: Matt Ranostay <mranostay@gmail.com>, robh+dt@kernel.org,
        mark.rutland@arm.com, Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        pantelis.antoniou@gmail.com, matt.porter@linaro.org
Subject: Re: [PATCH v2] ARM: dts: am335x-bone-common: Add i2c2 definition
Message-ID: <20140512204213.GD5668@atomide.com>
References: <1399686184-1594-1-git-send-email-mranostay@gmail.com>
 <20140512195050.GB5668@atomide.com>
 <CAOCHtYiYwx_bEsyqkbUTTAbhBYESzvfBOOYeVuFXPS1dDy0ZKA@mail.gmail.com>
 <20140512201517.GC5668@atomide.com>
 <CAOCHtYg6XpF0Gbo4iFqsFvP=QSivQQvCzov8UfxeLXMzrRYEWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOCHtYg6XpF0Gbo4iFqsFvP=QSivQQvCzov8UfxeLXMzrRYEWw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Robert Nelson <robertcnelson@gmail.com> [140512 13:27]:
> >> >
> >> > If these pins are not used for i2c2 on some capes, this device
> >> > should be set to status = "disabled" state by default. Then
> >> > u-boot could re-enable it on the boards that have i2c2 in use.
> >>
> >> To-date, this is the i2c bus that all capes have placed an at24 eeprom
> >> for cape identification.
> >
> > And how many capes actually implement the eeprom cape identification
> > out of the available capes? :)
> 
> Not including one off designs in someone's lab. We will never have an
> accurate number. ;)
> 
> So far; just the ones that want their "cape" detected in the default
> image currently being shipped by CircuitCo. Otherwise the few that
> I've seen without an eeprom, usually follow this default pinmux.
> 
> http://elinux.org/CircuitCo:Basic_Proto_Cape
> 
> Which includes that i2c bus enabled.

OK thanks for the info.
 
> Either case if fine with me.  As who knows when the dtc "overlay" will
> every truly make it mainline, as the capemgr was the only real kernel
> user of the i2c/at24 eeprom information.

Sounds like we should keep it disabled though so u-boot can be used
to toggle it while waiting for the capemgr. That's because the board
has a header for pins, so it's not exactly limited to just the capes.

Anybody working on enabling/disabling cape dtb configurations in u-boot?

Regards,

Tony
