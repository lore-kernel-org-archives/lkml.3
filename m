Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaLRI2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 03:28:48 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:42639 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaLRI2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 03:28:47 -0500
Date: Thu, 18 Dec 2014 09:28:44 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Felipe Balbi <balbi@ti.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: phy: Restore deferred probing path
Message-ID: <20141218082843.GC29856@ulmo>
References: <1417694767-18848-1-git-send-email-thierry.reding@gmail.com>
 <20141217082958.GC3303@ulmo>
 <20141217173448.GB24913@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <20141217173448.GB24913@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2014 at 09:34:48AM -0800, Greg Kroah-Hartman wrote:
> On Wed, Dec 17, 2014 at 09:30:03AM +0100, Thierry Reding wrote:
> > On Thu, Dec 04, 2014 at 01:06:07PM +0100, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >=20
> > > Commit 1290a958d48e ("usb: phy: propagate __of_usb_find_phy()'s error=
 on
> > > failure") broke platforms that rely on deferred probing to order prob=
ing
> > > of PHY and host controller drivers. The reason is that the commit sim=
ply
> > > propagates errors from __of_usb_find_phy(), which returns -ENODEV if =
no
> > > PHY has been registered yet for a given device tree node. The only ca=
se
> > > in which -EPROBE_DEFER would now be returned is if try_module_get() d=
id
> > > fail, which does not make sense.
> > >=20
> > > The correct thing to do is to return -EPROBE_DEFER if a PHY hasn't be=
en
> > > registered yet. The only condition under which it makes sense to retu=
rn
> > > -ENODEV is if the device tree node representing the PHY has been
> > > disabled (via the status property) because in that case the PHY will
> > > never be registered.
> > >=20
> > > This patch addresses the problem by making __of_usb_find_phy() return=
 an
> > > appropriate error code while keeping in line with the above-mentioned
> > > commit to propagate error codes rather than overwriting them. At the
> > > same time the check for a valid PHY is decoupled from the check for t=
he
> > > try_module_get() call and a separate error code is returned if the
> > > latter fails.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> > > ---
> > >  drivers/usb/phy/phy.c | 14 ++++++++++----
> > >  1 file changed, 10 insertions(+), 4 deletions(-)
> >=20
> > Ping?
>=20
> It's the middle of the merge window, we can't do anything until 3.19-rc1
> is out at the earliest.

This fixes a regression that was introduced in commit 1290a958d48e which
has been merged for v3.19-rc1, so this really should go in as soon as
possible. I brought this up around the time of v3.18-rc5 and it's a
shame it's been broken for so long.

Thierry

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIbBAEBAgAGBQJUkpA7AAoJEN0jrNd/PrOhbAAP+Pte/oUCGsyGdC1PvL+aPmzO
TEwIhhjpfMaJI/i552uIl+VSUamZSxlVCTgpNj2zgKXGRS4+dB5aL6GA7UJmBvZC
rT07PgN+KR6lcYaXm6MHhRiFAPiPWxe2fw+l0LMULYrXbJ1mIOOs/+1MLnfGXx6t
y2eic6GuE49h2Dkf0BtiAx5ub+bSspX2XNqje1Ws6ONc5fuMUvUeOGbWM2ej5PeF
oct4N0G1RAz8XKd/QE87deuF5wHg0fxe2WgJE+g4BTnA69N7nQcdTmCvIm0Jjl++
6VUQZ5LmtGhOS5vNquBbcOQaktwM1k4dJxeD2DsPvqRaACs1Ge0LjSN9j6x+UDH8
OUf62qziw/Q/60bLHxPSV78hZMsN1i8md8+/UDH2E64E/i3SKSU+u0sJ97qSx4eq
6XKsglDgsaNdGse4FFv4OzGgd6a/WRw/2aI9AwuVy9oB58PmjNh8CTtPI/MJfNKu
ZxIa7jq52aQEIP8gNqm+eSLVoUcB3B3kaVwrcua/7HdZ6pORoDTv+Mysdm/NAUo1
pAWsc3qzZxusA5NHNbbKfT58IfLIlY280Odfk97DlXV1UVozWnU3PyCdy1hWRdkk
I+etWP3BkZZO8k9gYJZToxhLxGQURdC6d/N72TZ3am+l2uTk30UioJrx7vj342Z0
cMqG49uABpIT2r1ACj0=
=tW06
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
