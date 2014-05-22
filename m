Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaEVHEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 03:04:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:43789 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaEVHEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 03:04:21 -0400
Date: Thu, 22 May 2014 09:04:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ye olde task_ctx_sched_out trace.
Message-ID: <20140522070414.GN30445@twins.programming.kicks-ass.net>
References: <20140521150613.GA28702@redhat.com>
 <20140521151655.GG2485@laptop.programming.kicks-ass.net>
 <20140521153013.GG5226@laptop.programming.kicks-ass.net>
 <20140521153219.GH5226@laptop.programming.kicks-ass.net>
 <537D9EBE.7030806@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3RfTNxEu1XWqbbj+"
Content-Disposition: inline
In-Reply-To: <537D9EBE.7030806@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3RfTNxEu1XWqbbj+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 09:52:46AM +0300, Adrian Hunter wrote:
> > diff --git a/fs/exec.c b/fs/exec.c
> > index 476f3ebf437e..8d51d7ce3dcf 100644
> > --- a/fs/exec.c
> > +++ b/fs/exec.c
> > @@ -1111,6 +1111,7 @@ void setup_new_exec(struct linux_binprm * bprm)
> >  		set_dumpable(current->mm, suid_dumpable);
> > =20
> >  	set_task_comm(current, kbasename(bprm->filename));
> > +	perf_event_exec();
>=20
> Shouldn't that be the other way around i.e.
>=20
> +	perf_event_exec();
> 	set_task_comm(current, kbasename(bprm->filename));

I suppose so indeed.

> Also what about flagging the comm event that corresponds to an exec e.g.

I think it was a mistake to conflate the two concepts, and separating
them into different functions makes things clearer.

--3RfTNxEu1XWqbbj+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfaFuAAoJEHZH4aRLwOS6VjgP/3djwxSJJcl4ZEPLI9lTu2Il
GB0KA/y/YqLJp7GtG2hxT6IyZD6Q0fdKlnJL3DzNTpv+TyZxZZFgjlGKX04MYf/I
isVgbA7XxXhQqwjXFmJxQFyvEpqMvwG0wItsNIZzDR7AWnUiyI0EQBPAV1uEmh3s
p3AsoLsO0CN145Fl4z5IA+1qUSWZ+f8k5ptTaN9e3yT5rpsqgITJpt7bzVSKWZr6
xzk4Cm1gaZBe4MU9Xeuc8dQjcW2op2gqYBEVc9hvmek2SPXhA8WNWuCrg6+HmrZM
cy9AizAzy2WNOwkeoX4Tr+NZcsx/HeqvKeuDU7P6M/VsSxXBgzENF5afusaY2vDx
T9x5r40sCxZN2e2LBcAqZ5TZBP8mVln3LhLfu9uPrquFji/KI8g9zVzTGrLXCEzI
Je5jwuumIa8nE0QK6pfPvYIs6TV2SwBg5wo+hpCYsExcKmG0ak1ec/VPcMBCxD54
NUEvFJS+Vl9XJ9Vp1MDz4DISB0eEPC39lfGwsqB67++MunxHwCWdZjvngB0YLMYC
vU4hNbnHMtHFlBgcO7vSpOrPi2oOkyUUxNAG1GD0oC1OO2jOMvkKDdti1xxHBa+L
h82YtGpCspbWKHDhCmr8WO9uKtIfjYWqd8zCa+e2DLKjKZqTPiVqP5DWwy85+RC/
eWyspiZAl2a+4pXi+j0T
=d+Yx
-----END PGP SIGNATURE-----

--3RfTNxEu1XWqbbj+--
