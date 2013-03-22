Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933401Ab3CVKAN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 06:00:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57861 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932138Ab3CVKAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 06:00:11 -0400
Date: Fri, 22 Mar 2013 11:00:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Andrew Murray <andrew.murray@arm.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 1/2] PCI: Introduce new MSI chip infrastructure
Message-ID: <20130322100005.GB21096@avionic-0098.mockup.avionic-design.de>
References: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
 <1363942307-9327-2-git-send-email-thierry.reding@avionic-design.de>
 <20130322093750.GA679@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <20130322093750.GA679@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:dVJCLsMqo9Lromaja8t+yC3f7b/QWH7g9E0cau1a9Xg
 Wlw87JuscD8dym7VlT6kABGc6Ez0XtLEGKuz5i4F2AQ4gJUC/6
 4ywNx4vP+vcxqRZoSUMXIUOfG6o5+ve9n4dskin/9DOWCs1AAl
 Z1vlAk3CMYZ7zTXqcbZIKA7tOCzwwWVpoQUC+VXrR24Ekout2e
 rUdFJaK2CjO9+dQ6dsDvd2mKqYytcsWdXRd1QwuYZdhrgw0M+t
 lya0x5uzi8zNe1go/k93inQvXf0chJIpjUQjKF9SMuJhiXec2K
 UffwGcv7x9+8fiNEMRXnD76xeFIOkDxaW8/krx4NJ8soDnXER6
 HKBbKXtZQs0+tt0nSSkg1etKQPOntmqtEbmsxVn3KmlscYTo1n
 XS3Anu0PgKDRNV9lcyA201TXjO9wWY7ox4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 22, 2013 at 09:37:50AM +0000, Andrew Murray wrote:
> On Fri, Mar 22, 2013 at 08:51:46AM +0000, Thierry Reding wrote:
> > index ce93a34..ea4a5be 100644
> > --- a/include/linux/msi.h
> > +++ b/include/linux/msi.h
> > @@ -58,5 +58,15 @@ extern int arch_setup_msi_irqs(struct pci_dev *dev, =
int nvec, int type);
> >  extern void arch_teardown_msi_irqs(struct pci_dev *dev);
> >  extern int arch_msi_check_device(struct pci_dev* dev, int nvec, int ty=
pe);
> > =20
> > +struct msi_chip {
> > +	struct module *owner;
> > +	struct device *dev;
> > +
> > +	int (*setup_irq)(struct msi_chip *chip, struct pci_dev *dev,
> > +			 struct msi_desc *desc);
> > +	void (*teardown_irq)(struct msi_chip *chip, unsigned int irq);
> > +	int (*check_device)(struct msi_chip *chip, struct pci_dev *dev,
> > +			    int nvec, int type);
> > +};
>=20
> Is there a need to add setup_irqs and teardown_irqs functions here? This =
will
> allow your MSI chips to support multiple MSIs per requesting device.
>=20
> What about restore_msi_irqs? Does this fit in here too?

I guess those could be added as well. I've concentrated on the most
common use-cases here, which seem to be the three included functions.
Most other implementations use the generic implementations for multiple
MSIs.

Note that the proposed framework is in no way fixed and can be extended
at will. The important step is to get rid of the one implementation for
the whole kernel concept.

Thierry

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRTCulAAoJEN0jrNd/PrOheJkQAKDJrX9rVGWYgMM5Mka2Sk5f
cWwXzWTiwdpqXoGPy7GW0ZhG0kB0KGXiCyACY3afLwGmK1BVmpMXFslxvJZHN7FR
y7YJ3+uwHrfLDgzIfkRNSjoVNN7ng7HorDH/P8E0sJElChjkOHXsHKQtFghCpDp3
VBBmQKSiVpcEri/2czrpjU8cLYddeN96dF4jYR4kcZBhDhEtRaR35QRShkSqsDcD
mfgBDAhR++1PhYUIzFWkrMHIxqmrgC6aBWUzpPtCAJxk8s1jVOg0q6YNE4iId0AG
/uKeEYaoe4/1/oldtGBtYWTQ+WMOeuOMgddfZVyMrPG/G2D2lwIxO/pwZ6+xMC0r
TF+/KXYU5XLF/kFyjFBeaRm+9N/wn/HZLp6hawkxWD5/rFpONbkOUvYAh0cznb5M
9+U8YmL+zK6qLK525oUpe0tEPmOC9nsp71xpCk/WZkDFvKj1bTsTC0LvfrG/Hgrt
zA4PudySXcwlqtOY011+y2NHMnjZzpxpxsWYPEWtzU91XRjyU3m2vTOIdLSBEH7T
ics9xnwcLw8vkMOFq8oCWtTF59mEkMqmcRdouIyij1xr1OKyMeooqed8iUNVo8mY
XX0totvPs9LOabGfLpCPoaEXyRuuXqRZF4UYdimUalT2sgfHS/9XeHpp+ZzMYa7D
KVnPC5jnlCDLef8xsqyk
=NbyG
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
