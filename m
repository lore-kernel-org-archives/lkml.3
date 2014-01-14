Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaANSAV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:00:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54167 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537AbaANSAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:00:19 -0500
Date: Tue, 14 Jan 2014 18:00:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: lgirdwood@gmail.com, Xiubo Li <Li.Xiubo@freescale.com>,
        alsa-devel@alsa-project.org, kuninori.morimoto.gx@renesas.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140114180005.GT15567@sirena.org.uk>
References: <20140114123606.2241d8ab@armhf>
 <20140114142014.GM15567@sirena.org.uk>
 <20140114171258.2d027ee5@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IQvoI1rdlCKiYEYW"
Content-Disposition: inline
In-Reply-To: <20140114171258.2d027ee5@armhf>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: simplify code
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IQvoI1rdlCKiYEYW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 05:12:58PM +0100, Jean-Francois Moine wrote:
> Mark Brown <broonie@kernel.org> wrote:

> > Please send this as a patch series to aid review, one patch doing four
> > different changes is much harder to review.

> As there are other bugs to fix, I may put back the 'of_device_is_available',
> but there are not 3 different changes: I just explain the visible
> effects of the patch. The patch itself is, as the subject says,
> 'simplify code', that is, 'have a simpler code with no change in the
> logic'.

There's several different simplifications going on here, or at least it
sounded that way.  For example creating a private data struct doesn't
seem obviously related to deleting unused fields from the platform data.
The larger a change is the more benefit there is from a series of
mechanical individual updates rather than several at once.

> > >  		ret = asoc_simple_card_sub_parse_of(np,
> > > -						  &info->cpu_dai,
> > > -						  of_cpu);
> > > +						  &priv->cpu_dai,
> > > +					  (struct device_node **)
> > > +						  &dai_link->cpu_of_node,
> > > +						  &dai_link->cpu_dai_name);

> > What's this cast here for?  That code doesn't look at all safe.

> dai_link->cpu_of_node is 'const struct device_node *' and both
> of_clk_get() and of_node_put() want 'struct device_node *'. So, there
> must be a cast somewhere.

> Do you prefer I put these ones when calling the 'of_xx' functions?

No, I think this stuff needs to actually be type safe with no dodgy
casts.  I'm not sure why we're doing an of_node_put(), for the
of_clk_get() it's not immediately obvious why it's not taking a const
clk.  Or perhaps the pointer shouldn't be stored as const.

--IQvoI1rdlCKiYEYW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1XsiAAoJELSic+t+oim9yeMP/jnThYE8FYGnXYoruMF/XFwd
u2jIZEeHVW/xDGMKYA7P1JhBuviGMPiWtAuL8ypFHX5MEsY81wZ55igYOdQHfCeX
e1Gsd07I7tMN1KvWURh5lWhEA2Bsmz3/C1vYgOW3ps/vONFyQBbaZY9J4mPqwNuo
wATxZcga/Eicr89DDyU6hbPlFnI3TAIJLAmpLLyVd73NoDlqNyhdBjVpLBeMIrO4
lfuJ97blj+WpvRTX/valnxp0OlGpo0Suw1SNtwjbb69pQ+ScjMKKsVGYBOxzjrc5
v33igqiSZGrMcyR6Gr9kuJTmVukw4E9ledQyo5uc3XIaes9zXyp7lezjHNVgtCFu
Q+4n6d70BST1bZGMMYGukuopGWne0xpHC1o86VhXSFAFigcOBoS1afIDC4mEHKv9
yKOaSXL/Wy6y+Mdyp7S106O0ndPF937tEL6ohghpVvP8QyRSys6q1Kcjkrd/Hatg
l7LhCpjkSm30sOKLOgt7xYyDgELUmcL713Rqji4KbICfqu2rjCqcxhk5Hx014Ekk
Ysq7dwdWFElu4Hd237Cn4Rv0RqA2gUzaaF2zZJAz0Y913WfpThYfB+PMRTYaCt4Z
JguTxquGhYgyvnu9inLzVkUoS6hM5dpxVVeglYow+T3hmhjbJiO1WO96QrdVNOFj
QE/h14u53Pjqc45zsxI3
=ndoj
-----END PGP SIGNATURE-----

--IQvoI1rdlCKiYEYW--
