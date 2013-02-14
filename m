Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab3BNGwb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:52:31 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:60502 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755310Ab3BNGwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:52:30 -0500
Date: Thu, 14 Feb 2013 07:52:03 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] of/pci: Add of_pci_parse_bus_range() function
Message-ID: <20130214065203.GA29588@avionic-0098.mockup.avionic-design.de>
References: <1360570940-17086-1-git-send-email-thierry.reding@avionic-design.de>
 <1360570940-17086-5-git-send-email-thierry.reding@avionic-design.de>
 <20130213225844.B79093E3557@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h31gzZEtNLTqOjlF"
Content-Disposition: inline
In-Reply-To: <20130213225844.B79093E3557@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:FLL/jTJKJhzormGNuBaEM7LvCASkCeUl9Wo6tVrLNqh
 Wv7zUJKQymueSKkrtAHFXusp9uPYUmq+ipnGyjtgqkQiRYWKA5
 XwckYsChJQ0bohqfnjbdvQOMiFln3Gf2hvvk806P1BpjhPBkwb
 LrcqapEK1ErF4VMc1Q5Sxnlnv+hazEg1QAhs84IYnushsIvcVm
 2HhSjOk6uBABiaiEjSQ/YVadVWQnAdPY5zd846lB36FrRGLhCp
 q2Y5VmesgbK83cHKqUbftL+7xAQccXI5eLXZTxb9A25CU6qLMP
 YQRF5dWQG7weFEz9IWermBkxo2Phdhl1PyuYODiOSeyDR/awUR
 ABh6X8GyKhS3+o2H6a7o/oq5rFRP14H7vsVOVkp4U+tL6PMQ8U
 qI8ciM5zUZzzWzfqS1DxdN3lOzzKEwAsf4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h31gzZEtNLTqOjlF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 13, 2013 at 10:58:44PM +0000, Grant Likely wrote:
> On Mon, 11 Feb 2013 09:22:20 +0100, Thierry Reding <thierry.reding@avioni=
c-design.de> wrote:
> > This function can be used to parse a bus-range property as specified by
> > device nodes representing PCI bridges.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Ditto for this one. We can wait on it until there is a user.

This is used by the Tegra driver and as I've explained the reason for
sending these patches separately was to get them merged beforehand to
reduce the number of dependencies that need to be tracked once the
driver is merged (possibly in 3.10, maybe later given the amount of
extra work you want done).

The patch used to be part of the Tegra series, but since Thomas started
using them for his Marvell work I thought it might be a good idea to
make them available separately.

But I can take it back into the Tegra series since that's where we seem
to be headed.

> > +/**
> > + * of_pci_parse_bus_range() - parse the bus-range property of a PCI de=
vice
> > + * @node: device node
> > + * @res: address to a struct resource to return the bus-range
> > + *
> > + * Returns 0 on success or a negative error-code on failure.
> > + */
> > +int of_pci_parse_bus_range(struct device_node *node, struct resource *=
res)
> > +{
> > +	const __be32 *values;
> > +	int len;
> > +
> > +	values =3D of_get_property(node, "bus-range", &len);
> > +	if (!values || len < sizeof(*values) * 2)
> > +		return -EINVAL;
> > +
> > +	res->name =3D node->name;
> > +	res->start =3D be32_to_cpup(values++);
> > +	res->end =3D be32_to_cpup(values);
> > +	res->flags =3D IORESOURCE_BUS;
>=20
> Is there precedence for using struct resource for passing around the PCI
> bus range values? Who will be the user of this function?

The PCI core code actually keeps track of bus-ranges this way. See
drivers/pci/probe.c for instance which uses the global the busn_resource
variable and keeps a list of struct resource:s for each domain as well.

Thierry

--h31gzZEtNLTqOjlF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRHImTAAoJEN0jrNd/PrOhX4gQAIU9KeeryHhM80ts/IVQThrr
h8nkCHuo48NoYqdhf5xlxAYcqW5ghEpdotSFt/kzdPWIoTAm9dMG/skhwMw0UwZk
phzeYlAmmVbc4v50RW6A8kpphHa0QiRn4EsxW86rrvjeuohkU0uN3MdOnEUAk3fZ
X1RjPPH4k0evvrLEjNLkaTzsMg8gZ6QJbHcd7yjVJvl4ZC/kSrsCVq00iNzb896J
PHfMBpXKrc3HI8HsOz9FE4SETmKcTxkR4U2KMoMlTIP7nXL6K4hQYq53N57J0V+Z
IqiyAdLA2Laz9ldquJi0DSZ5BV+aonsK9OVAz/+TVXv9aGzd2lFeWCxnmC8m3f0L
GU7DGPz+AgXBdqs9WR+m3TMkcRO1h57zGZFr6PSo8Yo9Xps7XqvsZwbmgaTywQLg
GBpiRVg4n/aEROgHSSWtbgTP3jDDn3b+LIZD21ZB9nftdZrFKIgsj2JScCRL86FY
IMlGeoG/M30f45ocwtIyq6F2uaSpC9LWOy1ZnEnRxLP9B1icwRRTltPrrKCOp820
itm0XA6Ya+6opKGiFQc8iI9u8q/qS5+M5Y6Cue9fPb36w7iMnvI7DslIEZTLdeQD
8TefOF7Q7YIWMAAg9GJc1ym2FSO6ojzqirF/BR+nr2bLfJwcXbMRq9IwGaJV99b8
lvjVUZZwQteK8BWoNozZ
=i7sv
-----END PGP SIGNATURE-----

--h31gzZEtNLTqOjlF--
