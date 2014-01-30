Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbaA3GEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 01:04:32 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:41203 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaA3GEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 01:04:30 -0500
Message-ID: <52E9EB67.3010409@ti.com>
Date: Thu, 30 Jan 2014 08:04:23 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <pali.rohar@gmail.com>, <pavel@ucw.cz>,
        <chf.fritz@googlemail.com>, Tero Kristo <t-kristo@ti.com>, <nm@ti.com>
Subject: Re: [BISECTED] OMAP: DSS: clk rate mismatch
References: <52E697C0.6000202@gmail.com> <52E7614E.8010903@ti.com> <52E76EE0.2060006@ti.com> <52E7F451.7040708@gmail.com> <52E8E643.60408@ti.com> <52E94DE6.9050806@gmail.com>
In-Reply-To: <52E94DE6.9050806@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Jwswxmx8qEJ4tordlXRGcS7vSm0hUFSGM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Jwswxmx8qEJ4tordlXRGcS7vSm0hUFSGM
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2014-01-29 20:52, Ivaylo Dimitrov wrote:

>> Can you try this one:
>>
>>  From e511789f7be00beeeee0712910c60a57c51b2705 Mon Sep 17 00:00:00 200=
1
>> From: Tomi Valkeinen <tomi.valkeinen@ti.com>
>> Date: Wed, 29 Jan 2014 13:28:53 +0200
>> Subject: [PATCH] clkoutx2 fix
>>
>> ---
>>   arch/arm/mach-omap2/cclock3xxx_data.c |  7 +++++++
>>   arch/arm/mach-omap2/dpll3xxx.c        | 20 ++++++++++++++++++++
>>   2 files changed, 27 insertions(+)
>>
>=20
> Yep, that one fixes the problem. Thanks!

Ok, good. I'll probably do some studying about clk framework and clean
up the patch and post it.

Btw, the clkoutx2 fix makes the DSS clocks work for you generally, but
if you happen to hit clock rates that don't divide evenly, you may also
need the patches for clk-divider and dss I posted earlier.

> Now I only need to find why maemo is 10 times slower with linux-next
> compared to 3.13-rc7, but that is another story :).

I sure hope it's not DSS's doings =3D).

 Tomi



--Jwswxmx8qEJ4tordlXRGcS7vSm0hUFSGM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS6etnAAoJEPo9qoy8lh71gr0QAJknPjdIyY3qCeIPgm27MxW0
qLMPfgHRkH6xOUl0+qN7S6gMBTJuViWSLU8iiKdmdlgZS3z8zRNlUjOLb2mNjD0D
DmQE1yvAgQtauEGzNSQepGDsQEi4iS+yvkcg2Zh2L+WqLzgjcDcNSUgV8TYcldL5
5FBtz4MpofpfRZ2M3QQwN4NWie4csUMvVMGoohiRIvaUJ5UxvAjrv/rFb9ZglVwk
0p0xpf+xPA4DtEWzK/kzw14Ao2B5FP9+26o4OvlCN4ElSf1lXIukVl9t5w10ig/C
FeQlU315xNOwG9K9EQS1jRlrmlloMbmMEXa4arFlTTzYsZ7jZ+53PgfedBAH3ORV
SsQ94Q/jrK0bHowf1TAq5I+NUpkO4ToRutvsO99TZjtreLGH/Z7VHk14rwCrA6An
quHqFh+lTCVdALHV0H8cgoPuaDou9LDzxKTmqH2KrBJu1m+nRAGJqkGzcGakYVoS
eDz7uSZO8XhVVlzUtQ75MZGFgefqi3ZJv3ILF/z1ebPu+p/LIn43Jd/CfzyZOJzV
Vx+R6Om24eRT4upUZfR1yA2psdU55hB/ZQGo97nb5IQVa1NYOILkM8ei1/1PqATR
2tLmoiuW7PC7oV4MiuFdnB0kIxoHGCfyM/jpuRBTZIXgqp2Qb8+Z0g9wcoki6N+n
B+GeB1nu3atJwB/clT5Q
=+Q/q
-----END PGP SIGNATURE-----

--Jwswxmx8qEJ4tordlXRGcS7vSm0hUFSGM--
