Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab3IPGyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 02:54:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38200 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3IPGyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 02:54:03 -0400
Date: Mon, 16 Sep 2013 16:53:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: Why does test_bit() take a volatile addr?
Message-Id: <20130916165344.144f0d0f1b58111f1c8c87cc@canb.auug.org.au>
In-Reply-To: <87ioy11k8s.fsf@rustcorp.com.au>
References: <87ioy11k8s.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Sep_2013_16_53_44_+1000_wCSAuZol.1Yz3xi7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Sep_2013_16_53_44_+1000_wCSAuZol.1Yz3xi7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 16 Sep 2013 13:38:35 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Predates git, does anyone remember the rationale?
>=20
> ie:
>         int test_bit(int nr, const volatile unsigned long *addr)

Because we sometimes pass volatile pointers to it and gcc will complain
if you pass a volatile to a non volatile  (I think).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Sep_2013_16_53_44_+1000_wCSAuZol.1Yz3xi7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSNqr9AAoJEECxmPOUX5FEE/cQAIP7xSKnGXPWkL19EjLBdPTb
AOn5UxeKYDB/QNi1Qj6KSLajXY+QkbBO2TtvzsbYP/gc+EGprEdwFKtLkq0M3pDX
QLIbrWjup2pnnhDtUnu2LTcyobfOyRT4Fnah4RDMFwtNvP8q4KnqQYtdJgFYI48A
bj4Ja34SA6uhdsC1x6s1DelbrfzQvLjr+Yf/y0dlRMhJnjmcSaRQxBPxUhH6R8mr
JJQnTVZ8JuMhkxR30UzTeVshYw6RJoZNhg3NoBkYr0CMRoIA45/+Dqpj+nuCSzgG
zM17w2YGZYfY6u41Lb7pYTgUl+Ca6R7wJPINZsAL/hnlRYwrKwiD29LJLn0HT8fa
q2b36H5mygaMQnptxqPQ8KluxsPFjn37HlALnweDBnt2vDeHqAC0t4+OHCBWY2lH
2tq+lRriuiNV8qL2bYMSKH+qy0kqW/J60gV7C/j2HvTnM4R62nynyQ5h6+UOmpk1
PW3lVyFOGf3PW2g4J/Q87W/VsElFqm7dhRMCWNf+PL4vv+miR/dOUU5VxbxG/sj7
ikla8zEiKA5ZaIhBTG3r9jgZgVQcS8CT7GlJPv7pNrpe4ssL6Aj286IvNPBya1Kr
VXczbCDItpLJ8ACELsZpZUhUhodfdSiemhEhvhYACtFjvY94SQc2sr76it4LEHW9
t6QzigrNKWS7h4j0Wxqm
=TEGR
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Sep_2013_16_53_44_+1000_wCSAuZol.1Yz3xi7--
