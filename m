Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbaHMQar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 12:30:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60613 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaHMQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 12:30:45 -0400
Date: Wed, 13 Aug 2014 18:30:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v5 tip/core/rcu 15/16] rcu: Make RCU-tasks wait for idle
 tasks
Message-ID: <20140813163015.GT9918@twins.programming.kicks-ass.net>
References: <20140811224840.GA25594@linux.vnet.ibm.com>
 <1407797345-28227-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1407797345-28227-15-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140813081215.GB9918@twins.programming.kicks-ass.net>
 <20140813124818.GQ4752@linux.vnet.ibm.com>
 <20140813134025.GN9918@twins.programming.kicks-ass.net>
 <20140813095132.56d288f2@gandalf.local.home>
 <20140813140705.GO9918@twins.programming.kicks-ass.net>
 <20140813101301.08019895@gandalf.local.home>
 <20140813144332.GW4752@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="F0/awBnMJF6bn4Az"
Content-Disposition: inline
In-Reply-To: <20140813144332.GW4752@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--F0/awBnMJF6bn4Az
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 07:43:32AM -0700, Paul E. McKenney wrote:
> o	drivers/acpi/acpi_pad.c, power_saving_thread().
>=20
> 	Looks like a kthread that does idle injection.  Currently, RCU
> 	sees it as not a quiescent state.  Would it kill these guys to
> 	put in a comment or two about what this is for???
>=20
> 	So adding rcu_idle_enter() and rcu_idle_exit() here might
> 	actually fix a bug, though it is not clear how long this thing
> 	actually runs.  If only for a few milliseconds, no harm done.
>=20

> o	drivers/thermal/intel_powerclamp.c, clamp_thread().
>=20
> 	Looks similar to power_saving_thread(), but for thermal control.
> 	Probably short term, shouldn't be a problem either way.
>=20

There's patches somewhere that make that go-away

  https://lkml.org/lkml/2014/6/4/56

Jacob was going to look at that.

--F0/awBnMJF6bn4Az
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT65KXAAoJEHZH4aRLwOS6z0MQAIuCshiehBSTTBd+cKyI3hwV
/mmHmnDBsgSYp56nZd9ul3FKMqsKvS/w5q5Ig6TXxVkeuNmc6mcP79xNrByDAdwL
IsflGB+V47+IbyXCVQQA1cLmEiZCZluJvmoZzgJHdtPUJxtXe2zsAtESbr46YAFT
qN2N9h0A0T8PeFcAQuY64xAEyKJ/9JRPsMYoYZpjJbn84AFEoYNqT7Qjh4CBlD1h
LIuFzV08f3hVEfSvG6VhWXDF2OKeoXH3nO6l3PJQNOSQct/v2pHQw+r2CAaDDK/7
xqgApUowqP1OMtw4QQ+YMMKFNcahNwBuVmE+dZXW+2ICP+H4C0By2QRJIFCM7TYi
NBcOttXkNOzYHC+Yku61ppjbvjZnRkJmWkHh7H1M7KqE/BvL6/71uwZUkRozlMwf
JZuBrP71oHgz7MotbgwROOEBozpY8+Xs6u2s4w+yybp57Rjvy4doqmGU91Fr9han
P23y/NAphABWdhf494FqiCWw0dbMLnuKu1IyajpAJgzDl3MLq7/S4gN/1gII8bx/
ETm2M9E3Cuyy+D31qTEQinEXTGpH2GINCr0ifqNImJZnNQ21ouQ7vkQMf2YumcuP
4dfKiR/ep6dzcutX4KUuw8sqxuCNg2B6NM756qeJWbOeEo3v91rUkeCz7MfzjTe+
7PWdZOQotq4TibS6uF/k
=bqDG
-----END PGP SIGNATURE-----

--F0/awBnMJF6bn4Az--
