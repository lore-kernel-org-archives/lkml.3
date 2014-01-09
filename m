Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaAIJGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 04:06:49 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54330 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754147AbaAIJGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 04:06:43 -0500
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
Subject: Re: [PATCH 0/7] improve robustness on handling migratetype
In-Reply-To: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1389251087-10224-1-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140109:kirill.shutemov@linux.intel.com::Yf0jqtrZHZFT1n4a:00000000000000000000000000000002bk
X-Hashcash: 1:20:140109:js1304@gmail.com::uV8zNzeFABzcIKe3:00RaG
X-Hashcash: 1:20:140109:minchan@kernel.org::7n8qCTBv0U/6i5M6:00000000000000000000000000000000000000000000jcz
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::N200yJdbCWAqF8Zn:0000000000000000000000000000000000000000+Zs
X-Hashcash: 1:20:140109:linux-kernel@vger.kernel.org::6bXCcJrF8iuvNcLp:0000000000000000000000000000000000pRH
X-Hashcash: 1:20:140109:riel@redhat.com::C6oMFZc8KEcUjtMN:001RHr
X-Hashcash: 1:20:140109:ak@linux.intel.com::vrzKyUV8oWrth56x:00000000000000000000000000000000000000000001hnH
X-Hashcash: 1:20:140109:jiang.liu@huawei.com::y1sjOQxNpZKoMh8j:000000000000000000000000000000000000000003ETz
X-Hashcash: 1:20:140109:linux-mm@kvack.org::m9NjOMu+9ogv7l9e:00000000000000000000000000000000000000000003Txy
X-Hashcash: 1:20:140109:mhocko@suse.cz::hiJRjHQ2aRv/SCBF:0003iyz
X-Hashcash: 1:20:140109:iamjoonsoo.kim@lge.com::q1KdE2JLIBAhe727:0000000000000000000000000000000000000004avY
X-Hashcash: 1:20:140109:cody@linux.vnet.ibm.com::Kp1tAOA1vFDYnx3W:000000000000000000000000000000000000004GeS
X-Hashcash: 1:20:140109:yongjun_wei@trendmicro.com.cn::FbYTV0/fLTN3S+WA:000000000000000000000000000000005WdQ
X-Hashcash: 1:20:140109:tangchen@cn.fujitsu.com::ULP8mvgqE8TNgna6:000000000000000000000000000000000000005CLq
X-Hashcash: 1:20:140109:akpm@linux-foundation.org::f9QDGTvm7ljz+NPN:0000000000000000000000000000000000007jsx
X-Hashcash: 1:20:140109:mgorman@suse.de::VSLNBq+wAk9KrFtn:00C1l8
X-Hashcash: 1:20:140109:hannes@cmpxchg.org::5XJiw3Z8lU2d6c4d:0000000000000000000000000000000000000000000EO6z
Date: Thu, 09 Jan 2014 10:06:34 +0100
Message-ID: <xa1tha9dbk2t.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 09 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> Third, there is the problem on buddy allocator. It doesn't consider
> migratetype when merging buddy, so pages from cma or isolate region can
> be moved to other migratetype freelist. It makes CMA failed over and over.
> To prevent it, the buddy allocator should consider migratetype if
> CMA/ISOLATE is enabled.

There should never be situation where a CMA page shares a pageblock (or
a max-order page) with a non-CMA page though, so this should never be an
issue.

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

iQIcBAEBAgAGBQJSzmaaAAoJECBgQBJQdR/03rwP/A70MFWvk9Zz81DwMlNFZQTi
jkeQWXQbKlz0Q6W3FPaTZK7nTqIcRQCwfttIGrnvWJOjw9IfLyWNSdzHaI8eQZsB
2Wyw0jUhhv4ARwOSEopst5Z+oeAmeJKHz4meJObdaH+3szfxNZm5wyl0RaNLqDGd
8MsfmnmLbgTNE/l/Fl2lNzGod36T51DMfzgTqVnBO3zK7WU8iAO3jP3y99aoijbZ
TbV3IH12T6heh/bYN9ky/FIxZ9LGI59pr0AvrvHzPEHD3ubE6La/40XCbosjsKif
MGw+2KmgL4/old+Xdtl6fm1hRAvnjpYk6rBVEzBlSZNcbHu5avfYJjcAfgV9sfMS
i9E02AuI3muTPvglCtAUtciBMdDcqbR8DLyJO8SYNqPqSZz4LtVz0pBqkpQyq7Uw
onUiuzlLSYvD7U1v8KfmRmhMkeIvBRGma2ifOoUOMCLIkhbBE0EIFztis/0BcjTf
CyWHDAMDI2ThkyM+aOgygrS0bnnDCHQDHWv3XvColu+Of6gRQL5gU/KyKI0Mau5T
Zh8DQKlX0u0BZ9Kt7HZ44SNrwEDzpf7Ov/KBgZF/Meg/fDnL06KJOMWjWG6jjTLp
1H6mQiqChwyVJ7qS2RoTWtG78sqI/xgBFVGFzogTehypy0UoRB6C64QjfHkg8SIW
SKevhN+2RDwN3u2FDdC5
=9KuD
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
