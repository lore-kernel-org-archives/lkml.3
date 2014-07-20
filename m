Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675AbaGTGwU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 02:52:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45077 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525AbaGTGwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 02:52:18 -0400
Date: Sun, 20 Jul 2014 08:52:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 143e1e28 sched: Rework sched_domain topology definition
Message-ID: <20140720065207.GU9918@twins.programming.kicks-ass.net>
References: <1405838616.6512.42.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jhQDtFD6/0rlgiNE"
Content-Disposition: inline
In-Reply-To: <1405838616.6512.42.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jhQDtFD6/0rlgiNE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 20, 2014 at 08:43:36AM +0200, Mike Galbraith wrote:
> Hi,
>=20
> +/*
> + * Topology list, bottom-up.
> + */
> +static struct sched_domain_topology_level default_topology[] =3D {
> +#ifdef CONFIG_SCHED_SMT
> +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> +#endif
> +#ifdef CONFIG_SCHED_MC
> +	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
> +#endif
> +#ifdef CONFIG_SCHED_BOOK
> +	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
> +#endif
> +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> +	{ NULL, },
> +};
>=20
> Why did this commit rename the CPU domain to DIE?

Because they're both wrong, but we found that DIE was less wrong than
CPU.

Seeing how CPU typically means 1 logical, well, CPU, in the scheduler,
and not the package you stick on your board.

We chose DIE over PACKAGE due to 1) its shorter name and 2) things like
interlagos which have multiple DIEs in one PACKAGE etc..

Also, the only person who would ever care is the one who (with
SCHED_DEBUG) enabled looks at the topology setup, which is maybe all of
us 5.

--jhQDtFD6/0rlgiNE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTy2cSAAoJEHZH4aRLwOS6MhsP/A5hs/dxqWYThlIicPP4yDJ2
zTeSaVowWyiXfcYL39Hd+R5tTRoTfF3vMzn7U1d4l6CbbUVn7aZ8nu9LwBnQpEMd
qkBGFuIK+LlRB/ChHkNuvsWW8lxjxKxXob2WlxUoKh2PpzXxGLAJTK+STG/oqYkl
ZBJIA7YFcm+9d71wCgpQg++7GIwpRqvHA7DaPqs3xZOF4uMY9lbOyJczTRSaBzBA
C0R3SivwXqsaW5pXYHhuYb/h0ZfOliDq0eQhGWKYkszYH0coKpo6KCYuWzoqJhkm
T5zg0Lp/9R3aCgxe6nAm40kvc1tPB6wgyb09IXd7s/NOFz3MYnAp5Wi4eHcu4mZX
5sLj3urrGD8sYGFsD0Ww/N01RfIeBeUbFTJ2WY4F+cenozHVWISN04uaoA237a9v
bFPLNw/HUbHQv9ryfQv8HQpOY/KDrgNaF8X4pW7FpUPlTIlL1a8Su4taCwTsvFXC
MvHUHp3NjQ/FOWtxPcFS/InWxbWklsBrx7gnMRqJN0rSdPI+8vOWw9JIvW2yruIX
Shg/jw6mrZiVgwsZX2DzNdQ53ClPbf8ub9tLg1Syl351xUJHBHEXPB/bAUUaADH9
/Fuo0z3UbXCXx7g2eZOXTGI/2lvp/cz6AHoCi0oxC3mKAyf8j2FK9S6BRj8gfO67
aKpbl1oGkIzy0UhP0FuC
=JpDl
-----END PGP SIGNATURE-----

--jhQDtFD6/0rlgiNE--
