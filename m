Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbaFSAGe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 20:06:34 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59166 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaFSAGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 20:06:32 -0400
Message-ID: <53A2297C.106@monstr.eu>
Date: Thu, 19 Jun 2014 02:06:20 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Tomasz Figa <tomasz.figa@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, mark.brown@linaro.org,
        Tomasz Figa <t.figa@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>, linux-kernel@vger.kernel.org,
        joshi@samsung.com, vikas.sajjan@samsung.com, chow.kim@samsung.com,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH RFC] mfd: syscon: Decouple syscon interface from syscon
 devices
References: <53A05E2D.6020702@samsung.com> <5027740.B7iVUcUX2T@wuerfel> <53A0B27E.5010708@gmail.com> <5537724.LlmJ2hxcKn@wuerfel>
In-Reply-To: <5537724.LlmJ2hxcKn@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="RrIbSI64TSdon8cUeSarWUaWltGJclnho"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--RrIbSI64TSdon8cUeSarWUaWltGJclnho
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

On 06/18/2014 02:57 PM, Arnd Bergmann wrote:
> On Tuesday 17 June 2014 23:26:22 Tomasz Figa wrote:
>> On 17.06.2014 17:42, Arnd Bergmann wrote:
>>> This seems like a reasonable way of solving the problem, but I think
>>> there is an even better one that we have about in the past: if we
>>> promote syscon from a platform driver into a a drivers/base/ helper
>>> that is independent of the platform device matching, we can use
>>> call syscon_regmap_lookup_* for any device node, whether it's already=

>>> bound to a driver or not, which do what you need. It would also make
>>> it easier to call the syscon code before the platform_device
>>> infrastructure gets initialized, which is something a number of
>>> people have asked for, e.g. for using regmap to do SMP bringup
>>> or for clock registration.
>>
>> Basically, unless I'm missing your point, this is what my patch does,
>> except that I don't move it to drivers/base/ and the registration
>> function I added require a pointer to struct device. Indeed, decouplin=
g
>> it further from the driver model, by adding of_syscon_register() shoul=
d
>> be useful for early users.
>=20
> I believe the part you are missing is that with the approach I suggeste=
d,
> there would be no registration function at all. You can easily do the
> lookup from the client drivers using the DT data structures, with no
> need for the device at all. The only exception today is the clps711x
> platform using syscon_regmap_lookup_by_pdevname(), but that should be
> solved in 3.17 when clps711x becomes DT-only.

I agree with Arnd. This patch is doing the part of what we wanted to do w=
ith it.
It means create a list of registered devices.
But you are working with struct device which you can't use in early phase=

which is the feature we wanted to use. But currently we have workaround
in the kernel and clk subsystem is not able to work with regmap anyway.

Moving to proper location is just the last step.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--RrIbSI64TSdon8cUeSarWUaWltGJclnho
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlOiKYAACgkQykllyylKDCEG1wCfbiLH4jcSjhO9Kmyvi69mjx1M
vH8An39Cz8WiE9xDIiLUkkt3IHym5SKi
=emaA
-----END PGP SIGNATURE-----

--RrIbSI64TSdon8cUeSarWUaWltGJclnho--
