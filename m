Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab3GZUaV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:30:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40471 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756762Ab3GZUaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:30:18 -0400
Date: Fri, 26 Jul 2013 23:30:12 +0300
From: Felipe Balbi <balbi@ti.com>
To: Olof Johansson <olof@lixom.net>
CC: Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
Message-ID: <20130726203012.GB14077@radagast>
Reply-To: <balbi@ti.com>
References: <1374605750-29565-1-git-send-email-olof@lixom.net>
 <20130725161406.GD31835@radagast>
 <CAOesGMiupSqpqfyuJ_abr4UQj9Ot77aGJZTsCEY63v-XttgPgw@mail.gmail.com>
 <20130725171951.GD25415@radagast>
 <CAOesGMgn0H4pteeWQcBzcccHr+F9Cf=Y+wvKHr2gCMfBBieOWg@mail.gmail.com>
 <20130726095437.GB2970@radagast>
 <CAOesGMgJsSjf7McOMTHd4E2yoxuxEjqp+DE-CxB4nuEY0gMOzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5I6of5zJg18YgZEa"
Content-Disposition: inline
In-Reply-To: <CAOesGMgJsSjf7McOMTHd4E2yoxuxEjqp+DE-CxB4nuEY0gMOzg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--5I6of5zJg18YgZEa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 09:23:35AM -0700, Olof Johansson wrote:
> On Fri, Jul 26, 2013 at 2:54 AM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Jul 25, 2013 at 01:59:51PM -0700, Olof Johansson wrote:
> >> On Thu, Jul 25, 2013 at 10:19 AM, Felipe Balbi <balbi@ti.com> wrote:
> >> > On Thu, Jul 25, 2013 at 09:18:39AM -0700, Olof Johansson wrote:
> >> >> That's what the code does today, and I wasn't trying to second-guess
> >> >> their decisions on that. Chances are firmware, in some instances, h=
ave
> >> >> left power on so continuing might do no harm.
> >> >
> >> > fair enough, then let's just decrease the error message level to deb=
ug
> >> > or info.
> >>
> >> Fair enough. info seems appropriate (or warn). Want me to respin, or
> >> can you edit when you apply?
> >
> > please respin
>=20
> An older patch from Arnd that accomplishes the same warning removal
> has mysteriously showed up in -next in the last couple of days
> (ae40d64b1f2db93d7b092e6425a2f716289fbd09), even though commit date
> was July 15.
>=20
> So, might as well, drop this one.

doesn't look like the same thing:

commit ae40d64b1f2db93d7b092e6425a2f716289fbd09
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed Jun 19 13:27:27 2013 +0200

    usb: gadget: at91_udc: call at91udc_of_init only when needed
   =20
    This avoids a build error in at91sam9261_9g10_defconfig:
   =20
    drivers/usb/gadget/at91_udc.c: In function 'at91udc_probe':
    drivers/usb/gadget/at91_udc.c:1685:34: warning: 'flags' may be used uni=
nitialized in this
    function [-Wmaybe-uninitialized]
      board->vbus_active_low =3D (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
                                      ^
    drivers/usb/gadget/at91_udc.c:1678:21: note: 'flags' was declared here
      enum of_gpio_flags flags;
                         ^
   =20
    Making the call to at91udc_of_init conditinal also reduces
    the object code size without sacrificing build coverage.
   =20
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Cc: Felipe Balbi <balbi@ti.com>
    Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
    Signed-off-by: Felipe Balbi <balbi@ti.com>

diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_udc.c
index 073b938..2cbab1c 100644
--- a/drivers/usb/gadget/at91_udc.c
+++ b/drivers/usb/gadget/at91_udc.c
@@ -1725,7 +1725,7 @@ static int at91udc_probe(struct platform_device *pdev)
 	/* init software state */
 	udc =3D &controller;
 	udc->gadget.dev.parent =3D dev;
-	if (pdev->dev.of_node)
+	if (IS_ENABLED(CONFIG_OF) && pdev->dev.of_node)
 		at91udc_of_init(udc, pdev->dev.of_node);
 	else
 		memcpy(&udc->board, dev->platform_data,

--=20
balbi

--5I6of5zJg18YgZEa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8txUAAoJEIaOsuA1yqREulMQAICam6YAGY8wrcL3udoJMQRJ
FXkJzAm1GhE+3Q4UQbVoftJeNCngqzra6zs8gLmWTwH0SHRLI9OxEvVbxpffxFWf
RR/a1ng1JzJO5etdUDOyDx/8oPKoQkYxwvq7EPE12hDnXBNX5NpaAMJaUX3vuktM
UVhEZ/vqXSnLUVgog3XkrrOk9bY3f+ZDAA5M5RLg2qhgFJi4tfKJ3AIHAOZZcoFD
v5cdcECWZVYGAxWWqnZ7wFOOTjAv6ME/I2mD17MWkLpR7sppntKY04zX6vNaKRW2
HbwT9TrJtEPk64YoaBJR/k2E/mcGf4ujeGqTxyvxtN0oVfPy/aEW2hWrKDOJMphX
/SnrmZcInDZY/3ncelpXCJfX0KsjcJdOWYtSs7jO+ZJ7fWnzRh63EhdNkhlCyMRc
UW9axJfmfNifFwEYYEk0nkFW34e70IMt8b3yMxnA18OM1sCrdLT4ns3rjr1TkB8y
V8oTW9Un5sc0TKBg1AY9uWl7PySBxyXdZqG6MJSTeWTfmsRGgsP7qiI75NUVGVSx
GQCAAawGBk8jAcaK/KL0iiWrvAqppm80X2gbaVOdzbKohjCC6BpW07WKNtxvU9uP
xKkMqUeASN8HUwopmDXOxi0PDOf0bOBdgHC/7Syb4dVxQ5NEKY6DhSHeZUao7Rws
bZPOnRH7LhBCfM+N9EcI
=8+Uj
-----END PGP SIGNATURE-----

--5I6of5zJg18YgZEa--
