Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab3K1DBr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 22:01:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49047 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754736Ab3K1DBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 22:01:46 -0500
Date: Wed, 27 Nov 2013 21:00:34 -0600
From: Felipe Balbi <balbi@ti.com>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
CC: Felipe Balbi <balbi@ti.com>, <sameo@linux.intel.com>,
        <lee.jones@linaro.org>, Tony Lindgren <tony@atomide.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 00/13] mfd: menelaus: a few cleanups
Message-ID: <20131128030033.GA15444@saruman.home>
Reply-To: <balbi@ti.com>
References: <1385579217-20127-1-git-send-email-balbi@ti.com>
 <20131127200247.GH24645@blackmetal.musicnaut.iki.fi>
 <20131127201149.GB20734@saruman.home>
 <20131127204621.GI24645@blackmetal.musicnaut.iki.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20131127204621.GI24645@blackmetal.musicnaut.iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 27, 2013 at 10:46:21PM +0200, Aaro Koskinen wrote:
> Hi,
>=20
> On Wed, Nov 27, 2013 at 02:11:49PM -0600, Felipe Balbi wrote:
> > On Wed, Nov 27, 2013 at 10:02:47PM +0200, Aaro Koskinen wrote:
> > > On Wed, Nov 27, 2013 at 01:06:44PM -0600, Felipe Balbi wrote:
> > > > few cleanups on the old menelaus driver. I don't have
> > > > HW to test these patches, maybe Aaro can help here ?
> > >=20
> > > Hmm, I got:
> > >=20
> > > [    1.330000] Unable to handle kernel NULL pointer dereference at vi=
rtual address 00000000
> > > [    1.340000] pgd =3D c0004000
> > > [    1.340000] [00000000] *pgd=3D00000000
> > > [    1.350000] Internal error: Oops: 17 [#1] ARM
> > > [    1.350000] CPU: 0 PID: 1 Comm: swapper Not tainted 3.13.0-rc1-n8x=
0_tiny-los.git-729021f-00018-g74a0f39 #2
> > > [    1.350000] task: c782c000 ti: c782e000 task.ti: c782e000
> > > [    1.350000] PC is at mutex_lock+0x0/0x20
> > > [    1.350000] LR is at __irq_get_desc_lock+0x6c/0x88
> [...]
> > > [    1.350000] [<c016745c>] (mutex_lock+0x0/0x20) from [<c00509ac>] (=
__irq_get_desc_lock+0x6c/0x88)
> > > [    1.350000] [<c00509ac>] (__irq_get_desc_lock+0x6c/0x88) from [<c0=
053518>] (__irq_set_handler+0x24/0x128)
> > > [    1.350000] [<c0053518>] (__irq_set_handler+0x24/0x128) from [<c01=
3ec80>] (menelaus_probe+0xbc/0x280)
> > > [    1.350000] [<c013ec80>] (menelaus_probe+0xbc/0x280) from [<c0140a=
b8>] (i2c_device_probe+0x98/0xc0)
>=20
> [...]
>=20
> > hmm, irq_set_chip_and_handler() will call back into the irq_chip we just
> > registered, so my ->irq_bus_lock needs to have everything setup
> > (chip_data my mutex), this should solve it:
>=20
> Yes, that fixes it. Seems to work fine now.

Awesome, should I add your tested-by ? I also added a few extra patches
on top which I'll send soon.

--=20
balbi

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSlrHRAAoJEIaOsuA1yqREb6gP/A0+vMvLNKynabb7Cm+ajE3x
+bI2M50diXPGTPF82r4on0QHYfC2P/neQwo+eh4dWS98hoDeK1S89/TaYjMDdoQw
UmfYGRT0+IHVqglseLuAu/fWSdRlPwa3+TT2iTNKiodpYMf6rkw8T6XFCmPJPUbQ
7JfpZI8X2cqfgyBO0EJpFM+POS0ZHWsP6IUj/A0v4CyseRZu3awJ1xcv+hVnPzNn
atLsG6SRWdaoM+/ZZjnHhsZJvQUEiW2q1gAZINGL869D4nl0eBQ+pAmxSzSgBf4d
YN57yj4N72FwycA7Nz4diLYZDzyJRXv7hjCnF5MmNV+SEXDKnC9J+X6mUzhHzn9g
LzHOBqXEBFxWPMBbQHFlRUfOr4jw/BvDTxdt/gJCxKqWuAeTdRzNwJAUjkppm14r
Fow0/N9VQTJ/e5Ny2S9SEZLZapVeroHsfZ1+6E7NPSqVaF+mCc4qHDBmFeCMXIk/
tMvDsoY/qylR6eud1UU2xjzVQldn6L22JWaohzo560+rUhXdE3tZT7nYdtH9+sGI
s/fMy8ClNY6c6haIVjNf6Y1mZQnm4dWRAZU7DG1rFiHw2NAEtYgD4UsotjPYyXHq
JmkwNm2MQzwLC2B06ghrgk5AYdRN6g1vuXKS0iB76IkQVJQTubWLyt8GeaoJqahr
TmGNmJVEG/l82WXnIhGZ
=9Ye0
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
