Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab3AKECR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 23:02:17 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50831 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab3AKECP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 23:02:15 -0500
Date: Fri, 11 Jan 2013 05:02:10 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Andrew Murray <andrew.murray@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/14] of/pci: Provide support for parsing PCI DT ranges
 property
Message-ID: <20130111040210.GC28094@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-2-git-send-email-thierry.reding@avionic-design.de>
 <50EF5798.6040405@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZmUaFz6apKcXQszQ"
Content-Disposition: inline
In-Reply-To: <50EF5798.6040405@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:rdbNSXOqb5SAyGmZBPo2DBkP1lShyahJxWptRzzi1Kl
 Y0A8c1yW80sEjzW+WSxT6NrGlR4U1tryMwNje4yf5i7CqZzbiL
 0F1zjnWxRZroRhjDL92W952VTKMleQHS3IF5FDCHsLlbhhxLuz
 G9kwP6KheeQMjYSMbh9DeVUultatPsrQf9yB0VxBM7zyWQniIC
 32r0cb2TsGGjdpfFUvAfKoQP/TBtlejxG5ocXcW0DP7sWyFX+X
 aRySN/pCb/jCh85BjHS9cNMVBl/ghovJJmv+XCXCjyDeThEkbE
 ibKJ0sfURpAfhJ2MQ5GYh5Ye7sewBGJc0fiyJaAfA75fUvw3iu
 zh1WsINl03BzXpCHMCgaLto0CcAvaxFIZg54G4FpDQs+o4Mhva
 fD6bsu9UXEVgUJOiiA01wRMlRPkGclfU5E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZmUaFz6apKcXQszQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 10, 2013 at 05:06:48PM -0700, Stephen Warren wrote:
> On 01/09/2013 01:43 PM, Thierry Reding wrote:
> > From: Andrew Murray <andrew.murray@arm.com>
> >=20
> > DT bindings for PCI host bridges often use the ranges property to descr=
ibe
> > memory and IO ranges - this binding tends to be the same across archite=
ctures
> > yet several parsing implementations exist, e.g. arch/mips/pci/pci.c,
> > arch/powerpc/kernel/pci-common.c, arch/sparc/kernel/pci.c and
> > arch/microblaze/pci/pci-common.c (clone of PPC). Some of these duplicate
> > functionality provided by drivers/of/address.c.
> >=20
> > This patch provides a common iterator-based parser for the ranges prope=
rty, it
> > is hoped this will reduce DT representation differences between archite=
ctures
> > and that architectures will migrate in part to this new parser.
> ...
>=20
> > diff --git a/drivers/of/address.c b/drivers/of/address.c
>=20
> > +const __be32 *of_pci_process_ranges(struct device_node *node,
>=20
> > +	while (from + np <=3D end) {
> > +		u64 cpu_addr, size;
> > +
> > +		cpu_addr =3D of_translate_address(node, from + na);
> > +		size =3D of_read_number(from + na + pna, ns);
> > +		res->flags =3D bus->get_flags(from);
> > +		from +=3D np;
> > +
> > +		if (cpu_addr =3D=3D OF_BAD_ADDR || size =3D=3D 0)
> > +			continue;
>=20
> Hmmm. That seems to just ignore bad entries in the ranges property. Is
> that really the right thing to do? At least printing a diagnostic might
> be a good idea, even if the code does just soldier on in the hope
> everything still works.

That's true. However, erroring out here wouln't be useful either since a
NULL return value is used to mark the end of the iteration and the
caller would have to assume that no more ranges are present. Maybe
that's better than continuing anyway, even if a message is printed.

Alternatively, the of_pci_process_ranges() could be changed to return an
ERR_PTR() encoded errno. This is one case where it makes a lot of sense.
I have a feeling that Grant won't like that very much, though.

Another possibility would be to change away from an iterator-based
approach and return an integer for the number of ranges and negative
error code on failure while returning an allocated array of resources
through an output parameter.

Thierry

--ZmUaFz6apKcXQszQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ747CAAoJEN0jrNd/PrOh/bQP/0IiT1xF+Klj+SSKlmrwUhEX
dgfuEscTyb+N1OHfVfvwDxRaRq0z2z+cwHdF/gjehUuwDkWBomvjonoPpauNs4uj
h4Rv3wvx0skXscKOxJgNB6vNbIAnoKgzBlJ13Z20AtxdqkncdTC8ZW/dRHCuW9W8
Cpv33q0Utl706pHpVAw/0KMlq3zrRYQz42cIYeSrMxwzaWlFAexk5HcEwem2/pUW
1/1Y6EhHO3FAS7IhQyLnnjVWlR89Gd9DzvYeCndLnP9lXfQ2FyKm83hKq8QqGpVN
g+54HeYMMGeQn2u4M9c+BJqUt7q8eiRnCMlZN0W02UI/9Vhq+znh6cAGGDruBXzZ
atkaJOxM997lYzBDgZA5u8AjS9O+n35UWNpyDgKoSJ05E7SuSBh/tBJuu1XVRu4z
ueE/HERCWFon2QodEYUk5iNvt+NDM66nrfxXh9BIOd045Al8eXdHQ4dhslLXS8Sz
qHC3dwoNKozfIHWrq4vAat+ERW79s1WgOf/NPLwpugdn56/wGCXJEQdblEDK/6Mj
BtgE7VlX88knrMx0i8CXeMsCJIwyZds4WhZNRJ1ao4F+e+Tjc15zDZb0geq047+j
aCrHplrXuK9iKzWAHFmMuabYjGDyhsAKx8Ii7GACCO9CisJIz+tgT6sJZU6ypajw
65VE+KSnz/gVtV2KSnc+
=eyXO
-----END PGP SIGNATURE-----

--ZmUaFz6apKcXQszQ--
