Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbaGOSIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 14:08:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60969 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078AbaGOSIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 14:08:17 -0400
Date: Tue, 15 Jul 2014 15:08:01 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the v4l-dvb tree
Message-ID: <20140715150801.7f8099b1@recife.lan>
In-Reply-To: <20140715155547.25959587@canb.auug.org.au>
References: <20140715132946.771def89@canb.auug.org.au>
	<53C4BF8E.4010509@roeck-us.net>
	<20140715155547.25959587@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.0 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/Sak35ldwC4.qG_Q8EpC/0h3"; protocol="application/pgp-signature"
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Sak35ldwC4.qG_Q8EpC/0h3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

Em Tue, 15 Jul 2014 15:55:47 +1000
Stephen Rothwell <sfr@canb.auug.org.au> escreveu:

> Hi Guenter,
>=20
> On Mon, 14 Jul 2014 22:43:42 -0700 Guenter Roeck <linux@roeck-us.net> wro=
te:
> >
> > On 07/14/2014 08:29 PM, Stephen Rothwell wrote:
> > >
> > > After merging the v4l-dvb tree, today's linux-next build (powerpc ppc=
64_defconfig)
> > > failed like this:
> > >
> > > arch/powerpc/kernel/smp.c:764:2: error: initialization from incompati=
ble pointer type [-Werror]
> > >    { cpu_smt_mask, powerpc_smt_flags, SD_INIT_NAME(SMT) },
> > >    ^
> > > arch/powerpc/kernel/smp.c:764:2: error: (near initialization for 'pow=
erpc_topology[0].sd_flags') [-Werror]
> > >
> > > Caused by commit 6a0b50087a89 ("Merge branch 'patchwork' into
> > > to_next").  The change to include/linux/sched.h in this merge commit
> > > does not seem to appear in either of the parents of the merge.
> > >
> > > Its also a change that (when suggested) was shown to cause more
> > > problems than it was worth and dropped.  I can't imagine how it ended
> > > up in the merge commit.
> > >

Sorry, it was merged there by mistake. I had to apply that quick hack
to be able check if everything was ok on my tree before pushing it
upstream (as I do my tests with W=3D1). Without that hack, it is almost
impossible to see anything at the compilation logs, as it generates
hundreds of warnings like:

In file included from include/linux/i2c.h:31:0,
                 from drivers/staging/media/go7007/go7007-fw.c:31:
include/linux/sched.h:875:25: warning: type qualifiers ignored on function =
return type [-Wignored-qualifiers]
 static inline const int cpu_smt_flags(void)
                         ^
include/linux/sched.h:882:25: warning: type qualifiers ignored on function =
return type [-Wignored-qualifiers]
 static inline const int cpu_core_flags(void)
                         ^
include/linux/sched.h:1002:21: warning: type qualifiers ignored on function=
 return type [-Wignored-qualifiers]
 typedef const int (*sched_domain_flags_f)(void);
                     ^

even when compiling just drivers/media and drivers/staging/media.

> >=20
> > Do you mean b6220ad66 (sched: Fix compiler warnings) ? I thought that w=
as accepted
> > a week or so ago.
>=20
> That is in the tip tree and includes the fixups to powerpc and arm.  I
> don't merge the tip tree till well after the v4l-dvb tree.  The merge
> in the v4l-dvb tree included only the change to include/linus/sched.h
> and neither parent fo that merge was based on the tip tree ...
>=20
Stephen,=20

Do you know if/when this patch will be merged upstream? It doesn't
seem to be at 2.6.16-rc5. Otherwise, I'll likely cherry-pick it on
my trees, as the lack of this fixup is making hard for me to check
if a media tree patch isn't introducing new warnings.

Thanks,
Mauro

--Sig_/Sak35ldwC4.qG_Q8EpC/0h3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxW4KAAoJEAhfPr2O5OEVVuoP/RzrjuYSI8kFNBD1Mwh9+5w/
au2X/AcKmy457ia5wGifgkGQys25/sC+pOsBNT5Jzu0lh6q6VRsDkadEnYVLt682
7yCPDS4oekgqlSPBrLAe/mqdCFt9N5ZKpjXUF2kq+egppep4IDLf/Yn/NnU+MMpP
TUXyer4UxAwuhJ9wxTAV//o58i1TTwAlWpya8VPS6V0TyYdzrhsPxpwh6sy2IKZM
KzHA3BlCAnv6/4Bvsex7wDLOnVwo8t8M7VApwaRX1UeY948goxiIVymjhY78GKkT
mKLb3XfvVOvghJDgLpTrQCx1gXPaKtMCy4c8/ewJb9hpJYYLdVG3HWxgasQyHfjn
Nqki81LJ74DrvOhuU/FmG+BCoR/bGfPNLGyX2oCklYmPyXiAbZsFdzzfB519VKEs
B5hS496e0ok9QO8AJZXFw6XYAWS8HDjeTnm64wgzLP7L/bQkScKP1PWkd0REWCQ0
6m/4Agq3XYGviSbRDxwuuTMCbNi/SZ1tV61Xn8fjOL7KDY7av6REzBb9aApPLcPa
LNl5kFDPK2qApYxgPBlgn4rsdOUOlFuVzuy9DlAY/K3w7jDuTp0cdhySPOKpcET3
r2ENJbJOKcpqvY6QD78HH46+LJhJ8x8xCNljeLOwJGlo5ZqB/cl2vwQ8DPE+3/TH
T1i8qh7XjcYnX54wdAZ+
=mNws
-----END PGP SIGNATURE-----

--Sig_/Sak35ldwC4.qG_Q8EpC/0h3--
