Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230AbaIJKDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 06:03:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaIJKDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 06:03:04 -0400
Date: Wed, 10 Sep 2014 12:02:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org, Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: perf: NULL ptr deref in perf_event_context_sched_in
Message-ID: <20140910100257.GP16043@twins.programming.kicks-ass.net>
References: <540F53C9.6040800@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qSHHer9gQ0dtepKr"
Content-Disposition: inline
In-Reply-To: <540F53C9.6040800@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qSHHer9gQ0dtepKr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 03:23:53PM -0400, Sasha Levin wrote:

> While fuzzing with trinity inside a KVM tools guest running the latest -n=
ext
> kernel, I've stumbled on the following spew:
>=20
> [ 1181.492212] BUG: unable to handle kernel NULL pointer dereference at 0=
000000000000040
> [ 1181.500717] IP: perf_event_context_sched_in (kernel/events/core.c:333 =
kernel/events/core.c:2575)

Oh joy:

static inline struct perf_cpu_context *
__get_cpu_context(struct perf_event_context *ctx)
{
	return this_cpu_ptr(ctx->pmu->pmu_cpu_context);
}

For some reason our pmu::pmu_cpu_context per-cpu storage is gone. Now
how did that happen.... /me puzzled

--qSHHer9gQ0dtepKr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUECHRAAoJEHZH4aRLwOS6SWsQAICJO2lWWoBoXsT2x6cQbcRD
pCE83khLsq4EK8x+s/W6hbKYOfnlRRpILGDhNzLeQqI0hfNQt5NiJzpl2MFWeh/B
HqKoMq0ol6IY2yw1b4mG2SOCGxetYub8zrLJ+IheTnLg9Gi1D03Ae7it9sGbkOT9
eVtPDjFzAcO5hP6whq137uUEd6H53a/j+EyMX0MzZki7jf6+tMwF6liqDKaAeZZQ
2W/FmHSAiFcDAWIej7zOlExwzGGR9+b8Ajnarkzzro4zHliyInOpH270GkFkxwJ+
OPC1Fh0MrkqWLPoPiwP4fyf//6cDbhfooWrqXr4WF0p3VRCYHVAiClG4SRu3V7K6
ef8EOjzhzecq6cSQDcqb1xo6W4elhQDSbzXKFWCdkN7Zht645kPexpf+1xMA9hfw
6fU72Qrpupjjaq+WabYhX/jTMjZZFE2ZFRbdt/g+/oEmuReXUJolestsNxLT+zsb
EYzZAbOw/AcN7/A+nEbAWy0+Nyjh6Usc58FLaROSJcNOYC0e6INQ2RIsi0Uj5yDj
cQWihBDRYcsGZLgXVbx9bKND+Z8CC1zhuy7iEu8wLIcDrbAtmGBHUxx4LDqJk/w9
50JmaAcAFqYMR0yirdm6urzVawjzK14oKdEtvVpGbvltOYpHDhW901XwF8joGjKs
31+t1AzgSnmuLPEW7zeO
=cOI0
-----END PGP SIGNATURE-----

--qSHHer9gQ0dtepKr--
