Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660AbaEGPhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:37:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:38739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbaEGPhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:37:43 -0400
Date: Wed, 7 May 2014 17:37:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com,
        paulmck@linux.vnet.ibm.com, akpm@linux-foundation.org,
        khilman@linaro.org, tglx@linutronix.de, axboe@fb.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/nohz] nohz: Move full nohz kick to its own IPI
Message-ID: <20140507153736.GS30445@twins.programming.kicks-ass.net>
References: <tip-72aacf0259bb7d53b7a3b5b2f7bf982acaa52b61@git.kernel.org>
 <20140505123706.GP17778@laptop.programming.kicks-ass.net>
 <20140505133113.GD1429@laptop.programming.kicks-ass.net>
 <20140505150356.GB2099@localhost.localdomain>
 <20140505151228.GR26782@laptop.programming.kicks-ass.net>
 <20140505153405.GD2099@localhost.localdomain>
 <20140507151735.GQ30445@twins.programming.kicks-ass.net>
 <20140507152922.GB16694@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xsn3knLL3qrmRbVI"
Content-Disposition: inline
In-Reply-To: <20140507152922.GB16694@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xsn3knLL3qrmRbVI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 05:29:24PM +0200, Frederic Weisbecker wrote:
> On Wed, May 07, 2014 at 05:17:35PM +0200, Peter Zijlstra wrote:
> > On Mon, May 05, 2014 at 05:34:08PM +0200, Frederic Weisbecker wrote:
> > > On Mon, May 05, 2014 at 05:12:28PM +0200, Peter Zijlstra wrote:
> > > > > Note the current ordering:
> > > > >=20
> > > > >     cmpxchg(&qsd->pending, 0, 1)       get ipi
> > > > >     csd_lock(qsd->csd)                 xchg(&qsd->pending, 1)
> > > > >     send ipi                           csd_unlock(qsd->csd)
> > > > >=20
> > > > >=20
> > > > > So there shouldn't be racing updaters. Also ipi sender shouldn't
> > > > > race with ipi receiver, the update shouldn't always eventually see
> > > > > the unlock happening.
> > > >=20
> > > > Yeah, I've not spotted how this particular train wreck happens eith=
er.
> > > >=20
> > > > The problem is reproduction, it took me 9 hours to confirm I could
> > > > reproduce the problem on my machine. So how long to I run it with t=
his
> > > > patch reverted to show its gone..
> > >=20
> > > Maybe it could be favoured cpu hotplug. Anyway converting to irq_work=
 should
> > > fix it.
> >=20
> > Ingo needs a commit msg for the revert of this patch; do you think you
> > have time to look into _why_ this patch is broken and write such a
> > thing?
>=20
> I can try but I need to reproduce it. Do you have any clue on how to do s=
o?
> Also which HEAD were you guys using?

Ha!, so I was running a tip/master with that commit in -- a few days
ago, v3.15-rc4-1644-g5c658b0cdf22 might've been it.

Then I ran it on my dual socket AMD interlagos, with:

while :; make O=3Dallyesconfig-build/ clean; make O=3Dallyesconfig-build/
-j96 -s; done

for 9 hours, and then got empty RCU stall warns and a bricked machine.

I might still have the .config, but I don't think there was anything
particularly odd about the config other than having NOHZ_FULL enabled.

The only way I found this patch was by staring at some RCU stall warns
Ingo managed to get, sometimes they actually got backtraces in them
apparently.

According to Ingo the bigger the machine the faster it reproduces, but
reproduction times, even for these 32 cpu machines, are in the many
hours range.

--Xsn3knLL3qrmRbVI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTalNAAAoJEHZH4aRLwOS6qBIQAIKpgSOqEi44vMAWfU5eLx7u
HIcwWUyh0IKthTPK/cTGebDy1fXPFRe9+lY+vKYfbuRDaSK7e/qCrP5612hakt38
Q0FWLpxk2GHovudrI5zMEMZbIjGD2fRpLT9dkmPuJ0FHLlCynVW3YmigFihUPdSC
TVR2AF8dszLw0DTLKb0p4AbNZ4UrRmEqWPuKV338YOWi+CDtcbo9xf/OPXuM5oQN
Io9XHK2qQQ+XRGzHsq/MhZLRoSoTZhHpfAK/oVvA2cgxVpnulyIAqWPI7iBMz4Eo
Loz8dmeYdli2sYyryidCn4zZ51ldZImqLDT5Ekh3mvhme3bbSSjdsEeLpJwNFC34
2idBoTADfIHUvTPz+x+PYZ3htI1sE9RSivInn1hc/hM7xNk8t+f/2d79NVbJC6CB
ddANSILje6uipuRr1wgCnTDuQunQxIoJTwxQ9VtF1ELkQI9g50gzQwprGxnkfqTM
FgMTTyn0PGa9wOPAh3tzTkgByWP8MEY4hvWLu/AI6q8mVjhZ2yNbKEllJ9jBOryS
Yxp+djZilfXt/YWQaWCJKNP8AfXbVDJgqT1UIcyOpoH/zRU9ZnboTS52iq1A9xwQ
jvqgrla/q/HGVNguMev/8cZalRIZ1H+ywPNyAOT3/Cqf6PqCrDZ6eBEMGWynefoc
c3/BcfrYlgxZsORpv+at
=Y2EA
-----END PGP SIGNATURE-----

--Xsn3knLL3qrmRbVI--
