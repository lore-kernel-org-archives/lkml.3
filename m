Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab3GOPJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:09:39 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40979 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3GOPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:09:35 -0400
Date: Mon, 15 Jul 2013 16:09:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        rob.herring@calxeda.com, lgirdwood@gmail.com, shawn.guo@linaro.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        rob@landley.net
Message-ID: <20130715150928.GI11538@sirena.org.uk>
References: <1373604855-17714-1-git-send-email-b38343@freescale.com>
 <20130712144037.GJ24508@sirena.org.uk>
 <20130712161511.GA21203@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4LwthZj+AV2mq5CX"
Content-Disposition: inline
In-Reply-To: <20130712161511.GA21203@Robin-OptiPlex-780>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: pfuze100: add pfuze100 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4LwthZj+AV2mq5CX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 13, 2013 at 12:15:12AM +0800, Robin Gong wrote:

Please fix your mail program to word wrap between paragraphs.

> On Fri, Jul 12, 2013 at 03:40:37PM +0100, Mark Brown wrote:

> > > +static const int pfuze100_swbst[] = {
> > > +	5000000, 5050000, 5100000, 5150000,
> > > +};

> > This looks like a linear map, the steps are all 50mV?

> Yes, but the swbst regulator share the same define type with the vsnvs
> regulator, and the later voltage table is not linear, so I use
> volt_table in swbst regulator . I don't want to  add another regulator
> type for this.

You should do so; it's not hard.

> > You should just register all the regulators rather than only registering
> > those that the user explicitly selects.  This allows users to inpect the
> > current configuration and simplifies the code - for example you don't
> > need to count the DT nodes and you can just have a simple array in the
> > platform data (see how wm831x does this for an example).

> Yes, it will simplifies the code, but sometimes we will not use all
> the regulators on boards, in this case, Is it better that only
> register the available regulators?

It's better to have everything, that way the framework can do things
like power down unused regualtors that got left enabled.

> > You should really be doing this on a copy of the regulators table rather
> > than on the table itself.

> everyone of the four regulators(SW2~SW4) has two different linear
> voltage table which decided by the specific bit(one regulator ,one
> different bit) . So  will modify the voltage table dynamically before
> regulator register. I think this way is more simple , although looks
> little weird and uncomfortable.

You're missing the point here.  You shouldn't be modifying global data
(which should be marked as const) at all, you should be working on a
copy of it if it needs modifying.

--4LwthZj+AV2mq5CX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5BClAAoJELSic+t+oim9mV0P/RzMvdKJZf9ShSrVbMD/voMd
NjzL+U56WlO+pcWnK+g8UcImz1mNvQ8RXBQvCrpCgDZbEPAKzbyfholgAzXnB9BH
OvOaivUX6M1sjxQe+7qNi0kUt+T2GuB9YJHw51g4KxRzD2nkdu/IzDD19cHWC5GE
lxTSO+5P+Cw7XomMweg+iG5p1ivHBbFEv4vaiqDY9Y2Avv2hLvp6dAjeMoCZjqFe
o8hxvMsF+R/xLyQEojwW0dNESJBYFJZws3i5hjCWANaUTZEHVNzoUvDTZKY+P7wd
dpnp3qgGSNGMPbGlY5IaeLYWLid9KDaySSNACxderUl4n7dT76wiJ4Dyt8pdXuxZ
xXiaE4PKabn95VXLCw0r/Gh+4hrCPjuhVZZY8MTg7QAR025l0PWm8RN3kyNPetDI
DP6U7bnH9N9R8G4o5U0cCU/GeiWkHrbcEZ2FJaTS15kX7RRyOajJZWKzCLumhEDF
l3Nx3xtBwAcXXnitvNzHusPaUX6/rpd4cbGwf2v+TpX3EV3TVymNT6AMaW2FrZMw
4JfLoCE0jkHLSyZMpdcvj2Xv/GByXPOP/MuLH9YeHWLJjz6oAXnFe3AnnpLKeVmg
7IwnqxzQfuMF+VAIYdLIFndB9/35IYhNOeKdkGWs5bTz/ii5FM4m8Pgk1QQDzkIv
orQb6BmowYMEsWM8aR0M
=dHUS
-----END PGP SIGNATURE-----

--4LwthZj+AV2mq5CX--
