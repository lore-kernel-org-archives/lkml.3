Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbaJLAtf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 20:49:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50070 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbaJLAte (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 20:49:34 -0400
Date: Sat, 11 Oct 2014 19:47:58 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Alessandro Zummo <a.zummo@towertech.it>,
        Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/12] rtc: omap: restore irq state after reading TC
 registers
Message-ID: <20141012004758.GB21128@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-9-git-send-email-johan@kernel.org>
 <20141010180225.GT31348@saruman>
 <20141011101201.GC18988@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GRPZ8SYKNexpdSJ7"
Content-Disposition: inline
In-Reply-To: <20141011101201.GC18988@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--GRPZ8SYKNexpdSJ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 11, 2014 at 12:12:01PM +0200, Johan Hovold wrote:
> On Fri, Oct 10, 2014 at 01:02:31PM -0500, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Thu, Oct 09, 2014 at 09:06:30PM +0200, Johan Hovold wrote:
> > > Make sure to restore local irq state when reading the timer/calendar
> > > (TC) registers, so that omap_rtc_read_time() can be called with
> > > interrupts disabled.
> > >=20
> > > Signed-off-by: Johan Hovold <johan@kernel.org>
> > > ---
> > >  drivers/rtc/rtc-omap.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >=20
> > > diff --git a/drivers/rtc/rtc-omap.c b/drivers/rtc/rtc-omap.c
> > > index 0ef016553a97..62e2e9a9887a 100644
> > > --- a/drivers/rtc/rtc-omap.c
> > > +++ b/drivers/rtc/rtc-omap.c
> > > @@ -239,8 +239,10 @@ static void bcd2tm(struct rtc_time *tm)
> > > =20
> > >  static int omap_rtc_read_time(struct device *dev, struct rtc_time *t=
m)
> > >  {
> > > +	unsigned long flags;
> > > +
> > >  	/* we don't report wday/yday/isdst ... */
> > > -	local_irq_disable();
> > > +	local_irq_save(flags);
> >=20
> > you should really convert these to a real spin_lock_irq*(), that's
> > because local_irq* do not get re-written with RT patchset, so this
> > pretty much "breaks" RT.
>=20
> The driver uses local_irq* throughout to guarantee registers are not
> read or written during an update event.
>=20
> In fact, at least on AM33xx, this is not even necessary when reading (as
> opposed to writing) the TC registers, but I did not dare change that
> without knowing how the legacy platforms work in this respect.
>=20
> Do you suggest doing this conversion as part of, or on top of, this
> series?

probably on top of is. Safer that way.

--=20
balbi

--GRPZ8SYKNexpdSJ7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOc++AAoJEIaOsuA1yqREjg4P/3+Lk5jKZx74l3U9ZvXHugE9
ADO+nDrgcesXoyGVp+bQVRNFkLbQdWCSHCyqkjC4Hx2Nxw832W74R+YqrJavfI7S
5+p4BFSTKEyDFuAKWtdLHLaAHgH2mAqPeMVb2XahX3jMeWH+ntBMf6cdPyf/f3Kb
GeTM+snI5ccSi7EnROIKMqIsdJLAiMwSkaarjyD9bUTNfievcvIXhf4WFc09sGCd
5ipRJm8fCWEPYcC7ORlEsUg7yZVyiMr5nbCV/1mO33igEu2f+Ic1XR+KchYmC6CO
cLK/5pDmg2oU4hWAbhOrup1sTAPKqErtCyFiu0nG0oQYrkE4INYs8VbHwJGg63v2
06U/WZDMGlICCRxWQ6L0HaEWAijuIrBE+gpHqZ+8vvaiSdVahIY2cwZVo12JJNXr
wjOQYwVIWh5U/LSnprfzWKQGsR5rfsrlcWRZznQfLI9JtjXvhz+7sgz4THQNC6Tl
DvC0KpUg046RBz7+om+qJC9RkUPIYoSGVemM2R5i5xrEMKDiubcvKkU39in2OUZ+
md4z5OGYZkfuYiliJeuet+LFwud7SGzhIsIF7swo5sZoxR9TkRiMdsEome21XRFt
XkB2O7DYr+DK/tb0UOku9KTiHOE2oU6fxcxrMfzoamP8yZ8jtQ6BGskdJhtyTJ5U
24ltYEf7YAsPSvB3ZQWR
=pRpA
-----END PGP SIGNATURE-----

--GRPZ8SYKNexpdSJ7--
