Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964890Ab3BMVaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 16:30:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60232 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649Ab3BMVaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 16:30:13 -0500
Date: Wed, 13 Feb 2013 22:29:51 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Rob Herring <robherring2@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Andrew Murray <andrew.murray@arm.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130213212951.GA27849@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-2-git-send-email-thierry.reding@avionic-design.de>
 <511949C7.7070604@gmail.com>
 <20130212064523.GA28850@avionic-0098.mockup.avionic-design.de>
 <511BA1E0.9000404@gmail.com>
 <20130213142521.GA6223@avionic-0098.mockup.avionic-design.de>
 <511BEF8D.7060506@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <511BEF8D.7060506@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:+PJMmAzFHQLuk9tnpgg0oHi8F4eWFUil7DTkqa6+hxI
 ueTWG1p8ILVIJA/E1LXXq3znyNOCYJPxLM2UvLAm/vRkqoBaPq
 qd1v5tNPQJKxdnrBw9gpNFp+qXEM0lRAW4aE/D5fxYmhIB9ksF
 0pjNIEklnr+7R8up5DdQPI+NCmmfWcU+VbGz5RJQsoG0j9j7nz
 U9zLwfav8ycELi/mmpXy3YfbAc+3Uzklv7jMC1yJXH1LMCz6Yx
 4v8rZ12qZdhMoO1GpDaTFuMC2CMpBdE+7ofqrAZUbsvKjItGuF
 ExgZB6yfA0CSiFspM4hEr9A3qVl5CusPdh2OoxtTffAmyHayq/
 DmT6QE9BzNq4SCZJecl2o08Hrf3/7amzLxF4/gAJdoVoO9F8z9
 EDk++mMZjdYNgMqhTxRrSyF7iIfuCbM9A4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 13, 2013 at 01:54:53PM -0600, Rob Herring wrote:
> On 02/13/2013 08:25 AM, Thierry Reding wrote:
> > On Wed, Feb 13, 2013 at 08:23:28AM -0600, Rob Herring wrote:
> >> On 02/12/2013 12:45 AM, Thierry Reding wrote:
> >>> On Mon, Feb 11, 2013 at 01:43:03PM -0600, Rob Herring wrote:
> >>>> On 02/11/2013 02:22 AM, Thierry Reding wrote:
> >>>>> From: Andrew Murray <andrew.murray@arm.com>
> >>
> >>>>> @@ -13,6 +13,7 @@
> >>>>>  #define OF_CHECK_COUNTS(na, ns)	(OF_CHECK_ADDR_COUNT(na) && (ns) >=
 0)
> >>>>> =20
> >>>>>  static struct of_bus *of_match_bus(struct device_node *np);
> >>>>> +static struct of_bus *of_find_bus(const char *name);
> >>>>
> >>>> Can you move this function up to avoid the forward declaration.
> >>>
> >>> It needs to be defined after the of_busses structure, which is defined
> >>> below the CONFIG_PCI block where of_pci_process_ranges() is defined. =
I'd
> >>> have to move that one as well and add another #ifdef CONFIG_PCI secti=
on.
> >>> If you prefer that I can do that.
> >>
> >> Okay, it's fine as is.
> >>
> >>>>> +static struct of_bus *of_find_bus(const char *name)
> >>>>> +{
> >>>>> +	unsigned int i;
> >>>>> +
> >>>>> +	for (i =3D 0; i < ARRAY_SIZE(of_busses); i++)
> >>>>> +		if (strcmp(name, of_busses[i].name) =3D=3D 0)
> >>>>                                               ^
> >>>> space needed.
> >>>
> >>> I don't understand. Do you want the space to go between '.' and "name=
"?
> >>
> >> Must have been some dirt on my screen... Never mind.
> >>
> >> I'll apply these for 3.9.
> >=20
> > Great, thanks!
>=20
> Grant vetoed merging. We need to see the other architectures using these
> functions rather than add yet another copy.

I think I've said this before, but converting the other architectures
isn't very trivial, mostly because each has a specific way of storing
the values read from these properties.

So unless we want to block any new drivers from being merged, the only
alternatives are to either merge these patches or include a copy of the
same code in each new driver that needs the functionality (or open-code
the functions in each driver).

There is quite a bit of rework required to unify the architecture
specific PCI frameworks and I think Bjorn and others have been making
quite a bit of progress in that direction. I think that these patches
can help refactor some of those parts.

Thierry

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHAXPAAoJEN0jrNd/PrOhISoP/1xbkU3WM8NJdgOR+FSoQNRK
bFcXkAGOITvYV5pr4yexW7vJsAAZhy6RvmrmVvLIBDkdmJKy2BF4SkntUYXm5IMM
k+isXT5ti2PuUgnbFo9kCIwIPXVAuTHj4mYUJCyyon2cSDB2ju6+6jnQBdfd7e2l
U3MZnSrEaXjkGy3+X4stoTLlCDHeW5yIRRKLUH0Z+E1pf//A35l8S0/o5mZlurqY
uX/vvnX9YxRE1m9EwLRR23jxFNOkHKjZkQWag2BGWt0s+J7vlhdrmG/HH5J8fLBi
XwzCK0DY+SBT6jf1BffHvDJhALunCQlVPkdzjzhU0L8n6Xw2fPKie3tDy9GgOdlu
2idjqDh9rkrlVlPi0S9RRp/k4cMXqCSTNx57JxMsi6tLb6ogbW8JrPygBkeJBR//
yyK/0GeDyadqYGT9t6MLfzV7dVny1hopL3gDFrWxJGACnleovonRjM3RmsAR//Or
hp2j25+i2xp/L9NL7hFT3zavfI3mfbmc+gxJE3OpbmXsCFn5M60fOZ+BPT7wmPWy
DXFNbkJALrwFq7CJQ0A/PUZH90XnnvSinWnPDNkGER922WhAxkskOmn12gge6x9Z
MlL+SeuQ3WayM+jQPOcsi0iELXz9gDIF7ULzVaW+HHOUjVhtyfGX/bJoFWW4/Nqb
9P9RZ6XATAeSpUtyMg94
=9ntJ
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
