Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756871AbaEIPq6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:46:58 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36439 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaEIPq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:46:57 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 3/3] CMA: always treat free cma pages as non-free on watermark checking
In-Reply-To: <1399509144-8898-4-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-4-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140509:linux-mm@kvack.org::47ReBGKVbf2qhLLX:000000000000000000000000000000000000000000008X+
X-Hashcash: 1:20:140509:linux-kernel@vger.kernel.org::K2IGrY22q+I5pYUa:00000000000000000000000000000000004JC
X-Hashcash: 1:20:140509:mgorman@suse.de::u0VqgUPMQIOg0VSk:000ElT
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::jMODyFp0GXXMaewK:0000000000000000000000000000000000000000L/5
X-Hashcash: 1:20:140509:akpm@linux-foundation.org::Sldmi56S23zG6Bh8:0000000000000000000000000000000000001E6R
X-Hashcash: 1:20:140509:heesub.shin@samsung.com::/UY1cjyEuguVO4vq:000000000000000000000000000000000000001kFu
X-Hashcash: 1:20:140509:m.szyprowski@samsung.com::1Y4XhlBXPXMnW1C4:00000000000000000000000000000000000002tFP
X-Hashcash: 1:20:140509:lauraa@codeaurora.org::qPgBE4aT23FxY7iB:00000000000000000000000000000000000000004Hzj
X-Hashcash: 1:20:140509:riel@redhat.com::20UieBUv2/DNE/0P:003jR7
X-Hashcash: 1:20:140509:hannes@cmpxchg.org::55kNHvp0qz7Mbwfp:00000000000000000000000000000000000000000005pAj
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::EFibjMK+v1QRpwbO:0000000000000000000000000000000000000006rHj
X-Hashcash: 1:20:140509:minchan@kernel.org::U/rdXRvAgGCoy05p:00000000000000000000000000000000000000000007rUa
Date: Fri, 09 May 2014 08:46:50 -0700
Message-ID: <xa1t1tw3x8d1.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 07 2014, Joonsoo Kim wrote:
> commit d95ea5d1('cma: fix watermark checking') introduces ALLOC_CMA flag
> for alloc flag and treats free cma pages as free pages if this flag is
> passed to watermark checking. Intention of that patch is that movable page
> allocation can be be handled from cma reserved region without starting
> kswapd. Now, previous patch changes the behaviour of allocator that
> movable allocation uses the page on cma reserved region aggressively,
> so this watermark hack isn't needed anymore. Therefore remove it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>


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

iQIcBAEBAgAGBQJTbPhqAAoJECBgQBJQdR/0W00P/2lA4due77ZgrKd3+b1G+hZW
54DbdgQdTTJZQJZGeCtCKx/v9O4nY6suKmeGQXpleMog4BGEUa/+UMVM8ZGZSwYv
DZjqTM4l/lwuK4fU0jEdSKwBmpYL9PnvtLhduY6iEuqW4zxqqZFo3Hkp5fdi++eh
XSUl2TTD/p97HqIJrRCjNsBwk67iQ06uH1Xn3BPdPFem4sXiyyuUbWwv2+kwcfJk
OICFmLXgMw4SDybGcADT7KTHp94BpDmqIOK4fu+hOGoGYzEQ0ECPZDnVgILRAbc/
mzecpMZWKYdsr/QXboAO7BU9V23x1DedJsJs87/Vq6MjB0PRUIAhUA4q52aI4Q9p
i03xO9ulah32J38Xium37xXmTj1unKd2V92q+nyJWd8tMTyAwiTwFZycU7WoeT+7
oSUzVXfqW/Lq9idLFyALyRjs7iq0ofaeW1xaQs+qeVNK/Pq6X0NtEsB8n2AEjZuh
Upy2h873IHhpT/YM4ZmxkL0VihqZOd6ofojgGXAj3Z+M9z8iQMEYeV9SwxM0URy0
d3IFE1fR0zWWZGJeWikKuv+iQk1lqIpD7fyEcqHJER2F8SBirtKFtIxbNec1tXEU
vbPOogilTy8lzdRq9dlft/iF93ogOcGAzGSrgtJshYlMdsH7yWWN0d/KCYjjuF7T
Q0ACZTmO0v/QIsNfEU4y
=BUaR
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
