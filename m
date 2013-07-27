Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab3G0P2h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:28:37 -0400
Received: from ozlabs.org ([203.10.76.45]:46781 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3G0P2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:28:34 -0400
Date: Sun, 28 Jul 2013 01:19:49 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130727151949.GA29970@voom.fritz.box>
References: <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
 <20130726132709.GH29916@titan.lakedaemon.net>
 <1374846070.14574.92.camel@i7.infradead.org>
 <CAKON4OzrkHzUzKkULWCgiEpAtJ5gLxUm78R5ctd7p6trqq_gCA@mail.gmail.com>
 <20130726142140.GR24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <20130726142140.GR24642@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 03:21:40PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 26, 2013 at 10:14:32AM -0400, jonsmirl@gmail.com wrote:
> > Yes, yes - that's why the schema should be written down and used as a
> > validation input to dtc. Then dtc can spit out errors for non-standard
> > items. There would be two versions - the standard one and a legacy one
> > that includes the standard one plus the hacks that can't be undone.
> >=20
> > But more importantly it provides a framework for people creating new
> > node definitions. Now they can't work in a vacuum and come up with
> > random names and structure for everything.
> >=20
> > Most of the problems express in the thread would go away if the schema
> > was written down and discussed. The rule going forward would be no new
> > nodes that aren't part of the standard schema.
>=20
> So this is why I'm seeing patches just a short time ago removing existing
> compatible strings from the DT descriptions and associated driver, and
> replacing them with new ones... meaning that the old DT files won't work
> with newer kernels.
>=20
> What that means is using the descriptions as the schema won't catch that
> because they're changing those as well to match.
>=20
> There's a solution to that: dtc becomes a separate project external to
> the kernel which also contains the schemas that it verifies against.

dtc has always been a separate project external to the kernel.  Though
we do have to keep reminding people to send their patches to upstream
first.

It's had minimal support for validation of the tree contents for a
long time.  It has no more than minimal support (including "schemas"
as such for bindings), simply because no-one's implemented it yet.

> That way, if you want to make changes such as that above, you need to
> get it past not only kernel people but also past dtc maintainers -
> which increases the chances of such stuff being caught.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHz5RUACgkQaILKxv3ab8avQQCeM9PqrPemhFWFhm57SXzFNEnZ
KjIAnAvdYBmJoZ0+pbQGc/uf4iNBxvYL
=8kXn
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
