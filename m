Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbaKSNQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 08:16:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41140 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753534AbaKSNQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 08:16:07 -0500
Message-ID: <546C97EC.10905@redhat.com>
Date: Wed, 19 Nov 2014 14:15:24 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 06/19] mm: store mapcount for compound page separate
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com> <1415198994-15252-7-git-send-email-kirill.shutemov@linux.intel.com> <546C761D.6050407@redhat.com> <20141119130050.GA29884@node.dhcp.inet.fi>
In-Reply-To: <20141119130050.GA29884@node.dhcp.inet.fi>
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="D0iXfmHUpo7RM25lPPKt2AucLa8O5rJmI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--D0iXfmHUpo7RM25lPPKt2AucLa8O5rJmI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/19/2014 02:00 PM, Kirill A. Shutemov wrote:
> On Wed, Nov 19, 2014 at 11:51:09AM +0100, Jerome Marchand wrote:
>> On 11/05/2014 03:49 PM, Kirill A. Shutemov wrote:
>>> We're going to allow mapping of individual 4k pages of THP compound a=
nd
>>> we need a cheap way to find out how many time the compound page is
>>> mapped with PMD -- compound_mapcount() does this.
>>>
>>> page_mapcount() counts both: PTE and PMD mappings of the page.
>>>
>>> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
>>> ---
>>>  include/linux/mm.h   | 17 +++++++++++++++--
>>>  include/linux/rmap.h |  4 ++--
>>>  mm/huge_memory.c     | 23 ++++++++++++++---------
>>>  mm/hugetlb.c         |  4 ++--
>>>  mm/memory.c          |  2 +-
>>>  mm/migrate.c         |  2 +-
>>>  mm/page_alloc.c      | 13 ++++++++++---
>>>  mm/rmap.c            | 50 ++++++++++++++++++++++++++++++++++++++++++=
+-------
>>>  8 files changed, 88 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 1825c468f158..aef03acff228 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -435,6 +435,19 @@ static inline struct page *compound_head(struct =
page *page)
>>>  	return page;
>>>  }
>>> =20
>>> +static inline atomic_t *compound_mapcount_ptr(struct page *page)
>>> +{
>>> +	return (atomic_t *)&page[1].mapping;
>>> +}
>>
>> IIUC your patch overloads the unused mapping field of the first tail
>> page to store the PMD mapcount. That's a non obvious trick. Why not ma=
ke
>> it more explicit by adding a new field (say compound_mapcount - and th=
e
>> appropriate comment of course) to the union to which mapping already b=
elong?
>=20
> I don't think we want to bloat struct page description: nobody outside =
of
> helpers should use it direcly. And it's exactly what we did to store
> compound page destructor and compound page order.

Yes, but hiding it might make people think this field is unused when
it's not. If it has been done that way for a while, maybe it's not as
much trouble as I think it is, but could you at least add a comment in
the helper.

>=20
>> The patch description would benefit from more explanation too.
>=20
> Agreed.
>=20



--D0iXfmHUpo7RM25lPPKt2AucLa8O5rJmI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUbJfsAAoJEHTzHJCtsuoCs2EIAK2Dy9isSBb5uUh9mv2GOBhN
cgAlRMwQf2dirDILIZMRrbGp3whn7MHQttyuVffvIzipZ5rkzluFCpnJogLuXP+H
WeCR4XLWAkBvM7mbWLDkve/Xa5RRavqTFgW4jqrpS5OFflLaqKP7YyAlB+PPEe8F
pKJqTtUZn5VRA8usXJVzv9Abhwi6B2a2ILXhc0Vpg132qlUqnUzqldpn+hxJj1YT
jQ5ah7TOHkQ0+dr2i+PQXASekKQSgtYoqlxY+dTpubKAyObdX53d/OhvF88lF9KK
cr8Y2do1oM2Ch9woKvnAbJ+HbmK39hkabwuF+SZQfVebu6WYuYUvACzaE+Hh3nw=
=NRWw
-----END PGP SIGNATURE-----

--D0iXfmHUpo7RM25lPPKt2AucLa8O5rJmI--
