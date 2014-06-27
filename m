Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaF0XKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:10:34 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:42142 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaF0XKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:10:31 -0400
Date: Sat, 28 Jun 2014 01:10:27 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 5/5] clk: Add floor and ceiling constraints to clock rates
Message-ID: <20140627231026.GA26184@ulmo>
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com>
 <1403855872-14749-6-git-send-email-tomeu.vizoso@collabora.com>
 <53ADF6E6.6090705@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jI8keyz6grp/JLjh"
Content-Disposition: inline
In-Reply-To: <53ADF6E6.6090705@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2014 at 04:57:42PM -0600, Stephen Warren wrote:
> On 06/27/2014 01:57 AM, Tomeu Vizoso wrote:
> > Adds a way for clock consumers to set maximum and minimum rates. This c=
an be
> > used for thermal drivers to set ceiling rates, or by misc. drivers to s=
et
> > floor rates to assure a minimum performance level.
>=20
> > diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>=20
> > +static struct rate_constraint *__ensure_constraint(struct clk *clk_use=
r,
> > +						   enum constraint_type type)
>=20
> > +	if (!found) {
> > +		constraint =3D kzalloc(sizeof(*constraint), GFP_KERNEL);
> > +		if (!constraint) {
> > +			pr_err("%s: could not allocate constraint\n", __func__);
>=20
> Doesn't kzalloc print an error itself if the allocation fails? I've
> certainly seen quite a few patches ripping out custom "allocation
> failed" errors in code.

Yes, these are unnecessary. There's even a checkpatch warning for this
construct nowadays:

	f9a5a624f414 checkpatch: attempt to find unnecessary 'out of memory' messa=
ges

Thierry

--jI8keyz6grp/JLjh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrfniAAoJEN0jrNd/PrOhXFoP/A/g7IhACYwoCK8SCH+u0m7f
z66vYKnBUokZnGZfJMoWqxhWCZH9Ws1gG49iZwt4AhDKYKZUg/3kIx3QhSBE6aZt
XWXEsKrCVoDMLRGkiOQpsVQB7RN7uRqFgP199cc45+QFaonbNKrmVl4opM7ABWkm
CUSD9HSC3X6YvwF/y4/YO1iwwRT2MhfyMfVEdmrxFJv/9ICGaz1qFAIzTwk8oV5s
rTz8WY7JubgiHsO6Ju4lHgq4KOhxC103b2nyv6NYu3EA8/0WcVTwmCKfJkgYRQH+
u8Nx0bP3nScJmSU9e8fbus4gjQ3f/2NyvgcOqLAfZnrSxWLxCHV/XIXKVCmEBxMv
dU9zE9rTWUKMKP1pyXyUgz4O6FU35eCI2TdaxQs1XBIAoco+Usk+Ox8UYgOeoB57
Q50g9/n6vp3pYEhkY7vEYbR7wNOVw7AsFg3TS5RJiGIt1kb5562oP6PFkLBIzPld
d3i5ciP37cXrqGumwQ78+9N1Xg9xQWgJ8hGe8cvWKyUkT8TK1sVgX8Z7Gx0mboy9
YL7mZI1WVt6hupnhcYY7geQLU+Je8UZuTuUQBv+Pzj9Bc0XRDxmU+Mbl6jdQTYZd
/U2bYN819vfCcebKl13/Zgpoj4dReHhFkP6ywa+LRsMMzNPxahVjtmBnoY8elS8b
wrl9BmcAEprpDS85wXmW
=oRjS
-----END PGP SIGNATURE-----

--jI8keyz6grp/JLjh--
