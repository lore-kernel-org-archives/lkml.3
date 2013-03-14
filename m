Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab3CNLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:25:27 -0400
Received: from multi.imgtec.com ([194.200.65.239]:62368 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667Ab3CNLZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:25:25 -0400
Message-ID: <5141B37A.7010101@imgtec.com>
Date: Thu, 14 Mar 2013 11:24:42 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Al Viro <viro@ZenIV.linux.org.uk>
CC: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "Rusty Russell" <rusty@rustcorp.com.au>
Subject: Re: linux-next: manual merge of the signal tree with the modules
 tree
References: <20130314172737.2856af8a9b368bc395d977be@canb.auug.org.au>
In-Reply-To: <20130314172737.2856af8a9b368bc395d977be@canb.auug.org.au>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig1B8DCD45A440EF27316E34AF"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_03_14_11_25_22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig1B8DCD45A440EF27316E34AF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 14/03/13 06:27, Stephen Rothwell wrote:
> Hi Al,
>=20
> Today's linux-next merge of the signal tree got a conflict in
> include/asm-generic/unistd.h between commit 837718bfd28b
> ("CONFIG_SYMBOL_PREFIX: cleanup") from the modules tree and commit
> e1b5bb6d1236 ("consolidate cond_syscall and SYSCALL_ALIAS declarations"=
)
> from the signal tree.
>=20
> The latter moved the cond_syscall stuff to linkage.h, so I applied the
> following patch as a merge fixup and can carry the fix as necessary (no=

> action is required).  I am not sure if this is completely correct or al=
l
> that is needed.

FYI, I've tested that symbol prefix stuff works on linux-next for metag
(after fixes applied from Rusty's latest symbol prefix patch).

Al: your signal tree still breaks symbol prefixed arches due to stuff
like this in kernel/sys_ni.i:

asm(".weak\t" "CONFIG_SYMBOL_PREFIXsys_quotactl" "\n\t.set\t"
"CONFIG_SYMBOL_PREFIXsys_quotactl" ","
"CONFIG_SYMBOL_PREFIXsys_ni_syscall");;

Cheers
James


--------------enig1B8DCD45A440EF27316E34AF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJRQbOiAAoJEKHZs+irPybfWx0P/2QbSROswKeQgydyuh5zwkvz
vKIya6zhlziVBt0O/1wJXgXCKgOZrOpJ3Zy1gCCAPnT+orubCo2R7iTl2jcx/8NL
6squF34r2DOHiBzyTxdth3vlAhpT65Bzwv4Bj3256mKSw3Y44Ttjb/3gVkiJ+dsy
pvdnqQHWSWOmw9wEuzI06VYBADOgFaCF4cjr3iEpgUVDS4r4f0ux76Ub1ZDBrr5u
WQ+kN/XySw/jFfrZmgsstMwidOB2XSvFbGFWAtoTCosP3bYgyCa5GQlm4I8WISwp
BIo8XniZDyD1xmiAUsNKsmLJqKQRySqbql2/K2we8dAaXBxWApI07+GS7jA5GtwQ
QNRsNl/qLwTto+Ljnyl13qQY4Ot4fle7uTl0BlqCG6nnpOn0RYN1u8OEQNBm/k0t
uFgFtsuKI0Ol5faVTtyfXyHbVfN2QzX4XH35PYfX+1izccnkqgNtaNYNEEEZZsEG
01XZPtfYwRVdAmqcOJNzdbq3WgvT3azIOpcS51tzgiH6V/Du5F/yZw2x6GiJ6PMN
3y9ZkWLyLeJBQ0UCLNvfAOCRa6kMymQKi8vIjx9GTlcNJWBakYcii42bi8YZWsY/
T1B/cIRY0pfFFqM3xCyRhSOJmjIwZp1piJERau35w0z0Ft3ejwx1EIKV7LS6yFZ4
kbxP5qm4K3tFVlm6sHXk
=Z7U9
-----END PGP SIGNATURE-----

--------------enig1B8DCD45A440EF27316E34AF--

