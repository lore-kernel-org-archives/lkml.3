Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754967AbaA1JtC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 04:49:02 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:57718 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751711AbaA1Js6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 04:48:58 -0500
Message-ID: <52E77D03.8090001@ti.com>
Date: Tue, 28 Jan 2014 11:48:51 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Christoph Fritz <chf.fritz@googlemail.com>
CC: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        Tero Kristo <t-kristo@ti.com>, Nishanth Menon <nm@ti.com>
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com> <1390848104.4936.62.camel@mars>	 <52E772A3.4090401@ti.com> <1390901735.2963.8.camel@lovely>
In-Reply-To: <1390901735.2963.8.camel@lovely>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="OBCdr3vqSPOtEchdiaE4KagdPIBgsT8EL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OBCdr3vqSPOtEchdiaE4KagdPIBgsT8EL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-01-28 11:35, Christoph Fritz wrote:
> On Tue, 2014-01-28 at 11:04 +0200, Tomi Valkeinen wrote:
>> On 2014-01-27 20:41, Christoph Fritz wrote:
>>> On Mon, 2014-01-27 at 19:30 +0200, Ivaylo Dimitrov wrote:
>>>> linux-next-20140124 DSS is broken on N900  - display stays black (th=
ere=20
>>>> is some noise though). I booted the kernel with qemu and it gives th=
e=20
>>>> following warning:
>>>>
>>>> [    0.623779] DSS: set fck to 172800000
>>>> [    0.624237] ------------[ cut here ]------------
>>>> [    0.624298] WARNING: CPU: 0 PID: 1 at=20
>>>> drivers/video/omap2/dss/dss.c:497 dss_set_fck_rate+0x68/0x8c()
>>>> [    0.624359] clk rate mismatch: 288000000 !=3D 172800000
>>>
>>> Here are also clock regressions since next-20140122 regarding
>>> dss_set_fck_rate() and sys_clkout2 occuring in my current patchset fo=
r a
>>> dm37xx100 board. Please see here:
>>
>> I presume you get a similar warning on your board? What rates does it
>> report?
>=20
> None, dss_set_fck_rate() just fails so omapdss_dss exits with error -22=
=2E

Ok, then it's something else. That means clk_set_rate() fails.

If you can do some tests, you could print the rate that the
dss_set_fck_rate() is given, to see that it's something reasonable, and
also do a clk_get_rate(dss.dss_clk) to see that the clock itself is ok
and there's some valid rate there.

> To quote the cover-letter[1] of my board-support patch series here:
>=20
> Due to a regression since next-20140122 the following errors are presen=
t:
>=20
>  - pin sys_clkout2, which gets configured to 24 Mhz by the fourth patch=

>    in this set, erroneously outputs only 12 Mhz.
>    Just out of curiosity, configuring it to 48 Mhz puts out desired 24 =
Mhz.
>=20
>  - omap_dss, which gets configured by the third patch in this set, fail=
s
>    to do 'dss_set_fck_rate(fck);' in
>    drivers/video/omap2/dss/dss.c:dss_setup_default_clock() which leads =
to:
>=20
>     | omapdss_dss: probe of omapdss_dss failed with error -22
>     | omapdss CORE error: Failed to initialize DSS platform driver
>     | panel-dpi panel-dpi.0: failed to find video source 'dpi.0
>=20
>   Both regressions seem to have something to do with the clock framewor=
k.=20
>   Could this be related to the DT clock conversion patches?

No idea...

 Tomi



--OBCdr3vqSPOtEchdiaE4KagdPIBgsT8EL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS530DAAoJEPo9qoy8lh71Nv0P/3xajB1XI7/usVAvpWAxib3z
XcUZBj2TY8cqP0OVmClQcZlL6uSiYVc4/MzYsQHMXKLNVxMgoFpwyJQD/p7IJmZj
/36re3chxoL5h0VevUlS3YgaydG+6qmxmOgqCD+KHqK4KKB3uDC70HJO7EFJjp4H
goojKJiFF1qK+uxTZB5KUi92XQPtViYx1VPquVdifsoMXnTljLFs1djrtACqWaN1
7N7/OE6qiYVdC5x37Ct8P/VPyFTQRJoiCdk00JVWahMctrrN43KalkHfyZOSloWw
sX1ePNQZnBnuXCM7qSJiQBU60hIP2kIX4ZBA0XNh1nMwW4LbND1Pc1w2rZQi1Fsp
sRStISTwxcVSQA37p+IXyk+A30vMD5rhvOHkUEW3vXigHTAcy25T/syI57EuEHXe
vEtockeRsQVnLH9ro2/uMcUpq4WdPT2vsj530AhvbCnoDnyfDWc6G6txwOVYXUtA
ZiWPn1FQK1JvB4cX3A+KjWbnDud84dIuyw2VfuZAF3sDa+2pmHp2+lbY9ZA0o3Sj
axToB4q17tyRjoxhbnCizK7++BCRbWn8vEUI6t7ajdfAWMuQR/8jbnn52ai4LK2m
4Pblta96JZRCCHHp2PdSvYyOBnlrkCLBTjTNaJPr/bF/ZC4ixPI9IOg8/PyEw+bz
cCnh5XwIdHO4ZGqV96ms
=E1rS
-----END PGP SIGNATURE-----

--OBCdr3vqSPOtEchdiaE4KagdPIBgsT8EL--
