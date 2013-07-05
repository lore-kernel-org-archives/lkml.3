Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab3GEULW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:11:22 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:51694 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab3GEULV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:11:21 -0400
Date: Fri, 5 Jul 2013 22:11:18 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, David Woodhouse <dwmw2@infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, oliver@schinagl.nl,
        linux-mtd@lists.infradead.org
Subject: MTD EEPROM support and driver integration
Message-ID: <20130705201118.GM2959@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Az4VpBrmI9+OyhK/"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Az4VpBrmI9+OyhK/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi everyone,

In the last weeks, we've drivers coming up both about mostly some very
simple drivers that expose to the userspace a few bytes of memory-mapped
IO. Both will probably live under drivers/misc/eeprom, where there's
support already for other kind of what could be assimilated as eeproms
(AT24, AT25, etc.).

Now, besides the code duplication every driver has to make to register
the sysfs attributes, it wouldn't cause much of a problem.

Except that these EEPROMs could store values useful for other drivers in
Linux. For example:
  - imx28 OCOTP (the latest of the two EEPROM drivers recently submitted)
    use it most of the time to store its MAC addresses
  - Allwinner SoCs SID (the other latest driver submitted) use it
    sometime to store a MAC address, and also the SoC ID, which could be
    useful to implement a SoC bus driver.
  - Some Allwinner boards (and presumably others) use an AT24 to store
    the MAC address in it.

For now, everyone comes up with a different solution:
  - imx28 has a hook in mach-mxs to patch the device tree at runtime and
    add the values retrieved from the OCOTP to it.
  - AT24 seem to have some function exported (at24_macc_(read|write)) so
    that other part of the kernel can use them to retrieve values from
    such an EEPROM.
  - Allwinner SoCs have, well, basically nothing for now, which is why I
    send this email.

The current way of working has several flaws imho:
  - The code is heavily duplicated: the sysfs registering is common to
    every driver, and at the end of the day, every driver should only
    give a read/write callback, and that's it.
  - The "consumer" drivers should not have to worry at all about the
    EEPROM type it should retrieve the needed value from, let alone
    dealing with the number of instances of such an EEPROM.

To solve this issues, I think I have some solution. Would merging this
drivers into MTD make some sense? It seems like there is already some
EEPROM drivers into drivers/mtd (such as an AT25 one, which also have a
drivers under drivers/misc/eeprom), so I guess it does, but I'd like to
have your opinion on this.

If so, would some kind of MTD in-kernel API to retrieve values from MTD
devices would be acceptable to you? I mostly have DT in mind, so I'm
thinking of having DT bindings to that API such as

  mac-storage =3D <&phandle 0xoffset 0xsize>

to describe which device to get a value from, and where in that device.

That would allow consumer drivers to only have to call a function like
of_mtd_get_value and let the MTD subsystem do the hard work.

What's your feeling on this?

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Az4VpBrmI9+OyhK/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1yhmAAoJEBx+YmzsjxAglegP/04oesR+DOsS5M+uGusrOOo+
i36UwpXrMvUWgsI1NERgI/PqlI6n5C9MX45FNM/d2Uhs3v6eQSWhYVlH+iyZe1FH
tGtyFU+owHxJMUwzAZ2z8WzG3ffdltpeMHPFYqXHgYeO+pZkfUrPDhNFDR8uMy3Z
8E7+l3QhgacXvFHgVPgNuxgFjGIhfZyFn8Ev6BgVcMoIiZXd1E3KsfLEwXVeQAPN
bjc9tzZR47xCVAvQ4YmANPvBw80ALfvGsXWiRiuv13Fbe6lg9vneq/7wye3EZpnK
/RiZuZi1lANGxuhddo7sZgM28uxywOEsdzk1+jqKwBpRGdbWJIu0ClbIxJZP+hgu
szIWLJSJiu/TkBYEBI7Xd/RhK5JoCZvabZOpVGq3V4n9Wow5r6h4xvWOtHNMgxyI
/49PgL9EmhWAxflN1RkGcIg+vyBVRMi/gmu1QBkYsbCtJWVxjDeNjKffraY4kmY7
QE6bH/X7F5zndkx2QOqU0xko4gxtZ+MqeFmL6r5jSAqnZieqcmutyzgu+vxgFQTg
EXx1gXRBeF5+VtetGz3rljRY3UfSmPJqmVSKuqwNHGICuu5+dI2U6aBDdsiEqVB/
xmk8R0d7jiImHCjDBVpcN+HwXAGgNUXq608gjJl8w6sQt7lFSp7W9M9VG1m2FkkK
hrT+slUGdP6hfR1iu68D
=w64G
-----END PGP SIGNATURE-----

--Az4VpBrmI9+OyhK/--
