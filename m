Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbaJKQoM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 12:44:12 -0400
Received: from mail.kernel.org ([198.145.19.201]:37073 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbaJKQoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 12:44:11 -0400
Date: Sat, 11 Oct 2014 18:44:04 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MFD for v3.18
Message-ID: <20141011164403.GA19541@earth.universe>
References: <20141010094046.GH26795@lee--X1>
 <CA+55aFyH-E4BTk0EVLnyVDqxtTNxAMM8fnzeo5=sfFaEp8RYhw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <CA+55aFyH-E4BTk0EVLnyVDqxtTNxAMM8fnzeo5=sfFaEp8RYhw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Oct 11, 2014 at 07:01:09AM -0400, Linus Torvalds wrote:
> On Fri, Oct 10, 2014 at 5:40 AM, Lee Jones <lee.jones@linaro.org> wrote:
> >  The following changes since commit 52addcf9d6669fa439387610bc65c92fa09=
80cef:
> >
> >   Linux 3.17-rc2 (2014-08-25 15:36:20 -0700)
> >
> > are available in the git repository at:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/lee/mfd.git tags/mfd-fo=
r-linus-3.18
>=20
> This causes Kconfig problems for me when doing "make allmodconfig":
>=20
>   fs/sysfs/Kconfig:1: symbol SYSFS is selected by CHARGER_MAX14577
>   drivers/power/Kconfig:327: symbol CHARGER_MAX14577 depends on POWER_SUP=
PLY
>   drivers/power/Kconfig:1: symbol POWER_SUPPLY is selected by HID_SONY
>   drivers/hid/Kconfig:649: symbol HID_SONY depends on NEW_LEDS
>   drivers/leds/Kconfig:8: symbol NEW_LEDS is selected by SENSORS_APPLESMC
>   drivers/hwmon/Kconfig:299: symbol SENSORS_APPLESMC depends on HWMON
>   drivers/hwmon/Kconfig:5: symbol HWMON is selected by EEEPC_LAPTOP
>   drivers/platform/x86/Kconfig:496: symbol EEEPC_LAPTOP depends on HOTPLU=
G_PCI
>   drivers/pci/hotplug/Kconfig:5: symbol HOTPLUG_PCI depends on SYSFS
>=20
> and the reason seems to be your changes to drivers/power/Kconfig for
> the CHARGER_MAX14577 symbol.
>=20
> So I pulled and then unpulled.  I realize you're not the only guilty
> party in this chain, but your pull is the final drop, so.. I would
> suggest making that MAX14577 charger interface _depend_ on SYSFS, not
> try to select it.

This is fixed in battery-2.6.git. I will send a pull request in a
couple of minutes.

-- Sebastian

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUOV5TAAoJENju1/PIO/qaoz0QAJJxN4fc/H7ZP4uUwG1W8ryY
XJlP8YWy026waJGiA4Nh3G9l+5tqIZ3gUThtYFsHKi7bbyFeg+LCvUY4IVu+6TVl
PstZJfrMSHW6QsxW0I8qB338XNGCTo6fKVzv8kDsWGHjGbCJSxcGwqZeBf5VnM+y
3jU7JlzuK5BSkIiEYpP4PHIY49SJ/oegITlL61vOyfU5eqRGvQYCBq/W+2hMeDuy
EawYP8wdJ5xk8JL+NNcKS8NrHjpn/7U1KyKT86l0AY2tUYWLRCrGqu04azUH8XN1
cBG54INg3H7urb6P7dZfW0YKRBXhfdahU/mNptNb8AWJI4UrzL+O12WX7QsUGiGr
k8b8ggl199v7oGSXYlUOyZ3E+XgdLJUzAfJt+VzpX+ZgD6QqJctFo0CiBy4vHXXN
aS61W6mC7LC6RD48db3XPyMs2m1MHRt94dSwupXJDiBeRErlVC2HsHiPpPyHvcfK
JbTmSX1l/aufejhNiJWzFASaHinFb42WIXGx2vBOQJZdDB/RRSz76d6PQvLNzAJ2
nVcX/M1G7r0uzNqDZAoROKHy7vdKNOWgXtguK0qW5fMmhgtPYNBdq1t2GxRaatoJ
F4cZI4yj4PEkSsx52E1+CjG80nRiIjsb5O/DqVe1csPB3oMdYmoAfFLzDD9CaShJ
oha8DAGMZdM2CDs3CJD/
=0ckc
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
