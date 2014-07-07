Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588AbaGGPm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:42:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:50508 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbaGGPmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:42:39 -0400
Date: Mon, 7 Jul 2014 17:42:30 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "pjt@google.com" <pjt@google.com>
Subject: Re: [RFCv2 PATCH 00/23] sched: Energy cost model for energy-aware
 scheduling
Message-ID: <20140707154230.GF19379@twins.programming.kicks-ass.net>
References: <1404404770-323-1-git-send-email-morten.rasmussen@arm.com>
 <20140704165552.GB30016@arm.com>
 <20140707135915.GA4485@e103687>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mfP1iJBimQeSOP+4"
Content-Disposition: inline
In-Reply-To: <20140707135915.GA4485@e103687>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mfP1iJBimQeSOP+4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 03:00:18PM +0100, Morten Rasmussen wrote:
> > Could this be addressed by making the scheduler more "proactive" and,
> > rather than just looking at the current energy diff, guesstimate what it
> > would be if not placing a task at all on the CPU? If for example there
> > is no other task running on that CPU, could energy_diff_task() take into
> > account the next deeper C-state rather than just the current one? This
> > way we may be able to achieve more packing even on fully symmetric
> > systems and allow CPUs to go into deeper sleep states.
>=20
> I think it would be possible to bias the choice of cpu either by
> considering potential energy savings by letting some cpus get into a
> deeper C-state, or applying a static bias towards some cpus (lower cpuid
> for example). Since it is in the wakeup path it must not be too complex
> to figure out though.
>=20
> I haven't seen the problem in reality yet. When I tried the short tasks
> test with all cpus using the same energy model I got tasks consolidated
> on either of the clusters. The consolidation cluster sometimes changed
> during the test.
>=20
> There is a lot of tuning to be done, that is for sure. We will have to
> make similar decisions for the periodic/idle balance path as well.

So one of the things I mentioned previously (on IRC, to Morton) is that
we can use the energy numbers (P and C state) to precompute whether or
not race-to-idle makes sense for the platform. Or if it benefits from
packing etc..

So at topology setup time we can statically determine some of these
policies (maybe with a few parameters) and take it from there.

So if the platform benefits from packing, we can set the appropriate
topology bits to do so. If it benefits from race-to-idle, it can select
that, etc.


--mfP1iJBimQeSOP+4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTur/mAAoJEHZH4aRLwOS6zOsQAJeoYjIh20uaTZ5T4tvVOS0m
wfJuQ+1S+o+mu4O9whbs9kFJ5AolUhgtXyupcArDErpG6GLtNy9+kxniRsISK4Bb
+SbO9AoCms2lqNK8hLK1RgAHR+Orr6iLwDNeyLwW54TxOyL4Zv023HK/EHzLNFUI
YcySCZHL9+87vCBuwK9mbDqwpagTQs5nP7+6EXjt4rYEZOGg8UCLcu/HR4+UnHXI
UoK8DXcI0wj0zrKa9rmDItDUSIQ+zZT6RKrlpR7W824cQ9NgLBuhVEBnZWVWRsKy
j2ozt+w9GMTCLWqCLntb3a4r9F9pfSVnAS0yn+xGEzOHvJFniyyBxSq28sogPkid
se460U5oDGjYnQzZGN6+QEWRQhbi/QITDirS4GVhbNiwWVY6hnDNIKsYaN7Wc7bZ
ikUI4Em70KPFYJnX+dXbCfdkd7sZpMhGSafHhzsMDuN0FTHlwuFPxvwwlWYlDDyN
lB1ncHzBEvC4TCKnBINGkWW+F8Ff0JHlMBNU9OEyd1qbG263TPmgfthv0ASRGCf+
Y0er3ERGortAA4GWkZYoKLNZ4cx7exy7N4pyDt9VakUQXIN+dfk6HN88tzxgIsrk
fjxgDo58Rc+O1FoWPBhGEqhIh3BklfkKzj5h+tHoWsLMa01IAAURA97KUo6PBkKR
Pz51LfWpgFFMovBUXs6x
=h9Ae
-----END PGP SIGNATURE-----

--mfP1iJBimQeSOP+4--
