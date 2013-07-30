Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758111Ab3G3Ijl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 04:39:41 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39654 "EHLO
	mail.free-electrons.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751601Ab3G3Ijh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 04:39:37 -0400
Date: Tue, 30 Jul 2013 10:39:32 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
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
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Dave P Martin <Dave.Martin@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Ksummit-2013-discuss] DT bindings as ABI [was: Do we have
 people interested in device tree janitoring / cleanup?]
Message-ID: <20130730083932.GE1441@lukather>
References: <51F3A82E.2000907@broadcom.com>
 <CACxGe6t0C7PTiDDaFkgoMZWUpBVokasxwZpV6HEtf3LaPi4qUw@mail.gmail.com>
 <CAKON4OymA55w_V=oP4BL2su84m8EnPgdhnQtyLWKaAJE-yNBkQ@mail.gmail.com>
 <CACxGe6uE6jOE-vz0onW5h93Es-soGiBAcFBM7Dvxh+HvCNrHkw@mail.gmail.com>
 <CACxGe6vw9=y5a+EgF1gO39SwGAdGofD2MYjyJ3jYu6uN3ke70A@mail.gmail.com>
 <1374988276.1973.29.camel@dabdike>
 <20130730014453.GJ29970@voom.fritz.box>
 <CAKON4OyWuF+qm2MAhbXnGg=ozzw37kpSWciLxyUy+QQzxoWdxQ@mail.gmail.com>
 <20130730032926.GL29970@voom.fritz.box>
 <CACxGe6sUFmLZMT+dvCbpmPrzR3DNMjw64LbD3n=JsjXsmrM-qg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Zw+/jwnNHcBRYYu"
Content-Disposition: inline
In-Reply-To: <CACxGe6sUFmLZMT+dvCbpmPrzR3DNMjw64LbD3n=JsjXsmrM-qg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Zw+/jwnNHcBRYYu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 10:35:03PM -0600, Grant Likely wrote:
> >> User acquires a machine running ARM Linux version 3.x, with u-boot
> >> and dtb in a read only flash partition. The board boots and works just
> >> fine. However, for his application, the user requires a new kernel
> >> feature that appeared in version 3.y where y > x. He compiles the new
> >> kernel, and it also works.
> >
> > I'm afraid this kind of use case will never be properly supported, DT
> > stable ABI or not.
>=20
> Why? New kernel features should be no problem at all.
>=20
> New driver features /might/ not be available, but only if the new
> feature requires additional data that isn't present in the tree and
> cannot be obtained elsewhere.
>=20
> >
> > Think about this: what kernel will actually be shipped in that board?
> > Most likely, it will be a BSP kernel from the vendor. Does the vendor
> > will have made that commitment to have a stable ABI for the DT? Will it
> > use the same bindings than mainline? Do we want to support all the crazy
> > bindings every vendor will come up with?
>=20
> That's not a DT issue. That an out-of-tree board/SoC support issue. DT
> doesn't make that any better or worse.

Yet, with the DT switch, the two are bound together.

Before the DT, the only convention we had basically was that we had to
be loaded in memory and executed.

Now, the bootloader has to pass a complex data structure to the kernel.
If this data structure doesn't follow the same convention than we do, we
are screwed, and if we can't update either the bootloader or the DT that
is loaded by it, we end up screwed.

One example that comes to my mind right now is this one: we've been
arguing over spidev probing for quite some time. The easy solution would
be to add a "linux,spidev" compatible. Obviously, this has been ruled
out numerous time. Yet, in the beaglebone black out-of-tree kernel,
there is actually a patch that adds this compatible, that is later used
in the DTs.

These spidev part of the DTs will never work with vanilla. And if you
can't update the DT and want to use mainline, you'll never ever have the
same feature set.

That's of course just a small example, with not much impact on a system,
but that could be way worse.

But saying that vendors will follow the same convention we do is just
unrealistic. I mean, even us haven't be able to work out a stable ABI
for more than 2 years now, yet we should expect anyone else to do it?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/Zw+/jwnNHcBRYYu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR93vEAAoJEBx+YmzsjxAgRmQP/2jf9x7hDU1rkc1kEiUaYyhU
aeStUMpNhmBtqShcqsit1RIN9pl5oBcOM0XkRxUQbHtu3ei3kJ5bnsi9jqnw0Mq9
i8NhG67FQh71quDHEr0CbERr/U7Y9RUnU16ldXZrbe9rn9trCQokCT5uf2GPHKjX
LSKmKp4cDFq1YgBgfOhBCuYozo6wKYIhGsTG/OrJo9VQMV4URzxMI6tvmMRMjCFN
bTdy5vZLhxfc3OrchlHtThCWkPVGveHw5aeTg621VG8g2eP8bFbFlVRNYY30HE49
AxKCXKHxTGAf89o1xISygN97kYIXxSUCBqrEBqhRQxQbeY6BXXpCeQK8EJalP2sw
bbMROkjOA96+N5OKyY+uzOgt95Fb7Cjloy9KfMinTW5BeS+W06MwRrLlB46cHO1R
zHlkX3TnI3ikgBYNqfIRP0CNAlZyU1VJZ9JBqI+WyOxLfqkBpQc6Hv8UUm7qrO+6
UaOt0wRkReAZOCVYyhixBd3nizP5m1A7vRMy0BoBvrskOa2hCqeuK1+8jzV2TBNF
d28z11R3e8LoQ9VeVWQ3OOqF0OjRFhVdyK3YlMUT/qMHBjyGWRQY07XoYQWC0XBs
Ni0b4HfyEbEevI/N8cAM60j7J7tRZ3vqoPam3lQ8sdt5ZHrA1cYc9Ls4erngktdi
yvrQd9u45q6bB0mQ8Suz
=0IhK
-----END PGP SIGNATURE-----

--/Zw+/jwnNHcBRYYu--
