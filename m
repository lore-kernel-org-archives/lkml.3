Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758635AbaHZORb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:17:31 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:33127 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374AbaHZORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:17:20 -0400
Date: Tue, 26 Aug 2014 16:17:16 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Jon Loeliger <jdl@jdl.com>
Cc: Alexander Holler <holler@ahsoftware.de>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140826141714.GA3027@ulmo>
References: <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
 <20140826102503.GC31124@ulmo>
 <53FC6513.5040800@ahsoftware.de>
 <20140826110827.GA31350@ulmo>
 <53FC6E4A.6030407@ahsoftware.de>
 <20140826114718.GB641@ulmo>
 <53FC76E8.5050009@ahsoftware.de>
 <E1XMHGc-0008TS-CQ@jdl.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrZ03NoBR/3+SXJZ"
Content-Disposition: inline
In-Reply-To: <E1XMHGc-0008TS-CQ@jdl.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 08:58:34AM -0500, Jon Loeliger wrote:
> > >>
> > >> Drivers don't provide that information (dependencies) in any usable =
way. And
> > >> as you said yourself, it's already contained in phandles. So what we=
 are
> > >> discussing here about? The proposal to use phandles for that is alre=
ady on
> > >> the table since several month. ;)
> > >>
> > >> Sorry, but I don't understand what you want to propose.
> > >
> > > In many cases we simply don't know where phandles are stored since we
> > > don't have the type information in DT. But drivers already know the t=
ype
> > > of a specific phandle and where to get it from, so the proposal is to
> > > make that knowledge more generally useful so that it can be used for
> > > dependency resolution.
> >=20
> > How?
>=20
> Is the issue around which we are dancing here the timing of
> topsort and the probing?  When the driver is probed, sure, it
> touches and resolves a bunch of phandles and references other
> nodes and devices.  But that is at probe time, and it only has
> the context of itself then.
>=20
> I think we need to do the complete topsort *before* we attempt
> to do any probing.  So three steps:
>=20
>     1) Graph Construction
>         Add a new "emit dependencies" function to driver bindings.
>         Iterate over known devices or nodes in the DT in any order.
> 	    Call the "emit dependencies" function.  It adds all
> 	    dependency edges to a global graph by knowing what
> 	    phandles or other pieces it will need.
> 	    A driver with no "emit dependencies" function can be
> 	    added to the graph anywhere without loss of generality.
>         Add any additional edges for whatever reason.
>=20
>     2) Topsort the generated driver graph
>=20
>     3) Call probe for real in topsort order

Yes, I think that makes a lot of sense. We need to provide a way to make
the dependency information available before probe time, otherwise we
don't gain anything. Whether we provide that in a form of a function
call or a table is an implementation detail.

I do think that requiring drivers to provide a function is going to make
things more complicated than necessary since that "emit dependencies"
function would need to copy a lot of the things that .probe() does
already. Sharing this information in a table sounds like a good idea. An
"emit dependencies" function in the core can use that data to resolve
dependencies whereas the driver core can equally use that information to
request the devices so that the drivers don't have to do so.

Thierry

--lrZ03NoBR/3+SXJZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/JbqAAoJEN0jrNd/PrOhRO0QAI8oe8CV7IHOG8vGapPUF3Mm
8szHIo+VIz5nbXab5jCR6/sI+mJDLi8Dg5gwz+voDZ3+8Pax1D5JfG42NlDeDczr
gxpq7emCgcvQvTErNAHTKGaBYmDm1Qlj7GM57Htj0E+zY9JssTGNMq5H8aT3F438
tpfeD40v4bFBVG4rzFTW8QHDnpCTqZkHIicXDzcdmixuJfGEw7Bpd/YiAiyMUDYH
rN2molWlxE4Xi/gDbRVg8VuCSpt118psNyignf11po/CCbtkxvhX2bB/izbbrfl5
Cqurhk7CS+n/0yDmdflK6Qargtcs29KBbMFS6kHh5vYKzbcXsAfpwD+rexIXm3ir
GvEpqiSMGSgDQPySE0IIeEmNkLiOEonHJSDai/VITWpidLRiHknyRuvgNHimp6RY
w2/HYsnf3Zze9RE67Gk9figiydqsV+P85hpCFcWoVQRsHBVwGAFRQCsByEnYk+2S
m1lKaclmGBBaas9q7nc6/0aAIKvW0awTAYa5MfjM00COOSw5kq5L6aRrxYgTfYOK
4JlPAzi0w6mBZ7/rkCkNeSQ3Tny0CBqnXl4Mime65R0Gz/KeDoexlNpgsGOJ0Fe2
BjS48Ri7YGNeCexRE97Ddhx4gFJIK5Vm1Gu7rHw8sEQxn/G6a5CplSFgNr+7mUss
t/9CeoAEMUu6r1CKkKEP
=6ATE
-----END PGP SIGNATURE-----

--lrZ03NoBR/3+SXJZ--
