Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbaDWNEl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:04:41 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:65250 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaDWNEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:04:38 -0400
Message-ID: <5357BA5C.6000606@monstr.eu>
Date: Wed, 23 Apr 2014 15:04:28 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Lee Jones <lee.jones@linaro.org>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, pankaj.dubey@samsung.com,
        Samuel Ortiz <sameo@linux.intel.com>, arnd@arndb.de
Subject: Re: [PATCH v3] mfd: syscon: Support early initialization
References: <3eb785d83c406f4a57508dc03610b05492e12bfd.1396969250.git.michal.simek@xilinx.com> <20140423100530.GG21613@lee--X1> <20140423114217.GW12304@sirena.org.uk>
In-Reply-To: <20140423114217.GW12304@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="CHQxD6qFOdXagbWc5DHF0UcMF9PmaSooG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--CHQxD6qFOdXagbWc5DHF0UcMF9PmaSooG
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/23/2014 01:42 PM, Mark Brown wrote:
> On Wed, Apr 23, 2014 at 11:05:30AM +0100, Lee Jones wrote:
>=20
>>> +struct regmap *syscon_early_regmap_lookup_by_phandle(struct device_n=
ode *np,
>>> +						     const char *property)
>>> +{
>>> +	struct device_node *syscon_np;
>>> +	struct syscon *syscon;
>>> +
>>> +	syscon_np =3D of_parse_phandle(np, property, 0);
>>> +	if (!syscon_np)
>>> +		return ERR_PTR(-ENODEV);
>>> +
>>> +	syscon =3D syscon_np->data;
>>> +
>>> +	of_node_put(syscon_np);
>>> +
>>> +	return syscon->regmap;
>>> +}
>>> +EXPORT_SYMBOL_GPL(syscon_early_regmap_lookup_by_phandle);
>=20
> I don't know what this is doing but it looks dodgy, we're returning
> something stored in the DT node after dropping our reference to the DT
> node.  For FDT systems this probably makes no difference since we don't=

> actually free the node but someone might decide to do something like
> clear data that's associated with a node (however that happened) when
> the node goes unreferenced.

In early_syscon_probe np->data contains pointer to struct syscon which
stores base, regmap and res - driver private data for system controller.
(init in early_syscon_probe)
This is the way I am aware of how to share driver private data without pd=
ev.
Maybe there is better way how to do it that's why please let me know
if you are aware about it.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--CHQxD6qFOdXagbWc5DHF0UcMF9PmaSooG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlNXulwACgkQykllyylKDCEWOQCeJqCfjepzPsNNP/F3hzInkSgN
qL0An0oNKRGX6TBGhX5mEUYQteWhQ9E2
=KO32
-----END PGP SIGNATURE-----

--CHQxD6qFOdXagbWc5DHF0UcMF9PmaSooG--
