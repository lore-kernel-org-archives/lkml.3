Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3KYJF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:05:26 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:36791 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3KYJFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 04:05:21 -0500
Date: Mon, 25 Nov 2013 10:04:40 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] clocksource: Do not drop unheld reference on device node
Message-ID: <20131125090439.GC22043@ulmo.nvidia.com>
References: <1382136588-15320-1-git-send-email-treding@nvidia.com>
 <20131122161607.GA5088@ulmo.nvidia.com>
 <528F86F2.40706@linaro.org>
 <20131122192257.GX28642@pengutronix.de>
 <52926F6F.3050104@linaro.org>
 <20131125072923.GB28642@pengutronix.de>
 <52931103.7030107@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vEao7xgI/oilGqZ+"
Content-Disposition: inline
In-Reply-To: <52931103.7030107@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vEao7xgI/oilGqZ+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 09:57:39AM +0100, Daniel Lezcano wrote:
> On 11/25/2013 08:29 AM, Uwe Kleine-K=C3=B6nig wrote:
> >Hello Daniel,
> >
> >On Sun, Nov 24, 2013 at 10:28:15PM +0100, Daniel Lezcano wrote:
> >>On 11/22/2013 08:22 PM, Uwe Kleine-K=C3=B6nig wrote:
> >>>On Fri, Nov 22, 2013 at 05:31:46PM +0100, Daniel Lezcano wrote:
> >>>>On 11/22/2013 05:16 PM, Thierry Reding wrote:
> >>>>>On Sat, Oct 19, 2013 at 12:49:48AM +0200, Thierry Reding wrote:
> >>>>Yes. Sounds like I missed it.
> >>>>
> >>>>This regression has been introduced by:
> >>>>
> >>>>commit 326e31eebe61dc838e031ea16968b2cfb43443e3
> >>>>Author: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> >>>>Date:   Tue Oct 1 11:00:53 2013 +0200
> >>>>
> >>>>     clocksource: Put nodes passed to CLOCKSOURCE_OF_DECLARE
> >>>>callbacks centrally
> >>>>
> >>>>     Instead of letting each driver call of_node_put do it centrally =
in the
> >>>>     loop that also calls the CLOCKSOURCE_OF_DECLARE callbacks. This =
is less
> >>>>     prone to error and also moves getting and putting the references
> >>>>into the
> >>>>     same function.
> >>>>
> >>>>     Consequently all respective of_node_put calls in drivers are rem=
oved.
> >>>>
> >>>>     Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutroni=
x.de>
> >>>>     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >>>>     Acked-by: David Brown <davidb@codeaurora.org>
> >>>Still all but the hook in clocksource_of_init of this commit was
> >>>correct, right? (Well, but this buggy hunk makes the commit log wrong.)
> >>
> >>I don't understand your comment, can you elaborate ?
> >My patch added an of_node_put in clocksource_of_init and dropped several
> >of_node_puts in drivers. This thread is about the first being wrong. My
> >question was if dropping the others was correct.
>=20
> Yes, Thierry's patch removes the of_node_puts but I am also wondering if =
we
> shouldn't just revert the patch 326e31eebe61dc838e instead.

I don't think that's necessary. Dropping the other of_node_put()s looks
like the right thing to do. They drop a reference that they haven't
taken themselves, which is usually not correct. I can't find anything
wrong with the rest of that commit.

Thierry

--vEao7xgI/oilGqZ+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSkxKnAAoJEN0jrNd/PrOhPxgQAJJnoCYDOsZFY4OB7+0Ha6nZ
bFM01da6Ddrr93O4ZSqnPkstKAY2Egmwb8JrtBfaynMPbYrk1Ojau1hDOzAgo1ml
/iI3mt3UFAdfZOah9eroucqC+iNGNg9yjzAMb7y+OeUe1+mgQbfPrR50ThY1Hy5l
rqydqOhw1pjDi5yLYOpDT5gAXH7GED081PFL+54N/s8ytb2oDDt2Bbwksmt23Vzq
Bx7lyDEMNboPUksvtos/70vgi9b7bx4olXIIjzocsL0BciTMmT2VpfYbnO1KKQVl
pEpuWCvqP00T9cEfPtEhkc1d9t6ZEYMzSbk0vGi1MMA+MGlfs7CZ/xnYwgeu/SOz
LDA756NOcv762N3RmvO2lfPKxiuh4tLS3m6br8rGa+bmQgogbMwvKAymzcbhxe+E
DxsgThghnSAyA+gy+U3v+ArYJoI+quv01W+g9cKQk656C8gyX0myWYjCdfEl9YsF
7EXNeMMVFjnGFvarBPX44C/AjtWaRmGexEzPWFxjS8+sGZZDxH0tcS8GzhXfxmIX
UXz6V/KLq8Ff0RPUXjpmfgcKpo/B64L83h0PUehK5vbKTV/c5kEwFUIjdg2O1AkZ
kAHIBbBr/OKneaN6NUF3sv91QCqxw7KGB0yiGXWl0M/n+nHTVWqARZgXfxz4hXz3
skKkHW5wEZgXFYc6asvR
=LVbx
-----END PGP SIGNATURE-----

--vEao7xgI/oilGqZ+--
