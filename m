Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab3G2Wae (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:30:34 -0400
Received: from ozlabs.org ([203.10.76.45]:52560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab3G2Wab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:30:31 -0400
Date: Tue, 30 Jul 2013 08:20:39 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Tomasz Figa <tomasz.figa@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Arend van Spriel <arend@broadcom.com>, Olof Johansson <olof@lixom.net>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ian Campbell <ian.campbell@citrix.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130729222039.GE29970@voom.fritz.box>
References: <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F39FD8.6080808@broadcom.com>
 <20130727183059.GD4813@netboy>
 <1441731.8CGUI1tUxh@flatron>
 <20130729180513.GB1884@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Content-Disposition: inline
In-Reply-To: <20130729180513.GB1884@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 12:05:13PM -0600, Jason Gunthorpe wrote:
> On Sat, Jul 27, 2013 at 11:51:06AM -0700, Tomasz Figa wrote:
>=20
> > Well, it depends on how we use the DT. There are (at least) two possibl=
e=20
> > usage scenarios:
> >=20
> >  a) using DT as direct replacement for board files - this means that yo=
u=20
> >     are free to say that DTSes are strictly coupled with kernel version=
=20
> >     and you are free to modify the bindings - see the analogy to board=
=20
> >     files, where you could modify the platform data structures and coul=
d=20
> >     not directly copy board file from one kernel version to another,
> >=20
> >  b) using DT as an ABI - this is the original way, i.e. define stable=
=20
> >     bindings and make sure that anu DTB built for older kernel will wor=
k,
> >     with equal or greater set of functionality on newer kernels.
> >=20
> > Now I believe in this thread the point whether we should use a) or b) o=
r a=20
> > combination of both has been raised.
>=20
> Right, and I think it is very important to consider that different
> systems can legitimately fall into those categories.
>=20
> Clearly general purpose systems (eg servers, workstations, etc) with
> *full featured firmware* fall into category b. Linux already basically
> has stable DT for those systems - but the firmware is expected to do
> lots of work and hide all the low level details from the
> kernel.  Basically, the DT should stick to approximately ePAR and
> everything else is hidden by the firmware.

No.  With the exception of the hypervisor/virtualization extensions,
ePAPR describes (for now) an entirely passive firmware interface.
That is, once the handover to the OS has happened, there is *no*
further firmware interaction.  It is not capable of hiding any details
=66rom the OS, except those which can be done by one-time
initialization.

In fact, a guiding principle of ePAPR's design was that except in
cases where it's *much* easier for the firmware to do things, the OS
should be expected to do it, because the OS is usually easier to fix
than the firmware.

> This is essentially how x86
> works and achieves its compatibility.
>=20
> Systems that have minimalist firmware, where firmware functions are
> pushed into the kernel and the DT is now required to describe
> intricate and unique SOC specific functions are clearly very
> different, and I think it makes sense to encourage those environments
> to be case 'a'.
>=20
> Basically, minimalist firmware should have a boot process design that
> *can* couple the DT and kernel, while full featured firmware should
> keep them seperate. IMHO that should be the clear message to people
> implementing this stuff.
>=20
> After enough time the DT for 'a' should become stable and churn free,
> but expecting/demanding that from day 0 is not helping anyone, IMHO.
>=20
> Jason

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlH26rcACgkQaILKxv3ab8aNZwCfV7pFtZ7Ujdd8tokTqGcU3Wo+
nRwAn28QPjRkqJyZ16WbiXApZZ3HOKoJ
=zTKv
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
