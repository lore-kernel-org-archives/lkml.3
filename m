Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaIIKUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:20:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:44023 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaIIKUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:20:07 -0400
Date: Tue, 9 Sep 2014 12:20:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140909102000.GE19379@twins.programming.kicks-ass.net>
References: <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908120140.GA17728@krava.brq.redhat.com>
 <20140908133428.GG6758@twins.programming.kicks-ass.net>
 <20140908151305.GU3588@twins.programming.kicks-ass.net>
 <20140908164524.GJ17728@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D8TvDI1vRZUl2ML+"
Content-Disposition: inline
In-Reply-To: <20140908164524.GJ17728@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D8TvDI1vRZUl2ML+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 06:45:24PM +0200, Jiri Olsa wrote:
> I just noticed that we initialize the child state with base parent
> state not the real (immediate) parent.. which is what we want IMO
>=20
> I wonder attached patch could fix the issue mentioned in:
>   1f9a726 perf: Do not allow optimized switch for non-cloned events
>=20
> now I need to recall what I used to test this ;-)

Ah, very nice! Yes this might just do it.

> ---
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index e4d6924..561a4ea 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -7794,6 +7794,7 @@ inherit_event(struct perf_event *parent_event,
>  	      struct perf_event *group_leader,
>  	      struct perf_event_context *child_ctx)
>  {
> +	enum perf_event_active_state parent_state =3D parent_event->state;
>  	struct perf_event *child_event;
>  	unsigned long flags;
> =20
> @@ -7827,7 +7828,7 @@ inherit_event(struct perf_event *parent_event,
>  	 * not its attr.disabled bit.  We hold the parent's mutex,
>  	 * so we won't race with perf_event_{en, dis}able_family.
>  	 */
> -	if (parent_event->state >=3D PERF_EVENT_STATE_INACTIVE)
> +	if (parent_state >=3D PERF_EVENT_STATE_INACTIVE)
>  		child_event->state =3D PERF_EVENT_STATE_INACTIVE;
>  	else
>  		child_event->state =3D PERF_EVENT_STATE_OFF;

--D8TvDI1vRZUl2ML+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDtRQAAoJEHZH4aRLwOS6PD4QALN2kC2QM5rEsj2xLhkFEhUk
tVB2Ntd2PV06KpVSBm+o6ICKTki70BuLtWRNSppCubC+TAywDYuPr2xXTvpvYB4l
e0K3CpzLwmP24hVq3Wj36ykxcNfsTtu6DuiSWlj+9Tq+dR73sI3rlnpZHURklt9i
jXU5fx4XnKVC6rqXyT8w+HU/hFe5A0CLjRng5XNaWh4N3wFttODsDCyJVqrApqRw
TxcB9vqBRbez5lXP++gfTXWIzlUdprEJl9DGgr9hLUapa9O9mdj/JxXgFMhXaN0q
NpsOSVllr06a2tBa/dvtR0pl87ZYh8TNYTn87hwH4cmGZTIILDV1WKlwx50Kv38v
7BlZa5RT7NWL9gqNDJSGcXdW9jlafmDFgLfollVVCLfUas3YP0HvnvjsbZC6kumT
eJfoUp4/++pmzsrpkNkR2pqHAq07D5KZu/QkUDiVyfP9rgSsBsTattTS7QpTOz2k
T1PlBXWVqUzbu2E/HCVwN2UIjWQxJpyc74PvEbGj7zznp6Ab0UcBRVwU1VigrL7d
xgmxFfri+SMdkeoo0oM01hRhH0taZ9o7wcHbrWIwpeDUjeAeh+CU9VGorEs/d0EB
+TwRGoQkwmXzjisIMFo0xISHPeo5yg0b2MFewFIbMJNzuJIQ4gHHtsyWLHyppsxo
yqoOWc+hM8feqHJdRK6k
=mKQn
-----END PGP SIGNATURE-----

--D8TvDI1vRZUl2ML+--
