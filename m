Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756876AbaEIPtp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:49:45 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:40950 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEIPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:49:43 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Vlastimil Babka <vbabka@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2 2/2] mm/compaction: avoid rescanning pageblocks in isolate_freepages
In-Reply-To: <1399464550-26447-2-git-send-email-vbabka@suse.cz>
Organization: http://mina86.com/
References: <alpine.DEB.2.02.1405061922220.18635@chino.kir.corp.google.com> <1399464550-26447-1-git-send-email-vbabka@suse.cz> <1399464550-26447-2-git-send-email-vbabka@suse.cz>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140509:akpm@linux-foundation.org::ofMojIfxL2kz9aBW:0000000000000000000000000000000000001dgh
X-Hashcash: 1:20:140509:hughd@google.com::ahWS3I4mcvd8yhMK:00tIL
X-Hashcash: 1:20:140509:minchan@kernel.org::1qJlM6lytnb26/kr:000000000000000000000000000000000000000000013dk
X-Hashcash: 1:20:140509:linux-mm@kvack.org::N2aANOjQyUgPee2c:00000000000000000000000000000000000000000001kc5
X-Hashcash: 1:20:140509:vbabka@suse.cz::x8dTBOq2W4WoP++K:0001/cH
X-Hashcash: 1:20:140509:linux-kernel@vger.kernel.org::wDnBO8SzJN0y6eb2:0000000000000000000000000000000004/tG
X-Hashcash: 1:20:140509:riel@redhat.com::e1VSuvL3BNXIVAy9:003aGU
X-Hashcash: 1:20:140509:vbabka@suse.cz::kvk8K+BUaCIMvvMG:0007Myo
X-Hashcash: 1:20:140509:b.zolnierkie@samsung.com::C74/GtqnjUr+0ECA:00000000000000000000000000000000000005zma
X-Hashcash: 1:20:140509:n-horiguchi@ah.jp.nec.com::Bxy6IgyYlKbcQ/o+:0000000000000000000000000000000000006Luz
X-Hashcash: 1:20:140509:rientjes@google.com::nZ9yb4sIgPz7LI0k:0000000000000000000000000000000000000000006V/B
X-Hashcash: 1:20:140509:cl@linux.com::93BruFOF2tRPtIHF:000007gHe
X-Hashcash: 1:20:140509:iamjoonsoo.kim@lge.com::2ZXia6moRpWk8XGt:0000000000000000000000000000000000000008EbO
X-Hashcash: 1:20:140509:gthelen@google.com::XV3v0lOeJxgpEkTN:00000000000000000000000000000000000000000009FEU
X-Hashcash: 1:20:140509:mgorman@suse.de::N5p5hHV2lvCv8lvv:00Bobj
Date: Fri, 09 May 2014 08:49:35 -0700
Message-ID: <xa1ttx8zvto0.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Wed, May 07 2014, Vlastimil Babka wrote:
> The compaction free scanner in isolate_freepages() currently remembers PF=
N of
> the highest pageblock where it successfully isolates, to be used as the
> starting pageblock for the next invocation. The rationale behind this is =
that
> page migration might return free pages to the allocator when migration fa=
ils
> and we don't want to skip them if the compaction continues.
>
> Since migration now returns free pages back to compaction code where they=
 can
> be reused, this is no longer a concern. This patch changes isolate_freepa=
ges()
> so that the PFN for restarting is updated with each pageblock where isola=
tion
> is attempted. Using stress-highalloc from mmtests, this resulted in 10%
> reduction of the pages scanned by the free scanner.
>
> Note that the somewhat similar functionality that records highest success=
ful
> pageblock in zone->compact_cached_free_pfn, remains unchanged. This cache=
 is
> used when the whole compaction is restarted, not for multiple invocations=
 of
> the free scanner during single compaction.
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> ---
>  v2: no changes, just keep patches together
>
>  mm/compaction.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
>
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

iQIcBAEBAgAGBQJTbPkPAAoJECBgQBJQdR/0RLcP/0AAvkxxjS2riJKTHRTWd/aJ
2aiLce1bXE7jeZ9w86p5jJzdh0WygXTw4gUgv53JVo2qj6oBlb6r4uwS3tsn+CeU
oK7EpLbCHJ2KzzTjMr662xwogg/8NPsdvMY+phghebfdTFxl+SYUm5yvHi2zsJRZ
enO+Rei9gZnZLi2AQiBPi/qVnjeu2pkIm2ty99G2GWpqi4uKfWy6U595jkuPnYhr
sG0ptclWFM9JJ12DfPerbiZFddq/wmFQJaLVEBcrLO0GiHpJ2KK4inKC5jP1R5uu
KcBXFc8Lm907PElA1Mqe2NjALbVpfN4+n0/M1Ye8ZL74yzy68CZCLueHAWw+m+Ia
399uKqUzW3xdNFzJ2tcZApdpjsWg2MHr3ilFSvpejS+i4tgMJeiWszQ7ZKx6zTHd
5lZH6Jd5NC4mENrfb8o5Vs2ghOCp3t0+o6EN/x/AMAsW/uWFYtWvCxDwmAdAjRpY
CVCbf236O1DP7s9xH4kWUxPcd/bVUJGT1fhSHTxUioEi18Qnd3hma+GcBbStIw2M
tqeoC5kS50ExKhVmg3WVAI0FC/uphdugt+kBV6Q+K05zfXQyp1dTgO/yqjbsxqCK
h+TcGctFLeNPQfpUtUcgc/wVnrcUuFZArU1CyZPLPDfWFI3jNVzHY9Wq26QxZ5hE
wUwzCQZK4DWaEFuc6CA6
=d7uz
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
