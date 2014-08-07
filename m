Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbaHGNPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:15:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:47189 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757399AbaHGNPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:15:47 -0400
Date: Thu, 7 Aug 2014 15:15:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON_ONCE(in_nmi()) hit in irq_work_queue_on
Message-ID: <20140807131536.GU9918@twins.programming.kicks-ass.net>
References: <20140806162113.GC14261@redhat.com>
 <20140806164633.GY3935@laptop>
 <20140806165610.GB12054@laptop.lan>
 <20140806170151.GC12054@laptop.lan>
 <20140806234456.GA17015@localhost.localdomain>
 <20140807081321.GI19379@twins.programming.kicks-ass.net>
 <20140807125852.GA19662@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H3rjvnIlNW8PJoxD"
Content-Disposition: inline
In-Reply-To: <20140807125852.GA19662@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H3rjvnIlNW8PJoxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 07, 2014 at 02:58:55PM +0200, Frederic Weisbecker wrote:
> On Thu, Aug 07, 2014 at 10:13:21AM +0200, Peter Zijlstra wrote:
> > On Thu, Aug 07, 2014 at 01:44:58AM +0200, Frederic Weisbecker wrote:
> > > In fact the problem has arised since the recent irq work patches I di=
d.
> >=20
> > No, those just added the WARN, previously we send the resched IPI, and
> > that's equally wrong from NMI context.
>=20
> Well the scheduler IPI was rather used for remote kicks before we had rem=
ote irq
> work. This includes local kicks as well as the caller could need to kick
> anywhere. As in inc_nr_running().
>=20
> But for strict local kicks, as in perf, we were using tick_nohz_full_kick=
() which has
> been using irq work for a while. But it got broken when we replaced it to=
 call irq_work_queue_on
> instead of irq_work_queue.

OK, clearly I made a mess of things in my head ;-)

--H3rjvnIlNW8PJoxD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT43v4AAoJEHZH4aRLwOS6VWoP/1fvlo4eWGR4T6N1eWbVXJg6
PxSoivOQTHL+uFzflv5CVoPsUC9PYMbobMQQgn4GOpVAfPTy2w3APWU21vWrzl1M
DNOVbVAsSh7Xj4jQjyZ0nPrMMEixVHgVZZUZgyiyt+ohyMj2BVv+vN0uc/LQuvkO
pJRriURwP70gGrY6792XNIq3WtgJk15djEooDLNTUGSOsDb7bmzGJ0nvf6VJBrL8
+rr54dLwptRqlt30eFpgyGK/ARMje8jBnvUJivY+ssSHTl4IELVOmrhLukpuQBQr
fLGKpsVFcnBjTZlPrzpAIDcEL7eD7yoHhOUzH4/NNVGEQKaUd/IXVO1qTXk7AY17
D2RBEtj/0//wrPi/KEvpR1a5ye96B0FOuuxUbnA4Da79l9puFsoX2YBdLdbAcO1F
qLUOU7zM72anulkFaBEgfTpCN8q/lcDCX4LQh5QiO0iz6zbB7/XXIXHOlSOi1ZeK
N/EgjR6m6fdCWdFjCEiOkfxBD/9QqmBfhvxYCAPBu/QEtQo4+blNQXePReo8SMF8
vbY3p3xQlQNwiDUBKtT9WvQtCwVu40B3U6wbffkcx549sbE+f990JqhpO9RKDcsI
FfkHT9Z8u6/rPj/wKlgVByMq+a2iYcxTgboX6ta+f8n+/IhGR8NBMMy6tMlSvAEg
PRZ4imZeb2KCamV3YSlZ
=00Qu
-----END PGP SIGNATURE-----

--H3rjvnIlNW8PJoxD--
