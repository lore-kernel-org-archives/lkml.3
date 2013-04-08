Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965292Ab3DHOva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 10:51:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45362 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965268Ab3DHOv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 10:51:29 -0400
Message-ID: <5162D961.7030206@canonical.com>
Date: Mon, 08 Apr 2013 16:51:13 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
References: <515E92CE.2000509@canonical.com> <20130405142104.GB29290@pd.tnic> <20130406145804.GJ3423@redhat.com> <20130406154751.GB3612@pd.tnic> <20130408115344.GA7513@gmail.com> <20130408115959.GB4395@pd.tnic> <5162B7FF.7010603@canonical.com> <20130408125129.GC4395@pd.tnic> <5162C1A8.4060904@canonical.com> <20130408141557.GD4395@pd.tnic>
In-Reply-To: <20130408141557.GD4395@pd.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigF0342B0B7D882F216B8ED3C8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF0342B0B7D882F216B8ED3C8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08.04.2013 16:15, Borislav Petkov wrote:
> On Mon, Apr 08, 2013 at 03:10:00PM +0200, Stefan Bader wrote:
>>          * that we limited the number of possible pages already to
>>          * the number of pages in the large page.
>>          */
>>         if (address =3D=3D (address & pmask) && cpa->numpages =3D=3D (=
psize >>
>> PAGE_SHIFT)) {
>>                 /*
>>                  * The address is aligned and the number of pages
>>                  * covers the full page.
>>                  */
>>                 new_pte =3D pfn_pte(pte_pfn(old_pte), new_prot);
>>                                                      ^
>>
>> This one. The first patch changed
>>
>> -               new_pte =3D pfn_pte(pte_pfn(old_pte), canon_pgprot(new=
_prot));
>> +               new_pte =3D pfn_pte(pte_pfn(old_pte), new_prot);
>>
>> The fixup patch drops new_prot completely from being initialized and o=
nly works
>> on req_prot. Probably it would be best to also drop the definition of =
new_prot.
>> I think it then completely unused.
>=20
> Actually, we do need and initialize new_prot at line 495:
>=20
> 	pfn =3D pte_pfn(old_pte) + ((address & (psize - 1)) >> PAGE_SHIFT);
> 	cpa->pfn =3D pfn;
>=20
> 	new_prot =3D static_protections(req_prot, address, pfn);		<---

You are right. Seems I missed that and a couble of other places. I can se=
e them
now... Hm, Monday morning or just morning issue... So, yes, its new_prot =
is
initialized and is still needed, otherwise  the loop over the whole range=
 would
be subtly different.
Sorry for the noise.

-Stefan

>=20
> and we need it for the subsequent loop where we go over the 512 PTEs to=

> decide whether to split or not.
>=20
> So it is needed after all, AFAICT.
>=20



--------------enigF0342B0B7D882F216B8ED3C8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRYtlhAAoJEOhnXe7L7s6jzQ4QAJgGJvbmcpVl23lb0dxafC1E
Fuz32m8pZNTcrx77rSbOwba2avFx/9IO9KeBCg/B3JwXZ71+I5HQP/BlBBeuGZ9/
WZVuAuXOxWI9ATlvZVvnSw+TPKJxfPVqNb8cZcRR3E5+kpSbs64xZTx+deQOWF7h
CRbqIIdjpEueDPv0OR+3CfNuvFDlP3JrZpBl04FdJ4zRJilbqwfNyqPOo+ZGU5Qr
uRAhTlnEeFjPNFKvjit2i0rGp0zAtMYL2WfnyWqzcnd56FJ3jT4db9rB+hVBzCLH
cvMnH4wQpJLLjWcux+aFPjNm2AANVWPeVAspZiCmXbenfR6SlvTdYPLHPkW7g089
91igrEwTWiks39ZtUXhRytR0bSG2x0eP0/ctuTXMghMb2nF4wchbM80VND2Cc5Ho
CP+DVHzCx1hYBG5sfEuyAFIgpcAJ+Uk+rrLYvKQyKKp2uWzJfOA01Semus2yB4qV
d0Ly0+sreEn1yU5sQrDoKSe1LtGt5zcYIUbo5ZT6A01YPfkauyi/w50OlasW4rNj
S3pU2twImc0yuADAYhNM2+RdNMTMBedWwcIRQhGZY4nv25KAtWi8zJws/dfn1bju
g0kxLCNQKSkk2scp31nvArIxwH+7lniYNPYwxk4PPzTJzj6XjNCdv8TA6+xzCMUq
TyA2no5O5PHiglx2vG7W
=9YFo
-----END PGP SIGNATURE-----

--------------enigF0342B0B7D882F216B8ED3C8--
