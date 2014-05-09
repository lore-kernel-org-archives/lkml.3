Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852AbaEIPpm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:45:42 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54497 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaEIPpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:45:40 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] CMA: aggressively allocate the pages on cma reserved memory when not used
In-Reply-To: <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1399509144-8898-1-git-send-email-iamjoonsoo.kim@lge.com> <1399509144-8898-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140509:m.szyprowski@samsung.com::jjklja5rOYzhLe7F:00000000000000000000000000000000000000akA
X-Hashcash: 1:20:140509:hannes@cmpxchg.org::sAN8SCTs+YspnYzz:00000000000000000000000000000000000000000001JlD
X-Hashcash: 1:20:140509:linux-kernel@vger.kernel.org::FH9rDb1i4aLnWAcD:0000000000000000000000000000000000rAy
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::QWg29gn20YSyv7lG:0000000000000000000000000000000000000002KnL
X-Hashcash: 1:20:140509:minchan@kernel.org::fKury2Afn+M7+a9n:00000000000000000000000000000000000000000005mDz
X-Hashcash: 1:20:140509:riel@redhat.com::YOdTrduOZTQbvAwK:004Kt6
X-Hashcash: 1:20:140509:akpm@linux-foundation.org::nOjqAUKWDiYQdkwu:0000000000000000000000000000000000005CLZ
X-Hashcash: 1:20:140509:lauraa@codeaurora.org::scImUw64u2TsiWeM:00000000000000000000000000000000000000007tsf
X-Hashcash: 1:20:140509:heesub.shin@samsung.com::sJ3jcBC5fDjbeXvg:00000000000000000000000000000000000000AyrZ
X-Hashcash: 1:20:140509:linux-mm@kvack.org::MDI4DM/vrTPdQ53N:0000000000000000000000000000000000000000000DD99
X-Hashcash: 1:20:140509:mgorman@suse.de::hZbAJekaHk+bQ7CR:00C+MR
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::4mtXAhVviBoVERHh:000000000000000000000000000000000000000FPDj
Date: Fri, 09 May 2014 08:45:32 -0700
Message-ID: <xa1t4n0zx8f7.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 07 2014, Joonsoo Kim wrote:
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

The code looks good to me, but I don't feel competent on whether the
approach is beneficial or not.  Still:

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

iQIbBAEBAgAGBQJTbPgcAAoJECBgQBJQdR/0V5EP9iwYwqxiwv9ZPYqFtCjjAsHH
tJomWa/nlEKJ+eVoTwFT2FjpORmux2MHNDCWL+ncpV4Gh3SODbstkiRhJNksiOsz
CKrc/amtefoiCkZOLf478Mn845t4a9TitUN3fAPqG4/iPulf1alelymFqaSiTU+I
wV5JaQK5KWUnUADR/5UzMCEG1pgyu9SbIHYM2pKljbtFDNrrcE+h10UFepUgiNda
onZvB002cdV4KR3ZA1Dw7UcMarL/gSL1GbWiqHuQz0Za2yoPZNtWJtuBoYBfNjfq
Nlq0aIrKmx0viXfC4XkdRIJ0lJkEaWz560exmeEXWrO3egd3TtbYjPdZ5nheDUBZ
21ZkTTSYggR33oIasTGiAGFrJNDdX2TebAvulC1vIYZ+7wP53iwHNBQqU6UkpPw+
0PrLQa1a7THDpoalRkfBCC+HBHBwJvsSGHYlgSvUA/b0EdzuI9CN29Ht+lC/kDqg
vCJiO0yykygOaj/JATdP/kNnmF7KhRAJhUc2HQgrGCQ6wpyQ5Tlk8vtL9OUdaH7G
W8VnqdRTU39S3j/1YXpJCjOxNr7m5mC6hl9pSkBaWzQ0x/bBi21jWiHdOPNWQnxK
Qb+DpilW5ZoSmULo5dwyXIbjVxdoUKJuF9JotBoSP6tDppvXv2LD0a7PoN4oYN6l
FEtcIJ2A1XPixQOfVFk=
=4Tff
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
