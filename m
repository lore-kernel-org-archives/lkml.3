Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaCGKKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 05:10:13 -0500
Received: from top.free-electrons.com ([176.31.233.9]:37518 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751981AbaCGKKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 05:10:08 -0500
Date: Fri, 7 Mar 2014 11:07:51 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3 1/5] i2c: mv64xxx: Add reset deassert call
Message-ID: <20140307100751.GN607@lukather>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140307095222.GG21483@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jHnPw6A2BvaEmbUM"
Content-Disposition: inline
In-Reply-To: <20140307095222.GG21483@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jHnPw6A2BvaEmbUM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Fri, Mar 07, 2014 at 09:52:23AM +0000, Russell King - ARM Linux wrote:
> On Tue, Mar 04, 2014 at 05:28:37PM +0100, Maxime Ripard wrote:
> > The Allwinner A31 SoC using that IP has a reset controller maintaining
> > it reset unless told otherwise.
> >=20
> > Add some optional reset support to the driver.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> > Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
>=20
> This appears to be causing some build errors in Olof's next builder
> for many of the ARM platforms which make use of this:
>=20
> drivers/i2c/busses/i2c-mv64xxx.c:924: undefined reference to `reset_contr=
ol_assert'
> drivers/i2c/busses/i2c-mv64xxx.c:904: undefined reference to `reset_contr=
ol_assert'
> drivers/i2c/busses/i2c-mv64xxx.c:771: undefined reference to `devm_reset_=
control_get'
> drivers/i2c/busses/i2c-mv64xxx.c:778: undefined reference to `reset_contr=
ol_deassert'

The reset framework doesn't define its functions when its not
selected, and somehow I think it was not here. What's odd is that
there is an explicit select on RESET_CONTROLLER in the Kconfig. Maybe
it's the circular dependency issue that has been reported that cause
this and Wolfram sent a patch for: http://patchwork.ozlabs.org/patch/327573/

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--jHnPw6A2BvaEmbUM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTGZp3AAoJEBx+YmzsjxAgJo0P/2nDzMlMX0CVtq/Z362htBoP
ZwNVZra0FPJdwkjZy1DJUTtK+Dk1zbGlcTE+Fwqg/mRtCQaa5EcKUOg9XSu79q2I
Ft3f0Z2lcBIQEDPx1DwWyhL6asEMdwiAJanqwM6z8yGr2LdAfjNQ1RUnL+E9j1Em
1ek+4PYFKPIrsrj5oM4wEyzu/+OOBLo/js8vPi8zSf5lbdrF0eagYjXYbXu/Zr9+
pj7NIVomcnR0fUNOOQiKKqT7lT55qDKgAsECURj+9cim9wlx0va6psd3HUEdMLj7
wVdmoTB5NusV8XCXFHLnlVCJYQoFgFer6nhGPe3bLVOETMoZW5oCOWcUpSl+XL6q
+l3860QLYNUoV8xgtaiDSrI178Z2pAi17N95/2K0ob/Px8AP9oBRbNZYCdgVpw3Z
tktbldmwNnEbcOpOP9pCLGuK6tsZkVN1YHsBCoGp+R7zdEqBZH/tNbVL/Yt58BxU
Sjgs7I7wVt452eaajt0eFiSnG5K+W1RczALfVtqqViM0flxtD7kjaMvxq9ZaFbUB
anB976zvwFueB0Geg24kQaAp3dPvVfWNn2HXQT1t3HgJvqe63dr7F3gxmFZMe34P
TOhg1jq2ot05b25c2rhY0e3CeA4/RnNnMISQmx95CL0onFEbyfX0Lzxq35MB97hN
AGHKl0mfMzWToLGs7drf
=mYy3
-----END PGP SIGNATURE-----

--jHnPw6A2BvaEmbUM--
