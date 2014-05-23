Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaEWPNE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:13:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:50910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaEWPND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:13:03 -0400
Date: Fri, 23 May 2014 17:12:52 +0200
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
Message-ID: <20140523151252.GE30445@twins.programming.kicks-ass.net>
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com>
 <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com>
 <20140523132250.GA1768@localhost.localdomain>
 <537F5F0F.5050802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HFKwn2g6R1ux/FzN"
Content-Disposition: inline
In-Reply-To: <537F5F0F.5050802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HFKwn2g6R1ux/FzN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 08:15:35PM +0530, Srivatsa S. Bhat wrote:
> >> +		 * During CPU offline, we don't want the other CPUs to send
> >> +		 * IPIs to the active_cpu (the outgoing CPU) *after* it has
> >> +		 * disabled interrupts (because, then it will notice the IPIs
> >> +		 * only after it has gone offline). We can prevent this by
> >> +		 * making the other CPUs disable their interrupts first - that
> >> +		 * way, they will run the stop-machine code with interrupts
> >> +		 * disabled, and hence won't send IPIs after that point.

That's complete nonsense, you can send IPIs all you want with interrupts
disabled.

--HFKwn2g6R1ux/FzN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTf2VtAAoJEHZH4aRLwOS6qrIP/RJV36pvvkDjsNCZIxogeITj
KX2G+LHCXIgMAjlgHbWIGcs7+aV2lHi2jht1A27ezbshYLJ+TsdZHBHM1dUpaFVg
Nd3fiv64f7BO6dSeho4k1vAAsttZmEKA1HC5kulUBDU84CQR3e1Pb0+uJ5bOev1g
7lny5pQB67ltl8vyHwz8lZ+AkWz/Pk8cp84fRDXbTgXjlQTs2wyZ1m2gYusTVwmV
56biMG0gK7IlZ6QwFlhQpm0GfOm8mwo4/HaWfpd2xf9vRbtvdrreLMzSuwaO7eaH
B5tta4M/ru78YBk95k4uWsWfs5lT9yinB09p3J8pznnWKylCqyTBeQqCeDA0uQiH
JTfKzAz4hr0XPkeQci1AaiJd9hTC5zdyLo8CbZEd8+ZOiPeN2kylzvONXORw1fIj
avGc14aDw1vYyTeAQ/XHq6NYkC0e0jXaj2x0SYEEXoY+Q5dQ7HM39Ab4lYpqkdfZ
+YFsxXuZjfN1bHpy4dyLXY+1Ra6clBiCWFI+Kb7rkA/GycyXkUnvBk9h77fAuGCR
aZJpEYLI+sm+jEWJtE5EYNPenS4j1PiZ9Aq+6TJ4/M+tQbgvaXv4vRlWAb3Q82eD
m6TJbqsaAB3I9d0i/7oOWEmKx9USLn2C9xoVJzfKn7gW2MpYqjRc+D2X6MnE/5QZ
x/qhL4koa0KVadfQ8g3Y
=pkxY
-----END PGP SIGNATURE-----

--HFKwn2g6R1ux/FzN--
