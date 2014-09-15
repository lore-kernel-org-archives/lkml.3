Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaIOQNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:13:53 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42788 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaIOQNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:13:49 -0400
Date: Mon, 15 Sep 2014 09:12:12 -0700
From: Mark Brown <broonie@kernel.org>
To: Grant Likely <grant.likely@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Hanjun Guo <hanjun.guo@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "linaro-acpi@lists.linaro.org" <linaro-acpi@lists.linaro.org>,
        Will Deacon <Will.Deacon@arm.com>, Lv Zheng <lv.zheng@intel.com>,
        Rob Herring <robh@kernel.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Robert Moore <robert.moore@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Charles Garcia-Tobin <Charles.Garcia-Tobin@arm.com>,
        Robert Richter <rric@kernel.org>, Jason Cooper <jason@lakedaemon.net>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "graeme.gregory@linaro.org" <graeme.gregory@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Olof Johansson <olof@lixom.net>
Message-ID: <20140915161212.GQ7960@sirena.org.uk>
References: <1409583961-7466-1-git-send-email-hanjun.guo@linaro.org>
 <1409583961-7466-2-git-send-email-hanjun.guo@linaro.org>
 <20140901170447.GF608@arm.com>
 <21764799.KDNDm9XRax@wuerfel>
 <20140915041404.A72CCC40A02@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zyWBJsol2ZBPjK0b"
Content-Disposition: inline
In-Reply-To: <20140915041404.A72CCC40A02@trevor.secretlab.ca>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH for Juno 1/2] net: smsc911x add support for probing
 from ACPI
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zyWBJsol2ZBPjK0b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 14, 2014 at 09:14:04PM -0700, Grant Likely wrote:
> On Mon, 01 Sep 2014 19:11:44 +0200, Arnd Bergmann <arnd@arndb.de> wrote:

> > > > +     config->phy_interface = PHY_INTERFACE_MODE_MII;

> > > > +     config->flags |= SMSC911X_USE_32BIT;

> > > > +     config->irq_polarity = SMSC911X_IRQ_POLARITY_ACTIVE_HIGH;

> > > > +     config->irq_type = SMSC911X_IRQ_TYPE_PUSH_PULL;

> > > > +     return 0;
> > > > +}

...

> > There is of course the possibility to set those values based on the
> > acpi_device_id, but that is exactly the part that _DSD is trying to
> > avoid.

> These are merely defaults. DSD parsing, when implemented, would be
> override these default values.

One note of caution here: I do agree that default settings are good but
it's worth having clear rules for how we pick the defaults, and advice
for maintainers on how to pick those rules.  If there's a default people
often want to pick it to match their particular system and it can
sometimes be hard for the maintainer to identify if a given tweak
someone is proposing in the defaults might break some other existing
system.  Having clear guidelines for picking the defaults avoids
arguments and breakage.

The two basic rules I've seen are that we either follow the defaults
the hardware has after reset or we follow the state the hardware is left
in when the kernel starts.  Neither is perfect and sometimes the
bootloader option just doesn't make sense at all but they're at least
clear and simple to understand.

It's not the end of the world to do something else, and sometimes the
way systems are done just doesn't lend itself to providing clear rules,
but if we encourage people to set them they can save grief.

--zyWBJsol2ZBPjK0b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUFw/YAAoJECTWi3JdVIfQnHkH/2hZ77pviuoQeTy90lD8knJw
J4w+VyvDioJlivfBphVrb3LkWpwUHF3KkSEQi4hAZlFCZA/4nxyNQKdw8juwfgxm
OIkZg5yKGTKm7xoTSzG66HQmvafo8yiNWDVB68UTFBwaXlsq85Ssdj4PzF8xnaCG
OG9wtE65eq9t+HrjiO+PGqMWt1aw3XXek6lIhCAcnbdL97jXRBqAv7UdZg0fGBW0
OT61YMe7ajl7s42G6s7NXKRc45bbyBdgVKA0kTomdFEMJvRQ3oVUw6Jg+BC+fqw8
QnygX7Hxay+/GFKaLPhzp1F5fwg/MaJWVR0HHFEI5hbVlT5Lh/wfeHLBvhhMdNc=
=SxfL
-----END PGP SIGNATURE-----

--zyWBJsol2ZBPjK0b--
