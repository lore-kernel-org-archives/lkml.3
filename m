Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab3JPBxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:53:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:33559 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190Ab3JPBxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:53:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,504,1378882800"; 
   d="asc'?scan'208";a="419743845"
Date: Tue, 15 Oct 2013 21:39:02 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
Message-ID: <20131016013902.GB6898@gchen.bj.intel.com>
Mail-Followup-To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-3-git-send-email-gong.chen@linux.intel.com>
 <20131015181723.GC2777@naverao1-tp.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHWLQfXTYDoKhP50"
Content-Disposition: inline
In-Reply-To: <20131015181723.GC2777@naverao1-tp.ibm.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hHWLQfXTYDoKhP50
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 11:47:23PM +0530, Naveen N. Rao wrote:
> Date: Tue, 15 Oct 2013 23:47:23 +0530
> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org
> Subject: Re: [PATCH 2/8] ACPI, CPER: Update cper info
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On 2013/10/11 02:32AM, Chen Gong wrote:
> > To satisfy the necessary of following patches and make related definiti=
on
> > more clear, update some definitions about CPER. No functional changes.
> >=20
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> >  drivers/acpi/apei/apei-internal.h | 12 ++++-----
> >  drivers/acpi/apei/cper.c          | 46 ++++++++++++++++---------------=
--
> >  drivers/acpi/apei/ghes.c          | 54 +++++++++++++++++++------------=
--------
> >  include/acpi/actbl1.h             | 14 +++++-----
> >  include/acpi/ghes.h               |  2 +-
> >  5 files changed, 64 insertions(+), 64 deletions(-)
> >=20
> > diff --git a/drivers/acpi/apei/apei-internal.h b/drivers/acpi/apei/apei=
-internal.h
> > index f220d64..21ba34a 100644
> > --- a/drivers/acpi/apei/apei-internal.h
> > +++ b/drivers/acpi/apei/apei-internal.h
> > @@ -122,11 +122,11 @@ struct dentry;
> >  struct dentry *apei_get_debugfs_dir(void);
> > =20
> >  #define apei_estatus_for_each_section(estatus, section)			\
> > -	for (section =3D (struct acpi_hest_generic_data *)(estatus + 1);	\
> > +	for (section =3D (struct acpi_generic_data *)(estatus + 1);	\
>=20
> This is a good one to rename, though I wonder if acpi_generic_error_data
> is more appropriate?
>=20
> >  	     (void *)section - (void *)estatus < estatus->data_length;	\
> >  	     section =3D (void *)(section+1) + section->error_data_length)
> > =20
> > -static inline u32 apei_estatus_len(struct acpi_hest_generic_status *es=
tatus)
> > +static inline u32 cper_estatus_len(struct acpi_generic_status *estatus)
>=20
> Not sure I understand the rationale for these changes - we are still
> dealing with ACPI/APEI generic error status/data structures. So, why
> the cper_ prefix?
>=20

Because CPER is not APEI specific, beside APEI, some others like eMCA
needs this.

> >  {
> >  	if (estatus->raw_data_length)
> >  		return estatus->raw_data_offset + \
> > @@ -135,10 +135,10 @@ static inline u32 apei_estatus_len(struct acpi_he=
st_generic_status *estatus)
> >  		return sizeof(*estatus) + estatus->data_length;
> >  }
> > =20
> > -void apei_estatus_print(const char *pfx,
> > -			const struct acpi_hest_generic_status *estatus);
> > -int apei_estatus_check_header(const struct acpi_hest_generic_status *e=
status);
> > -int apei_estatus_check(const struct acpi_hest_generic_status *estatus);
> > +void cper_estatus_print(const char *pfx,
> > +			const struct acpi_generic_status *estatus);
> > +int cper_estatus_check_header(const struct acpi_generic_status *estatu=
s);
> > +int cper_estatus_check(const struct acpi_generic_status *estatus);
>=20
> Same here. All the above functions work on ACPI structures...
>=20
> >  /* Values for block_status flags above */
> > =20
> > -#define ACPI_HEST_UNCORRECTABLE             (1)
> > -#define ACPI_HEST_CORRECTABLE               (1<<1)
> > -#define ACPI_HEST_MULTIPLE_UNCORRECTABLE    (1<<2)
> > -#define ACPI_HEST_MULTIPLE_CORRECTABLE      (1<<3)
> > -#define ACPI_HEST_ERROR_ENTRY_COUNT         (0xFF<<4)	/* 8 bits, error=
 count */
> > +#define ACPI_GEN_ERR_UC			(1)
> > +#define ACPI_GEN_ERR_CE			(1<<1)
> > +#define ACPI_GEN_ERR_MULTI_UC		(1<<2)
> > +#define ACPI_GEN_ERR_MULTI_CE		(1<<3)
> > +#define ACPI_GEN_ERR_COUNT_SHIFT	(0xFF<<4) /* 8 bits, error count */
>=20
> I'd prefer ACPI_GENERIC_ERR_ since ACPI_GEN_ERR sounds far too much like
> ACPI "Generated" :)
>=20
>=20
> Thanks,
> Naveen
>=20

--hHWLQfXTYDoKhP50
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSXe42AAoJEI01n1+kOSLHPp4P/0yMk8q7VLwisQwQPlbn/j4h
ch1DkCGcpOQCuqWZ4S5W3xJcHgXGQ8mJbHoPnZFAP0NoevWHFkfbI2NG1vFSOv3e
nvgeJE6eHWcppujuNL231qSSB8j0XqCG230mxUlEvex48/R6AWapbTfh0b9d4s28
bA6WqYUemYD5OkQttHDyYjeF8npwZ3brpslZmEI5DD1pA9oTKB4u97iLpU/dEafP
5jHwYpCNdVSC9lR3vGG7Ry8e6hgr6DlUZLE8TvovVYlivBZ3y7vDELZSunVfHsUT
jSLmYnXnECWZvk1xO8rPaJmpCnBETMfqiWTYlGEkmaSWL/PPlclOrAm27zXVZBa3
QiIZLIBZ0EWtoHOZtRCEjoMdwnzS2OEt6ZgAn60TvIe92EiRfZwj9u15l0JuJ/uA
UOgZqBPo2sYpsSjXEh14J70c2rK//NZK+9ZobTE8jQTcDFIzz3piHvWzapY6G1x6
crlHXsG58djk/InfjMSO6+kw0JeXWrhclvyhDCaLnCqpxk4EgM/5M66aSNltKJSf
9K9zhWOEryTAahl3lvZmoW4/1ElPcKvAExkOkMLJv1fO181s0gnpgSIDKsbskOFX
GWAraoiuxlaSIir4L6mNzRQqfCDKjrCHE7xvdvcBuQ0yknRXINIOkJVjjBewpbjP
VKSRkLSBScl1OYXvkLbi
=dfTg
-----END PGP SIGNATURE-----

--hHWLQfXTYDoKhP50--
