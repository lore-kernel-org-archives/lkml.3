Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581Ab3JPKrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 06:47:46 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:61263 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760182Ab3JPKro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 06:47:44 -0400
Message-ID: <525E6EC6.70908@monstr.eu>
Date: Wed, 16 Oct 2013 12:47:34 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>
CC: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC 1/9] of/irq: Rename of_irq_map_* functions to of_irq_parse_*
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org> <1381869563-16083-2-git-send-email-grant.likely@linaro.org>
In-Reply-To: <1381869563-16083-2-git-send-email-grant.likely@linaro.org>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="TeA2akp6vUVGlkdGjG8dnBiGuaMDK0qCw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TeA2akp6vUVGlkdGjG8dnBiGuaMDK0qCw
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 10/15/2013 10:39 PM, Grant Likely wrote:
> The OF irq handling code has been overloading the term 'map' to refer t=
o
> both parsing the data in the device tree and mapping it to the internal=

> linux irq system. This is probably because the device tree does have th=
e
> concept of an 'interrupt-map' function for translating interrupt
> references from one node to another, but 'map' is still confusing when
> the primary purpose of some of the functions are to parse the DT data.
>=20
> This patch renames all the of_irq_map_* functions to of_irq_parse_*
> which makes it clear that there is a difference between the parsing
> phase and the mapping phase. Kernel code can make use of just the
> parsing or just the mapping support as needed by the subsystem.
>=20
> The patch was generated mechanically with a handful of sed commands.
>=20
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Michal Simek <monstr@monstr.eu>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
>  arch/arm/mach-integrator/pci_v3.c              |  4 ++--
>  arch/microblaze/pci/pci-common.c               |  2 +-
>  arch/mips/pci/fixup-lantiq.c                   |  2 +-
>  arch/mips/pci/pci-rt3883.c                     |  2 +-
>  arch/powerpc/kernel/pci-common.c               |  2 +-
>  arch/powerpc/platforms/cell/celleb_scc_pciex.c |  2 +-
>  arch/powerpc/platforms/cell/celleb_scc_sio.c   |  2 +-
>  arch/powerpc/platforms/cell/spider-pic.c       |  2 +-
>  arch/powerpc/platforms/cell/spu_manage.c       |  2 +-
>  arch/powerpc/platforms/fsl_uli1575.c           |  2 +-
>  arch/powerpc/platforms/powermac/pic.c          |  2 +-
>  arch/powerpc/platforms/pseries/event_sources.c |  2 +-
>  arch/powerpc/sysdev/mpic_msi.c                 |  2 +-
>  arch/x86/kernel/devicetree.c                   |  2 +-
>  drivers/of/address.c                           |  4 ++--
>  drivers/of/irq.c                               | 28 +++++++++++++-----=
--------
>  drivers/of/of_pci_irq.c                        | 10 ++++-----
>  drivers/pci/host/pci-mvebu.c                   |  2 +-
>  include/linux/of_irq.h                         |  8 ++++----
>  include/linux/of_pci.h                         |  2 +-
>  20 files changed, 42 insertions(+), 42 deletions(-)

I have go through microblaze changes in this series and all are fine.

For Microblaze changes. I expect you have already compiled that
without any warning.

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--TeA2akp6vUVGlkdGjG8dnBiGuaMDK0qCw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlJebsYACgkQykllyylKDCFyzQCfYMjBr1uy21nbUu/5TL1G17xC
h2sAniofl4LffSDZer054pDmDP/NuN2+
=wVoe
-----END PGP SIGNATURE-----

--TeA2akp6vUVGlkdGjG8dnBiGuaMDK0qCw--
