Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087AbaBRRoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 12:44:20 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:55788 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbaBRRoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 12:44:17 -0500
From: Michal Nazarewicz <mina86@mina86.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Circular locking dependency - DRM/CMA/MM/hotplug/...
In-Reply-To: <53036D51.2070502@samsung.com>
Organization: http://mina86.com/
References: <20140211183543.GK26684@n2100.arm.linux.org.uk> <52FB9602.1000805@samsung.com> <20140212163317.GQ26684@n2100.arm.linux.org.uk> <53036D51.2070502@samsung.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140218:dri-devel@lists.freedesktop.org::4SJ62A6tBJA+yi8d:0000000000000000000000000000001epw
X-Hashcash: 1:20:140218:linux@arm.linux.org.uk::YM31swOwsyxp8n/x:0000000000000000000000000000000000000003SkH
X-Hashcash: 1:20:140218:linux-arm-kernel@lists.infradead.org::GXccj6RtY066jT0e:00000000000000000000000004Ctf
X-Hashcash: 1:20:140218:airlied@linux.ie::8lzezZAZvrFQhCQK:08CDR
X-Hashcash: 1:20:140218:m.szyprowski@samsung.com::fGkpeKa+ecmMNt3i:00000000000000000000000000000000000009rEM
X-Hashcash: 1:20:140218:linux-kernel@vger.kernel.org::xgUFyQxdwdLddRVB:000000000000000000000000000000000JoHt
Date: Tue, 18 Feb 2014 18:44:08 +0100
Message-ID: <xa1t8ut8wc2f.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

> On 2014-02-12 17:33, Russell King - ARM Linux wrote:
>> What if we did these changes:
>>
>> struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>>                                         unsigned int align)
>> {
>> ...
>>          mutex_lock(&cma_mutex);
>> ...
>>          for (;;) {
>>                  pageno =3D bitmap_find_next_zero_area(cma->bitmap, cma-=
>count,
>>                                                      start, count, mask);
>>                  if (pageno >=3D cma->count)
>>                          break;
>>
>>                  pfn =3D cma->base_pfn + pageno;
>> +               bitmap_set(cma->bitmap, pageno, count);
>> +               mutex_unlock(&cma_mutex);
>>                  ret =3D alloc_contig_range(pfn, pfn + count, MIGRATE_CM=
A);
>> +               mutex_lock(&cma_mutex);
>>                  if (ret =3D=3D 0) {
>> -                       bitmap_set(cma->bitmap, pageno, count);
>>                          page =3D pfn_to_page(pfn);
>>                          break;
>> -               } else if (ret !=3D -EBUSY) {
>> +		}
>> +		bitmap_clear(cma->bitmap, pageno, count);
>> +		if (ret !=3D -EBUSY) {
>>                          break;
>>                  }
>> ...
>>          mutex_unlock(&cma_mutex);
>>          pr_debug("%s(): returned %p\n", __func__, page);
>>          return page;
>> }

Like Marek said, this will fail if two concurrent calls to
alloc_contig_range are made such that they operate on the same pageblock
(which is possible as the allocated regions do not need to be pageblock
aligned).

Another mutex could be added just for this one call, but as I understand
this would not solve the problem.

>> bool dma_release_from_contiguous(struct device *dev, struct page *pages,
>>                                   int count)
>> {
>> ...
>> +       free_contig_range(pfn, count);
>>          mutex_lock(&cma_mutex);
>>          bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
>> -       free_contig_range(pfn, count);
>>          mutex_unlock(&cma_mutex);
>> ...
>> }

This *should* be fine.  Didn't test it.

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

iQIcBAEBAgAGBQJTA5voAAoJECBgQBJQdR/0IUoP/0QrRz+dF5SPqjnUVIuo0bl9
97+SmjYHz2E86VgUKB3fXwD+Aj8nNqVLoyjX1BSPgteqhK0ivk187bDtCxEvGdGa
z7K5KbNdPp5tMTti/YYbouXmRGD+w/5goyvbwoIe0FGbAoaFBrx0znYR3l2m2DpN
45yS0OdJmzQJMJhv+Nj9dIjxT08HJSlcm/x1gvfdPJxx+CKKZHuT3L93fp9mpUx3
VSz84AtIO+MHz6Oj/08c56c+1QDRVk3T2CMDzWiWA1Sry1oxebQUTTsR+kJC5tmu
+PkKMSOZtbx9tQEBVdWQ1g852lLN+yBegZHutaeYAev292XUIxJrZi4v+eghlm1a
zIJ9pC97tJ8Vuu7UVa0gmCCKGiXNxGe+FdR8oSFhngAbV0WjcWAIEDqzJ5ON0XwZ
l4hQ2NlyF+obOvq4yEJA9Gajt0uo7iUXLkK0aEWJ3AP75ANFHY3N6YrHlwbzW39y
pqp+LoIsb90aagtCkGN63OjJJwcE2wl5ldcYwNJN8DoKCFwiXGFHLPomPNNaturF
9/v5T+2+BfN6QiFamn91hL+j2U4yh3+gSf8qZuwY0cRkMO8f/xILk1imwrW9D0yr
elDX3JnENq0kCom04pkmQzaJ7s3hQv6oZnWXPLAKCk9BQtfWm4RJL/2uEd/qO+Q9
USynYOm5rOqkGt6jX8j4
=mbCW
-----END PGP SIGNATURE-----
--==-=-=--

--=-=-=--
