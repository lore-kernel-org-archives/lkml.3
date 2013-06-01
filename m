Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab3FAFoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 01:44:55 -0400
Received: from ozlabs.org ([203.10.76.45]:50306 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462Ab3FAFot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 01:44:49 -0400
Date: Sat, 1 Jun 2013 15:30:57 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: jdl@jdl.com, mmarek@suse.cz, Stephen Warren <swarren@nvidia.com>,
        linux-kbuild@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2] dtc: ensure #line directives don't consume data from
 the next line
Message-ID: <20130601053057.GB12059@boomeroo.fritz.box>
References: <1370025184-23808-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
In-Reply-To: <1370025184-23808-1-git-send-email-swarren@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2013 at 12:33:04PM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Previously, the #line parsing regex ended with ({WS}+[0-9]+)?. The {WS}
> could match line-break characters. If the #line directive did not contain
> the optional flags field at the end, this could cause any integer data on
> the next line to be consumed as part of the #line directive parsing. This
> could cause syntax errors (i.e. #line parsing consuming the leading 0
> from a hex literal 0x1234, leaving x1234 to be parsed as cell data,
> which is a syntax error), or invalid compilation results (i.e. simply
> consuming literal 1234 as part of the #line processing, thus removing it
> from the cell data).
>=20
> Fix this by replacing {WS} with [ \t] so that it can't match line-breaks.
>=20
> Convert all instances of {WS}, even though the other instances should be
> irrelevant for any well-formed #line directive. This is done for
> consistency and ultimate safety.
>=20
> Reported-by: Ian Campbell <Ian.Campbell@citrix.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

Nice catch.

Acked-by: David Gibson <david@gibson.dropbear.id.au>

I'll pull it into my github tree.  Jon, please either apply directly
or pull from my tree.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGphxEACgkQaILKxv3ab8awPQCeL+iOBmgPbA5rnvnI6KTXMqxf
W18AnjzJ4Pm02RaFdClj+TsWM5tqAJBo
=zVV5
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
