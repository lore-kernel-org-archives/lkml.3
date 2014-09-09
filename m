Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbaIIOn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:43:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57618 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbaIIOn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:43:26 -0400
Date: Tue, 9 Sep 2014 09:43:09 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v7 2/2] usb: gadget: f_fs: virtual endpoint
 address mapping
Message-ID: <20140909144309.GG6151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410163020-13910-1-git-send-email-r.baldyga@samsung.com>
 <1410163020-13910-3-git-send-email-r.baldyga@samsung.com>
 <20140908134733.GL22409@saruman.home>
 <540E97E8.80701@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j2AXaZ4YhVcLc+PQ"
Content-Disposition: inline
In-Reply-To: <540E97E8.80701@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--j2AXaZ4YhVcLc+PQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 08:02:16AM +0200, Robert Baldyga wrote:
> On 09/08/2014 03:47 PM, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Mon, Sep 08, 2014 at 09:57:00AM +0200, Robert Baldyga wrote:
> >> This patch introduces virtual endpoint address mapping. It separates
> >> function logic form physical endpoint addresses making it more hardware
> >> independent.
> >>
> >> Following modifications changes user space API, so to enable them user
> >> have to switch on the FUNCTIONFS_VIRTUAL_ADDR flag in descriptors.
> >>
> >> Endpoints are now refered using virtual endpoint addresses chosen by
> >> user in endpoint descpriptors. This applies to each context when endpo=
int
> >> address can be used:
> >> - when accessing endpoint files in FunctionFS filesystemi (in file nam=
e),
> >> - in setup requests directed to specific endpoint (in wIndex field),
> >> - in descriptors returned by FUNCTIONFS_ENDPOINT_DESC ioctl.
> >>
> >> In endpoint file names the endpoint address number is formatted as
> >> double-digit hexadecimal value ("ep%02x") which has few advantages -
> >> it is easy to parse, allows to easly recognize endpoint direction basi=
ng
> >> on its name (IN endpoint number starts with digit 8, and OUT with 0)
> >> which can be useful for debugging purpose, and it makes easier to intr=
oduce
> >> further features allowing to use each endpoint number in both directio=
ns
> >> to have more endpoints available for function if hardware supports this
> >> (for example we could have ep01 which is endpoint 1 with OUT direction,
> >> and ep81 which is endpoint 1 with IN direction).
> >>
> >> Physical endpoint address can be still obtained using ioctl named
> >> FUNCTIONFS_ENDPOINT_REVMAP, but now it's not neccesary to handle
> >> USB transactions properly.
> >>
> >> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> >> Acked-by: Michal Nazarewicz <mina86@mina86.com>
> >=20
> > after this patch I get build errors:
> >=20
> > drivers/usb/gadget/function/f_fs.c: In function =E2=80=98ffs_epfiles_cr=
eate=E2=80=99:
> > drivers/usb/gadget/function/f_fs.c:1555:40: error: =E2=80=98struct ffs_=
data=E2=80=99 has no member named =E2=80=98eps_addrmap=E2=80=99
> >     sprintf(epfiles->name, "ep%02x", ffs->eps_addrmap[i]);
> >                                         ^
> > drivers/usb/gadget/function/f_fs.c: In function =E2=80=98ffs_func_setup=
=E2=80=99:
> > drivers/usb/gadget/function/f_fs.c:2900:19: error: =E2=80=98struct ffs_=
data=E2=80=99 has no member named =E2=80=98eps_addrmap=E2=80=99
> >     ret =3D func->ffs->eps_addrmap[ret];
> >                    ^
> > make[3]: *** [drivers/usb/gadget/function/f_fs.o] Error 1
> > make[3]: *** Waiting for unfinished jobs....
> > make[2]: *** [drivers/usb/gadget/function] Error 2
> > make[1]: *** [drivers/usb/gadget] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [drivers/usb/] Error 2
> >=20
>=20
> Array "eps_addrmap" was introduced in patch "usb: gadget: f_fs: fix the
> redundant ep files problem". I have received mails from you and Greg
> that it's already applied to usb tree, so I have assumed that there is
> no need to include it to this patchset. I can resend this patch if it's
> needed.

No, no, I was didn't have -rc4 merged on my next. Now I do.

--=20
balbi

--j2AXaZ4YhVcLc+PQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDxH9AAoJEIaOsuA1yqREjrsP/jmZx+FPrBTgyrA2t++YUrYw
lV3wxBChBY8nO+OqLfdW4f7rS4lgWVZTRHYTBd2lSo8c3Tz/Sn6cPrRpoj+z47bZ
alZYpN/nmpIT8cPZbc9CGm1ZfrY1bdZCsjnXVClo1uD8z6llnuDorHLz8zZgSHp5
2Mm7aDM1O3/zoxRaNpvW+xJbyz1HxXrtYizR9KuK6uhmC+dtb2PjxEeKy1iJaY1S
5DO2XXIo8XUCBUvzjWT2QOYoS7OXN8V08BMrNdiJg8F0b8tI9JsQKV01sOEO8A3Z
h40FBBye1msiO2jHwYWNgklkPKgZovPfiLwo8FlC5CUC4+LgNS8KcFPu0n3Q84kq
qOoPjxTS8DeJqGeCqG7+jo1ax78iDIaIRhf84mOhL3sGhqHbMLf4XQ2Uow3bpVfT
zAQkigbUpKs9Y3qFq9+e06FEvhYpX7urwEDUmlT0kvThZ9HPuen6oV9Ko5uQ49Nq
Zd3jZl0vuCZru1ADfgOtKc6gyIIwq79kaF9Ur9cK+QEnC2Ws6Ieq2pLd+Upu0Tyg
2ayvNKkO6T17eMI79THJkarEcoX4+yFmKiLfPV7YHfWd+FJsGaAiRKiDZsDwjNZA
7UreMX2hsO5hBBeRHL0Oc/kYYBsYi51ASedshT1gj3S43e7EKKVjNg5yFeUr/Qvg
bsOUyLMYG8XC4ETzBqbL
=NhA+
-----END PGP SIGNATURE-----

--j2AXaZ4YhVcLc+PQ--
