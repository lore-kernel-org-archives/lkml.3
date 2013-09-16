Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab3IPPVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 11:21:07 -0400
Received: from sauhun.de ([89.238.76.85]:39587 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197Ab3IPPVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 11:21:05 -0400
Date: Mon, 16 Sep 2013 17:21:04 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
Message-ID: <20130916152104.GA3909@katana>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
 <20130916091956.GF3999@lee--X1>
 <20130916104009.GA29403@sirena.org.uk>
 <CACRpkdatiELF3WK9qE_Mgcq3iCgv5w3X22xp1=232JJq9sWggQ@mail.gmail.com>
 <20130916135118.GD29403@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <20130916135118.GD29403@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


On Mon, Sep 16, 2013 at 02:51:18PM +0100, Mark Brown wrote:
> On Mon, Sep 16, 2013 at 02:44:35PM +0200, Linus Walleij wrote:
>=20
> > I've tried to fix this for DT-only I2C devices
> > and this very driver was the reason.
>=20
> > But a tiresome regression due to drivers relying on this
> > i2c_device_id not being NULL and inability to remove it from the I2C
> > core without refactoring the world ensued, see:
> > commit c80f52847c50109ca248c22efbf71ff10553dca4
>=20
> Oh, that was the change...
>=20
> > Reverted in:
> > commit 661f6c1cd926c6c973e03c6b5151d161f3a666ed
>=20
> > For this reason I think:
> > http://marc.info/?l=3Dlinux-next&m=3D137148411231784&w=3D2
>=20
> > I have tentatively given up getting pure DT I2C drivers
> > to probe, I don't think I have the whole picture, but
> > Wolfram has serious doubts about this and say we have
> > to be careful ....
>=20
> > Wolfram, do you have some ideas on how we should
> > proceed or ar you happy with merging this as-is?
>=20
> I'd have expected that it should be possible to change things such that
> the change in the core doesn't produce any change in behaviour for
> existing drivers.  Can we not change the patch so that i2c_match_id()
> copes with getting a NULL id_table?  Something like this:

I hacked something like this after Linus posted his approach. However, I
found out that run time instanciating ('new_device' file) needs an
id_table. I wasn't to keen on disabling the feature for dt-only drivers.
That's where I stopped, due to lack of time.


--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSNyHgAAoJEBQN5MwUoCm24nwP/2AbTpOSLvvSpxX4mz9tBbYP
Rpvstzrg6RU3lyc3/xNIR42l+1PN6awss9cuEkfpV5J5xv/wGaxkQ9GoP7SBLVgU
MC1VzfP2w6mi0b/PxFfjdp+8liEsnA7FQfNtetdirU9rrlE/QPEu6hiRm+SMztMi
Wr1B/jyI76yBHd3EtnpwztrLQ6gw4ABPXHqz2/ItFhTN51+jSwNZX4Ya7m1niCYN
RpTlzDnmqXziBLaYQ7aMGYUuupH/IXbwqd0WckmKoa2d4RfoNkrIPS1X894F0fDK
iQiXx48V46O6Oln5SzJL5kAxn5c1UB5TIs08gS4eNVgIJZqfwSH6m2O2ImWEB6d0
0ZWpZ4caraE3SdWTn6PZfwRfuP1o95+2h7R84jpfdHdDrUHl+SvBXI+SdEcLM2Av
/u5Ak3+KoZqJlV1V0ZlAnoM/Q3BVDWClHwtvHArvL3bNxnoI6DV5i9vY5Lf//T3Z
2JYRrK1+5DhiNjMOdctG9tZDwBIMQvwpanVXvgWglZ0xwrY0x3fYBP0b5qgMuO8h
sAERQGF4rtbLOVA835rOJ4iaMqP7PacDDFn0ftbhLm9YnMam0MyTHagoJmQK7yu/
fbgJEaqkgXWe6rHhVlavuGgoRxtWwARQXrz0H5e61586PIxRBE+LK0IWB+0bgpf9
DmsEmMOqB3I2GqRF6OEc
=ZMwJ
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
