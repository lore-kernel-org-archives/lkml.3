Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab3A2R56 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 12:57:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485Ab3A2R54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 12:57:56 -0500
Date: Tue, 29 Jan 2013 11:57:43 -0600
From: Clark Williams <williams@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sched: move scheduler sysctl bits into dedicated
 header file
Message-ID: <20130129115743.0f9e67dc@redhat.com>
In-Reply-To: <87vcagv808.fsf@sejong.aot.lge.com>
References: <20130128143120.1b60bfb6@redhat.com>
	<87vcagv808.fsf@sejong.aot.lge.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Yz7FZG7GmkwN.FCUUB2zFrd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Yz7FZG7GmkwN.FCUUB2zFrd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 29 Jan 2013 15:05:43 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> Hi Clark,
>=20
> On Mon, 28 Jan 2013 14:31:20 -0600, Clark Williams wrote:
> > Move all the scheduler sysctl-related bits out of include/linux/sched.h
> > into a new file include/linux/sched_sysctl.h.
> >
> > Signed-off-by: Clark Williams <williams@redhat.com>
> > ---
> [snip]
> > diff --git a/include/linux/sched_sysctl.h b/include/linux/sched_sysctl.h
> > new file mode 100644
> > index 0000000..912adab
> > --- /dev/null
> > +++ b/include/linux/sched_sysctl.h
> > @@ -0,0 +1,121 @@
> > +#ifndef _SCHED_SYSCTL_H
> > +#define _SCHED_SYSCTL_H
> > +
> > +
> > +/* provide a home for sysctl scheduler tuning knobs */
> > +
> > +/*
> > + * default timeslice is 100 msecs (used only for SCHED_RR tasks).
> > + * Timeslices get refilled after they expire.
> > + */
> > +#define RR_TIMESLICE		(100 * HZ / 1000)
>=20
> It seems this line came from sched.h but I can't find that part
> deleted.
>=20

Arggghh! I reorganized the commits and didn't remove RR_TIMESLICE when
I moved it. I'm surprised it compiled.=20

I can generate a new patchset or let Ingo just remove it from sched.h.

Clark

--Sig_/Yz7FZG7GmkwN.FCUUB2zFrd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEIDZcACgkQHyuj/+TTEp0xegCdGdem94QcmY6GWU/EDOiXhBdS
JL4AoIbW3TP/MGsrLR4h/DjEmN5jNqyP
=NDwX
-----END PGP SIGNATURE-----

--Sig_/Yz7FZG7GmkwN.FCUUB2zFrd--
