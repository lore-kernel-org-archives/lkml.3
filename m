Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbaIHNey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:34:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43333 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925AbaIHNew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:34:52 -0400
Date: Mon, 8 Sep 2014 15:34:28 +0200
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
Message-ID: <20140908133428.GG6758@twins.programming.kicks-ass.net>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908120140.GA17728@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tlmTQnts/ksf8jP+"
Content-Disposition: inline
In-Reply-To: <20140908120140.GA17728@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tlmTQnts/ksf8jP+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 02:01:41PM +0200, Jiri Olsa wrote:
> On Mon, Sep 08, 2014 at 12:01:22PM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 08, 2014 at 11:48:55AM +0200, Peter Zijlstra wrote:
> >=20
> > > > The thing is; I don't understand those reasons. That commit log doe=
sn't
> > > > explain.
> > >=20
> > > Ah wait, I finally see. I think we want to fix that exit path, not
> > > disallow the cloning.
> > >=20
> > > The thing is, by not allowing this optimization simple things like eg.
> > > pipe-test say very expensive.
> >=20
> > So its 179033b3e064 ("perf: Add PERF_EVENT_STATE_EXIT state for events
> > with exited task") that introduces the problem. Before that things would
> > work correctly afaict.
>=20
> hum, I dont think so.. because the perf_remove_from_context set event
> to PERF_EVENT_STATE_OFF state anyway.. thus making any new cloned events
> disabled

Urgh, see I knew I was missing something.

Can't we fix that? Lemme check to see what relies on this.

--tlmTQnts/ksf8jP+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDbBkAAoJEHZH4aRLwOS6dqcP/3oL0vcf46Ohy/pdDvwTus0U
Id+7ClAlryOI5cxjulzlkysRnVPqZSWUAOdxIXaohVtX8mVecps7tbfb2LejQ4eZ
VBjz/t4hSfrgptvC8O/pGrhm2Zx+MHd/PjCwnQ9PhlC5ZKR6CAQDpoH5sJtoXqNA
Km1cq7Ty/rnhZbnE3rdfwGqcTzBb8BtJVb9fg0CWe44VXBrB0tx3uzGhx0dVIcYD
new3L0OM/QGg+jqSicmM78QmDPXk0NjhrQSIRId0wJt6RpGJhV9w5R58PdPJwgNu
7KJyMAEdS0GrAhyvLdcKjVcPnlAsQw/fKfTlYj4mp/O00rw66RvU9F0leQgatb3X
lCERkQb1L9qd5Io/Li10kRQ3bgdwJMRIl5ZkndxQTAY6aDnd9U50dra0uWjn9Hb6
DkQpJSm0s1I+vyY6clEcZuLjhsrNHH826uwW0S6CvokRy560ua3BbIkxt0ys6D/0
JYIOWvu8puNx98sYqHQ6uBwjAJKipYg0yZs+bUBh2i1AV4BV4i3Y0C07GkK/HIkE
rGA5bnIjWfFwK3PVB35qEygtP1c42BM250s2f5D0jk9JBfGC2uAVz3YP3rrfx49d
fXgi3stKeJe0rpJZcFRp/w6zbXFy/+2HFYDm1LiUe0RXj8r4SEHre1Ma99aRg6k+
t5CHQI/vaUP+EN8bweFN
=iY9K
-----END PGP SIGNATURE-----

--tlmTQnts/ksf8jP+--
