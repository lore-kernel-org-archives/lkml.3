Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751114AbaCVIPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 04:15:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60078 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750738AbaCVIPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 04:15:07 -0400
Date: Fri, 21 Mar 2014 20:17:39 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] i2c: mv64xxx: Fix compilation breakage
Message-ID: <20140321191739.GT27873@lukather>
References: <1394204370-22979-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140307160836.GM21483@n2100.arm.linux.org.uk>
 <20140310105808.GE2815@lukather>
 <20140310112929.GY21483@n2100.arm.linux.org.uk>
 <CAP=VYLqCmG6fRmPPABoW4xg_tFgGh2pji=f5ML=cBgCu4zZocg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CV9cI//wlcIKC9rG"
Content-Disposition: inline
In-Reply-To: <CAP=VYLqCmG6fRmPPABoW4xg_tFgGh2pji=f5ML=cBgCu4zZocg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CV9cI//wlcIKC9rG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 21, 2014 at 11:49:59AM -0400, Paul Gortmaker wrote:
> On Mon, Mar 10, 2014 at 7:29 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Mar 10, 2014 at 11:58:08AM +0100, Maxime Ripard wrote:
> >> On Fri, Mar 07, 2014 at 04:08:36PM +0000, Russell King - ARM Linux wro=
te:
> >> > On Fri, Mar 07, 2014 at 03:59:30PM +0100, Maxime Ripard wrote:
> >> > > @@ -900,7 +902,8 @@ mv64xxx_i2c_probe(struct platform_device *pd)
> >> > >  exit_free_irq:
> >> > >   free_irq(drv_data->irq, drv_data);
> >> > >  exit_reset:
> >> > > - if (pd->dev.of_node && !IS_ERR(drv_data->rstc))
> >> > > + if (pd->dev.of_node && IS_ENABLED(CONFIG_RESET_CONTROLLER) &&
> >> > > +     !IS_ERR(drv_data->rstc))
> >> > >           reset_control_assert(drv_data->rstc);
> >> >
> >> > Another question is... why do we need to check pd->dev.of_node here?
> >> > If CONFIG_RESET_CONTROLLER is set, we always try to get the reset
> >> > controller node, so drv_data->rstc is either going to be a valid
> >> > pointer, or it's going to be an error pointer - neither
> >> > reset_control_get() nor devm_reset_control_get return NULL.
> >>
> >> Following back on this as I was doing the patch, actually,
> >> drv_data->rstc will be NULL if we're not probed by DT, and hence never
> >> call reset_control_get, that would set an error pointer.
> >>
> >> But then, we can use IS_ERR_OR_NULL on drv_data->rstc.
> >
> > I think you can also move the devm_reset_control_get() into the main
> > probe function: you're only checking for -EPROBE_DEFER from it to fail,
> > allowing other errors to continue with the driver init.  This means
> > that on non-OF, devm_reset_control_get() will fail with -ENOENT.
>=20
> Looping linux-next into the CC since this is the cause of the failure
> in orion5x_defconfig there, and no point in anyone else re-doing the
> same bisect.

I sent a fix for this that hasn't been picked up yet:
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-March/239069.html

IIRC, Wolfram's away until Monday, so I guess it will be merged some
time next week.

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--CV9cI//wlcIKC9rG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTLJBTAAoJEBx+YmzsjxAgH6gP/jKtHBpq3INeEpd7SkNLUmEx
HehCiSx8kJZXH29suIjw/O2BP8TuOh6sXfMmwRQdGgSTgf4mztCPW2wyzQSMWw23
so0nO52DBAEA0Hn+VRags2/rIb7K9aEarZ/j1cJPLO1E7guzwT+QZAJRr68xKo1P
dGBFbW21KtwU4GNWzSCntp1HFmHr66XNFxAflHJkxOV6FW9MnSx/Pl4Ql91r5nFu
88CCcJ7YlKYwXF+Vd9SSRALhAicyKBgfiU85vofy36ZiljZgvTRHCnYS26MrZM/V
AIh+Q3Tyv5YVmaM+Vg+BN90i/+W/HPJkgkp9VAUJT6sYw5n+Z7eucagwgNElD+vm
WCB8kuXSrtcu/GlWGsX0Sqi/aFtzbNRf2eZSQKadtn2DuJSaNufccJHn8uemSOPJ
9SljO+XWSOWS6a7sVhdmzbhM8KoKPHM+K9r+59flGlukBEYATeiAeaSZMgxR1MfD
UGH76k38c0KYlxuFGlT7P33P4EzTl7PL3dQ6smfOSp5T9HI+kqI5xx8JKexPTYM+
GKQ9aiP3EFL3LcC7RNa9dSuPzH1h/bHkvfdacKz5g2xo/J0qXgwtEuBm7lQJNVUS
dAVAWW/hwHpFl+YGTFAAwgcTigLlw5ENdcYlbM/dGjXQHYOMdml0Boc6grHj03w3
WI+L+TpsisyrrgJ8J0QS
=WB5f
-----END PGP SIGNATURE-----

--CV9cI//wlcIKC9rG--
