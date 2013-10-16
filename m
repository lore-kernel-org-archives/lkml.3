Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3JPBue (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 21:50:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:2807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3JPBuc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 21:50:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,504,1378882800"; 
   d="asc'?scan'208";a="417458483"
Date: Tue, 15 Oct 2013 21:35:19 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 5/8] ACPI, APEI, CPER: Add UEFI 2.4 support for memory
 error
Message-ID: <20131016013519.GA6898@gchen.bj.intel.com>
Mail-Followup-To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
	tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
	linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-6-git-send-email-gong.chen@linux.intel.com>
 <20131015172625.GB2777@naverao1-tp.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <20131015172625.GB2777@naverao1-tp.ibm.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 15, 2013 at 10:56:25PM +0530, Naveen N. Rao wrote:
> Date: Tue, 15 Oct 2013 22:56:25 +0530
> From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, bp@alien8.de, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org
> Subject: Re: [PATCH 5/8] ACPI, APEI, CPER: Add UEFI 2.4 support for memory
>  error
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On 2013/10/11 02:32AM, Chen Gong wrote:
> > In latest UEFI spec(by now it is 2.4) memory error definition
> > for CPER (UEFI 2.4 Appendix N Common Platform Error Record)
> > adds some new fields. These fields help people to locate
> > memory error on actual DIMM location.
> >=20
> > Original-author: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> >  drivers/acpi/apei/cper.c | 3 ++-
> >  include/linux/cper.h     | 7 +++++++
> >  2 files changed, 9 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> > index b2e4134..680230c 100644
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
> > @@ -191,6 +191,7 @@ static const char *cper_mem_err_type_strs[] =3D {
> >  	"memory sparing",
> >  	"scrub corrected error",
> >  	"scrub uncorrected error",
> > +	"Physical Memory Map-out event",
>=20
> All small letters to match the rest of the items:
> "physical memory map-out event"
>=20

sure, of course.

> >  };
> > =20
> >  static void cper_print_mem(const char *pfx, const struct cper_sec_mem_=
err *mem)
> > diff --git a/include/linux/cper.h b/include/linux/cper.h
> > index c230494..bd01c9a 100644
> > --- a/include/linux/cper.h
> > +++ b/include/linux/cper.h
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
> > +	__u16	mem_array_handle;
> > +	__u16	mem_dev_handle;
>=20
> Nit: could you name those fields similar to what the spec has:
> card_handle and module_handle, with perhaps a comment to indicate
> relationship to SMBIOS type 16/17 tables?
>=20
>=20
On the contrary, what I'm thinking is reserve these names but
adding comments for what it is in the spec. I consider a
reasonable name is more meaningful than just following the
spec strictly.

> Regards,
> Naveen
>=20
> >  };
> > =20
> >  struct cper_sec_pcie {
> > --=20
> > 1.8.4.rc3
> >=20
>=20

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSXe1XAAoJEI01n1+kOSLHdUsQAJRRfsA7yoxnJyd1rqZLwLtM
6FfGGFPpfIXlKKc9MOnGJ8oR3dma0/gdFVOy/Khg63/Jwd3gO1HQPOJvWNRKV8MF
unJSr3zyyUOpf5a2V7scSPo6aRSWItD5uwkV4kUSaZECSG2X18BxnK9VJpKjnMSV
7RjfyaNhIw3hLXOmt6o1aNwx6xwQAMfBG3PPAmOUYFr+tG8z0oscI9uHSykksDKu
gLHa6CKDBt8ySPWRs/0cj6h7bVNAOk8cYkgUpeTgJjCqKkShYddCCncOlOcZ/uLB
I6bNzVIDTG5ImpAAZ+YcG8xJLWJ77pSDCMOu2j3UC7YD3vhQICsz4HVLKdhGJVaf
2oy39g+DpsVAIVkCzBgY5qK8IFA6PL86K3ZycM8StILUOR+7n8nK50FAxyJuiKDG
g23gd0GFPo6QEYNW/Fuj2PwNlVU7RnczVGXhCLiIfNK4zIPJFMbXjxn149G32sBc
ZibxsFADAILtjIBpVyIQBlyZYu52jQvQtDpj1xk3boRTePrPQNOGUNOmyeuMyrXK
jb3HyvJIyHe+ZYbduzRjo6LSF0PytoFiJ+rjPCqHh3yceL9ym0Y1vc9xpnXN2+rF
tqtVq96KpMVJi8JFGw2jDfJ2EZGjFzKWSjW9e2zuIm7Q8GhTeUYcESE2Xf8TUx+6
0B5yiFB1zrzbW0+Yh5KA
=Cq3t
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
