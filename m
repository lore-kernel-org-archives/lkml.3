Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaEWPbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:31:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:51002 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEWPbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:31:20 -0400
Date: Fri, 23 May 2014 17:31:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, tglx@linutronix.de,
        mingo@kernel.org, tj@kernel.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-ID: <20140523153113.GG30445@twins.programming.kicks-ass.net>
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com>
 <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com>
 <20140523132250.GA1768@localhost.localdomain>
 <537F5F0F.5050802@linux.vnet.ibm.com>
 <20140523151252.GE30445@twins.programming.kicks-ass.net>
 <537F66AF.30303@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UY5t8JEv+jjMAULN"
Content-Disposition: inline
In-Reply-To: <537F66AF.30303@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UY5t8JEv+jjMAULN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 08:48:07PM +0530, Srivatsa S. Bhat wrote:
> On 05/23/2014 08:42 PM, Peter Zijlstra wrote:
> > On Fri, May 23, 2014 at 08:15:35PM +0530, Srivatsa S. Bhat wrote:
> >>>> +		 * During CPU offline, we don't want the other CPUs to send
> >>>> +		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
> >>>> +		 * disabled interrupts (because, then it will notice the IPIs
> >>>> +		 * only after it has gone offline). We can prevent this by
> >>>> +		 * making the other CPUs disable their interrupts first - that
> >>>> +		 * way, they will run the stop-machine code with interrupts
> >>>> +		 * disabled, and hence won't send IPIs after that point.
> >=20
> > That's complete nonsense, you can send IPIs all you want with interrupts
> > disabled.
> >=20
>=20
> True, but that's not what the comment says. It says "you can't send IPIs
> because you are running the *stop-machine* loop, because the stop-machine=
 loop
> doesn't send IPIs itself! The only possibility of sending IPIs from within
> stop-machine is if that CPU can takes an interrupt and the *interrupt han=
dler*
> sends the IPI (like what the block layer used to do) - and we precisely a=
void
> that possibility by disabling interrupts. So no IPIs will be sent beyond
> this point.

but one of those CPUs is running the stop machine function, which calls
CPU_DYING which runs all kinds of nonsense and therefore can send IPIs
all it wants, right?

--UY5t8JEv+jjMAULN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTf2nBAAoJEHZH4aRLwOS68MoQAJvaiFkrIYbCIXTVeHyIY/8M
hdwTIUMlrBvL+xpuha4D/KioI+kEJO0w6KPTBuJEvLjaPqjzPHzT9EYtPBFnW3/P
haBMGdpnZljyg0djpsWGpKsNU1220Rliqf5QCddINLDmUsaEYcYCdzphgLTRJym3
DT0B/ZbEUWxDSmenBROToDM97p7GMZATgM9thE+OySPtV0vb0tm9chHNmXSdufTi
HZv0GLi+LVp6LpqLa5aSNbaBW8IdB3OY5xEH7JZaB5/jwT2t3z1XglBlBHAd9ifH
Bo1mQATiLBYCickPKJu3HpQASlTAmNlXfwEA0NeTY9wVPYPddBx6d4tXqZO6QZqE
TkQQipTqQ+XQxL/WYUWMcDBUD2c2JU6BpCILes8+Qja1u+VgEer3+yMqA19mNVGO
9PZZ7GawzzUG5YBHxoiCUpf645f4z06waVoERjKXYz+WkWQ0ohpJiRO6YfXRrFpx
PZNJpMyYUDhc4ca1YILPtbjVU9TptMWSSferHthAN7odP6fQca7HoHETp6Pd8Pib
kYSScMZxUa6bRb8W5fuXKOyMqrnl8MskdWVUuFVoIzQKEZV3ydnG4iDNxEeYiHST
aRqBY60VISQ6LEDWjgRjpUqCPaCXJS0bf0bi7/NUyg5Gm8BOdSu5xiMjUbStmf2M
lNekHYaWyVzgpJ8/45UQ
=OQWq
-----END PGP SIGNATURE-----

--UY5t8JEv+jjMAULN--
