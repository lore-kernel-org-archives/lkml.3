Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183Ab3LLS3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:29:08 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52416 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585Ab3LLS3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:29:05 -0500
Date: Thu, 12 Dec 2013 12:28:31 -0600
From: Felipe Balbi <balbi@ti.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Chao Xu <caesarxuchao@gmail.com>, Linux-OMAP <linux-omap@vger.kernel.org>,
        "santosh.shilimkar@ti.com" <santosh.shilimkar@ti.com>,
        ext Kevin Hilman <khilman@deeprootsystems.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ext Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        Kevin Hilman <khilman@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: Re: [RFC/RFT/PATCH V3] gpio: omap: refresh patch "be more aggressive
 with pm_runtime" against v3.12-rc5
Message-ID: <20131212182831.GM1939@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385506004-14943-1-git-send-email-caesarxuchao@gmail.com>
 <1386477638-6331-1-git-send-email-caesarxuchao@gmail.com>
 <CACRpkdaD13JnGetD-GLpxSoaf_LkRKYFjis7Tftc6U38E1ES5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1rguoi8KZGYj2k4L"
Content-Disposition: inline
In-Reply-To: <CACRpkdaD13JnGetD-GLpxSoaf_LkRKYFjis7Tftc6U38E1ES5A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--1rguoi8KZGYj2k4L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 12, 2013 at 07:19:35PM +0100, Linus Walleij wrote:
> On Sun, Dec 8, 2013 at 5:40 AM, Chao Xu <caesarxuchao@gmail.com> wrote:
>=20
> > From: Felipe Balbi <balbi@ti.com>
> >
> > try to keep gpio block suspended as much as possible.
> >
> > Tested with pandaboard and a sysfs exported gpio.
> >
> > Signed-off-by: Felipe Balbi <balbi at ti.com>
> >
> > [caesarxuchao@gmail.com : Refreshed against v3.12-rc5, and added
> > revision check to enable aggressive pm_runtime on OMAP4-only. Because
> > am33xx_gpio_sysc.idlemodes seems to be wrongly marked as
> > SIDLE_SMART_WKUP, which might cause missed interrupts with this patch.
> > Tested on Pandaboard rev A2.]
> > Signed-off-by: Chao Xu <caesarxuchao@gmail.com>
> > ---
> > changes since v2:
> > *add wrapper function to avoid 'is_aggressive_pm' check everywhere, as
> > suggested by Santosh Shilimkar
> > *fix format issue in commit log
>=20
> I'm dropping this until you convince Kevin/Tony that this is
> the way to go.
>=20
> One thing caught my eye, you add:
>=20
> > +static void _aggressive_pm_runtime_get_sync(struct gpio_bank *bank)
> > +static void _aggressive_pm_runtime_put(struct gpio_bank *bank)
> (..)
>=20
> Then everywhere:
>=20
> > +       _aggressive_pm_runtime_get_sync(bank);
> (...)
> > +       _aggressive_pm_runtime_put(bank);
>=20
> Aggressive, argh, runtime PM is agressive by definition. If you
> want to switch this on and off use the compile option
> to enable/disable runtime PM altogether and do not wrap it
> like this.

heh, OMAP doesn't work without pm_runtime.

--=20
balbi

--1rguoi8KZGYj2k4L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSqgBPAAoJEIaOsuA1yqREPjoQAJ9fLpRv/7J3DVy3v+ztVu0U
d/Lwg3bd9T06hO01qW8AIpK/pRAIfy+oyGocX+NmsyOzDlVLOd3MbhDrwHWKHkQB
JKPdlKp8BElJBuf2XmnqNW0q4oWnY6AiCWRlwLubT5vwALuEV+CP4DrNZdXx5iwQ
KEKEFQg+OrrBvO6q5oPLeTX1aEppaTp7I4BVIbpaagAzkjFMre7qyGQRTOPGsheK
SavHbSa4h68HkI3bcjzE5gct9w2LKn8xnvzwdxx5EExHw6w1EUCRJXVchPyXbQCO
naEyj0bSqNZjZMe+cS+QufUHG/pQedg5/PLzHWljRsRslYhDL+STfzx9UWfSrLKJ
jhqTZ1QKelVu6yfcn6TCx4KqMCjYF74UHVPBVUCLh7WQtVVGubkgQJ9Mf9Bq62ZC
1yPPZBR/p3dcG/3EbjoBG89BCWSn5K0OkREq1bQNWnP3ldEcv6hHqBQTt0zqywhq
7mLDZaiimi1BnXs/poz6OGuPDbUhNHOM2MlCm6GmMBJUqP1o9i0mCfN8fA5UPr5m
SqbiCsR1ZUCywhNqMUKiccIDcA/Kz1po84iPNugJKafWLzL5hYimQvTm7ToeGAH1
siR2xOmnIDYpIpkfkeCXuLOtSaFtRzTpWaZ6NvMzH2qAqEd8clUcDr7Hg35vgkBo
DscTfLOgtbJYI+z8Udro
=6KpK
-----END PGP SIGNATURE-----

--1rguoi8KZGYj2k4L--
