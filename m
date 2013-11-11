Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab3KKL1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:27:04 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:43177 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab3KKL0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:26:47 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] crypto: make sure *blkcipher_walk_init properly initialises walk
In-Reply-To: <20131111012809.GA5091@gondor.apana.org.au>
Organization: http://mina86.com/
References: <1384108681-23519-1-git-send-email-mpn@google.com> <20131111012809.GA5091@gondor.apana.org.au>
User-Agent: Notmuch/0.15.2+55~geb6e9d8 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:131111:herbert@gondor.apana.org.au::II2N+oTL1ma7yBvv:0000000000000000000000000000000000087Z
X-Hashcash: 1:20:131111:linux-kernel@vger.kernel.org::dYioa5v/KsCi2XfJ:0000000000000000000000000000000002UD5
X-Hashcash: 1:20:131111:linux-crypto@vger.kernel.org::G+jRb4EccmXApxmD:0000000000000000000000000000000005qIW
X-Hashcash: 1:20:131111:davem@davemloft.net::y3/JF4tlNfdTSzBz:0000000000000000000000000000000000000000003hz6
Date: Mon, 11 Nov 2013 12:26:38 +0100
Message-ID: <xa1t61rzyya9.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11 2013, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Nack.  The field flags is used as a bit-field and all bits other
> than those initialised that you see are used internally by the
> walker function and will be initialised on demand.
>
> Please do not just rely on tools such as coverity and actually
> read the code when submitting patches.

I have read the code which is why I concluded that it is safe to replace
the bit operations with a simple assignment.  Since, as you described,
all other bit fields are initialised on demand anyway, there is no harm
in setting them to zero here.  Especially since I see no advantages of
the current approach, but instead see two disadvantages: longer machine
code (load-modiy-store vs. store) and confusion of tools such as
Coverity.

But of course, if you want it as it is, I won't be bothering you.

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

iQIcBAEBAgAGBQJSgL7uAAoJECBgQBJQdR/0nxYP/2mR7DEkC9yE4zKXb5CK5eCH
hfwoCzCInvcBP0M6fM0aNRyDMpoOKF8lAoOUb/5CYyoPrdxFzh5R2xx4kPsK76cn
rO9zmhez4uQsuqT6tlolk/l51koVa/uQq4VPjZaZKigd+1G+2mwyzVjs8Zh+biGO
2O5xzXF6U3aV26JGdtfpY/DEZENxr505VfI2UGXUUFjWEg8TrWFcJN80/1HXTkOC
irP+6b8oG4HsnRhWHMEUmVrJzq1ZOiytiMMjglCOmz3Y9xYnHHXs2LxE1FJpB5TC
JTrw5mCcbMI0GC77/KOoJsT6w/gOgdKTUh5uJfg/W3Y8s0oZSFIjd2idnqkIzXAt
ZlCrKbPsqS5h2iWucMTc7iiSiKC0yjO1M44uXIna+qF2uD5QDZwvJlJ8hxQrgOKu
+auA6kOQMkx7yJX243on6qjnxjGMfOesjTVqndvdPlnhWUBrkOdaStzzdPj2nZjG
36ttn1x4UwqYh3BuJpU5NW29vV8xtxfpldwE65327o0n4WpmhrUt4D4ZB8nQGaOb
eH7a9ibraG8ddl8ZLC141wEhpsHa03fs1FEv5GLnY8rO4A8+djzfGN+1oiIUy7PP
UdicxpThacxSBU6R0yyHPvcYXeks8jFYp3t/FCVkRyLL1ezXL4AzME7Hcb6U0NQB
B2i9G0t47QTh8JOLKTmo
=jUH5
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
