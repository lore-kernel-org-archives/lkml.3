Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaEUR1U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 13:27:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35542 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbaEUR1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 13:27:19 -0400
Date: Wed, 21 May 2014 18:27:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, s-anna@ti.com,
        loic.pallardy@st.com, lftan.linux@gmail.com, slapdau@yahoo.com.au,
        courtney.cavin@sonymobile.com, robherring2@gmail.com, arnd@arndb.de,
        joshc@codeaurora.org, linus.walleij@linaro.org, galak@codeaurora.org,
        ks.giri@samsung.com, Jassi Brar <jaswinder.singh@linaro.org>
Message-ID: <20140521172701.GV12304@sirena.org.uk>
References: <1400134105-3847-1-git-send-email-jaswinder.singh@linaro.org>
 <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bnwoLX+t3cc59+J0"
Content-Disposition: inline
In-Reply-To: <1400134260-3962-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv5 2/4] mailbox: Introduce framework for mailbox
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bnwoLX+t3cc59+J0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 15, 2014 at 11:41:00AM +0530, Jassi Brar wrote:
> Introduce common framework for client/protocol drivers and
> controller drivers of Inter-Processor-Communication (IPC).

This looks pretty nice, though I do have a few *very* small nits beyond
those Arnd had.

> +	if (chan->cl->tx_block && chan->active_req) {
> +		int ret;
> +		init_completion(&chan->tx_complete);

reinit_completion().

> +	if (!cl->tx_tout) /* wait for ever */
> +		cl->tx_tout =3D msecs_to_jiffies(3600000);
> +	else
> +		cl->tx_tout =3D msecs_to_jiffies(cl->tx_tout);

Is the default wait for ever the best timeout - I'm not sure it's best
=66rom a defensiveness point of view.  It should be fine either way,
it's just a matter of taste.

> +	ret =3D chan->mbox->ops->startup(chan);
> +	if (ret) {
> +		pr_err("Unable to startup the chan\n");

Perhaps print the error codes?  Might be helpful to users.

> +	/* The queued TX requests are simply aborted, no callbacks are made */
> +	spin_lock_irqsave(&chan->lock, flags);
> +	chan->cl =3D NULL;
> +	chan->active_req =3D NULL;
> +	if (chan->txdone_method =3D=3D (TXDONE_BY_POLL | TXDONE_BY_ACK))
> +		chan->txdone_method =3D TXDONE_BY_POLL;
> +
> +	module_put(chan->mbox->dev->driver->owner);
> +	spin_unlock_irqrestore(&chan->lock, flags);

Is the module_put() safe in atomic context?

--bnwoLX+t3cc59+J0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfOHiAAoJELSic+t+oim9N30P/36gHpXHVbJI6IlRMNuhE4La
l2uOWjNC2x+p+9EYAKWsTwJsgrA6UZdpAs6Yzy7QagNtz141uuUgGewvtRFnlBCO
2ogvfiG01BXhduqGM1E/VXI3hCmGAwIzsskZ5mw7xMTHRhxXWRJzLpOYt7QEvQCJ
KOFU7WnP8n74k6TwhTaxqROAxb/jXkoSCC0vXY/hjBhCeVdhPu0Kl7ZbvCaBkvh3
X/7HfFzSsRObBloQ1FyM/CKBRRKKHHiEdpkz1j68ROk6+h24DF8kq9z1XDqRRPTo
+o3WC0dhhFywMjcm9k+qiCZgNO+b4i7JUjz4x/0f/cEnbF/P3O5+2OGnzjIZRVKx
cVekp7qkP8OHnbr+YoWIiiUO0JtSuSuPqlpReI7MuZGDcM3g2/S6s8lmUa10iScs
8ckEc+ezuS+j+kODHXwduL0bP0p3l9Gu0Sj9vQ1Oo3/79INYLj0iaEXOYyzjw7CB
6CH/VuZBLRSiIPv0TvaP7Qz5NhsGL3mZn2SeJfGc5Hm7CCT4n955C+EJbjC/i1zH
i6RWelXFwcD0A+oQaGYBtg2h6g1zR2z3YvACJ72MjddgBkEuW8JQIuEfBJBeH9v8
dfS0fMWWnV9LSfORQVADDehj32aguIoBoL5HZnoXX5Apzj8RSmOf64pEgC88VeQI
GarCW/dGouBlbQhvMn5s
=c5Rv
-----END PGP SIGNATURE-----

--bnwoLX+t3cc59+J0--
