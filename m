Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751414AbaHGSqw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 14:46:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48371 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbaHGSqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 14:46:51 -0400
Date: Thu, 7 Aug 2014 20:46:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 3/9] rcu: Add synchronous grace-period
 waiting for RCU-tasks
Message-ID: <20140807184635.GI3588@twins.programming.kicks-ass.net>
References: <20140805205711.7a52076c@gandalf.local.home>
 <20140806012139.GY8101@linux.vnet.ibm.com>
 <20140806084708.GR9918@twins.programming.kicks-ass.net>
 <20140806120958.GZ8101@linux.vnet.ibm.com>
 <20140806163035.GG19379@twins.programming.kicks-ass.net>
 <20140806224518.GA8101@linux.vnet.ibm.com>
 <20140807084544.GJ19379@twins.programming.kicks-ass.net>
 <20140807150031.GB5821@linux.vnet.ibm.com>
 <20140807152600.GW9918@twins.programming.kicks-ass.net>
 <20140807172753.GG3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZilngB4jitXEoqOO"
Content-Disposition: inline
In-Reply-To: <20140807172753.GG3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZilngB4jitXEoqOO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 07:27:53PM +0200, Peter Zijlstra wrote:
> Right, Steve (and Paul) please explain _why_ this is an 'RCU' at all?
> _Why_ do we have call_rcu_task(), and why is it entwined in the 'normal'
> RCU stuff? We've got SRCU -- which btw started out simple, without
> call_srcu() -- and that lives entirely independent. And SRCU is far more
> an actual RCU than this thing is, its got read side primitives and
> everything.
>=20
> Also, I cannot think of any other use besides trampolines for this
> thing, but that might be my limited imagination.

Also, trampolines can end up in the return frames, right? So how can you
be sure when to wipe them? Passing through schedule() isn't enough for
that.

Userspace is, but kernel threads typically don't ever end up there.

--ZilngB4jitXEoqOO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT48mLAAoJEHZH4aRLwOS68NIQALSWYgpKnd5MVMYdW/KFrWU3
R9c9Vy03JMCSEcjis8tNF5NGP7WlMDeVBr4AobkHQOrxL01OjFxUV8ePqb+yneZr
zoZoF5feWFTFZzoxFrAs/TFf4QKWl/4Uqk1AOPT7vBojFweMKCoEZ5UJBCfQvIdT
2BwXmlqjohSoGbw5XRShQqhEW6su0zol+5klE8tvX5jdtQgAkqinc/yLcxhMMFKo
5nYnKQhI6JIMwaG6GaHl8+RUqr402Ds0lGJdUzcxdNWHFT3N5ssIfXdTkl76783G
xaCiuqAOtqW0M024w9pShvMijz+dRQ8mdv4Oxl8wsBd4PXyYF+HKx65uCOQGJLez
k16NCW94sd1c4dMrbp6ZFi13kLI8QI1Xnw5skQzackVW9TMgd0oiiaJLzS7wCZqa
8lnJGOI/SfDyqf5GzarE3W/BSJDJvMM6H4aK2FraR8g4RPdikP214zZCpATe4e6S
xR8lkxFNMOBv/WmqLk3kcbW9UEdQTQWRN3Try6PfX5BQvphTn1xjdAxEktuZt071
4NvSDBR1q8fsXVucp15XPqt2WQIGWG5gIDsKEXYw4GaFGnfxMSCVxf66FQ/d4X+p
rWTKT1pnumfUuAfDD9G4wLZcX15JT0c56jIwCA+7stAGATpgOqGM+8R+mrO45HCJ
yCQiFoOF3ogUj6STzPE1
=bYzp
-----END PGP SIGNATURE-----

--ZilngB4jitXEoqOO--
