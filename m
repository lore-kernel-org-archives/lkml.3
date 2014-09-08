Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbaIHNrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:47:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57146 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbaIHNrs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:47:48 -0400
Date: Mon, 8 Sep 2014 08:47:33 -0500
From: Felipe Balbi <balbi@ti.com>
To: Robert Baldyga <r.baldyga@samsung.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND v7 2/2] usb: gadget: f_fs: virtual endpoint
 address mapping
Message-ID: <20140908134733.GL22409@saruman.home>
Reply-To: <balbi@ti.com>
References: <1410163020-13910-1-git-send-email-r.baldyga@samsung.com>
 <1410163020-13910-3-git-send-email-r.baldyga@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ai3I8gwHc37+ASRI"
Content-Disposition: inline
In-Reply-To: <1410163020-13910-3-git-send-email-r.baldyga@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ai3I8gwHc37+ASRI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Sep 08, 2014 at 09:57:00AM +0200, Robert Baldyga wrote:
> This patch introduces virtual endpoint address mapping. It separates
> function logic form physical endpoint addresses making it more hardware
> independent.
>=20
> Following modifications changes user space API, so to enable them user
> have to switch on the FUNCTIONFS_VIRTUAL_ADDR flag in descriptors.
>=20
> Endpoints are now refered using virtual endpoint addresses chosen by
> user in endpoint descpriptors. This applies to each context when endpoint
> address can be used:
> - when accessing endpoint files in FunctionFS filesystemi (in file name),
> - in setup requests directed to specific endpoint (in wIndex field),
> - in descriptors returned by FUNCTIONFS_ENDPOINT_DESC ioctl.
>=20
> In endpoint file names the endpoint address number is formatted as
> double-digit hexadecimal value ("ep%02x") which has few advantages -
> it is easy to parse, allows to easly recognize endpoint direction basing
> on its name (IN endpoint number starts with digit 8, and OUT with 0)
> which can be useful for debugging purpose, and it makes easier to introdu=
ce
> further features allowing to use each endpoint number in both directions
> to have more endpoints available for function if hardware supports this
> (for example we could have ep01 which is endpoint 1 with OUT direction,
> and ep81 which is endpoint 1 with IN direction).
>=20
> Physical endpoint address can be still obtained using ioctl named
> FUNCTIONFS_ENDPOINT_REVMAP, but now it's not neccesary to handle
> USB transactions properly.
>=20
> Signed-off-by: Robert Baldyga <r.baldyga@samsung.com>
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

after this patch I get build errors:

drivers/usb/gadget/function/f_fs.c: In function =E2=80=98ffs_epfiles_create=
=E2=80=99:
drivers/usb/gadget/function/f_fs.c:1555:40: error: =E2=80=98struct ffs_data=
=E2=80=99 has no member named =E2=80=98eps_addrmap=E2=80=99
    sprintf(epfiles->name, "ep%02x", ffs->eps_addrmap[i]);
                                        ^
drivers/usb/gadget/function/f_fs.c: In function =E2=80=98ffs_func_setup=E2=
=80=99:
drivers/usb/gadget/function/f_fs.c:2900:19: error: =E2=80=98struct ffs_data=
=E2=80=99 has no member named =E2=80=98eps_addrmap=E2=80=99
    ret =3D func->ffs->eps_addrmap[ret];
                   ^
make[3]: *** [drivers/usb/gadget/function/f_fs.o] Error 1
make[3]: *** Waiting for unfinished jobs....
make[2]: *** [drivers/usb/gadget/function] Error 2
make[1]: *** [drivers/usb/gadget] Error 2
make[1]: *** Waiting for unfinished jobs....
make: *** [drivers/usb/] Error 2

--=20
balbi

--ai3I8gwHc37+ASRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDbN1AAoJEIaOsuA1yqREUg8QALJrmpHOTlAA9wzWe95I3098
LjXNyjAbRu8UENm8VqKQnpVkwoQU+LA4dLzbgy0zMuQQWlytbgX0Pkjp9yX705XT
OwN3iIeoiukNc83MK9cwSaOEMzMl8sUpzQJCqtS/CZSQYAsoboFUtrTl+t7MeBHV
ezqi7jH2jWPf6sB7V4WANGUW1od2iIlHtOoNrrsrBf4x2SlXw+t+7ov0qg9J6/cQ
/pQHKVnyUPArVxph/BD+LjhWmgWBAG+42nP1rc/F5X/7N0PUyEyNlp0TclI4/NYG
HnZnBvQhmpqslV6Nek7/Ge6YlvL3WHwct21VNQcYr3hz5Z1Jet654HgJvOzWTzjj
kV10HqWrTBq1MBy9eJ7QFKmPSWy20W/UelAYpqnRLTOLvkr5aTP5c1sRnhXCwYDw
1xsK6XKM4x6JHT7ydk8ctJ4QL8aecMoQzPkkNeGOEheMTgEuOTRvUhyptB1OJ9wV
z8j7TSnAr+wB+P9IyUYMrk/lzSXYeQoJD0SvF5pAQyXN7lUKAOc3/MacMAicqmd+
5KIdEB8ZC5jDkvcVF70oc8aaH4+D/dU2XNzG/luJkETyiHe+3GiLIAGPiVChBpyG
bfXTSV8RTbNB0U+XVE7OpTpixU6B/vXSB1hi3ShKkzMbLTFN85pMjHz7kuWFIram
N6sse1e0E3rIoYr+LhDh
=Htnm
-----END PGP SIGNATURE-----

--ai3I8gwHc37+ASRI--
