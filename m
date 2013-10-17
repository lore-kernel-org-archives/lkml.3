Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab3JQMbo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:31:44 -0400
Received: from mga09.intel.com ([134.134.136.24]:29280 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579Ab3JQMbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:31:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,514,1378882800"; 
   d="asc'?scan'208";a="394373764"
Date: Thu, 17 Oct 2013 08:16:49 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/9] ACPI, APEI, CPER: Add UEFI 2.4 support for memory
 error
Message-ID: <20131017121649.GA8701@gchen.bj.intel.com>
Mail-Followup-To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	tony.luck@intel.com, bp@alien8.de, joe@perches.com,
	naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-7-git-send-email-gong.chen@linux.intel.com>
 <20131017072306.5839d500@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
In-Reply-To: <20131017072306.5839d500@samsung.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 17, 2013 at 07:23:06AM -0300, Mauro Carvalho Chehab wrote:
> Date: Thu, 17 Oct 2013 07:23:06 -0300
> From: Mauro Carvalho Chehab <m.chehab@samsung.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
>  naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
>  linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 6/9] ACPI, APEI, CPER: Add UEFI 2.4 support for
>  memory error
> X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
>=20
> Em Wed, 16 Oct 2013 10:56:03 -0400
> "Chen, Gong" <gong.chen@linux.intel.com> escreveu:
>=20
> > In latest UEFI spec(by now it is 2.4) memory error definition
> > for CPER (UEFI 2.4 Appendix N Common Platform Error Record)
> > adds some new fields. These fields help people to locate
> > memory error on actual DIMM location.
> >=20
> > Original-author: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > Reviewed-by: Borislav Petkov <bp@suse.de>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce-apei.c |  3 +--
> >  drivers/acpi/apei/cper.c              |  7 ++++---
> >  drivers/acpi/apei/ghes.c              |  4 ++--
> >  drivers/edac/ghes_edac.c              |  5 ++---
> >  include/linux/cper.h                  | 11 +++++++++--
> >  5 files changed, 18 insertions(+), 12 deletions(-)
> >=20
> > diff --git a/arch/x86/kernel/cpu/mcheck/mce-apei.c b/arch/x86/kernel/cp=
u/mcheck/mce-apei.c
> > index cd8b166..de8b60a 100644
> > --- a/arch/x86/kernel/cpu/mcheck/mce-apei.c
> > +++ b/arch/x86/kernel/cpu/mcheck/mce-apei.c
> > @@ -42,8 +42,7 @@ void apei_mce_report_mem_error(int corrected, struct =
cper_sec_mem_err *mem_err)
> >  	struct mce m;
> > =20
> >  	/* Only corrected MC is reported */
> > -	if (!corrected || !(mem_err->validation_bits &
> > -				CPER_MEM_VALID_PHYSICAL_ADDRESS))
> > +	if (!corrected || !(mem_err->validation_bits & CPER_MEM_VALID_PA))
> >  		return;
> > =20
> >  	mce_setup(&m);
> > diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> > index eb5f6d6..946ef52 100644
> > --- a/drivers/acpi/apei/cper.c
> > +++ b/drivers/acpi/apei/cper.c
> > @@ -8,7 +8,7 @@
> >   * various tables, such as ERST, BERT and HEST etc.
> >   *
> >   * For more information about CPER, please refer to Appendix N of UEFI
> > - * Specification version 2.3.
> > + * Specification version 2.4.
> >   *
> >   * This program is free software; you can redistribute it and/or
> >   * modify it under the terms of the GNU General Public License version
> > @@ -191,16 +191,17 @@ static const char *cper_mem_err_type_strs[] =3D {
> >  	"memory sparing",
> >  	"scrub corrected error",
> >  	"scrub uncorrected error",
> > +	"physical memory map-out event",
> >  };
> > =20
> >  static void cper_print_mem(const char *pfx, const struct cper_sec_mem_=
err *mem)
> >  {
> >  	if (mem->validation_bits & CPER_MEM_VALID_ERROR_STATUS)
> >  		printk("%s""error_status: 0x%016llx\n", pfx, mem->error_status);
> > -	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)
> > +	if (mem->validation_bits & CPER_MEM_VALID_PA)
> >  		printk("%s""physical_address: 0x%016llx\n",
> >  		       pfx, mem->physical_addr);
> > -	if (mem->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK)
> > +	if (mem->validation_bits & CPER_MEM_VALID_PA_MASK)
> >  		printk("%s""physical_address_mask: 0x%016llx\n",
> >  		       pfx, mem->physical_addr_mask);
> >  	if (mem->validation_bits & CPER_MEM_VALID_NODE)
> > diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> > index 0db6e4f..a30bc31 100644
> > --- a/drivers/acpi/apei/ghes.c
> > +++ b/drivers/acpi/apei/ghes.c
> > @@ -419,7 +419,7 @@ static void ghes_handle_memory_failure(struct acpi_=
generic_data *gdata, int sev)
> > =20
> >  	if (sec_sev =3D=3D GHES_SEV_CORRECTED &&
> >  	    (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED) &&
> > -	    (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS)) {
> > +	    (mem_err->validation_bits & CPER_MEM_VALID_PA)) {
> >  		pfn =3D mem_err->physical_addr >> PAGE_SHIFT;
> >  		if (pfn_valid(pfn))
> >  			memory_failure_queue(pfn, 0, MF_SOFT_OFFLINE);
> > @@ -430,7 +430,7 @@ static void ghes_handle_memory_failure(struct acpi_=
generic_data *gdata, int sev)
> >  	}
> >  	if (sev =3D=3D GHES_SEV_RECOVERABLE &&
> >  	    sec_sev =3D=3D GHES_SEV_RECOVERABLE &&
> > -	    mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
> > +	    mem_err->validation_bits & CPER_MEM_VALID_PA) {
> >  		pfn =3D mem_err->physical_addr >> PAGE_SHIFT;
> >  		memory_failure_queue(pfn, 0, 0);
> >  	}
> > diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
> > index bb53467..0ad797b 100644
> > --- a/drivers/edac/ghes_edac.c
> > +++ b/drivers/edac/ghes_edac.c
> > @@ -297,15 +297,14 @@ void ghes_edac_report_mem_error(struct ghes *ghes=
, int sev,
> >  	}
> > =20
> >  	/* Error address */
> > -	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS) {
> > +	if (mem_err->validation_bits & CPER_MEM_VALID_PA) {
> >  		e->page_frame_number =3D mem_err->physical_addr >> PAGE_SHIFT;
> >  		e->offset_in_page =3D mem_err->physical_addr & ~PAGE_MASK;
> >  	}
> > =20
> >  	/* Error grain */
> > -	if (mem_err->validation_bits & CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK) {
> > +	if (mem_err->validation_bits & CPER_MEM_VALID_PA_MASK)
> >  		e->grain =3D ~(mem_err->physical_addr_mask & ~PAGE_MASK);
> > -	}
> > =20
> >  	/* Memory error location, mapped on e->location */
> >  	p =3D e->location;
> > diff --git a/include/linux/cper.h b/include/linux/cper.h
> > index 09ebe21..2fc0ec3 100644
> > --- a/include/linux/cper.h
> > +++ b/include/linux/cper.h
> > @@ -218,8 +218,8 @@ enum {
> >  #define CPER_PROC_VALID_IP			0x1000
> > =20
> >  #define CPER_MEM_VALID_ERROR_STATUS		0x0001
> > -#define CPER_MEM_VALID_PHYSICAL_ADDRESS		0x0002
> > -#define CPER_MEM_VALID_PHYSICAL_ADDRESS_MASK	0x0004
> > +#define CPER_MEM_VALID_PA			0x0002
> > +#define CPER_MEM_VALID_PA_MASK			0x0004
> >  #define CPER_MEM_VALID_NODE			0x0008
> >  #define CPER_MEM_VALID_CARD			0x0010
> >  #define CPER_MEM_VALID_MODULE			0x0020
> > @@ -232,6 +232,9 @@ enum {
> >  #define CPER_MEM_VALID_RESPONDER_ID		0x1000
> >  #define CPER_MEM_VALID_TARGET_ID		0x2000
> >  #define CPER_MEM_VALID_ERROR_TYPE		0x4000
> > +#define CPER_MEM_VALID_RANK_NUMBER		0x8000
> > +#define CPER_MEM_VALID_CARD_HANDLE		0x10000
> > +#define CPER_MEM_VALID_MODULE_HANDLE		0x20000
> > =20
> >  #define CPER_PCIE_VALID_PORT_TYPE		0x0001
> >  #define CPER_PCIE_VALID_VERSION			0x0002
> > @@ -347,6 +350,10 @@ struct cper_sec_mem_err {
> >  	__u64	responder_id;
> >  	__u64	target_id;
> >  	__u8	error_type;
> > +	__u8	reserved;
> > +	__u16	rank;
> > +	__u16	mem_array_handle;	/* card handle in UEFI 2.4 */
> > +	__u16	mem_dev_handle;		/* module handle in UEFI 2.4 */
>=20
> Hmm... you're adding 3 new types here and the corresponding space inside =
the
> structure (rank, card_handle and module_handle), but the code that parses=
 and
> prints it is missing, at apei_mce_report_mem_error(), cper_print_mem(),
> ghes_handle_memory_failure() and ghes_edac_report_mem_error().
>=20
>=20

1. This patch is just for definition update.=20
2. apei_mce_report_mem_error/cper_print_mem/ghes_handle_memory_failure
   finally point to apei/cper. So patch [8/9] can cover it. As for=20
   EDAC part (ghes_edac_report_mem_error), I can add a new separate
   patch to fix missed part.

> >  };
> > =20
> >  struct cper_sec_pcie {
>=20
>=20
> --=20
>=20
> Cheers,
> Mauro

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSX9UwAAoJEI01n1+kOSLHOD0P/iIV5BSUKsdwzBTj3Tfqc/K0
0lWwHmsd+w/O0ZCEw4lWG+Ext7/9E2KF+yCWURgl5Qwbf5AUVusOJo731nHBxjCb
BYYQb09kO77VXgo/9K7P7VvgtV08STYv1aJccn4U0P0dcNZwTxUU6sX6r6CJmO29
e2ZHEGLxwIPEbDKB2lTBuSIWbRo1iVOAt5ztpNN/MMHdaidNfIgjP8v6vvLV6Px5
CEe1C+t5ri8fD3T8WZkR9eLKjS0ebi8yDgqukY64NfeABwI4T1bsWa7KimdC9z7U
Jkxy7moofnnmY+OJ80PiCaPLhORT9h8ZhuaKQ0VOJYuRKKyLtnf04Z2Zkljia/bw
BsshPcHJ1XWlCK9kqyLfs4h5OA0/vjFBiV5vY9e5AIzXRScrus34sco61xhi5F6y
m4ZXn8LkynGkZfvhYtHt0zCxiTySVMNSR4JL8aPvEeVgv+7dcOu0XE0GTYXYDK2Z
1z3t0m9GcXrDxDzrqNvX3kHBd7aZRet5m+aJpXT2Or8Z5pzkBWxMW2Ek8RVtNFAS
x3KVMN7Kq9XWHFY+T+ZyIRI+xG5ivr3BySEHl6Q90REpjmFosGEWElXEvwHK0iRt
LEjLNcgcnfVXzmQrwJmM9WxDrl0fkM6x4gAJRXaShSyLpegFkE7+E2HXcdDLPUg0
bsYyqRglc+5PI8gWlw84
=zTMY
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
