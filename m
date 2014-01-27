Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbaA0R54 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:57:56 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:47303 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926AbaA0R5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:57:54 -0500
Message-ID: <52E69E1E.3020202@monstr.eu>
Date: Mon, 27 Jan 2014 18:57:50 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Q] block / zynq: DMA bouncing
References: <Pine.LNX.4.64.1401271549280.23931@axis700.grange> <20140127170230.GQ15937@n2100.arm.linux.org.uk> <52E69B4E.5010604@monstr.eu> <20140127175231.GU15937@n2100.arm.linux.org.uk>
In-Reply-To: <20140127175231.GU15937@n2100.arm.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="uFFiXq1NItkHisFCj743jDDeUTD4WRL1R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--uFFiXq1NItkHisFCj743jDDeUTD4WRL1R
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/27/2014 06:52 PM, Russell King - ARM Linux wrote:
> On Mon, Jan 27, 2014 at 06:45:50PM +0100, Michal Simek wrote:
>> Why 0x4000? IRC Linux for ARM is using space for any purpose.
>> Russell knows this much better than I.
>=20
> Probably because as the kernel is loaded at 0x8000, it will place the
> swapper page table at 0x4000, thus covering from 0x4000 upwards.

Ah yeah swapper.

>=20
> Thus, the majority of your un-DMA-able memory will be kernel text or
> swapper page tables.

Yes, exactly.
0x0 - 0x4000 - reserving not to be used by DMA
0x4000 - 0x8000 swapper page table
0x8000 - 0x80000 kernel text + up

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--uFFiXq1NItkHisFCj743jDDeUTD4WRL1R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLmnh8ACgkQykllyylKDCHf0gCeLPB3O2+U+u37SyE1sIAVO4np
WpkAn1VPgiAYBbDuJClZRZKL901DDQ15
=MZGi
-----END PGP SIGNATURE-----

--uFFiXq1NItkHisFCj743jDDeUTD4WRL1R--
