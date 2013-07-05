Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851Ab3GEBZM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:25:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39660 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab3GEBZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:25:10 -0400
Date: Fri, 5 Jul 2013 11:24:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>
Subject: linux-next: build failure after merge of the pm tree
Message-Id: <20130705112458.f7e8297da9ea551c9fca2cb5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.19; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Jul_2013_11_24_58_+1000_=3CIbplC7TgrwZBP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Jul_2013_11_24_58_+1000_=3CIbplC7TgrwZBP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/gpu/drm/radeon/atombios_encoders.c: In function 'radeon_atom_backli=
ght_init':
drivers/gpu/drm/radeon/atombios_encoders.c:230:2: error: implicit declarati=
on of function 'acpi_osi_version' [-Werror=3Dimplicit-function-declaration]
  if (acpi_osi_version() >=3D ACPI_OSI_WIN_8)
  ^
drivers/gpu/drm/radeon/atombios_encoders.c:230:28: error: 'ACPI_OSI_WIN_8' =
undeclared (first use in this function)
  if (acpi_osi_version() >=3D ACPI_OSI_WIN_8)
                            ^
drivers/gpu/drm/radeon/atombios_encoders.c:231:3: error: implicit declarati=
on of function 'acpi_video_backlight_unregister' [-Werror=3Dimplicit-functi=
on-declaration]
   acpi_video_backlight_unregister();
   ^

Caused by commit 1823b2aeccce ("drm/radeon: don't provide ACPI backlight
if firmware expects Windows 8").

I have used the pm tree from next-20130704 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Jul_2013_11_24_58_+1000_=3CIbplC7TgrwZBP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR1iBuAAoJEECxmPOUX5FE5ZMP/1SgEGmJ+Il4uJldvgD0fs0y
xGP2OzJ4fe2eKmDX4rrfnZXnuseXyMA4Ob7PJfyCdqV5Rll+CjGH9/TJug5a/vlT
qNmKRdAG1BFp17vEixBTMD1juB9AuVw6yCVZCJ18sLko3Vhb4bztSQrKGWFK7z0F
r8g2LDzmWv+xkThxQwA3bQhDGpSB0Kas10vqoN9rFHdbrHYWgrSjMAQockPLSql6
NKwHZBTcFtDLEK1Db/pUC7dyD96AYj+KtSWd8QK/6lbTGYgWomFYIgx033H77NHh
7d3vMxGFPCi1/sC5CGjLf0ELQzd74210Eo+wAjSRRSc0frUhd7UeX6qxPVvgRHZF
TjrfxN72E40Bpb7H2XDdmgKt436P7H738QqNWsTllt0uGVEC4HkN5RJ8AqXVNmQ+
djxo15vzqjjT/Qvi+yAbiISWl7d4xJK9eqFq59jXrh7egvxpx5ifzvjSO4JTZsFy
SHGjInSOcVgV4lWgDtm+pZYyXQh2MK/BlkWosDjCe6sOSEPOkc2nkcDdW10r+/5u
YcOMlb28ESKvK7G5DOGPCCCpnk1BfSLHgmLKnt+pCn7pnZE0litZ3ATNZIF5v7Y5
k5ZIoWJCd2MuaXYIPkArKB9Jt1g0zgTVdcnlh5491PSYhtjeBBW9IC2wmrbJmUEA
R73ACzUePpLUK0pZH8Ac
=QY5f
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Jul_2013_11_24_58_+1000_=3CIbplC7TgrwZBP--
