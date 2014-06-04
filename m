Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107AbaFDII1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 04:08:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37201 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387AbaFDIIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 04:08:23 -0400
Date: Wed, 4 Jun 2014 10:08:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Morten Rasmussen <morten.rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>
Subject: Re: [PATCH v2 08/11] sched: get CPU's activity statistic
Message-ID: <20140604080809.GK30445@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-9-git-send-email-vincent.guittot@linaro.org>
 <20140528121001.GI19967@e103034-lin>
 <CAKfTPtDxeBfZK1AxCRqEG91pi--Ti1RYFoQPDhvMVnGTCspQ-g@mail.gmail.com>
 <20140528154703.GJ19967@e103034-lin>
 <20140603155007.GZ30445@twins.programming.kicks-ass.net>
 <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0Hxo4/sPH1pM8XTf"
Content-Disposition: inline
In-Reply-To: <CAKfTPtDUvH--WxFATTW6YRAvLuohzyNHDUq6DRdfxc7gRKCX6Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0Hxo4/sPH1pM8XTf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 04, 2014 at 09:47:26AM +0200, Vincent Guittot wrote:
> On 3 June 2014 17:50, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, May 28, 2014 at 04:47:03PM +0100, Morten Rasmussen wrote:
> >> Since we may do periodic load-balance every 10 ms or so, we will perfo=
rm
> >> a number of load-balances where runnable_avg_sum will mostly be
> >> reflecting the state of the world before a change (new task queued or
> >> moved a task to a different cpu). If you had have two tasks continuous=
ly
> >> on one cpu and your other cpu is idle, and you move one of the tasks to
> >> the other cpu, runnable_avg_sum will remain unchanged, 47742, on the
> >> first cpu while it starts from 0 on the other one. 10 ms later it will
> >> have increased a bit, 32 ms later it will be 47742/2, and 345 ms later
> >> it reaches 47742. In the mean time the cpu doesn't appear fully utiliz=
ed
> >> and we might decide to put more tasks on it because we don't know if
> >> runnable_avg_sum represents a partially utilized cpu (for example a 50%
> >> task) or if it will continue to rise and eventually get to 47742.
> >
> > Ah, no, since we track per task, and update the per-cpu ones when we
> > migrate tasks, the per-cpu values should be instantly updated.
> >
> > If we were to increase per task storage, we might as well also track
> > running_avg not only runnable_avg.
>=20
> I agree that the removed running_avg should give more useful
> information about the the load of a CPU.
>=20
> The main issue with running_avg is that it's disturbed by other tasks
> (as point out previously). As a typical example,  if we have 2 tasks
> with a load of 25% on 1 CPU, the unweighted runnable_load_avg will be
> in the range of [100% - 50%] depending of the parallelism of the
> runtime of the tasks whereas the reality is 50% and the use of
> running_avg will return this value

I'm not sure I see how 100% is possible, but yes I agree that runnable
can indeed be inflated due to this queueing effect.

--0Hxo4/sPH1pM8XTf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjtPpAAoJEHZH4aRLwOS60zYP/1tdzup7DYmCbBBbJPnZ7rUN
yGuEw8pVdmL16xAci+8Dle7PDOW9Lhn7KVkoVDTAp7UVcdKZWh4MEZi31vSZ5YXF
R3uQv6dGmKqtIx7yeZWgtmJpPIEiD+dlV0ohmcwFet5D90vHZbIck8w2WJBLpe3K
ihQfYH+pULITTG8CyOg010VrJptsupvZv3E4s35Lwv+HSr92tVbeJ8D57AI1/BLl
fLbu+6wFEq+/GTqcPKuQqa9v40zFvFVRpvC9ttuXH/XbsxNIwl87An75u2qW8pPr
/dQl3TxrIRJ/rAbLEAvqalux1GQ4xn+lHSBTgqUPBw7haPbmJuxzMtEz+E2luj+Q
Tgqkl4Df/CoBuRXQD5dWKQCxbGvnx6j4OwwIsu+IltYZdX6r/ULJ3CW29zXTAUPk
aHZgNHtqmxHnJkSk//BXYhIW6kvpwdmz1FoPavJuKNOSnGZlexADtW2Z3kX4+ZW6
Adym2NC/ympyDOtz296lBgwns4xKJdU83eF5JwpRY2yoZBDk8g6bOTR1sl9YcU3a
p9rkE/TFHdc+ySq8tehoEyvexnk+Lqi02q35loXiwbfsalkD1XGMBA67xr2m2IoF
MK7yOXP1vQ4hcBxlKqJAe0HFHQiY5UcnMFP9YJ1MxPKxOdGe0v3nkSK4vJEMvhCR
9tDbGkLlR4nO3+DW/IfV
=gtRG
-----END PGP SIGNATURE-----

--0Hxo4/sPH1pM8XTf--
