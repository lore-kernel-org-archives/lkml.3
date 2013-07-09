Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753167Ab3GIL2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 07:28:35 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33070 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751176Ab3GIL2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 07:28:32 -0400
Date: Tue, 9 Jul 2013 14:27:51 +0300
From: Felipe Balbi <balbi@ti.com>
To: George Cherian <george.cherian@ti.com>
CC: <balbi@ti.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <benoit.cousson@linaro.org>, <afzal@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
Message-ID: <20130709112751.GI5552@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
 <20130709102022.GH5552@arwen.pp.htv.fi>
 <51DBF23F.20103@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="poJSiGMzRSvrLGLs"
Content-Disposition: inline
In-Reply-To: <51DBF23F.20103@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--poJSiGMzRSvrLGLs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 09, 2013 at 04:51:35PM +0530, George Cherian wrote:
> >>+				compatible =3D "snps,dwc3";
> >>+				reg =3D <0x48390000 0xcfff>;
> >weird size, shouldn't this be 0xd000 then the size would be exactly
> >52KiB
>=20
> okay

btw, the reason here is that when you call devm_ioremap_resource(), that
will call resource_size() which does:

	size =3D res->end - res->start - 1;

so you need this extra 1 on the size when passing it via DT.

> >Another thing: am437x has 4 instances of this IP, why are you adding
> >only one ?
>=20
> AM437x has got only 2 instances. I have verified only one on HAPS so
> adding only one.

weird, on my TRM I see for dwc3 but 2 PHYs.

> >And why aren't you pasing the PHY nodes here ? The device
> >won't work without its PHYs.
>=20
> Yes true, again in HAPS I  didnt have any PHY configuration to be done.

alright, but we should still pass the PHY right ? once silicon comes,
we want this to work without any further changers.

--=20
balbi

--poJSiGMzRSvrLGLs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR2/O3AAoJEIaOsuA1yqREQG8P/03IiNYWxofEiiBOjt1pNPEv
7pdR6dQdkb3AnTmIYyoulaWYC5SpmcwGyFoWOrcJPHb7bJ1R5zfjNqkpVqfhd7Tl
lhLKVYS/3DnSazb7Iekx/vdUgG0VCXDkk7UHATkS6y5Oldjxs7m92/Mrt3VyNZ4F
LabfdDtc8Y/tv3mCCxX6RfjJFChx+jj9ip8rrRnw7SEhqpub8oP60xY9ozO33K3Z
/QC5OqPkx8iZXEMV519PcCVnvriLhWSMLG2ioO6qZ0fUYJ1cG6w9bNsFeNtHCyhp
2ZUpJkKfNQ78tsEzivN9wXRMsz/wreE2Z7qHwe8BRWJCf96+candoHobhjInLI7S
CFX0a/YQ6A1fptHt9lBS8eVEYpNtLfQh0oP3OX/IV7rVMrV2WgavtqMKmvL0sIdi
FcKb1jhSeY3a9twDhBNeGcik2ii0UUaix0yvkr9DlJ9VaCMEVm7zkkTnkXZfQkNx
PMBfvbPdcw6XbYXJe1hUcydmyPfeibHbB9Jf3tlgc7AA8ESUF25391CPOxyMdOPw
mafSjiIYQUISg8eZh6QDiSJwKS27O3TJOduPJUSzcv0Yqc2HReDizldwev+0JRAt
72sIFdR0i210/meQWMeZ25mNuheuE8/LMjxU1g8+Pzw4qEwyvhJF51WC3UFPKsCS
+q0VoL1AUVA4w3Lx2PYT
=JCMD
-----END PGP SIGNATURE-----

--poJSiGMzRSvrLGLs--
