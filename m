Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934135Ab3BMPTy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:19:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934080Ab3BMPTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:19:53 -0500
Date: Wed, 13 Feb 2013 09:19:37 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130213091937.5a226c5d@riff.lan>
In-Reply-To: <20130213091512.GC7630@gmail.com>
References: <20130207094650.76302f47@riff.lan>
	<20130207185608.GA25223@gmail.com>
	<20130207191345.GA28960@gmail.com>
	<20130207195257.GA29985@gmail.com>
	<20130207150838.02226207@riff.lan>
	<20130208141841.GB30334@gmail.com>
	<20130208085828.02e61518@riff.lan>
	<20130211095457.GF23932@gmail.com>
	<87d2w5ovc0.fsf@sejong.aot.lge.com>
	<20130213091512.GC7630@gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//wl9TFcS4Sb5i.5AW2aAhqr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//wl9TFcS4Sb5i.5AW2aAhqr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Feb 2013 10:15:12 +0100
Ingo Molnar <mingo@kernel.org> wrote:

>=20
> * Namhyung Kim <namhyung@kernel.org> wrote:
>=20
> > Hi,
> >=20
> > On Mon, 11 Feb 2013 10:54:58 +0100, Ingo Molnar wrote:
> > > * Clark Williams <williams@redhat.com> wrote:
> > >
> > >> I figured that was coming. :)
> > >
> > > ;-)
> > >
> > >> I'll look at it again and see about pulling the=20
> > >> autogroup/cgroup stuff into it's own header. After that it's=20
> > >> probably going to require some serious changes.
> > >>=20
> > >> Any suggestions?
> > >
> > > I'd suggest doing it as finegrained as possible - potentially=20
> > > one concept at a time. I wouldn't mind a dozen small files in=20
> > > include/linux/sched/ - possibly more.
> >=20
> > What about the .c files?  AFAICS the sched/core.c and=20
> > sched/fair.c are rather huge and contain various concepts=20
> > which might be separated to their own files.  It'd be better=20
> > reorganizing them too IMHO.
>=20
> I'd be more careful about those, because there's various=20
> scheduler patch-sets floating modifying them.
>=20
> sched.h is much more static and it is the one that actually gets=20
> included in like 60% of all *other* .c files, adding a few=20
> thousand lines to every .o compilation and causing measurable=20
> compile time overhead ...
>=20
> So sched.h splitting is something we should really do, if=20
> there's people interested in and capable of pulling it off.
>=20
> Thanks,
>=20
> 	Ingo


And since I'm one of the people that care about the RT patch (which
modifies the scheduler files) I'll just start with baby steps and reorg
the headers.=20

Clark

--Sig_//wl9TFcS4Sb5i.5AW2aAhqr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEbrwkACgkQHyuj/+TTEp2/DACggvfcYduSR0X6Bt0N3Y3K/6SD
ba8AoNnm2LnjV8sk2jV9dT2lTlKH0UDy
=POpP
-----END PGP SIGNATURE-----

--Sig_//wl9TFcS4Sb5i.5AW2aAhqr--
