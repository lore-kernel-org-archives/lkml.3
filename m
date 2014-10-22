Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbaJVXwE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 19:52:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43448 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbaJVXwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 19:52:00 -0400
Date: Thu, 23 Oct 2014 00:51:33 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Rob Herring <robherring2@gmail.com>,
        Rob Herring <rob.herring@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>
Message-ID: <20141022235133.GJ2344@sirena.org.uk>
References: <20140729234522.E9FF1C40738@trevor.secretlab.ca>
 <1409672700-21697-1-git-send-email-svarbanov@mm-sol.com>
 <20140908145204.8ADC2C40AE5@trevor.secretlab.ca>
 <540E1014.8090102@codeaurora.org>
 <20140914044610.913E9C4102A@trevor.secretlab.ca>
 <54483746.9060104@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ZSpXV6RUUo6PuQK"
Content-Disposition: inline
In-Reply-To: <54483746.9060104@codeaurora.org>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] RFC: add function for localbus address
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ZSpXV6RUUo6PuQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 22, 2014 at 04:01:26PM -0700, Stephen Boyd wrote:

> >> "Currently a bunch of I2C/SPI MFD drivers are using IORESOURCE_IO for
> >> register address ranges. Since this causes some confusion due to the
> >> primary use of this resource type for PCI/ISA I/O ports create a new
> >> resource type IORESOURCE_REG."

> > Sorry, I mistook IORESOURCE_REG or IORESOURCE_IO. You're right, this
> > isn't an issue.

> > I'm still concerned about the implications of automatically populating
> > platform_devices with this resource type. I'll talk to Mark about it
> > face to fact at Connect this week.

Hrm, missed that discussion.

> Where did this end up? When we talked at Connect I think we settled on
> exploring a driver core specific API like dev_get_localbus_address()
> that calls of_get_localbus_address() for devices with an of_node and in

...

> That's fine, but I still think we want to have the IORESOURCE_REG
> resources given that we have drivers in-flight and some already merged
> that are using the IORESOURCE_REG resource. Furthermore, ACPI is using

Right, IORESOURCE_REG was the original solution to the overlapping use
of IORESOURCE_IO (rather than having multiple IORESOURCE_IO trees since
we do special magic for IORESOURCE_IO for legacy reasons which was
causing issues but the idea of doing it for generic I/O make sense).

> the platform bus for MFDs so it's not like we're going to be using a
> different bus in the future for these pmic sub-device drivers if we
> decide to do pmic devices in ACPI (looks like there is at least
> precedence for that with Intel's i2c pmic). Supporting this on ACPI is
> going to take the same effort if we plumb it into the resource table or
> we plumb it into a new driver core API, so the bus agnostic angle isn't

Even if we do these things in ACPI it's not at all clear to me that the
idea of putting the internals of the device in ACPI would be at all
tasteful there.  Personally I'm not a big fan of always doing it in DT
either but it's more tasteful there and definitely does make sense for
some things.

--0ZSpXV6RUUo6PuQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSEMEAAoJECTWi3JdVIfQ4AkH/1IxX/lmLvXnj9kjBoKfxwjS
/MW+gdxw7t9B6cbfxmG6fISs6OJjR5Lw2ycWqLYYumb8H7N88aTAh63+5T4zRjbp
DUKXKhxWphLHB75v3i0YOQOIB0z6yQP+G4usmHV+y1P5qKHLsobvhyR/RO7bGMfh
hKDNq8M+J2fY4JdZJT4Vy5hZkBV3C9ZlcQp8jA/iMxso84G2EacylfuVtLj+LtSM
0f+299iaCYr4RBQKHhkYEWzGQ79D421xuScjlVL5dxIYgOyFFwIM4jTrOvaPqqdg
O+bIPEsfDJV3udO10U7+p2iFq0DlE4BeOXQWENv+K3ABCdPhM1eArFu63jgCUpA=
=pZQQ
-----END PGP SIGNATURE-----

--0ZSpXV6RUUo6PuQK--
