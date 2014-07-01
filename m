Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739AbaGAJe5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:34:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:54630 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177AbaGAJez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:34:55 -0400
Date: Tue, 1 Jul 2014 11:34:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Rientjes <rientjes@google.com>
Cc: Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, perf: avoid spamming kernel log for bts buffer
 failure
Message-ID: <20140701093442.GN6758@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QwltuPJOutxmIGiQ"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406301600460.26302@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QwltuPJOutxmIGiQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2014 at 04:04:08PM -0700, David Rientjes wrote:
> It's unnecessary to excessively spam the kernel log anytime the BTS buffe=
r=20
> cannot be allocated, so make this allocation __GFP_NOWARN.
>=20
> The user probably will want to at least find some artifact that the=20
> allocation has failed in the past, probably due to fragmentation because=
=20
> of its large size, when it's not allocated at bootstrap.  Thus, add a=20
> WARN_ONCE() so something is left behind for them to understand why perf=
=20
> commnads that require PEBS is not working properly.

Can you elaborate a bit under which conditions this triggered? Typically
we should be doing fairly well allocating such buffers with GFP_KERNEL,
that should allow things like compaction to run and create higher order
pages.

And the BTS (branch trace store) isn't _that_ large.

That said, the patch is reasonable; although arguably we should maybe do
the same to alloc_pebs_buffer().

--QwltuPJOutxmIGiQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTsoCyAAoJEHZH4aRLwOS6Ik8P/jomlc68EO6Jpd0X3Nj5kztO
1sb9GBbvPBe+npFsr1qJjzfuHeeEu3vcRhSzo9WVT7whTd2roWhxGsOWnyfYysfx
d7kh9rMIUWsqZTpW8Zh0JIlYuxxGu9jtqzJM687ZtOItm/2HzmCISJOP9VO46LG1
odvOpDuXANTAANwRN1xyZukKyZCXPzC3B0jmW5PeDDjdWDTutq3gxjfOaQ2OCXoL
TN9WAd0bEam95vxwXg4VPM8K9jb+nyJ0EognB9eb1muMm15HKGPmeCJqoXAqbMwu
8bdM1FYNFyx+88byKnKVoNV9lG6iyB/zTTtV7JTX4A8NYd+4SOIcv4/XcLxNOmWy
vQ4xLsUddU9s170Au87iBC6SYv2La62fWmoS8ghPCv2OC1VzRGPGo2iHSFts3nNQ
ZvotoDouJl7CNFWD6v8Izj3naFLR0bJK0LH2Dcd1kM5U6Bz9s/Ui8FUVsZtqlsyQ
ku+kubKvI27vVYszkMENJ6CSqBLB3WH/76PXYQaEvm/eAuBhZ6EUydJ+Xe/prvEp
3uZZencxg6k7tTAVUVbu1Hi03/6UM9smN55SNwEZ/f5wT67QpG+fU0yX/CeOgWbS
c9DAURCTTHsd8KGeNtFIkl0xMU7A4UJVNZ0Vf18kP4cCZLiJALYOqjrJ3fJ+3eod
HPV/mTKjMtSasqm+dhOk
=ImK2
-----END PGP SIGNATURE-----

--QwltuPJOutxmIGiQ--
