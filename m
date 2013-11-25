Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab3KYJAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 04:00:03 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54919 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754101Ab3KYI76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:59:58 -0500
Date: Mon, 25 Nov 2013 09:59:16 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH] clocksource: Do not drop unheld reference on device node
Message-ID: <20131125085915.GA22043@ulmo.nvidia.com>
References: <1382136588-15320-1-git-send-email-treding@nvidia.com>
 <20131122161607.GA5088@ulmo.nvidia.com>
 <528F86F2.40706@linaro.org>
 <20131122192257.GX28642@pengutronix.de>
 <52926F6F.3050104@linaro.org>
 <20131125072923.GB28642@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <20131125072923.GB28642@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 08:29:23AM +0100, Uwe Kleine-K=C3=B6nig wrote:
> Hello Daniel,
>=20
> On Sun, Nov 24, 2013 at 10:28:15PM +0100, Daniel Lezcano wrote:
> > On 11/22/2013 08:22 PM, Uwe Kleine-K=C3=B6nig wrote:
> > >On Fri, Nov 22, 2013 at 05:31:46PM +0100, Daniel Lezcano wrote:
> > >>On 11/22/2013 05:16 PM, Thierry Reding wrote:
> > >>>On Sat, Oct 19, 2013 at 12:49:48AM +0200, Thierry Reding wrote:
> > >>Yes. Sounds like I missed it.
> > >>
> > >>This regression has been introduced by:
> > >>
> > >>commit 326e31eebe61dc838e031ea16968b2cfb43443e3
> > >>Author: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> > >>Date:   Tue Oct 1 11:00:53 2013 +0200
> > >>
> > >>     clocksource: Put nodes passed to CLOCKSOURCE_OF_DECLARE
> > >>callbacks centrally
> > >>
> > >>     Instead of letting each driver call of_node_put do it centrally =
in the
> > >>     loop that also calls the CLOCKSOURCE_OF_DECLARE callbacks. This =
is less
> > >>     prone to error and also moves getting and putting the references
> > >>into the
> > >>     same function.
> > >>
> > >>     Consequently all respective of_node_put calls in drivers are rem=
oved.
> > >>
> > >>     Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutroni=
x.de>
> > >>     Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> > >>     Acked-by: David Brown <davidb@codeaurora.org>
> > >Still all but the hook in clocksource_of_init of this commit was
> > >correct, right? (Well, but this buggy hunk makes the commit log wrong.)
> >=20
> > I don't understand your comment, can you elaborate ?
> My patch added an of_node_put in clocksource_of_init and dropped several
> of_node_puts in drivers. This thread is about the first being wrong. My
> question was if dropping the others was correct.

Yes, it looks to me like the others were correct. A reference on np is
taken by the for_each_matching_node_and_match() in clocksource_of_init()
and released when through the loop, or rather on the next iteration. So
it would be an error to release the reference within the driver-specific
initializations, since they don't take a reference of their own.

Thierry

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSkxFjAAoJEN0jrNd/PrOhdacP/A8GkNRFWq63ADOUu47d0R3b
y0gghyTuIiy451dAWnY2vDX7GEAIsHG8hZAK2sMOOaM3AJaBjQCybSRofNvRk6yL
ltje4davhPxNO1IFiIIRtxDy9tIWkMXt/bqzmVSis3AmW+N8J2Qdh3thd2UTATJO
eEKAFiI7pYts++DHacQBTLBN69zj1dSU9m8u/4igNNLlmASKuVLae7t7r2cROXqj
xbK3T9G1bUkYdPHuyD14UMEFkwjpHwEW351IYiH/ErwzeES22LQNJXJSaU7lKKrN
NwerMRdPcRwwCJfoah8+IWrjZZrhg6KnKdZTK3PdeuLZxX9VWO1nLvwksbtIeGPR
5i3dHGRBE7DnRAMSY9NwSrf0DzbKmkndJ9QdpSfig7yqcodLmeOJ79pYrr23+oUc
VSd+0s8V1LhgbidC9ZG/F4f+e8p/Ivh2LsTTEBlHtuyn1fKo07J+YQYHQ/FPHFDQ
bplPAuQvPLGsouvQMIa3W4NbUX80yzdnyyCIOVx7R754CxDXXtviC+/zuNLmh17E
206VKz7QfYZV3NvafOetutkRhgowzQnq49fj0bT+3y0RXXjD5Kpz6dd3xy2BRX6x
TKMXILdTe0VFwNOmFaUdCOqB7fL+tf4UHdigOUZscOYzAhx5BzIQsCdSwjFpbxS+
MLsaCDn5kAJVyq05vo7M
=CRtH
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
