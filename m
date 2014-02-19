Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379AbaBSLo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:44:56 -0500
Received: from mail-ee0-f45.google.com ([74.125.83.45]:37061 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbaBSLoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:44:54 -0500
Message-ID: <53049932.8020901@monstr.eu>
Date: Wed, 19 Feb 2014 12:44:50 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        broonie@kernel.org
Subject: Re: [RFC PATCH v2 1/2] mfd: syscon: Support early initialization
References: <cover.1392807832.git.michal.simek@xilinx.com> <fa3178534fcf4488fc45a9a24e44b2588acb38c6.1392807832.git.michal.simek@xilinx.com> <20140219114132.GC10504@lee--X1>
In-Reply-To: <20140219114132.GC10504@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="ODx12beRDPGPwLgvF6aqkKvlGQj97Xkxg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ODx12beRDPGPwLgvF6aqkKvlGQj97Xkxg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/19/2014 12:41 PM, Lee Jones wrote:
> FAO Arnd, Mark,
>=20
>> Some platforms need to get system controller
>> ready as soon as possible.
>> The patch provides early_syscon_initialization
>> which create early mapping for all syscon compatible
>> devices in early_syscon_probe.
>> Regmap is get via syscon_early_regmap_lookup_by_phandle()
>>
>> Regular device probes attach device to regmap
>> via regmap_attach_dev().
>>
>> For early syscon initialization is necessary to extend
>> struct syscon and provide remove function
>> which unmap all early init structures.
>>
>> Signed-off-by: Michal Simek <michal.simek@xilinx.com>
>> ---
>>
>> Changes in v2:
>> - Fix bad logic in early_syscon_probe
>> - Fix compilation failure for x86_64 reported by zero day testing syst=
em
>> - Regmap change available here
>>   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap.git tag=
s/nodev
>>
>>  drivers/mfd/syscon.c       | 128 ++++++++++++++++++++++++++++++++++++=
+++------
>>  include/linux/mfd/syscon.h |  11 ++++
>>  2 files changed, 122 insertions(+), 17 deletions(-)
>=20
> I have the same reservations as last time:
>=20
>   http://archive.arm.linux.org.uk/lurker/message/20140212.095424.96cb72=
81.html
>=20
> I believe you were waiting for Arnd and/or Mark to comment.

yes on Arnd because Mark already applied that regmap part.
But of course any input how to get this done will be helpful.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--ODx12beRDPGPwLgvF6aqkKvlGQj97Xkxg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMEmTIACgkQykllyylKDCFcFACgkhePHhW7AojTakArTjEPgt1f
gqsAoIIk9YnX64gQW39zX++VPR601y4I
=Z1VF
-----END PGP SIGNATURE-----

--ODx12beRDPGPwLgvF6aqkKvlGQj97Xkxg--
