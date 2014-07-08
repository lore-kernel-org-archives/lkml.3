Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbaGHH7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:59:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:53413 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbaGHH7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:59:14 -0400
Date: Tue, 8 Jul 2014 09:59:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 3/4] documentation: Add acquire/release
 barriers to pairing rules
Message-ID: <20140708075902.GM19379@twins.programming.kicks-ass.net>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SMcH7s1wxTzO87UA"
Content-Disposition: inline
In-Reply-To: <1404771862-6904-3-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SMcH7s1wxTzO87UA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 03:24:21PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>=20
> It is possible to pair acquire and release barriers with other barriers,
> so this commit adds them to the list in the SMP barrier pairing section.
>=20
> Reported-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Reviewed-by: Tejun Heo <tj@kernel.org>


> +A write barrier should always be paired with a data dependency barrier,
> +acquire barrier, release barrier, or read barrier, though a general
> +barrier would also be viable.

   Similarly a read barrier or a data
> +dependency barrier should always be paired with at least a write barrier,
> +an acquire barrier, or a release barrier, though, again, a general
> +barrier is viable:

When I first read the Changelog I though you were going to add things
like:

  An acquire barrier should be paired with a release barrier, however
  .... barrier is also viable.

  A release barrier should be paired with an acquire barrier,... etc.

Now the above does seem to imply such rules but it isn't explicit in
them, since it only lists the requirements for read/write. Now since the
entire thing is indeed symmetric the implications are fairly strong,
still.

Also, it might be good to have a section on the ramifications of pairing
acquire/release with other than themselves, I have the feeling there's
subtle things there.

--SMcH7s1wxTzO87UA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu6TGAAoJEHZH4aRLwOS6TygP/1Mi6AAd358wQQSoJt/yeaMV
D5j/hjqxkJT1MIkJQsILP3h1iixNPYNC7MvAbQQ4gC1efov2q/ChKS4OtAOwqysP
QeY6iAPiJpf+3DyspR2/sWfnABVqwkW9j4j7YYkJqgo1wVeM96gCKdmOmOpnrzQp
hDLqH8psJyjKv8DUCXO6RB/BZnjzhxqEdtmuIdYx28DR8nORrUcsqHF3EJ8jH6dc
XaJDni07CBxieaWs+rHVc8oqQkQRStlG9PlGjveWLv6ReVklR/aILxNEZzUuGc69
Of/5RKXoMIU36SW2iH4CsGbSq4eJvHRCuqHrKhSirJ7VaGi87WXfYoTKniO42tnM
cMekn2U4cRCBla+skEX0TzX6eI8uoIcSmpwXaW8Phb44HD26y9WX2sYGYtFhwoA3
itM8ygugdwDvOL2cIbDOxGSnIxW9m2Q7H+ZAhEkdDK6f/IZEQlQAtanYgXhZbvOJ
a9c6sMG1nwXRy3/fX5UX8Ug3krrvXt7Q5t4Bac9I6/OEjTdeHb4n8sJkEGVxqD8x
0e5dmgX+F7aVMj8xMkuyQKwgKhJmUyF0d4+LSbAmS+yS+USp87f69FgbeetFMhs6
WYZe2l/UCeSOkARBCROzQR6yJWM3TSiOpC911xgg5LG7TSiQ5RccFhFVHupMZ38G
eiyZWZizQNQCKoUx9pWE
=Xl9c
-----END PGP SIGNATURE-----

--SMcH7s1wxTzO87UA--
