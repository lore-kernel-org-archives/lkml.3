Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaIIHqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 03:46:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:21689 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755322AbaIIHqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 03:46:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,491,1406617200"; 
   d="asc'?scan'208";a="570401603"
Date: Tue, 9 Sep 2014 03:12:52 -0400
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: rdunlap@infradead.org, bp@alien8.de, tony.luck@intel.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND RFC 5/5] PCIe, AER: Update initial value of UC error mask
Message-ID: <20140909071252.GB27821@gchen.bj.intel.com>
References: <1407910961-7798-1-git-send-email-gong.chen@linux.intel.com>
 <1407910961-7798-6-git-send-email-gong.chen@linux.intel.com>
 <20140905233421.GL8080@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pd0ReVV5GZGQvF3a"
Content-Disposition: inline
In-Reply-To: <20140905233421.GL8080@google.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pd0ReVV5GZGQvF3a
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 05, 2014 at 05:34:21PM -0600, Bjorn Helgaas wrote:
> Date: Fri, 5 Sep 2014 17:34:21 -0600
> From: Bjorn Helgaas <bhelgaas@google.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: rdunlap@infradead.org, bp@alien8.de, tony.luck@intel.com,
>  linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [RESEND RFC 5/5] PCIe, AER: Update initial value of UC error
>  mask
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Wed, Aug 13, 2014 at 02:22:41AM -0400, Chen, Gong wrote:
> > In PCI-e SPEC r3.0, BIT 0 of Uncorrectable Error Status Register
> > is redefined and it has an explicit requirement that when writing
> > this field, a value of 1b is the only choice. So change previous
> > initial maks from 0 to 1.
> >=20
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> > NOTE: After scratching all use cases, this is the most obvious use
> > case to violate the SPEC. Most of use cases just read first and
> > then overwrite for clear purpose. Even so, such fix is obvious to
> > not compatiable with previous SPEC definition. Do we need a dirty
> > hack?
> >=20
> >  arch/mips/pci/pci-octeon.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/arch/mips/pci/pci-octeon.c b/arch/mips/pci/pci-octeon.c
> > index 59cccd95688b..f1bfdc201297 100644
> > --- a/arch/mips/pci/pci-octeon.c
> > +++ b/arch/mips/pci/pci-octeon.c
> > @@ -134,7 +134,7 @@ int pcibios_plat_dev_init(struct pci_dev *dev)
> >  				       dconfig);
> >  		/* Enable reporting of all uncorrectable errors */
> >  		/* Uncorrectable Error Mask - turned on bits disable errors */
> > -		pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, 0);
> > +		pci_write_config_dword(dev, pos + PCI_ERR_UNCOR_MASK, 1);
>=20
> I see the text in the spec that says we should only write 1 to bit 0 (sec
> 7.10.3, for anybody following along).  It looks like that change was made
> between PCIe r1.0 and r1.1.  It would really be nice to have more context
> about why the change was made, because if there's hardware in the field
> that implements r1.0 behavior, this patch will change the way it works, a=
nd
> I don't know how to verify that is safe.
>=20
> Does this actually change fix a problem?  If it fixes a problem that
> happens on real hardware, that's a much better reason to make a change th=
an
> just to comply with the spec.
>=20
> Sec 7.10.2 also says we should ignore the value of bit 0 in the
> Uncorrectable Error Status register, and I don't see any place where we
> follow that advice.
>=20
That's why I mark this patch as RFC. As you mentioned above, these are my
concerns, too. I submit such a patch not for merging but throwing a potenti=
al
issue. As I noted above, I don't know if it is deserved to fix all affected
placed to comply with spec change. After all, no one reports such an
issue (or maybe have happened :-))

--Pd0ReVV5GZGQvF3a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUDqh0AAoJEI01n1+kOSLHy4QP/2BbLr1NORHlsNG7eypswhdJ
7FrEXWQus8W3+ByjLwxYJsIWEUbkdMMseMkfT2urguUQZQgldgT6W0q0amG8ntCn
nx37ra9ct4XtUGdicSCCs+zGAIZvl9O9X1HfDjubC+JbXeoiRgUd7Sxd1Zws6Qeh
rJRKzIyUCdnBjZz23hPFKKNBO3myvuveOmLNpwNTYHBISbzk8hMytZkjAc5viAkQ
FG2Yj6eh4BGvp9zv02I5lTHUY7RNVLhxwejIbmPb/FMA2hqfq/fav4+ft76rIMn+
N6xfauxQmukF6IP9YlkZdtxbudLMe8noqy41OJcU3w5d+SLcwHrkPoqp/d0Vmz1N
wPoX5IcnB/M/vYfKZ5ZWm0h91ctGvI6G/1a3tMeVcMHoFKGUA/GJkhkoIB7+ZttY
SwHR/axViRs0Jr62+ZM/gwGQi5wxBbz3e0AhgKZqRG8qMy2MIljDbIvMc7c70wA8
T1dP4nrSZTalqva0+FiFdxsCH3gDc5DLfEH6fwWvP8CvNen53X+4Z0xccMgNUJuR
FdLl1HSVg+xj7VnP8e+opgKl4ieKRlRQT8i1oU3OaFXdsGVieFauZ2aCsTiZusfI
oDQs1sflB3uKetWdur5EUzxYmSVp4cEgi2EaRMwDFffRrUGpfch62P3HSt0Wu2gz
xXL4usDe3xQRRQCwfadQ
=50d2
-----END PGP SIGNATURE-----

--Pd0ReVV5GZGQvF3a--
