Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966897Ab3HHX6c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 19:58:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33713 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966520Ab3HHX6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 19:58:30 -0400
Date: Fri, 9 Aug 2013 09:58:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Steven Rostedt <rostedt@goodmis.org>, Michal Marek <mmarek@suse.cz>,
        Kevin Hilman <khilman@linaro.org>, sedat.dilek@gmail.com,
        "Theodore Ts'o" <tytso@mit.edu>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linux kbuild ML <linux-kbuild@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-Id: <20130809095817.4fafdf8cb64428ea062a19b7@canb.auug.org.au>
In-Reply-To: <20130808215449.GD3282@free.fr>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
	<CA+icZUUt4domktYZZn0Qp3BZoSFqmKic4qSnVP4cuTKwUww_=A@mail.gmail.com>
	<20130807153840.4f2997b603397c07aca98b2d@canb.auug.org.au>
	<87zjsted0c.fsf@linaro.org>
	<20130808102228.d2034d3a4c986d2970926ab9@canb.auug.org.au>
	<20130808103614.a039da2f236154b52329b28b@canb.auug.org.au>
	<20130808191650.GB3282@free.fr>
	<20130808215449.GD3282@free.fr>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Aug_2013_09_58_17_+1000_ca.4epyt/2pxOUE."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Aug_2013_09_58_17_+1000_ca.4epyt/2pxOUE.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Yann,

On Thu, 8 Aug 2013 23:54:49 +0200 "Yann E. MORIN" <yann.morin.1998@free.fr>=
 wrote:
>
> Ok, I've had a look in the linux-next archives, and I think I got it.
> Is the following right?
>=20
>     git clean -d; git clean -dX     # To be sure tree is clean
>     touch empty
>     make KCONFIG_ALLCONFIG=3Dempty allmodconfig
>     grep MODULES .config
>     $ CONFIG_MODULES is not set

Yes, that is what I am seeing.

> If so, I think I found the reason: the modules symbol is _always_ set to
> being valid as soon as KCONFIG_ALLCONFIG is read, even if it was not
> present in that file.
>=20
> Since it is set to be valid, the following change means it is not
> affected another value later on.
>=20
> So, I wonder what the best option is:
>   1- revert the following, and find another solution,
>   2- de-specialise the modules symbol,
>   3- or further specialise the modules symbol.
>=20
> I'd be inclined to go for 1, but I have no straightforward idea so far.
> It's late here, so I'll look more thouroughly this WE.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Aug_2013_09_58_17_+1000_ca.4epyt/2pxOUE.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSBDCeAAoJEECxmPOUX5FEqEsP/jq8vB7El1WhsydZeVb/YpYX
PR/14PAEgXnRW4Fy4YDYUK49ZQKk2uFZg920EcNgvfBZ2sh2LE/7hOMIEMFrFlvk
7iyyjZxebgWRqXJHf0Eu69qTnPOI++DXd0kqtnWr0DrCM9hSlKsakqFvVsRuP7hu
AeXQKRvU2TMWIIlwXQDaB3C64ovfUysAX4nkSgu+U2lokQBT0cQFURWe14txCoLv
EKeZ8RVgrmIvU18SlzzZE5RCNq1gxCRuRCyQQVF9PH3coEvXNWpYuet4IP+Ibb/B
m5L8r0hShzKHLWsUV9oGrXTAPnr/UTtCxOLg9qJcl5+cWBzTtJCtaoyMo9+le3CS
6GoS5NM5hBOmPdMDwNHCuI5+EIkxJ9rkkYlAxFU5/SXFVJU+QCWOnRZNoL+0yPnM
VVpNNbloIS2fQJ/1bPR396pZ0/PXm8wJv1fPvCYcv+ICNdCfkB6qxFH/cvTN/TRl
glepNgeE+8qkLweBVr00DfNCUImtiUrPMG4NlCXXaCOr0LQzF96ZHrmqH55wcJEb
2//e6ppoxHcMHP9yhSbgMA/asZMeL57mH2h/0vp3eVqc84cH/oc4LeljKDagDenm
TPyAVneNzrfT373wKfwba97BGTEOQL3n20oe8Qrn2BtdhWAmVBgd9Q41AHHz5p02
lHxt9mNGGjo8irzL1poT
=qjz5
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Aug_2013_09_58_17_+1000_ca.4epyt/2pxOUE.--
