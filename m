Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3JYNhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 09:37:01 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:34104 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab3JYNhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 09:37:00 -0400
Date: Fri, 25 Oct 2013 15:36:57 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the c6x tree
Message-ID: <20131025133656.GB1551@ulmo.nvidia.com>
References: <1382632289-18523-1-git-send-email-treding@nvidia.com>
 <1382706224-8859-1-git-send-email-treding@nvidia.com>
 <1382707377.1768.89.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U+BazGySraz5kW0T"
Content-Disposition: inline
In-Reply-To: <1382707377.1768.89.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U+BazGySraz5kW0T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 25, 2013 at 09:22:57AM -0400, Mark Salter wrote:
> On Fri, 2013-10-25 at 15:03 +0200, Thierry Reding wrote:
> > Today's linux-next merge of the c6x tree got a conflict in
> >=20
> > 	arch/arm/Kconfig
> >=20
> > caused by commits 148104c (ARM: 7854/1: lockref: add support for lockle=
ss
> > lockrefs using cmpxchg64) and commit d701884 (arm: select
> > ARCH_MIGHT_HAVE_PC_PARPORT).
> >=20
> > I fixed it up (see below). Please verify that the resolution looks good.
>=20
> > Thanks,
> > Thierry
> > ---
> > diff --cc arch/arm/Kconfig
> > index c06647d,7db8abe0..b6a708e
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@@ -5,7 -5,7 +5,8 @@@ config AR
> >   	select ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE
> >   	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
> >   	select ARCH_HAVE_CUSTOM_GPIO_H
> >  +	select ARCH_USE_CMPXCHG_LOCKREF
> > + 	select ARCH_MIGHT_HAVE_PC_PARPORT
> >   	select ARCH_WANT_IPC_PARSE_VERSION
> >   	select BUILDTIME_EXTABLE_SORT if MMU
> >   	select CLONE_BACKWARDS
>=20
> ARCH_USE_CMPXCHG_LOCKREF needs to come after ARCH_MIGHT_HAVE_PC_PARPORT
> to keep things sorted alphabetically. Other than that, its fine.

Right, I missed that. Will keep it in mind, although I guess today will
be my last tree for a while since Stephen mentioned that he would
probably take over on Monday.

Thierry

--U+BazGySraz5kW0T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSanP4AAoJEN0jrNd/PrOho2sQAIHGyG5Rb3o5OgfOzwq9zAHs
MEW65Zz2nQLucuwaba7U2h0GeOANnOngRHq9vBetW/gIxAB6zFiSPJjuwRDGvyOi
p+pveo9bW6zCdtUIVeQL7NjkiI0+FRMcGohVM1LimZBMol+c9+Eg5uybPAR5rLX9
DFnXogd4Ljn+aDyA5t0R+ewOaagmoeHSAr3yXgi3bLJxmkEXYvPGdycLcqARnA0h
NZvHvdZKUOQhCtIGG7CTDXSHUqmPZ/B7kmcCvBHQN0nWr/j/4x5+i2k/7rJ/lZa9
mnzTsqrG7r/cYKAD8wJaJHk3IYC7k2X/ZkKkF6wBAZ1h5+UupooaGwJgKbh4ttIc
vYisK2JCfv5DBDaPPoSoycGxmQ3Uqy607elil7jYcBg7C4fqs1YnXkvbtBErynEo
J5Pwz7nFOJ0trM5g30ocD5ctW3crGY6zyaBFBgUr3wrtBq/NEuHrNrjN0rbQGP4q
kEwW+CeMSWcCpnKlR5dnlTkFH2d5BF+sXFXpbbL2UNXsJO/SSDj0ihrU5DiiUBUP
yKK2//68At/iM3HrHWsGTVE1raMF1+goofK7h69lr3heabMnUWF89Ile8KjrA6xr
hBDOENtRT7C1bw9jMrqURurFLK18HESXssH2+3dYZpFL/Dj5Wjw8Ud0TBhJOyET9
+1xc9weS4s3ENrp4E7c9
=HfS1
-----END PGP SIGNATURE-----

--U+BazGySraz5kW0T--
