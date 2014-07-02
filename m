Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754641AbaGBOyW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:54:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42831 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaGBOyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:54:20 -0400
Date: Wed, 2 Jul 2014 16:54:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Rientjes <rientjes@google.com>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer
 failure
Message-ID: <20140702145411.GI19379@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
 <20140701093442.GN6758@twins.programming.kicks-ass.net>
 <CABPqkBT9zT6Qejc3hin5yLO4x8bxkZqrXTS-VNana8MhtWC0XA@mail.gmail.com>
 <20140702133105.GG19379@twins.programming.kicks-ass.net>
 <CABPqkBSCckKtKUZ0P0FONtiygjmGYzgA1myE9aG+-RcQ9xnLsg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9s922KAXlWjPfK/Q"
Content-Disposition: inline
In-Reply-To: <CABPqkBSCckKtKUZ0P0FONtiygjmGYzgA1myE9aG+-RcQ9xnLsg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9s922KAXlWjPfK/Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 03:38:50PM +0200, Stephane Eranian wrote:
> On Wed, Jul 2, 2014 at 3:31 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > Right, that'd suck. I suppose we could also change that to allocate the
> > DS resources on first demand and never free them again.
> >
> Some may argue that if you never use perf_event again, you are wasting
> (1 + 1 + 4) pages per CPU. That may not be okay on some systems.
>=20
> But yes, it would avoid this problem and also take the penalty for the al=
locs
> only once.

We could of course over engineer this and put a timer on them to free
after 5 minutes to avoid the alloc/free cycle for workloads that
create/destroy events a lot.

--9s922KAXlWjPfK/Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtB0TAAoJEHZH4aRLwOS6kpoQAIMWRoxyIQJ2xCYuJAxsaslg
/LUAQPUcTfCna8Lw3PInCV74FshA89wXCxapdE+FKjNr1gH6TNYyO20rqyi0hjR6
6SX43lSFuVb9zG6U/jH87RDTI5C+CZMD4INMhJv5pfhf8LTx8niUgOow9EKIU6l4
1YEp49bA9UN6591EraXMqX/idQR7UT9gRNcPVePvkKKyBXbqyE8lUdYqdUV+dsnv
Dvq7B8qzdzCLU2n66INQpgqJZHraP+/y5pJs9pfzsqDH6oK4u6Rjw/xfGVprTwCz
eAh+mNVIHDE+Y/iUcESI/iQbgtYPdz1hrQOg8xPK1PjXj+2/vNqphGjsZ0MaGWFX
Oyq1upE5gOvsuSWPLiBx3n8/GhCxF87GNf0DfnjTTJt+lwNGSnlkXeUIqPisqfR2
jS0cVFVYc0TscZ6uKXcosgEWzI253CObkJm9QMiqckiYGCpWHbWOnOfkBvVNNKxs
CYnRsIUl0Qst5vtTBQi8gkZ0LsCef0ziZwwDNDhMNyS0oG1/nUeWZUyLKZg8jGjt
TVnTD4r7thDE89cJ0wlPOttPwqkuXhhfDQPMGfVjHSdzf5Xuzd8IFKbZrkSgVKpm
OJpeUkIOzbxefHfWVxQLjUpOwOAcMHHcwpCpGnMFRKEvuSPS5frdIZeKblasP9sc
LNrb61dT6hApU1Yjhoec
=auQM
-----END PGP SIGNATURE-----

--9s922KAXlWjPfK/Q--
