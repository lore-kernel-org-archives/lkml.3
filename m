Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab3DHNKW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 09:10:22 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44474 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935389Ab3DHNKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 09:10:21 -0400
Message-ID: <5162C1A8.4060904@canonical.com>
Date: Mon, 08 Apr 2013 15:10:00 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: x86/mm/pageattr: Code without effect?
References: <515E92CE.2000509@canonical.com> <20130405142104.GB29290@pd.tnic> <20130406145804.GJ3423@redhat.com> <20130406154751.GB3612@pd.tnic> <20130408115344.GA7513@gmail.com> <20130408115959.GB4395@pd.tnic> <5162B7FF.7010603@canonical.com> <20130408125129.GC4395@pd.tnic>
In-Reply-To: <20130408125129.GC4395@pd.tnic>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enigF9B52D1A763AB09475FC631C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF9B52D1A763AB09475FC631C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 08.04.2013 14:51, Borislav Petkov wrote:
> On Mon, Apr 08, 2013 at 02:28:47PM +0200, Stefan Bader wrote:
>> To enforce the PSE bit here sounds reasonably right. And also apply
>> canon_pgprot, too. GLOBAL I don't know for sure.
>=20
> Well sure, you don't want to flush those from the TLB if it is kernel
> memory since it is mapped in every process AFAICT.
>=20
>> By the way there is a usage of new_prot a bit down of
>> try_preserve_large_page which probably should be changed into
>> req_prot, too. That was enforcing the canon_pgprot before the change.
>> So that may be considered a regression to before.
>=20
> Which one?

         * that we limited the number of possible pages already to
         * the number of pages in the large page.
         */
        if (address =3D=3D (address & pmask) && cpa->numpages =3D=3D (psi=
ze >>
PAGE_SHIFT)) {
                /*
                 * The address is aligned and the number of pages
                 * covers the full page.
                 */
                new_pte =3D pfn_pte(pte_pfn(old_pte), new_prot);
                                                     ^

This one. The first patch changed

-               new_pte =3D pfn_pte(pte_pfn(old_pte), canon_pgprot(new_pr=
ot));
+               new_pte =3D pfn_pte(pte_pfn(old_pte), new_prot);

The fixup patch drops new_prot completely from being initialized and only=
 works
on req_prot. Probably it would be best to also drop the definition of new=
_prot.
I think it then completely unused.

-Stefan

>=20
> Actually, after Andrea's patch it all makes sense - we initialize
> new_prot from req_prot *after* all protections checks. new_prot are,
> IMHO, the final protection bits which we are actually going to change.
>=20



--------------enigF9B52D1A763AB09475FC631C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRYsGpAAoJEOhnXe7L7s6joRAP/AyEbpNTtIL96Pw1605eRpvW
wUitR2m/d+P+wwQ2QKwV25DEsCnaatsTp5J/soRtnZMUnBSsQA83d9kr2t8SbMnX
epQcmYICQDtV8zZ72v6k7khQVtkwbnU8XvAi97ELtHQVaHgNJmKEaQIw9gbnCn2n
JJqLithX75NhQfEPaoAyKtIzqz10JeZst0pdT+vXtmRStm3GNvEYsB3qJOUzRQrF
i2c9ii1T3XSo+0E9onNA3N3M4+/Nvfm02iKJHOiS5kUz5gb732bXSveuF1UxQ+fc
ZV3vUPeY6PQgg2alipg5+JiqPR2yazBFBEwvoRVOJNJvKI81h/GLjwWOr1NSZP3q
Ujgyp/JRVNBCSJfLwWHEfZgYVefUlw04Gq1yMzb8wAfVp+mc0TOUdqhPdBu38YGy
hqLOzBfhCGu1wcYweisDLI4LW2wnR7p09y7Ej9c8oqysZzhN3UfSoFPk/eeLUmo+
v/Rb3IqJvLjqgdQ/kVT2s2ffeERkRKklqiY7hFsSRs8g30TThfzAaXdX8RMi7qvM
/BdgrhF6XqOAFyYspbGw+vlnyhVrSfcxic/QCXEOJ2K0vW9+BoAVkDi3kLSA2fCm
h8Yej2U1pVY0JQ9a7ZjM2n6sIxcpJe/AFeXaXd+xofWB/MO1jawSl+uUurjMck5G
OnJikoliDRKTu7kvZ6Ef
=AzdW
-----END PGP SIGNATURE-----

--------------enigF9B52D1A763AB09475FC631C--
