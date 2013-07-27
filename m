Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3G0P2g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 11:28:36 -0400
Received: from ozlabs.org ([203.10.76.45]:60688 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068Ab3G0P2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 11:28:34 -0400
Date: Sun, 28 Jul 2013 01:28:46 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Cochran <richardcochran@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "ksummit-2013-discuss@lists.linuxfoundation.org" 
	<ksummit-2013-discuss@lists.linuxfoundation.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Domenico Andreoli <cavokz@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130727152845.GB29970@voom.fritz.box>
References: <CAOesGMhJ+je8FZqeFxhAcYwU0CHYer+aGP6DA_8x3azrzfA2sw@mail.gmail.com>
 <20130725175702.GC22291@e106331-lin.cambridge.arm.com>
 <51F168FC.9070906@wwwdotorg.org>
 <20130725182920.GA24955@e106331-lin.cambridge.arm.com>
 <20130725184834.GA8296@netboy>
 <20130725213753.GC17616@obsidianresearch.com>
 <20130726080115.GA5436@netboy>
 <1374831744.2923.42.camel@shinybook.infradead.org>
 <20130726130927.GC4219@netboy>
 <20130726131423.GL24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
In-Reply-To: <20130726131423.GL24642@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 02:14:23PM +0100, Russell King - ARM Linux wrote:
> On Fri, Jul 26, 2013 at 03:09:29PM +0200, Richard Cochran wrote:
> > On Fri, Jul 26, 2013 at 10:42:24AM +0100, David Woodhouse wrote:
> > > On Fri, 2013-07-26 at 10:01 +0200, Richard Cochran wrote:
> > > > On Thu, Jul 25, 2013 at 03:37:53PM -0600, Jason Gunthorpe wrote:
> > > > >=20
> > > > > We use DT has a kernel configuration input. Our environment is
> > > > > designed to guarantee 100% that the kernel and DT match exactly. =
DT
> > > > > very deliberately isn't an ABI boundary in our systems.
> > > >=20
> > > > Think about what you just said.
> > > >=20
> > > > The DT describes the *hardware* not the kernel. Why should you ever
> > > > need to update your DT at all?
> > >=20
> > > Well, the nodes which describe hardware devices, according to the
> > > bindings which form an ABI contract between DT and drivers, should not
> > > normally change. Although they *can* change, if for example you change
> > > the MAC address and that's stored there. Or you change the PHY you wa=
nt
> > > it to use. Or something like that. The *ABI* doesn't change, but the
> > > data you express *using* that ABI can change. That's kind of the poin=
t.
> >=20
> > Unless I totally misunderstood, the thread is talking about letting
> > established bindings change with each new kernel version.  I am
> > opposed to that.
> >=20
> > Of course, a user may want to change the values of his MAC addresses,
> > if he needs to. But he should never have to change *how* he specifies
> > those addresses.
> >=20
> > So, as long as everyone can agree to the principle that a working DT
> > should remain working after a kernel upgrade, then I'll shut up. In
> > actual fact, this is not the case today, nor was it ever so in the
> > past, AFAICT, but it never hurts to set goals.
>=20
> We agree.
>=20
> That's precisely why I'm saying that once a binding appears in a -final
> released kernel, it is _stable_ by that very fact.  If there were any
> doubts about it, it should never have been accepted into the kernel tree
> in the first place.
>=20
> It's no different from how we treat syscalls.  Once we accept a syscall
> and it's published in a -final kernel, it can't then be altered - it can
> be supplemented by a new syscall with a different interface, but the old
> one remains and keeps its semantics for a great many years.
>=20
> There's no reason for DT to be any different in this regard.

I agree, and the fact that we have a bunch of bad bindings in the wild
is a mess which is difficult but necessary to clean up.

Something that helps, is that just as it's possible to support old,
badly-thought out syscalls with a compat shim over newer
implementations, we can in many cases localize handling of bad device
tree bindings to early boot code, so that old bad ideas don't have to
infect every part of every driver.

It would probably be a good idea to implement a DT quirks mechanism,
to be run immediately after unflattening.  That way a driver can just
register a fixup function to patch the DT up to a newer standard,
instead of scattering if (old-style-representation) throughout the
code.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iEYEARECAAYFAlHz5y0ACgkQaILKxv3ab8YA6ACdEAosj48LwZuiQci2/8LE9hQw
BK4AoJNzIGsoleedvIWkfmvsJmAeFvCx
=6r85
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
