Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaFDQ0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 12:26:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:47535 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170AbaFDQQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 12:16:26 -0400
Date: Wed, 4 Jun 2014 18:16:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140604161618.GQ30445@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
 <20140603114428.GY11096@twins.programming.kicks-ass.net>
 <20140604154227.GR29593@e103034-lin>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYeHKcgVFLkBoQ16"
Content-Disposition: inline
In-Reply-To: <20140604154227.GR29593@e103034-lin>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYeHKcgVFLkBoQ16
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 04:42:27PM +0100, Morten Rasmussen wrote:
> On Tue, Jun 03, 2014 at 12:44:28PM +0100, Peter Zijlstra wrote:
> > On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> > > +static struct capacity_state cap_states_cluster_a7[] =3D {
> > > +	/* Cluster only power */
> > > +	 { .cap =3D  358, .power =3D 2967, }, /*  350 MHz */
> > > +	 { .cap =3D  410, .power =3D 2792, }, /*  400 MHz */
> > > +	 { .cap =3D  512, .power =3D 2810, }, /*  500 MHz */
> > > +	 { .cap =3D  614, .power =3D 2815, }, /*  600 MHz */
> > > +	 { .cap =3D  717, .power =3D 2919, }, /*  700 MHz */
> > > +	 { .cap =3D  819, .power =3D 2847, }, /*  800 MHz */
> > > +	 { .cap =3D  922, .power =3D 3917, }, /*  900 MHz */
> > > +	 { .cap =3D 1024, .power =3D 4905, }, /* 1000 MHz */
> > > +	};
> > > +
> > > +static struct capacity_state cap_states_cluster_a15[] =3D {
> > > +	/* Cluster only power */
> > > +	 { .cap =3D  840, .power =3D  7920, }, /*  500 MHz */
> > > +	 { .cap =3D 1008, .power =3D  8165, }, /*  600 MHz */
> > > +	 { .cap =3D 1176, .power =3D  8172, }, /*  700 MHz */
> > > +	 { .cap =3D 1343, .power =3D  8195, }, /*  800 MHz */
> > > +	 { .cap =3D 1511, .power =3D  8265, }, /*  900 MHz */
> > > +	 { .cap =3D 1679, .power =3D  8446, }, /* 1000 MHz */
> > > +	 { .cap =3D 1847, .power =3D 11426, }, /* 1100 MHz */
> > > +	 { .cap =3D 2015, .power =3D 15200, }, /* 1200 MHz */
> > > +	};
> >=20
> >=20
> > So how did you obtain these numbers? Did you use numbers provided by the
> > hardware people, or did you run a particular benchmark and record the
> > power usage?
> >
> > Does that benchmark do some actual work (as opposed to a while(1) loop)
> > to keep more silicon lit up?
>=20
> Hardware people don't like sharing data, so I did my own measurements
> and calculations to get the numbers above.
>=20
> ARM TC2 has on-chip energy counters for counting energy consumed by the
> A7 and A15 clusters. They are fairly accurate.=20

Recent Intel chips have that too; they come packaged as:

  perf stat -a -e "power/energy-cores/" -- cmd

(through the perf_event_intel_rapl.c driver), It would be ideal if the
ARM equivalent was available through a similar interface.

http://lwn.net/Articles/573602/

> I used sysbench cpu
> benchmark as test workload for the above numbers. sysbench might not be
> a representative workload, but it is easy to use. I think, ideally,
> vendors would run their own mix of workloads they care about and derrive
> their numbers for their platform based on that.
>=20
> > If you have a setup for measuring these, should we try and publish that
> > too so that people can run it on their platform and provide these
> > numbers?
>=20
> The workload setup I used quite simple. I ran sysbench with taskset with
> different numbers of threads to extrapolate power consumed by each
> individual cpu and how much comes from just powering on the domain.
>=20
> Measuring the actual power is very platform specific. Developing a fully
> automated tool do it for any given platform isn't straigt forward, but
> I'm happy to share how I did it. I can add a description of the method I
> used on TC2 to the documentation so others can use it as reference.

That would be good I think, esp. if we can get similar perf based energy
measurement things sorted. And if we make the tool consume the machine
topology present in sysfs we can get a long way towards automating this
I think.



--WYeHKcgVFLkBoQ16
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTj0ZSAAoJEHZH4aRLwOS6FiAP/R6+8hfnAZS1iRQ2+HpDW1+U
Htbcwj/nAslNS6cyrVuA9f8gB5tvVR0NqUsZv8J8pUU3D23UztsJxtLkQJzAICa4
EgMMFS61HPdvYqlseHkOFdCnG4GNP6yAmXOdM6H9dEYhz/RqRNp1D0F9VMK6B5kz
GYwbwuGLMVIZPHY+8bsr6bquV28FRagoAyDl9imC1X4SXPl/TJ8gML3Bvo2vFCrb
cylR66dU35H3eeM0frjAK9MkFBiGb/CdLVCgBOmbn1vzwwEV06k8ZhlQgvGf1AbK
JYzNgzAHsqztvXciczgEbhI/HUbpRgC6/lDzVhpKyR/onnwZKgzkPtKKvZvNai48
c17dqM3ysan3ZfNqful0XLnO5cVe2CUfrlXNsXUmkQ5GhbQzWCUQUmydI5NJO2Wv
kH9GMM5IkZA6nNrv65a7og/RIar6jcDq6Rm5MG99WWmik+WOk4veaLK6O/lLHIdW
WgjVKBf6YeFMK/WFnFVCJDCttHPn+7Opyhs1fQiuphYgW3bV4meE+x8xHICEQlz1
gOqDL0Qijt4P5FSZgOdzan0Vcb2fseeDIf3XNNvDlbiky5KskflfnqfYKbXO+11r
iXANT4PPf8OPB+VGnJvk6OL5tzCCcauB4tCuZBKTY/starlegzFSSg/8n0qgirLZ
+rLJRgNKsotYNCBdsN+F
=1V5E
-----END PGP SIGNATURE-----

--WYeHKcgVFLkBoQ16--
