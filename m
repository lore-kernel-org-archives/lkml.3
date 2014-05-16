Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068AbaEPReD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:34:03 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:46647 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735AbaEPRdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:33:45 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Vlastimil Babka <vbabka@suse.cz>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Vlastimil Babka <vbabka@suse.cz>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH v2] mm, compaction: properly signal and act upon lock and need_sched() contention
In-Reply-To: <1400233673-11477-1-git-send-email-vbabka@suse.cz>
Organization: http://mina86.com/
References: <1399904111-23520-1-git-send-email-vbabka@suse.cz> <1400233673-11477-1-git-send-email-vbabka@suse.cz>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140516:akpm@linux-foundation.org::FfJwsGYxxrjJ26d4:0000000000000000000000000000000000000pSU
X-Hashcash: 1:20:140516:vbabka@suse.cz::YnTp8+qQIBlwaBGz:0000v6u
X-Hashcash: 1:20:140516:b.zolnierkie@samsung.com::EOYp+n25Pkhzy1i2:00000000000000000000000000000000000000HKX
X-Hashcash: 1:20:140516:cl@linux.com::hAAUNUljMPg0Wt+k:000001aIE
X-Hashcash: 1:20:140516:linux-kernel@vger.kernel.org::fWZA8JGb6aQ7o36A:0000000000000000000000000000000001OEV
X-Hashcash: 1:20:140516:hughd@google.com::66iieo0zGNJnaHhC:01sZh
X-Hashcash: 1:20:140516:riel@redhat.com::Px0QW3mGtwlhCk75:002ojT
X-Hashcash: 1:20:140516:mgorman@suse.de::NrlXFYjsklpwtERY:0039GY
X-Hashcash: 1:20:140516:rientjes@google.com::2EG0af9pZ9K5K0fA:0000000000000000000000000000000000000000002agN
X-Hashcash: 1:20:140516:minchan@kernel.org::zUEri+1oed9dbpUS:00000000000000000000000000000000000000000004c/j
X-Hashcash: 1:20:140516:linux-mm@kvack.org::bk0676C5Ee+quwy1:00000000000000000000000000000000000000000003kDM
X-Hashcash: 1:20:140516:gthelen@google.com::cfAOOc0cv8Piwr5Q:000000000000000000000000000000000000000000054BG
X-Hashcash: 1:20:140516:vbabka@suse.cz::XN+PD7cwrHgLpVXI:00068TR
X-Hashcash: 1:20:140516:iamjoonsoo.kim@lge.com::inWdm8JZcJE/gT6/:0000000000000000000000000000000000000009u30
Date: Fri, 16 May 2014 10:33:35 -0700
Message-ID: <xa1tsio9fx1s.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, May 16 2014, Vlastimil Babka wrote:
> Compaction uses compact_checklock_irqsave() function to periodically chec=
k for
> lock contention and need_resched() to either abort async compaction, or to
> free the lock, schedule and retake the lock. When aborting, cc->contended=
 is
> set to signal the contended state to the caller. Two problems have been
> identified in this mechanism.
>
> First, compaction also calls directly cond_resched() in both scanners whe=
n no
> lock is yet taken. This call either does not abort async compaction, or s=
et
> cc->contended appropriately. This patch introduces a new compact_should_a=
bort()
> function to achieve both. In isolate_freepages(), the check frequency is
> reduced to once by SWAP_CLUSTER_MAX pageblocks to match what the migration
> scanner does in the preliminary page checks. In case a pageblock is found
> suitable for calling isolate_freepages_block(), the checks within there a=
re
> done on higher frequency.
>
> Second, isolate_freepages() does not check if isolate_freepages_block()
> aborted due to contention, and advances to the next pageblock. This viola=
tes
> the principle of aborting on contention, and might result in pageblocks n=
ot
> being scanned completely, since the scanning cursor is advanced. This pat=
ch
> makes isolate_freepages_block() check the cc->contended flag and abort.
>
> In case isolate_freepages() has already isolated some pages before aborti=
ng
> due to contention, page migration will proceed, which is OK since we do n=
ot
> want to waste the work that has been done, and page migration has own che=
cks
> for contention. However, we do not want another isolation attempt by eith=
er
> of the scanners, so cc->contended flag check is added also to
> compaction_alloc() and compact_finished() to make sure compaction is abor=
ted
> right after the migration.
>
> Reported-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Cc: Michal Nazarewicz <mina86@mina86.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> Cc: Christoph Lameter <cl@linux.com>
> Cc: Rik van Riel <riel@redhat.com>
> ---
> v2: update struct compact_control comment (per Naoya Horiguchi)
>     rename to compact_should_abort() and add comments (per David Rientjes)
>     add cc->contended checks in compaction_alloc() and compact_finished()
>     (per Joonsoo Kim)
>     reduce frequency of checks in isolate_freepages()=20
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

iQIcBAEBAgAGBQJTdkvvAAoJECBgQBJQdR/0o3MP/Rj0r/oRm/6Otfqz2rlcqW2g
36HpqwRC0R2Mmmk7VN4IofX9GuhDUCjlQYUfKIVIapOhqm+N3buepLv2V6/Zv0KA
KJllXOp310O2VO9KwtSpOK7K82HLPzGi/QrCRFt1Wc+0C2PJB8cIjn+myDdcCvTl
eAR6GosGCpla72wLkuwxc6tmbMZ54Bzhrv2mE+hMdSnkmmV/gnSAFNzT1yhfDpJZ
4/0FZs4KkqHWy9BnpxOWwiAsa3/r4G0KjHGRAdp61iv/wTUeL0QG57v7kWsFBi1b
YrFstvmO4fXTvoGnCPf2GeWu1Y5qillXMptP3BK7Qjv058NDBeCP6rWUxii9Eu7F
meYXmet2fmBHcIKmdrZsYQ5dcDulKeAv1ATNvU6rQ6JW4Ov/oigMbylPTNlsZ2Nw
+vohZqm9sgpa628BwiTX1O3hv/0YG/QxWa36EezFFfIQLo09TwXYreLMy5bggpjX
AJXW1pxY1RRDA1CRsPTRTmduIikxUYAHhSsCCLPrT2xMPuz9D+5PaCHf80XjuicQ
JEA88a4BvNy7AMfUfgJriKFGpg+yY3gyGmftZAI5zwlrcwzWcAbkdfyykVJO9DRT
hQjasihW31OlVofl+QtmjwokcGaJzGc2TfetP7v/XeJQvTcb6/6Qh4oF2ZqoUzVY
e77JD7YNElAQRi2PFpzN
=FZ3h
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
