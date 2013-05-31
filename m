Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab3EaQdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:33:18 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47167 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435Ab3EaQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:33:09 -0400
Message-ID: <51A8D0BC.4080107@monstr.eu>
Date: Fri, 31 May 2013 18:33:00 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Timur Tabi <timur@tabi.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v3 7/8] video: xilinxfb: Fix sparse warnings
References: <cover.1370004925.git.michal.simek@xilinx.com> <1466524.sgAzczhnBg@wuerfel> <51A8BC83.6050809@tabi.org> <4930944.aMQtpv2nTI@wuerfel>
In-Reply-To: <4930944.aMQtpv2nTI@wuerfel>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2WFGXFMHGDXUQSENQVGFC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WFGXFMHGDXUQSENQVGFC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/31/2013 05:29 PM, Arnd Bergmann wrote:
> On Friday 31 May 2013 10:06:43 Timur Tabi wrote:
>> On 05/31/2013 09:56 AM, Arnd Bergmann wrote:
>>> Yes, unfortunately, this is what all other frame buffer drivers do
>>> at the moment. It is technically not correct, but most architectures
>>> are able to call readl/writel on regular memory, or dereference
>>> __iomem tokens, so we often get away with it. It's probably not
>>> worth fixing it in the fbdev code base as that would be a huge
>>> change, and people are migrating to DRM/KMS.
>>
>> But why bother fixing this bug if it just makes things worse?  Sparse =
is
>> supposed to warn us about bad code.  This patch doesn't fix the bug, i=
t
>> just masks the warnings!
>=20
> Yes, good point. It's probably best cast the ioremap() output to
> a regular pointer here, as that is actually just uncached RAM,
> not an MMIO register.

ok. It means I will just remove this patch from this patchset.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



------enig2WFGXFMHGDXUQSENQVGFC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlGo0LwACgkQykllyylKDCFsZQCeJurxGsrrgx/tiqqtMnWys2uv
fpEAnRU/TrO2BgevXrXTEGs4h0pLhM/V
=gC46
-----END PGP SIGNATURE-----

------enig2WFGXFMHGDXUQSENQVGFC--
