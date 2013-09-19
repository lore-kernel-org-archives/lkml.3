Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab3ISNW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 09:22:59 -0400
Received: from ozlabs.org ([203.10.76.45]:55055 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab3ISNWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 09:22:50 -0400
Date: Thu, 19 Sep 2013 22:31:03 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Olof Johansson <olof@lixom.net>, Jon Loeliger <jdl@jdl.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [dtc RFC PATCH] Enforce node name unit-address presence/absence
Message-ID: <20130919123103.GD3551@voom.redhat.com>
References: <1379535836-12726-1-git-send-email-swarren@wwwdotorg.org>
 <CAOesGMg0Rrmew0iK-Gtrx_UiODhpro_S2xUxQi0gZ+7PJmBHnw@mail.gmail.com>
 <523A30FC.3060309@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J5MfuwkIyy7RmF4Q"
Content-Disposition: inline
In-Reply-To: <523A30FC.3060309@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J5MfuwkIyy7RmF4Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 05:02:20PM -0600, Stephen Warren wrote:
> On 09/18/2013 02:41 PM, Olof Johansson wrote:
> > On Wed, Sep 18, 2013 at 1:23 PM, Stephen Warren <swarren@wwwdotorg.org>=
 wrote:
> >> From: Stephen Warren <swarren@nvidia.com>
> >>
> >> ePAPR 1.1 section 2.2.1.1 "Node Name Requirements" specifies that any
> >> node that has a reg property must include a unit address in its name
> >> with value matching the first entry in its reg property. Conversely, if
> >> a node does not have a reg property, the node name must not include a
> >> unit address.
> >>
> >> Implement a check for this. The code doesn't validate the format of the
> >> unit address; ePAPR implies this may vary from binding to binding, so
> >> I'm not sure that it's possible to validate the value itself.
> ...
> > Anyway, I think it'd be better to produce warnings than errors for
> > this. That way we could also merge it now while the trees are fixed
> > up.
>=20
> Yes, that makes sense.
>=20
> > Also, maybe warn for @0x<foo>, which is another unpreferred syntax, it
> > should just be @<foo> (with foo being in hex).
>=20
> ePAPR doesn't seem to disallow that; it explicitly says that the
> unit-address consists of the characters from table 2-1, which is the
> same table of characters used for the node name itself. However, it does
> state that the binding for a particular bus may impose additional
> restrictions; should I implement such a check but limit it to the root
> node or specific known bus types? That would require explicitly
> whitelisting the check for a lot of bus types, given that each I2C/...
> controller binding is a bus type...

Yeah, I think that's the wrong approach.  Instead I think we need a
table of bus type -> unit address validation functions.  That way we
can start with the common ones - plain memory address, PCI, USB and
I2C, then add more as we need them.

I actually started implementing this once, but I seem to have lost the
patch.

One thing to bear in mind if you do have a crack at this - the correct
encoding of reg -> unit address isn't always unique, although it
usually is.

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--J5MfuwkIyy7RmF4Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSOu6HAAoJEGw4ysog2bOS3xkP/1ARiMSKexL9sT7Mdf+KWIL5
HmNRWhi6kj+eAsJxh7bSEiBQ+ReD9SfWu68l3A/WhlqFcVxCgabTDMt9Vkn9xQsK
DM9yXjlI8T0MK6+GLpaHgsZs1fBPypUGwOmJ48yi2AjwFw2k5IWBhOaY0eacycdA
PBZjY+MlwtWrBE6lN9ItD1MQYy+GzN5RzkEcqIYxIoysB61jgYDni2WlPOMdN6mg
ffi+h9ciaD3HwYa3bRUqnz0Sg3CBo+Ji6z7e7oG5tVTaPOXEzo6Yb3PtrCfH2z6j
3MdWM/qn57XvdlfOaTsnfnMwKBA09HlruNK2FaowyQXCQ9/ewZuyBdQCN3hVrQGA
bXt9s+v3AXybHwv2sqrTmnNiUKRHYLEcYX82L08eclTLtg1wngAmF3tYTmB+taDX
kb5U4Tm5KYglYv/iInIaAx/qcf4l5WGSERfSXlMCVI/5LgbYaQtoJDcRbZ7M6bJ+
b7nDEw1WdWjzlzAbHIAbMro41vai9SMvUDaaTofUA3LHXySl3Z64EmDLZgNQX7sD
dmFJMOcO6qT0mdTpBmnS4kY3mslefzEU9NpsCBOcPwvJS5avjbS+PpCbgB36kKEQ
xPXwvHuXKsnGDn2c5EcfsRROpbQAmdqmosZUV5O5frRCdgH+oQ0A7VKhap/xB1nS
qzhjRgyFkz0YqaeEZkWT
=Dtw8
-----END PGP SIGNATURE-----

--J5MfuwkIyy7RmF4Q--
