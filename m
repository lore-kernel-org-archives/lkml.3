Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965057Ab3DJMwg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 08:52:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39026 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934484Ab3DJMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 08:52:35 -0400
Date: Wed, 10 Apr 2013 13:52:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Subject: Re: mfd, arizona: Fix the deadlock between interrupt handler and
 dpm_suspend
Message-ID: <20130410125232.GA9243@opensource.wolfsonmicro.com>
References: <1365597549.12565.4.camel@cliu38-desktop-build>
 <20130410123003.GZ9243@opensource.wolfsonmicro.com>
 <27240C0AC20F114CBF8149A2696CBE4AC114FF@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YpRP0zjcYagsg5gy"
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4AC114FF@SHSMSX101.ccr.corp.intel.com>
X-Cookie: Your love life will be... interesting.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YpRP0zjcYagsg5gy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 10, 2013 at 12:46:55PM +0000, Liu, Chuansheng wrote:
> Hi Mark,

> > > Here the arizona irq is not NOSUSPEND irq, so when doing device suspe=
nd,
> > > we can disable the arizona irq, and enable it until devices resuming =
finished.

> > Hrm, well - actually the primary IRQ probably ought to be a nosuspend in

> Could we set the irq as NOSUSPEND directly?

Worth checking, yes.

> > +static int arizona_suspend_late(struct device *dev)
> > +{
> > +	struct arizona *arizona =3D dev_get_drvdata(dev);
> > +
> > +	dev_dbg(arizona->dev, "Late suspend, reenabling IRQ\n");
> > +	enable_irq(arizona->irq);

> Here, after later suspending, is it possible the irq coming again?

No, by the time late suspend happens all interrupts ought to be off. =20

> and one more question, why the irq is needed to be enabled even after sus=
pended?

We want interrupts to function as wake sources and want to minimise the
risk of confusing things - the enable/disable ought to nest with what
the core is doing.

--YpRP0zjcYagsg5gy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRZWB9AAoJELSic+t+oim9zhcP/1toEBvDg8Ct3Uc7adDAuPy+
NNDS2T1V15d8Y9nNQO0Apys0eLU8fwHf9pcOaVh36sFTXlGBJRYIbCARqUogqz3J
gY1sf+PjconErVn8ctvvv6RtfwF7oYf5sH35uDfBQHIrQ8dY118gbzFDohek1p/T
DHu5h43uvFH4orjebj1l3M4PmEI2ANwm28QacV61N5bYE9aNSC69L8JydRF8cPvl
8La2FH9cR2XTgfDGAwdGWT06lSc6RZVloMYVEKOjChShXXr//7w+u/gFZvn9sxm9
6asoAj7hdxu9Zb1EQYm3ej2UHybvnBIM6TQeFykYQSOWyXznSiV1TM7ZD00WkCv9
jbCkWz+Dkjm91wmZDxe45/dBSsCbe1T12PQkbkOzE5Vuq0X5sR9ZjcznYkB/xuim
Fg42JYuPeS11IIXAHS3jookSCe/rxBGoOR0lFWTSbltVXkEGQFja4qG3YL/H4clp
UQydTazbEk9iD65BTuoTfMzzZAWS9P25c2KNgyb3Vgu/Ayt6fA95nbD7ubncE/1U
BHtCcv/SVy5vwQQ71ELtY39pz7rHykSVAH8jFj+Ft1At0oMTExkSjcPI1BK0h4tG
aCJ1owy3ReZumHCNR7dtC9aAVZ75BD5n3zzus6wQOe/ttqKUHLeBgdYUBd9rFFf5
jLWk7KVhHGEUMq0N5ISY
=cZ3i
-----END PGP SIGNATURE-----

--YpRP0zjcYagsg5gy--
