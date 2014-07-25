Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885AbaGYQGG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 12:06:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60681 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbaGYQGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 12:06:03 -0400
Date: Fri, 25 Jul 2014 18:05:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mikey@neuling.org, mingo@kernel.org,
        pjt@google.com, jhladky@redhat.com, ktkhai@parallels.com,
        tim.c.chen@linux.intel.com, nicolas.pitre@linaro.org
Subject: Re: [PATCH] sched: make update_sd_pick_busiest return true on a
 busier sd
Message-ID: <20140725160549.GD6758@twins.programming.kicks-ass.net>
References: <20140722144559.382c5243@annuminas.surriel.com>
 <20140725152728.GB6758@twins.programming.kicks-ass.net>
 <53D27B7E.8090404@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qi9i1S6E/JzMSUse"
Content-Disposition: inline
In-Reply-To: <53D27B7E.8090404@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qi9i1S6E/JzMSUse
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 11:45:02AM -0400, Rik van Riel wrote:
> > So for !ASYM the code is effectively:
> >=20
> > return sgs->avg_load > sds->busiest_stat.avg_load;
> >=20
> > I'd like to at least add a clause that makes overloaded groups=20
> > prioritized over !overloaded groups.
> >=20
> > Also, like we found earlier, calculate_imbalance() relies on the=20
> > sum_nr_running > group_capacity_factor thing, which you've just=20
> > 'wrecked', so we'd need an update to that part too.
>=20
> I guess that would mean update_sd_pick_busiest would look like
> this for the !ASYM case:
>=20
> 1) remembering whether busiest is overloaded
>=20
> 2) if (sgs->busiest_stat.overloaded && !sgs->overloaded)
>             return false;
>=20
> 3) if (sgs->avg_load > sds->busiest_stat.avg_load)
>             return true;

Right. So the situation I was worried about is where we have say 8 +nice
tasks in one group and 2 -nice in another. So the group with 2 tasks can
actually be 'heavier' but not fully utilized. In that case we want to
pull tasks from the lighter but overloaded group.

--qi9i1S6E/JzMSUse
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT0oBdAAoJEHZH4aRLwOS6KXUP/0ZKT/ABJYMAD1WCxl0bkxE8
N+STBZtj4Pfcp3OJbwYfbnhLCRELFPQnY0HGwI1dzw7VEHJbpBb8JcMqbzj1dAg3
Nn2wImXW4AAXsEtrZ/cy0Zp3UYpC6Lkhx3xo8Ya392byVoPoAO6Eoxun4CnlyLbe
Mf+e2oqSCMYJVghwngX9aiDGk0dj/eyIY4QSXZSC8mdkEMaD7NYTpNiATNP5fvjV
3dolaLM+PGrOA86NcUprpElb1kikZJ+jLPfBBCQ3oS2dyK9ZXKaZvtJbmr7dp9Wg
hVMCz9wgRjtZps6jcuTia7tZj5j4EVF88RPaolMNMN83h/6KXgO9VonM6zKmnlZS
0R2IWe4Ekhck5Ec59NxOZzYTd4vYBVLDfToPhiKTN1TmUt5mKMTGmA/kdGZK30KR
+jtbpBkZX/wjDwsSsdBuZhNQeZ2mHrhJO8REXgqnElNSdIYxnmwsJh8NL4+vrtJ7
8e1WYuOIKYmRL9tVC+NxIR/1UonlKJ6oDD3Wth6mZ88monztRYile+LE57I+eO+2
g+8QqM5FewhmcquyZmSxzRhfZUjO/Qp1DjXcipz44TUfMxS8ea8OpQcE9DgA5wrG
TV/Wkvih7o/a8s14swnsxlmSvWR59cztJ3rHYF6synr9mIlP6fGRDVvQMPFwTjPE
GClhbWeFQGN9WXx8lB8U
=d+pI
-----END PGP SIGNATURE-----

--qi9i1S6E/JzMSUse--
