Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab3GYRT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:19:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:34418 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab3GYRTz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:19:55 -0400
Date: Thu, 25 Jul 2013 20:19:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: Olof Johansson <olof@lixom.net>
CC: Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: at91_udc: Check gpio lookup results
Message-ID: <20130725171951.GD25415@radagast>
Reply-To: <balbi@ti.com>
References: <1374605750-29565-1-git-send-email-olof@lixom.net>
 <20130725161406.GD31835@radagast>
 <CAOesGMiupSqpqfyuJ_abr4UQj9Ot77aGJZTsCEY63v-XttgPgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kR3zbvD4cgoYnS/6"
Content-Disposition: inline
In-Reply-To: <CAOesGMiupSqpqfyuJ_abr4UQj9Ot77aGJZTsCEY63v-XttgPgw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--kR3zbvD4cgoYnS/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2013 at 09:18:39AM -0700, Olof Johansson wrote:
> On Thu, Jul 25, 2013 at 9:14 AM, Felipe Balbi <balbi@ti.com> wrote:
> > Hi,
> >
> > On Tue, Jul 23, 2013 at 11:55:50AM -0700, Olof Johansson wrote:
> >> This resolves the following valid build warning:
> >>
> >> drivers/usb/gadget/at91_udc.c:1685:34: warning: 'flags' may be used un=
initialized in this function [-Wmaybe-uninitialized]
> >>
> >> I switched from ? : to !! mostly to save from wrapping the lines while
> >> I was at it.
> >>
> >> Signed-off-by: Olof Johansson <olof@lixom.net>
> >> ---
> >>
> >> Felipe, this would be nice to see fixed for 3.11 but I'd argue that it=
's
> >> been here long enough to not really be needed for -stable.
> >>
> >>  drivers/usb/gadget/at91_udc.c |   12 ++++++++++--
> >>  1 file changed, 10 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/usb/gadget/at91_udc.c b/drivers/usb/gadget/at91_u=
dc.c
> >> index 073b938..f3dbcd0 100644
> >> --- a/drivers/usb/gadget/at91_udc.c
> >> +++ b/drivers/usb/gadget/at91_udc.c
> >> @@ -1682,12 +1682,20 @@ static void at91udc_of_init(struct at91_udc *u=
dc,
> >>
> >>       board->vbus_pin =3D of_get_named_gpio_flags(np, "atmel,vbus-gpio=
", 0,
> >>                                                 &flags);
> >> -     board->vbus_active_low =3D (flags & OF_GPIO_ACTIVE_LOW) ? 1 : 0;
> >> +     if (board->vbus_pin < 0)
> >> +             pr_err("%s: Failed to get atmel,vbus-gpio property\n",
> >> +                    np->full_name);
> >> +     else
> >> +             board->vbus_active_low =3D !!(flags & OF_GPIO_ACTIVE_LOW=
);
> >
> > should you even continue if you can't get the gpio ? If this gpio is
> > optional, then it's not really and error, rather a debugging or
> > informational message.
>=20
> That's what the code does today, and I wasn't trying to second-guess
> their decisions on that. Chances are firmware, in some instances, have
> left power on so continuing might do no harm.

fair enough, then let's just decrease the error message level to debug
or info.

--=20
balbi

--kR3zbvD4cgoYnS/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR8V43AAoJEIaOsuA1yqREYmEP/jXPH+4YOTJFNg05MOwMoBTu
lFVGol5gvPUXBJ/v08gj1C8t2QhCmY/dnINpv8QZfaGbMDgypeRmzwuikk9kI2KW
iPOrufoL1su/kf4iqoLxSSykMR7XLCRYMgWEo+BbYXRxOx3qjrhrA+gOAWPES0pN
YtMA7hcRmAKVlmEQEMqcfD9IxOp1IeQx4kopyVSOI1eAWWgK2w8MtBgbr19CfVnh
i+9rYPrdsG4oX9eRcFD3FzIZwdvGEdbawVLTcggSW5IE8nsyIiXKoIgigMW6ohFb
mxDojaCIAmj8imZrK5lu22H8+uUzlWtyY/cDhQZ0ZKpyUhETtGMEU7AIjWEaZBHU
+4sr08vdRVBxSIbdXH7kKfiHrkP6cQhGc+SZmQziLnvG9dLpSBFekbRKdavgaq+1
DrzsBeq6iH/iRvSJW6wVtA4MxLQU3QbkA/IDGy0GXAYAi/5TzrFP+iML+YUxZj7Q
IupyahvOP22wVObAhewxM6bfwzfukl8sHoFwzwHIO+ka2QR3sUbz+qyaAJ+GB/bH
bjcxVK8wF7Enr3U712l7+80SYsqH4vI63GIsQA7n0m19ll+L0LFy++Nd2BsU6UOR
CBxYVNr7JcPTf3S8Dqe4X4YPcODobvwObY7cxhNbfALqaPbllWfahAxyvhEnVvNr
oNnFNrpNaBaiZDviuUO2
=IaYm
-----END PGP SIGNATURE-----

--kR3zbvD4cgoYnS/6--
