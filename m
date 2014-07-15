Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaGOOia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:38:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916AbaGOOh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:37:56 -0400
Date: Tue, 15 Jul 2014 16:37:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: perf: FORMAT_GROUP on attached process stops working in 3.16-rc
Message-ID: <20140715143745.GK9918@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1407151030550.20353@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2KNN3gYh9MUZz6n4"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407151030550.20353@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2KNN3gYh9MUZz6n4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 10:36:33AM -0400, Vince Weaver wrote:
> Hello
>=20
> I noticed in the 3.16-rc kernels that one of my regression tests was=20
> failing, specifically
> 	https://github.com/deater/perf_event_tests/blob/master/tests/bugs/read_g=
roup_attached.c
>=20
> This test creates an event group with two events and PERF_FORMAT_GROUP
> set.
>=20
> It creates a child process, stops it, attaches the event group to it,=20
> starts the events and the child, waits for the child to finish, stops the
> events, then reads the value.
>=20
> In theory a subsequent read from the group leader should return values fo=
r=20
> *both* events (due to PERF_FORMAT_GROUP) but this stopped working, it onl=
y=20
> returns the value for the leader.
>=20
> I've bisected it down to change: 15a2d4de0eab5=20
> 	"perf: Always destroy groups on exit"
>=20
> So is this expected behavior due to this patch, or is it a regression?

Regression, lemme try and wrap my head around it. Thanks!

--2KNN3gYh9MUZz6n4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxTy5AAoJEHZH4aRLwOS6NC0P/jpHgZIPIZzaJxJgrj2NNR0j
mNjpMh4p5Qg8xxStXI1/gsip0cyr4SXwytEA/FxmmEg2hdKDqMb7ukSMCVLgy6wq
py6RIq50ubzsEaXqQ6x3laRRf5BsleHCkprlgLuvTuLEnPRstUFovLXi4aej7ndy
gOLO5e0FjJFnxq0mY7QJgjSCss6H3qIAiy0Qy/wiDhAjGXIwyH1u4R2uH7WGaog7
rU/+6OSNaJVRFQImGrvfdo2Q/Otz7O/8F2iErDlYz+msQTUUAYpT3+hrbZzYasvv
3k2SdOXTaFzUi0Z2h4HHkMuAht3gv8FghB1i+0ODoPDYj+WMNBR+bBALBiXTb0qe
BsUIn3zZkMWX02l7YS2NUIcPRS/mwUqzTmHlu5xVV0vBbqkKEc+Z24VB9SI/ArTk
8Abq6m5Ah7P47RJWVviIKsscjf2azecVh++RMZd+8DZdNKr9QxmiWrtUYqtEPpya
MPTBcqgpHDsAP97TGbOKRbWPO8AyrcKzRTvo7I3TpzgZ8DVKek4s6llP8GOQUVnK
ZK4Mfp9kc6KuzO8mIFZYh9ePj1v0h/VqaqeUIzl+S9hZdT6hzyZm7p3VNDbiXK1q
b/0TpFTliwJUb2x/6VLwXe5AI/JbQC1U2uvvAtTEPVKtjnvGeko8JyB+4CQxGv2B
vRztpz8YL+IocAoJ7CBj
=/O6A
-----END PGP SIGNATURE-----

--2KNN3gYh9MUZz6n4--
