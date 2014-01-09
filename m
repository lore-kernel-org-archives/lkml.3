Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaAIJS0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:18:26 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49937 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaAIJSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:18:09 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Jiang Liu <jiang.liu@huawei.com>,
        Mel Gorman <mgorman@suse.de>, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Minchan Kim <minchan@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Tang Chen <tangchen@cn.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 5/7] mm/page_alloc: separate interface to set/get migratetype of freepage
In-Reply-To: <1389251087-10224-6-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com> <1389251087-10224-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140109:minchan@kernel.org::zNQcrf8K05Qy1P0L:000000000000000000000000000000000000000000001qa
X-Hashcash: 1:20:140109:mhocko@suse.cz::CYrG+xvcyE4k88CU:00006wS
X-Hashcash: 1:20:140109:hannes@cmpxchg.org::SWcygaCBjIo+XhAQ:00000000000000000000000000000000000000000000e3D
X-Hashcash: 1:20:140109:kirill.shutemov@linux.intel.com::2FOnX7z614BLMR1Y:0000000000000000000000000000000CXx
X-Hashcash: 1:20:140109:js1304@gmail.com::gERS0vSExrgsqf4B:00DY5
X-Hashcash: 1:20:140109:linux-mm@kvack.org::ekRIlCIsn6IyUaT7:00000000000000000000000000000000000000000000nPf
X-Hashcash: 1:20:140109:tangchen@cn.fujitsu.com::Ns1urbGAS805/usX:000000000000000000000000000000000000000yJK
X-Hashcash: 1:20:140109:ak@linux.intel.com::MpOgkGgbgucaDWn/:00000000000000000000000000000000000000000001v9n
X-Hashcash: 1:20:140109:jiang.liu@huawei.com::4oJNbP+nstO8FV2G:000000000000000000000000000000000000000002Po0
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::kWp4GUsKtoCORN2h:0000000000000000000000000000000000000002j1q
X-Hashcash: 1:20:140109:riel@redhat.com::TEMtLvd/A+7sY7XQ:002xiF
X-Hashcash: 1:20:140109:linux-kernel@vger.kernel.org::4Eq7FhxLT6ej0Sax:0000000000000000000000000000000003gAJ
X-Hashcash: 1:20:140109:cody@linux.vnet.ibm.com::66gvlHlPuex7QgVD:000000000000000000000000000000000000005zeE
X-Hashcash: 1:20:140109:mgorman@suse.de::ITZxtQTQ1/E5jS0N:008KkO
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::2oCy807DhFrQMFF8:0000000000000000000000000000000000000007aOB
X-Hashcash: 1:20:140109:akpm@linux-foundation.org::omxJAgkVotdf0d81:000000000000000000000000000000000000AicW
X-Hashcash: 1:20:140109:yongjun_wei@trendmicro.com.cn::Xt9JvrC7RlIzNqcZ:00000000000000000000000000000000Cwqa
Date: Thu, 09 Jan 2014 10:18:00 +0100
Message-ID: <xa1tbnzlbjjr.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09 2014, Joonsoo Kim wrote:
> Currently, we use (set/get)_freepage_migratetype in two use cases.
> One is to know the buddy list where this page will be linked and
> the other is to know the buddy list where this page is linked now.
>
> But, we should deal these two use cases differently, because information
> isn't sufficient for the second use case and properly setting this
> information needs some overhead. Whenever the page is merged or split
> in buddy, this information isn't properly re-assigned and it may not
> have enough information for the second use case.
>
> This patch just separates interface, so there is no functional change.
> Following patch will do further steps about this issue.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

I think this patch would be smaller if it was pushed earlier in the
patchset.

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

iQIcBAEBAgAGBQJSzmlIAAoJECBgQBJQdR/0aFAP+waDevUQpa9xhmLPbYlXrCpa
LO3GprL2KYWtpEnjGAkGmI1ywnsbukNNpXg/q9n1xY/fr7SYQlys9TFnPsydRFq7
R5K3M07ITUEeEl65h269aU86odK1iH246ch3fwjPOrPOz6hmZkwiHUos6dDWE4SN
Oe8/FzbhLHVXpKrSrnc9rSdArZfUbjSmPx3Np/32WCWTE9nEQxT5G1tLrRMhd2nh
QAyKS93Z4YDwFGRnniibbfC3lns7lRbSAtUUS+SBNXaqQpa8jPA7rklsuDR8YXw1
YLY88ojn7pyW8cZsNn93oe9m9O850EbTJOHzVZIgJeRU04pOWRmKF7WYQSq8ZSvo
MvuRBNXz05huYVwyUKvCUAyNmoDhobOSEFE2Go3vaYcA7dhPYMm00VzIdJI1u/w0
63zwaWfVUcqFvnnsOZMTHrJlb/U0Cvv8pBUJcSW8uPL3VNl8P5v4jKXaY7gWMEmq
g8h6Pz8Bv3S9qAnO9YDRaT20jcQjVVRnrxya/ovgwhU8l+/qbWMkCQvcMRXXgY7G
+oBXZwmRYcFGIdrMox2GbtlrQWFj9C8/VrzlqbJNvAOU76t9PJ/429JENp7hjidL
U9TngSMevAAOgbvZzIchVKLKBLXIiCb+RIf87JEYIdLT3sspRBZwgPiBAn/PYXTL
kdwG+bGk3CGEGcrT8/Tp
=19u7
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
