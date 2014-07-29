Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaG2Imr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:42:47 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:11388 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751702AbaG2Imo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:42:44 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 29 Jul 2014 01:30:31 -0700
Date: Tue, 29 Jul 2014 10:42:38 +0200
From: Thierry Reding <treding@nvidia.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the gpio tree
Message-ID: <20140729084237.GE31360@ulmo.nvidia.com>
References: <20140729183153.0e77a6f6@canb.auug.org.au>
MIME-Version: 1.0
In-Reply-To: <20140729183153.0e77a6f6@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 10:31:53AM +0200, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>=20
> Hi Linus,
>=20
> After merging the gpio tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
>=20
> In file included from arch/arm/mach-tegra/board-paz00.c:20:0:
> include/linux/gpio/machine.h:24:2: error: unknown type name 'u16'
>   u16 chip_hwnum;
>   ^
> include/linux/gpio/machine.h:31:19: error: field 'list' has incomplete ty=
pe
>   struct list_head list;
>                    ^
>=20
> Caused by commit 0a6d315827ee ("gpio: split gpiod board registration
> into machine header") or an interaction of that with commit
> a0524acc94c9 ("ARM: tegra: Sort includes alphabetically") from the
> arm-soc tree.
>=20
> linux/gpio/machine.h needs to include some of the same files that
> linux/gpio/driver.h does.  See Rule 1 in Documentation/SubmitChecklist.
>=20
> I have used the version of the gpio tree from next-20140728 for today.

I think linux/gpio/machine.h needs at least linux/types.h (for u16,
though I guess that "dependency" could be removed by simply making
gpiod_lookup.chip_hwnum an unsigned int) and linux/list.h for struct
list_head.

Thierry

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1159AAoJEN0jrNd/PrOhHF0P+gI/MTgH6lzX29qNWk7yzafh
kfFPWcAhvywOdscbt1/DoRaMGXKFJcgtfCZkLvMeVWv+EYmzj8Bq4cWWQjJ4Za/P
c4JqFzqwHOK0LUHPD0Vr/3ySRj9iyOXuxOXEfmqbT+tT02bMQ+8njt5pKE2kShyq
gkdvKROv7B8eKXqHF/LM6bJindDuf2BgvAhr/45QbkTOQCtnLzP7HbMNxerCgiru
bkQZR5kFrFHe9toZ3byDJQ3yzSUmAs0gfXPOHHJyZlQXn0JoVKVkt8oXAvpHy8fv
lVKWn7j1htGcX+aQPPyZ2gLV2q6W16Hcuct/qr5fRcXuzCMs1G+wPsVBuukSNMAB
PT9k7qW/f9wyR+Knn4u60Lp/zqA/5qtCaVIn+vZdikM8s3rJzannzwzeoz9u81ah
yE6fRovEpKhNBBlz4DVPeumly5VQysEzIUaIG4Ul43b4vwY1o8B32UkQxCvO+6et
XcJivNJMKzmpZ4LZUaTP7CmFux4XwymnHvldNkgiF5scv/OjLnRi3/XTATM8SOWQ
hGXgo3vJV0j4VcsKTKfuybgpPwKiVEc1C5STNmHjoVPbqi1Kgs/TvajUGYwyPkSd
MBe1FV56iag/eewgj+gJfJA9up77vRgR+2vmnvDLuwRX1ZoquNjR6QXmj7vbQil1
pUDRpV4NA4GqhhnyGlAy
=qL11
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--
