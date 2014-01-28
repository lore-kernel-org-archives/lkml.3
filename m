Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaA1SN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:13:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54156 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970AbaA1SNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:13:25 -0500
Date: Tue, 28 Jan 2014 12:12:06 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: Felipe Balbi <balbi@ti.com>, "xinhui.pan" <xinhuix.pan@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        <linus.walleij@linaro.org>, <gnurou@gmail.com>,
        <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] gpio-intel-mid: fix the incorrect return of idle callback
Message-ID: <20140128181206.GB31977@saruman.home>
Reply-To: <balbi@ti.com>
References: <52E76F71.4080304@intel.com>
 <20140128164937.GA30226@saruman.home>
 <20140128172413.GA31821@psi-dev26.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20140128172413.GA31821@psi-dev26.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 28, 2014 at 09:24:13AM -0800, David Cohen wrote:
> On Tue, Jan 28, 2014 at 10:49:37AM -0600, Felipe Balbi wrote:
> > On Tue, Jan 28, 2014 at 04:50:57PM +0800, xinhui.pan wrote:
> > > From: "xinhui.pan" <xinhuiX.pan@intel.com>
> > >=20
> > > intel_gpio_runtime_idle should return correct error code if it do fai=
l.
> > > make it more correct even though -EBUSY is the most possible return v=
alue.
> > >=20
> > > Signed-off-by: bo.he <bo.he@intel.com>
> > > Signed-off-by: xinhui.pan <xinhuiX.pan@intel.com>
> > > ---
> > >  drivers/gpio/gpio-intel-mid.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >=20
> > > diff --git a/drivers/gpio/gpio-intel-mid.c b/drivers/gpio/gpio-intel-=
mid.c
> > > index d1b50ef..05749a3 100644
> > > --- a/drivers/gpio/gpio-intel-mid.c
> > > +++ b/drivers/gpio/gpio-intel-mid.c
> > > @@ -394,7 +394,9 @@ static const struct irq_domain_ops intel_gpio_irq=
_ops =3D {
> > > =20
> > >  static int intel_gpio_runtime_idle(struct device *dev)
> > >  {
> > > -	pm_schedule_suspend(dev, 500);
> > > +	int err =3D pm_schedule_suspend(dev, 500);
> > > +	if (err)
> > > +		return err;
> > >  	return -EBUSY;
> >=20
> > wait, is it only me or this would look a lot better as:
> >=20
> > static int intel_gpio_runtime_idle(struct device *dev)
> > {
> > 	return pm_schedule_suspend(dev, 500);
> > }
>=20
> The reply to your suggestion is probably in this commit :)
>=20
> ---
> commit 45f0a85c8258741d11bda25c0a5669c06267204a
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Mon Jun 3 21:49:52 2013 +0200
>=20
>     PM / Runtime: Rework the "runtime idle" helper routine
> ---
>=20
> We won't return 0 from here.

so you never want to return 0, why don't you, then:

static int intel_gpio_runtime_idle(struct device *dev)
{
	pm_schedule_suspend(dev, 500);
	return -EBUSY;
}

just like drivers/tty/serial/mfd.c::serial_hsu_runtime_idle() is doing ?

--=20
balbi

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS5/L2AAoJEIaOsuA1yqRE608QAKc4Vx+1SeD+mNG0J1VojlD/
tl8ePdGIj9zzwDSDSEMDNm/SRNc9Ax46xCipzXLyatGs27JRlMQ8UbKqVOca2fzP
7pRYCh/fXP5g5C53WRBFgujlDqBqkq84DZRG4TzCY7pKaDQSZkm0X9HCv9GlMQyA
Rvaf3cC2TlOxhOhl/CQOVs3ZQA/9T/i20xGy3+at7mnhTET1DK8nhgAQm6sod5Jy
DyXlTmN+3eGhN7HhYTB3Gnd72CPqxbEJrFSXHt45dmtaaMQPuvU/hsWkTuGVGcCA
pn5D7XqnRop7mCUOU3YR2DFKRpLyLtlfDt+OXmbRdg4vdq56QMKIx99ksyEIaPsA
Z5gCfD7UCk2abBSAly/dSncmaQ5GlHmgFznKUdCMqA19U7bD9gFceiJBKJAV+poX
/q62k2c1fJd5WrTgzYpKohw8rB3z1k1q0HoHsWh8XHvRRypSjlnsPbFoRBvpN7Ir
TxkBQb3mBk498C56PHenqCjZkqb3aQgX2ekxZZiMOpfLa2TVnsljb0gCzmiQAklF
vVLNDpBO9Uz6pJsb8RDVePQyRaYDLV2lf2mGnbv6AfKoUhpH8cYHAQFD1gkpmsAC
pGvZinF0MB4TAV07KFTw9KV3uN5we3mkAOC16ZyyE2ZaX5Obo8YNQtmK1Rtfa7fh
PiIq22x777RY2KJFTGLn
=Fiiz
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
