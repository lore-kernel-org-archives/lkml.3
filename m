Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaEBR1k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:27:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42567 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842AbaEBR1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:27:39 -0400
Date: Fri, 2 May 2014 19:27:31 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140502172731.GK30445@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu>
 <20140501150948.GR11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
 <20140502154217.GW11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021218350.22556@vincent-weaver-1.umelst.maine.edu>
 <20140502162234.GX11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O3RTKUHj+75w1tg5"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405021230130.22556@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O3RTKUHj+75w1tg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 12:43:17PM -0400, Vince Weaver wrote:
> On Fri, 2 May 2014, Peter Zijlstra wrote:
>=20
> > In principle the vfs file refcounting should be responsible for that.
> > But I'll go over it in a bit.
>=20
> The poll code is ancient and the C-parser in my head really can't handle=
=20
> it very well.

Yeah, that code isn't my favourite part either..

> Anyway for completeness this is the kind of thing I'm seeing.
> The poll() manpage isn't very clear about what is supposed to happen if=
=20
> you poll() on a closed file descriptor.

              POLLNVAL
                     Invalid request: fd not open (output only).

Seems applicable..


Also, could you send your entire diff this way so we're more or less
staring at the same code again?

--O3RTKUHj+75w1tg5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTY9WDAAoJEHZH4aRLwOS6S/YP/RCm4ORSvaUT+pPnkOHYqNBa
QbZgUX7CVKxdBxuzW8T4d7obmU9M3H8KfJvy458Af9ZJlNuJQABhlWhQieB2s3a2
8aHPRF4aMFc7z0LpS9ddLl1cJ+5NyOVoOMGbm7LxmGIY6OLQRh5F+/9TtFOQL7k/
5GrgqvoQeerjFvCkL7ZrCb+osVNV+5DEApBKll9tr0sZatPYgSWIXlPmIyNcFESh
eh6lQbX1WEfiLC2D41XncoMaCEi/Tt4S1+GSWyYrmgrww7VxYHiEYgJCA3nyrC6i
MWEoh2d6FN3f4C9pIld2s/rT61/cnbzu4aKLr1TbJUDOIVrpoCnDnoizTTKyetGD
yAs8DZGFVbI0JVZNY0asVkvVJqkHd2Iz4BYMphKMSuZdlBBT5H1Q1KAKwRwxYtK+
SJ5AljFC8e1Vrl8h+y79hPZZQO4DY6XpA3KNuvx5coWyV8/WMyyZum8oEBQYw2Bm
XwRcqPoHnFiEdXBiitpE7epxNQj3nvKPq9gUgkCmopN05xdIJ7hH1IctM5HQxkUD
d5cb1gMwpQuATH02n0WKGVR92YM3QsVdmh4rXQ6M5DwMmKAJ7GAWhDgjco3k3Fij
TZlYG4Q71rF2XptOXEXrLofecamSnkCo3NDkDwQVThl7UurBmQiF3gnbQMC0U46D
E4QMgXSyDYvFcA8aW03z
=RVWw
-----END PGP SIGNATURE-----

--O3RTKUHj+75w1tg5--
