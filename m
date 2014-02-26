Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaBZXAf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:00:35 -0500
Received: from ozlabs.org ([203.10.76.45]:46991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445AbaBZXAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:00:34 -0500
Date: Thu, 27 Feb 2014 10:00:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (akpm-current tree related)
Message-Id: <20140227100026.1cc909f2722b16b6d11a7b91@canb.auug.org.au>
In-Reply-To: <20140226100234.GA23064@thin>
References: <20140226191627.9adf3c8e1548e2016c16557c@canb.auug.org.au>
	<20140226100234.GA23064@thin>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Feb_2014_10_00_26_+1100_q83SYf+8Ri_LR0g0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Feb_2014_10_00_26_+1100_q83SYf+8Ri_LR0g0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Wed, 26 Feb 2014 02:02:34 -0800 Josh Triplett <josh@joshtriplett.org> wr=
ote:
>
> On Wed, Feb 26, 2014 at 07:16:27PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the final tree, today's linux-next build (powerpc64
> > allnoconfig) failed like this:
> >=20
> > arch/powerpc/kernel/built-in.o: In function `.machine_check_queue_event=
':
> > (.text+0x11260): undefined reference to `.irq_work_queue'
> >=20
> > Caused (or exposed) (along with a lot of warnings) by commit 3dd6115cd6=
0b
> > ("kconfig: make allnoconfig disable options behind EMBEDDED and EXPERT")
> > from the apm-current tree.
>=20
> Pre-existing, just now triggerable with just "make allnoconfig" rather
> than manually turning off other options (like PRINTK) that select
> IRQ_WORK.  (One of the goals of that commit: get those options more
> widely used and build-tested.)
>=20
> The following (untested) patch *should* fix this:
> ----- 8< -----
> From 36a5b6c87292b6c5eeb390ed6dc6acbb8f0a3767 Mon Sep 17 00:00:00 2001
> From: Josh Triplett <josh@joshtriplett.org>
> Date: Wed, 26 Feb 2014 01:58:02 -0800
> Subject: [PATCH] ppc: Make PPC_BOOK3S_64 select IRQ_WORK

OK, I added this as a merge fix patch for Andrew's tree today.  Please
check the build results overnight tonight (for next-20140227 at
http://kisskb.ellerman.id.au/linux-next) and submit any more fixes for
the allnoconfig build errors.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Feb_2014_10_00_26_+1100_q83SYf+8Ri_LR0g0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDnIOAAoJEMDTa8Ir7ZwVxLkP+QH7upg3ImmQTCAUN/7RJd1E
JEzGZEdyiXZ9zNG3QpxMOGbWxv4TzbRAwzjB9awUjUtax9/Z4u19qfYPTyICnxp9
9GPEoujpHiu3yX3ZG41Ivc9yGfgaCfTSUaWkFrnX870zFXNEghaZ46Lsh+Ibn0Q/
VukeQk2je1FymnTeTOvTHSNVcs4JFJw5e3Fg7IyCTrk/7xPjoOc+2tDKhuiPaZj/
/C7x+Eg8OPL9JXeS2xmEKQlQPpHvQawuCzfKx95vcQ+nKcPoQrQw+6YwpzsW79AS
bXzM3dAJuAgb0RvjbPj0JdmDs0YwOOQT1rUsxKDka7kj7ygIHksr4O7wVTNhG91C
pGdZ8je0bDNs1ifuFEclJzevlINu7GQnfE4SLnjuJqfngM+O+u9P/ay90UTMGQjv
l20JVf0LyZKLYPAcdqggnhc0s3ciL/IYyAIHPHypFe2CqwkFHEiSzilVAORUeaOx
58/7zuN84PV/tQHuCVo9qvPflZ6Qn6LU7lfI9+2xoQ/N8tPw+aMNppeBtuQYfBcM
1IWsKEUGrj4hw08uuI34n9BhR0XYwJEmyPKjDm0h6JRJ0dzDQAjwg5yiaWVMZmrD
DpH0tl+KDrFEF1ibEtnNvu+zPF2uhlEAyYAO5Codn7ZRoPpvcg4iNLoJfAR6NQBZ
DX3TkxSmCckDkyE5aRlF
=mk8+
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Feb_2014_10_00_26_+1100_q83SYf+8Ri_LR0g0--
