Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751261AbaKFDwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:52:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38860 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbaKFDwE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:52:04 -0500
Message-ID: <545AF05A.1040300@suse.de>
Date: Thu, 06 Nov 2014 04:51:54 +0100
From: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Heiko Stuebner <heiko@sntech.de>, linux-sh@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>, Olof Johansson <olof@lixom.net>,
        Punnaiah Choudary Kalluri 
	<punnaiah.choudary.kalluri@xilinx.com>,
        Andreas Olofsson <andreas@adapteva.com>
Subject: Re: [PATCH 0/7] Pinctrl support for Zynq
References: <1415041531-15520-1-git-send-email-soren.brinkmann@xilinx.com> <5459BC1C.3000807@suse.de> <44de30f0237545c6b62871d6c0480a67@BY2FFO11FD050.protection.gbl>
In-Reply-To: <44de30f0237545c6b62871d6c0480a67@BY2FFO11FD050.protection.gbl>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="tXPsp2GTfp1VGKUQqMsDQgikFSr1x740V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tXPsp2GTfp1VGKUQqMsDQgikFSr1x740V
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Am 05.11.2014 um 18:03 schrieb S=C3=B6ren Brinkmann:
> On Wed, 2014-11-05 at 06:56AM +0100, Andreas F=C3=A4rber wrote:
>> I've tracked down all 54 MIO pins of the Parallella and cooked up the
>> equivalent DT patch. [...] For testing purposes I've configured a
>> heartbeat trigger for the USER_LED (CR10).
>>
>> To my disappointment these pinctrl additions did not fix one issue:
>> Whenever a write access to be handled by the bitstream (0x808f0f04) is=

>> performed, the board hangs and the heartbeat stops. Would a bug in the=

>> bitstream allow this to happen, or are more drivers missing to actuall=
y
>> make use of the PL in general? With a downstream ADI/Xilinx 3.12 kerne=
l
>> that problem does not surface.
>=20
> This doesn't sound like being related to pinctrl at all.
> Devices in the PL are just memory mapped on the AXI bus. There is
> nothing needed to access those. Hangs do in most cases indicate that th=
e
> IP does not respond (properly). In my experience this is mostly caused
> by=20
>  - level shifters not enabled
>  - IP kept in reset
>  - IP is clock gated
> With the clock gating being the culprit in most cases. Did you check
> those things?

Figured it out: zynq-7000.dtsi sets fclk-enable =3D <0>, i.e., all PL
clocks are disabled by default. When overriding that tiny property with
0xf it suddenly works as expected! I'll send a patch later in the day.

Are boards expected to use clocks =3D <&clkc 15>, ...; on individual node=
s
relying on the PL? Or does enabling those clocks require actually
loading a bitstream so that it is not being done by default?

It seems ranger dangerous to me that a single MMIO write can freeze the
system - as a software developer I would've expected this to be caught
and handled as a SIGBUS.

Regards,
Andreas

--=20
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=C3=B6rffer; HRB 21284 AG N=C3=BC=
rnberg


--tXPsp2GTfp1VGKUQqMsDQgikFSr1x740V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJUWvBdAAoJEPou0S0+fgE/HWIQAI9ySqe3HSMJnPw+NEe0JJXm
IGU8xqkIB2+/gGM5GBc/mtJ6uz8HuHmG+myG28n6+xMMPID3U/ZG1CAMpvqe2IOb
qSuUqGW/arsUXP1ZhJRfQDwyyPYCwPlMPIvaBt373WmFgo6ITSxezjhNUuoTz8rp
C+jbYle1ZltRvWzYRz9W42mEzisXlaiJaG3eYQUYmd0zRX1UazaqrUT7E5jgsfrU
KCmahkSDezxnKz91iDjXie1oOd3t2Hd7PndrLd9WvcuR+wX/H0D1SobKLYyWmbFD
xrg+Jv0yWknYkDnL6thhV5SLR8Lb7uxWj5/rQ3YeGiUcsKJvEZHRenD8/wNdMVau
9Jm3Vytpr4QbIwhgn2Ao9CL/FGEbrrg5rWUDWDMovyTpI5g+5y1joSZNWeQUNqwk
cEE6O5Kl2vsPIbvGjCZaUiN3H0ihFb4A4CgQweOEpXxfxaIialilaGhyLSKotaeK
NvP0iA9R6wA6RnTwgPm5Xfi7tX+bzuPxnw+TrPJcrv4VEy2xBlJl30v0l0XpQ4ge
7EroBHiRzpH29bwryIk0jFkaXObJ9Axm6lnV09eqaUGo8GoRA509ScwlX/Pru/U3
9br+EdMFfDfVauy0ysq9x68IDwlnLlKT7u5L6BROfaxxK+MvnqufJgGmaWwM07vE
K4XJbiLR1WNcR31+b9bJ
=olJ6
-----END PGP SIGNATURE-----

--tXPsp2GTfp1VGKUQqMsDQgikFSr1x740V--
