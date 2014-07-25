Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934459AbaGYQNR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:13:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:48339 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaGYQNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:13:16 -0400
Date: Fri, 25 Jul 2014 18:12:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Jean Pihet <jean.pihet@linaro.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 17/19] perf tools: Always force
 PERF_RECORD_FINISHED_ROUND event
Message-ID: <20140725161259.GF6758@twins.programming.kicks-ass.net>
References: <1405893363-21967-1-git-send-email-jolsa@kernel.org>
 <1405893363-21967-18-git-send-email-jolsa@kernel.org>
 <20140724213451.GH7831@kernel.org>
 <20140725113426.GC1214@krava.brq.redhat.com>
 <20140725141413.GK7831@kernel.org>
 <20140725154512.GA16182@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xzSe+wpn+kb4oFkG"
Content-Disposition: inline
In-Reply-To: <20140725154512.GA16182@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xzSe+wpn+kb4oFkG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 05:45:15PM +0200, Frederic Weisbecker wrote:
> On Fri, Jul 25, 2014 at 11:14:13AM -0300, Arnaldo Carvalho de Melo wrote:
> > Em Fri, Jul 25, 2014 at 01:34:26PM +0200, Jiri Olsa escreveu:
> > > On Thu, Jul 24, 2014 at 06:34:51PM -0300, Arnaldo Carvalho de Melo wr=
ote:
> > > > I think both changes are OK, but should be split in different patch=
es,
> > =20
> > > right, I'll split it
> >=20
> > Thanks!
> > =20
> > > > [root@zoo /]# perf stat -r 5 perf report --no-ordered-samples > /de=
v/null
> > > >    101,171,572,553      instructions              #    1.10  insns =
per cycle       =20
> > > >       30.249514999 seconds time elapsed                            =
              ( +-  0.48% )
> >=20
> > > > [root@zoo /]# perf stat -r 5 perf report --ordered-samples > /dev/n=
ull
> > > >    105,982,144,263      instructions              #    1.04  insns =
per cycle       =20
> > > >       32.636483981 seconds time elapsed                            =
              ( +-  0.41% )
> >=20
> > > so those 2 extra seconds is the ordering time, right? sounds ok
> >=20
> > Yeah, but I think its worth investigating if using it is a strict
> > requirement in all cases, i.e. is it possible to receive out of order
> > events when sampling on a single CPU? Or a single CPU socket with a
> > coherent time source? etc.
>=20
> It's theoretically possible to have out of order events if perf_event_out=
put()
> is interrupted between perf_prepare_sample() and perf_output_begin() and =
the irq
> generates an event too.
>=20
> So the first event saves its timestamp "t1" from perf_prepare_sample(), g=
ets interrupted
> before perf_output_begin() so it hasn't reserved room in the ring buffer =
yet. The
> irq generates an event with a timestamp t2 that can be t2 > t1 if the clo=
ck has a
> high enough resolution (tsc works there).
>=20
> The IRQ write the event in the buffer, returns to the interrupted event w=
hich
> record after the irq event.
>=20
> One possibility to solve this is to fetch perf_clock() only from perf_out=
put_sample().
> At that time the event has reserved the buffer space so any irq event is =
guaranteed
> to be written _after_ the interrupted event and thus guarantees some mono=
tonicity.

No, I think the current code is correct in that t1 actually happens
before t2. They end up in the buffer in reverse order but that's
unavoidable.

Artificially fixing that up doesn't make sense.

--xzSe+wpn+kb4oFkG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0oILAAoJEHZH4aRLwOS6CMEP/3brjErsWhUMuOePSjQnQIaK
iPEEWX3e0J4jgBQfSeSGxsxWMR0wr5IgUUNYaIGfMzdm5zkeUZ2aVz4scnBMC4fF
yCEGxJ9+sjalozPNv3kEa056SBRXjsqN5zANNDuWU/MkixJrSWda912tKLg/qYrB
QKZz5FPv82OUfKhnHXJTiLwVqKM4d5jwGbumM5TxwY73ZIzSh25aO5wvom3Llzq1
D3aQxxfnmOATDf7DQ+YDexYnlPvas3QUuB5VNcZZCr0XToVA2q19f4gZJjaFUr/M
vdvcwWXbTP96SRfeOPEmDh+YDzldsZLgLzSCGG1eTUyzoQncItlrt/R0U8CRAKO+
SdD9A9WSgbVgtoQu3PjrqiehPIeOU+DHaXN6BGXlFROD0mFzCZNRewoCWyAtArJc
/aUjdRtzfF6A/5IKItCS7Ks0aL0lT2XI9neELLbPnCi+UUe3hdWMra6iO88Pf1wT
vy/34wFMvyRpqC5qqaNIFiUvSDgVuTmelTcH9RT3HzdplquRRb6aU7SCHPpzagbK
zPomsMyeZJ5radRWFsfanvGzJA4ORe8rfxkY7pnCGBz4V09Y6/1Y7rB1aWYqZp8E
Sfd9w6WVuinIwGo/qebYFARzJDSly4mvtxy/qpKpb9cbHFuSpgbkP4FSP4RQ8ePw
IKGk9ddyDGb4ZQnmTYjs
=hPVV
-----END PGP SIGNATURE-----

--xzSe+wpn+kb4oFkG--
