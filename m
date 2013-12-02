Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752879Ab3LBNFu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 08:05:50 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:50311 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3LBNFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 08:05:46 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Mark Brown <broonie@kernel.org>,
        linux-spi@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: tegra: avoid unsigned->signed->unsigned promotion
In-Reply-To: <20131129214313.GA18036@mithrandir>
Organization: http://mina86.com/
References: <1385745164-10534-1-git-send-email-mpn@google.com> <20131129214313.GA18036@mithrandir>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131202:linux-spi@vger.kernel.org::8vyEYi4OsP0/4jlB:0000000000000000000000000000000000000bAv
X-Hashcash: 1:20:131202:broonie@kernel.org::XaBxm9fW6APLWlLQ:00000000000000000000000000000000000000000000J3H
X-Hashcash: 1:20:131202:ldewangan@nvidia.com::Qu5v6JhmR/aGZC2A:000000000000000000000000000000000000000000gJ9
X-Hashcash: 1:20:131202:linux-kernel@vger.kernel.org::xQ58m+sgd/wOs1Xr:0000000000000000000000000000000003+ds
X-Hashcash: 1:20:131202:thierry.reding@gmail.com::X9gT1kTu3P4isKMa:0000000000000000000000000000000000000CUtL
X-Hashcash: 1:20:131202:linux-tegra@vger.kernel.org::oLIzhe56Vtzk/pVa:0000000000000000000000000000000000BoVX
Date: Mon, 02 Dec 2013 14:05:35 +0100
Message-ID: <xa1tli038ktc.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On Fri, Nov 29, 2013 at 06:12:44PM +0100, Michal Nazarewicz wrote:
>> u8 type, which is unsigned, is promoted to int, which is singned, when
>> doing a binary shift.  Then, on 64-bit machines, it is further promoted
>> to unsigned long which may lead to more significant half of the value
>> to be all ones.  To avoid this, explicitly promote to an unsigned type.

On Fri, Nov 29 2013, Thierry Reding wrote:
> But I don't think there's a real issue here. Even on 64-bit platforms,
> writel() will only write 32-bit registers, and therefore discard the
> upper 32 bits.
>
> I think in general perhaps a more proper fix would be to use only u32
> instead of unsigned long for these cases, since then the problem goes
> away. u32 is also the type of the value used by writel() so it makes
> perfect sense to use it.

Yes, you're absolutely right.  I dunno why I missed the fact it's used
in writel only.  I'll prepare a new patch soon(ish).

--=20
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=3D./ `o
..o | Computer Science,  Micha=C5=82 =E2=80=9Cmina86=E2=80=9D Nazarewicz   =
 (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--

--=-=-=
Content-Type: multipart/signed; boundary="==-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"

--==-=-=
Content-Type: text/plain


--==-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJSnIWfAAoJECBgQBJQdR/0N3YQAIY840S8OZ7afX+q9n44AH2R
7lbWi2kQoaBcl3mTx86MxR4qNKoltcHq+syuCjGyv8SIMw0Sod7giQX6iwB+f1Kn
fgqQgTw7PYUQQBHwSn/dK1/pudJ4MprcA02MBwS2wQ5yDk9WUnF2k98OkPo4sD8n
2j3/bmLu+89FmKMNDk1QrliV1Oginv/r8004c2r1btN3gr54rjmcc5k3oP0L+i5c
GSvjniMvUIC5B6v56p5tKxst+JYblZqZ23vTOK/xTeshtiE8iTYv7msTlu5g2fIs
9mKAZFc/OYlBYMGaRVsgBjnWfCc1Q9DzGPBkvRnP87K8LC8drmCO8fQtJm0rh1KZ
D2WO9TT1aRRxTZ7SVkd61VW/jb0xxydZCDkNuat1mPP2q8oZNScWme+akwl4iyk2
NbaTmr2dTjMz2yaxStbihd1hDyyavlYOptfUINBrOFpRNqFSg44ntXKMbQmWRODy
Ct41WUBM+1AmGvrr6cgaFp93iqwIe/Dtk6sQL7br8hF0/cTuUt8miM0ddsBWGAOK
s+NHsD/Cj/9XQktTfMjFJTwblr2IP5t/5YqbjaN70V0bvpLtE5ylkrdTZOJwKw53
nc/jQynz9b/vZjHrBz1wV7nCjjW/9YuwRuXHoQp7Q2t5RoIiuvMYolinUOaSanVb
lPEyZIYSxjKq0vX3agd0
=Zblu
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
