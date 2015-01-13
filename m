Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650AbbAMLe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 06:34:27 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:40846 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752525AbbAMLeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 06:34:23 -0500
Message-ID: <54B502B9.9030609@ti.com>
Date: Tue, 13 Jan 2015 13:34:17 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: Antonino Daplas <adaplas@gmail.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fbdev: savage: remove unused variable
References: <1420549930-16607-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1420549930-16607-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="WXbjBBrieNW08IrKTjBplel7iRLSiA6nc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WXbjBBrieNW08IrKTjBplel7iRLSiA6nc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 06/01/15 15:12, Sudip Mukherjee wrote:
> vga_in8() was storing the return value in tmp, but that return value
> was never used again. so it should be safe to remove those variables.
>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>=20
> just one doubt:
> vga_in8() is calling savage_in8() which is a readb().
> so in effect we are reading one byte from
> (par->mmio.vbase + 0x8000 + 0x3da) and then discarding that value.
> so if we are discarding that value then why we are reading it?

Sometimes reading a HW register without actually using the returned
value has some effect. I don't know if there's a reason for that in this
case, though, as I'm not familiar with the HW.

In any case, it's safer to keep the read there as you did.

Queued for 3.20.

 Tomi



--WXbjBBrieNW08IrKTjBplel7iRLSiA6nc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtQK5AAoJEPo9qoy8lh71NxkP/04ytN7Fp6p1UW5cq8YYMz/P
JN2nF+bIRE+v3S4m2OAuo2RvEb1OixtLA5QjKZOvrOFwybDLQMhRhji9EHOrm2pL
vuw+7XbnRM18iwmbs6MPlrapACplfj0dNRqB71FLPL1VP3ejJWRmHGexnegGUScL
8/go8KWABQDdw5f6uKA54Rtq6C8tl1TW4NojVo0fMpOpP/YMjyGIkHESQzP7zMS1
DetBildrfPNTBZWO7dFAeOkTQNL7iSov6MWfcyIYo61/oNV66/wBcT5Vb6lEYH8d
XPjwgY2QlCtOCmz1Lj6iL9eFF/QDdR0gKLC4XyjAONAZ+lF/L2svD4Dts3KnaEEV
ozSrNbbnLNUR8fB5ra7Fst0GYD0V6RraH9VXvv12/BaFaUOmF5RGyTUN1r+kjZtK
xVUuC7VbcOCuGlnRGEfflgfDlltpFF+93uja6p4IlAgQhMXGVsf3LzOakNHHI2V0
KtuazuIWuZwI0zJ8bSdhcbLSHyda41Svxx5RqaQRXjDfvNJecUGXvvVLzGauMtNr
ducZSZ7RJOFbCAVeCH09qc3GET52YQnQ0dkhVsdUyxAv6UiA5hgn5GNx/PDdcLrM
Lf/3d/ww1m4nl8rywmbQB8yjrlAtmwoa+fXroXuzYYKgG5Ansv/lWdVOwH1t2xp9
qvaPT19VxRDHztYHR+dc
=TzEP
-----END PGP SIGNATURE-----

--WXbjBBrieNW08IrKTjBplel7iRLSiA6nc--
