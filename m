Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaBCMNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 07:13:51 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:57345 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaBCMNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:13:50 -0500
Message-ID: <52EF87EA.4010501@monstr.eu>
Date: Mon, 03 Feb 2014 13:13:30 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Michal Simek <michal.simek@xilinx.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Josh Cartwright <josh.cartwright@ni.com>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: zynq: Reserve not DMAable space in front of the
 kernel
References: <780bb8c8fd752eeace2fd2fbe1d8ed8572dc0d76.1391170073.git.michal.simek@xilinx.com> <CAL_Jsq+4Ea7=WP+mj_k1Q3q7DKm-hk6WXpv2DOBQwefp-zxzjg@mail.gmail.com>
In-Reply-To: <CAL_Jsq+4Ea7=WP+mj_k1Q3q7DKm-hk6WXpv2DOBQwefp-zxzjg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="aKWpx9fns61hIoKCC8WimMEoTFMO5pB00"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aKWpx9fns61hIoKCC8WimMEoTFMO5pB00
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/31/2014 06:38 PM, Rob Herring wrote:
> On Fri, Jan 31, 2014 at 6:08 AM, Michal Simek <michal.simek@xilinx.com>=
 wrote:
>> Reserve space from 0x0 - __pa(swapper_pg_dir),
>> if kernel is loaded from 0, which is not DMAable.
>> It is causing problem with MMC driver and others
>> which want to add dma buffers to this space.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> Jason: I don't think it is worth to bring 0x8000 magic
>> value and count minimum from it and phys_addr of swapper_pg_dir.
>> Full 512k of memory shouldn't be used by DMA.
>>
>> ---
>>  arch/arm/mach-zynq/common.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>=20
> The existing DT reserved range can't be used for this purpose?

I expect you are talking about memreserve.

Two cases which are valid for us which have the same DTS file
with this setup.

memreserve 0 - 0x4000
memory node 0x0 - 0x40000000


1. standard
kernel starting addr is 0x8000 and kernel is using 1GB memory which just =
works

2. AMP which we are also using
kernel starting for example from 0x10008000 and use just 768MB, 256MB for=
 remoteproc.
With memreserve in DTS this ends in mark_bootmem BUG because reserved mem=
ory is not in memory
which Linux can handle (at least this is my theory).

Case 2 require one small fix which Russell is aware of,
I have to check status on it.

But with this current implementation both cases just work
without changing dts file because for both cases
dts file is just the same and user decides where kernel is placed
and how much memory user wants to use.

If you know how to fix this with any better dt description please
let me know. I am not aware about it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--aKWpx9fns61hIoKCC8WimMEoTFMO5pB00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlLvh+oACgkQykllyylKDCFdQgCdGPGIAM3sipfzWJMwNQcU6mB0
CHMAoIXaVySlTeimXEg+8ZidSq1seb6t
=n2u8
-----END PGP SIGNATURE-----

--aKWpx9fns61hIoKCC8WimMEoTFMO5pB00--
