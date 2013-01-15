Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab3AOPoi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:44:38 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54265 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab3AOPoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:44:34 -0500
Date: Tue, 15 Jan 2013 16:44:23 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130115154423.GA13871@avionic-0098.adnet.avionic-design.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <1357371910-3164-3-git-send-email-ldewangan@nvidia.com>
 <20130105080658.GA1315@core.coreip.homeip.net>
 <20130106192739.GA11566@avionic-0098.adnet.avionic-design.de>
 <20130106195748.GA28212@core.coreip.homeip.net>
 <20130109070745.GA12782@avionic-0098.adnet.avionic-design.de>
 <20130109091939.GA4369@core.coreip.homeip.net>
 <20130109092352.GA28037@avionic-0098.adnet.avionic-design.de>
 <20130114154959.GA25049@avionic-0098.adnet.avionic-design.de>
 <20130115130623.GC2625@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20130115130623.GC2625@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:HofL2F16/aAgMB0pKBLw6RJH1fPtKAKuQJLbI9pj7I8
 dbictmneGjc/mTynNXsYG4ZBTC/qVkFUIDLlip/QutYQw/w4uK
 yUGLE5CRtwyNPRaTBdjse2pd5OQq6YqQobpp0Nq+c2jw6q9HX0
 GK98Dy0eXQqEK6U2BmnEXtjxFVAT2bHn6yCLIfwVbgXVGc8uWK
 /XpvUDcXpPuYfnlnUuKUFODquHVS94tNobo84QtfNSXeKru2MQ
 Pjj/S/BiNSLdgyJaoeioodGE7d8Zupj15VeiUvVIy2JbV/312C
 bxp0AXUJFeX9lWs2puaWlxkOE+dUTg7B71DlfAsRH551wNl5yy
 nZq+YZlFPz3GRo40v3obHgJAAjJSOUBkXjKyGVjvYjBrCoG17U
 IkIXZ10NCiB8+IDApdwG2kRJnvJ9vMdVCkg3dtoqEU7A8MhvuL
 +IVrf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 02:06:23PM +0100, Wolfram Sang wrote:
> Hi,
>=20
> > > > > > I am sorry, but I do not consider a function that was added a l=
ittle
> > > > > > over a year ago as a canon. If you look at the uses of EADDRNOT=
AVAIL it
> > > > > > is used predominantly in networking code to indicate that attem=
pted
> > > > > > _network_ address is not available.
> > > > >=20
> > > > > EBUSY might be misleading, though. devm_request_and_ioremap() can=
 fail
> > > > > in both the request_mem_region() and ioremap() calls. Furthermore=
 it'd
> > > > > be good to settle on a consistent error-code instead of doing it
> > > > > differently depending on subsystem and/or driver. Currently the v=
arious
> > > > > error codes used are:
> > > > >=20
> > > > > 	EBUSY, EADDRNOTAVAIL, ENXIO, ENOMEM, ENODEV, ENOENT, EINVAL,
> > > > > 	EIO, EFAULT, EADDRINUSE
> > > > >=20
> > > > > Also if we can settle on one error code we should follow up with =
a patch
> > > > > to make it consistent across the tree and also update that kernel=
doc
> > > > > comment. I volunteer to do that if nobody else steps up. I'm also=
 Cc'ing
> > > > > Wolfram (the original author), maybe he has some thoughts on this.
>=20
> Handling the error case was the biggest discussion back then. I
> initially did not want to use ERR_PTR, because I see already enough
> patches adding a forgotten ERR_PTR to drivers. My initial idea was to
> return a simple errno and have the pointer a function argument. I was
> convinced [1], however, that the dev_err printout is enough to make
> visible what actually went wrong and return a NULL pointer instead. So
> much for why the function does NOT return a PTR_ERR, and I still prefer
> that.
>=20
> Then, I added the example code in the documentation using EADDRNOTAVAIL.
> Yes, I was brave with this one. Yet, EINVAL, EBUSY, ENOENT, did not
> really cut it and are so heavily used in drivers that they turned into a
> generic "something is wrong" error. I tried here to use a not overloaded
> error code in order to be specific again. Since the patches were
> accepted, I assumed it wasn't seen as a namespace violation. (Then
> again, it probably would have been if that error code would go out to
> userspace) Naturally, I didn't have the resources to check all patches
> for a consistent error code.

The problem with the current approach is that people (me included) keep
telling people to use this or that error code in an attempt to achieve
some kind of consistency. Also using an error message to distinguish
between reasons for failure makes it impossible to handle the error
other than by visual inspection. Granted, there are currently no code
paths that require this.

One problem with the original patch was also that it didn't actually
convert any existing uses, so there was little chance of anyone noticing
potential problems. More than a year later this function is used by many
subsystems and a lot of drivers. It just so happened that I observed how
many people just didn't know what error codes to choose and often just
grabbing one randomly.

By adding devm_ioremap_resource() and having it return ERR_PTR()-encoded
error codes we get rid of all these problems and put the responsibility
for choosing the error code where, in my opinion, it belongs: the
failing function.

> > > > If you going to change all drivers make devm_request_and_ioremap()
> > > > return ERR_PTR()-encoded errors and then we can differentiate what
> > > > part of it failed.
> > >=20
> > > Yeah, that thought also crossed my mind. I'll give other people some
> > > time to comment before hurling myself into preparing patches.
>=20
> As said above, that was argued away when committing the patches.
>=20
> But there is more to that:
>=20
> When working with this function, there was also the idea to abstract
> getting the resource away. Which then gave Sascha Hauer and me the
> question, if drivers really have to do this or if this couldn't be done
> by the kernel somehow, i.e. giving the drivers already the resources
> they need, completely prepared.

I'm not sure I like that very much. That could possibly lead to a new
problem where drivers that need to do something special have to jump
through hoops to achieve something that may otherwise be simple.

Anyway, if people don't think this is a sensible conversion I should
waste no more time on it. On the other hand I have the patch series
ready so I might as well post it for broader review.

Thierry

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9XlXAAoJEN0jrNd/PrOhh9UQAK0B8uBj+nhk8NTmPxVI65jv
8Zdt7CGm/lQF4gv+pNX07dQ21HQ298RcZEOxfciNRWqRYeS6vl2NUTDmyXK8SGBs
2llQPH/2MU7aRlxYhqZGJxtLOhV+J7LHQ1rHkVrtEXC+AsNfs+MzsrsOmaDpcFF7
WX6p14L0+AlCsctGHuIEWapgsDD1kZrdrPrUz694srUyMi0o9PMugE2JRtBi6ChU
UAePUOxQ91Lafht9xHOCJksoYWUNsfTVwkKXUKAIINJsJozu4CBHklTKSsyFJYSA
TkIHo5CBJI+cvMdkzveeyVvYWkUdHxbrWAiIS9sBnh659DcDVmTcIlHlBkFDl39s
Ynqx8+Um4F12259/z5pgJH5SQaDt5UNR67Ef434bLXqPyMX3QyLWPgZazvLCDosC
vWPK1YR7lC4b2gqePjqxe8RsJFo7KnNRfpU1lowl62Jz2pLLppTJwUm7OjCMaufr
fZSX0ghzzvzrIcjah91M6Ia9oEZMScGwIfMJ87TV25lbIeIR1tRVtWcG0UJ/WYIn
ZlDG1egRIdRVZT1OVB0KtTOooHZ5tci58GwLtSFaTfbPr0fgLsDl73gtq0FNse7z
jKve1yrPve37PFgX7ARaCJBhep02s7Gs5piasfnvqNWWUKBslZnYN+DTE2wFYOlY
Q3LIpORpa2YjVmbabBor
=x7DQ
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
