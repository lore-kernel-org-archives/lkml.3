Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbaGBM2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:28:09 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41772 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaGBM2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:28:08 -0400
Date: Wed, 2 Jul 2014 14:27:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH V4 10/16] perf, core: simplify need branch stack check
Message-ID: <20140702122757.GB19379@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-11-git-send-email-zheng.z.yan@intel.com>
 <20140702105737.GC6758@twins.programming.kicks-ass.net>
 <CABPqkBT2ZTC4Q3L9KwNfAs05qQvRFUZYvQ4QXJmiFeL-jwWSSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <CABPqkBT2ZTC4Q3L9KwNfAs05qQvRFUZYvQ4QXJmiFeL-jwWSSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 01:08:30PM +0200, Stephane Eranian wrote:
> On Wed, Jul 2, 2014 at 12:57 PM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > On Mon, Jun 30, 2014 at 04:50:47PM +0800, Yan, Zheng wrote:
> >> event->attr.branch_sample_type is non-zero no matter branch stack
> >> is enabled explicitly or is enabled implicitly. we can use it to
> >> replace intel_pmu_needs_lbr_smpl(). This avoids duplicating code
> >> that implicitly enables the LBR.
> >
> > How so? I grep'ed for a minute but could not find what you're referring
> > to.
>=20
> If !(attr->sample_type & PERF_SAMPLE_BRANCH_STACK), then
> event->attr.branch_type =3D 0. If the sample_type is set, then branch_type
> is necessarily non-zero.

Does not compute.. and that appears to contradict whatever Yan Zheng
tries to say. He says that we have branch_type !=3D 0 for PEBS events, and
I couldn't find where that lived.

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs/rNAAoJEHZH4aRLwOS6fukQAI7+44nGflHeYH+fg47WSYXp
NnKgq5rdq0Zshgu9BG8yp2YjM4Lc9su0QTGur1lspaP3cUnMNgFtHuVL1FOcQrNz
W/ivx6d0yLQtB8MAXf3fVqDISFhjiGXbo+5YfCW7uTXOye/2qzuVDAOpdD57w26w
/SW+uV7r00liyJf04DUy1ciaLvrsWmh+nA8soMMHwCCferZNc7MdAlqk+MXkUdZ6
QFACOu8OPdwba6bBk5omKUfLFsocBfa/0BOqRx+Ky7azAFD87ncp1FcNSHIgrxRQ
pvmu96ixh3a1hpQ43JBV7duVZyUE/hBYmMOhLMQ8s1ektKZX6qndFo9F1ILzWBVU
WlSZE48LG1MrHJtidb4Z9p4bigs49Z0PAlOHqTWJxhweJMgH/ZfMAuDQqjzPOGs3
1SNTc6hebejomhTcIars+p7m1QBtKThzM6samzIOM3ojlI1+ieMHEy43vfvMDAwW
QNp6mFgrykE9wSPlNzSg0TdTfr0YPVS8OUCoEbFq8jIkj6KRIumR3VZNEZ5jz6Ze
zqPxgv8RiT8qTRfXyV2hhsbq4cYWvKE3o88wDa3z0cImY68QYlsPlQ7rFEbODq98
YYblGv+06RvtvsKEn6pHPKFMfhXvEjQ8HOMcwB10UeT+kVBvVOG/tjKSNBUp9SE7
4fShj54va+KHTcyD8NBE
=mP1U
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
