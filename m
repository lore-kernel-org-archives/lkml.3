Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751340Ab3JNFJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 01:09:43 -0400
Received: from mga03.intel.com ([143.182.124.21]:16086 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab3JNFJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 01:09:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,489,1378882800"; 
   d="asc'?scan'208";a="374284223"
Date: Mon, 14 Oct 2013 00:55:00 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error output
 format
Message-ID: <20131014045500.GC12189@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-8-git-send-email-gong.chen@linux.intel.com>
 <20131011160208.GL5925@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <20131011160208.GL5925@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 06:02:08PM +0200, Borislav Petkov wrote:
> Date: Fri, 11 Oct 2013 18:02:08 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org
> Subject: Re: [PATCH 7/8] ACPI, APEI, CPER: Cleanup CPER memory error outp=
ut
>  format
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Fri, Oct 11, 2013 at 02:32:45AM -0400, Chen, Gong wrote:
> > Keep up only the most important fields for memory error
> > reporting. The detail information will be moved to perf/trace
> > interface.
> >=20
> > Suggested-by: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > ---
> >  drivers/acpi/apei/cper.c | 42 ++++++++++++++--------------------------=
--
> >  1 file changed, 14 insertions(+), 28 deletions(-)
> >=20
> > diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> > index 2a4389f..567410e 100644
> > --- a/drivers/acpi/apei/cper.c
> > +++ b/drivers/acpi/apei/cper.c
> > @@ -206,29 +206,29 @@ static void cper_print_mem(const char *pfx, const=
 struct cper_sec_mem_err *mem)
> >  		printk("%s""physical_address_mask: 0x%016llx\n",
> >  		       pfx, mem->physical_addr_mask);
> >  	if (mem->validation_bits & CPER_MEM_VALID_NODE)
> > -		printk("%s""node: %d\n", pfx, mem->node);
> > +		pr_debug("node: %d\n", mem->node);
> >  	if (mem->validation_bits & CPER_MEM_VALID_CARD)
> > -		printk("%s""card: %d\n", pfx, mem->card);
> > +		pr_debug("card: %d\n", mem->card);
> >  	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
> > -		printk("%s""module: %d\n", pfx, mem->module);
> > +		pr_debug("module: %d\n", mem->module);
> >  	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
> > -		printk("%s""rank: %d\n", pfx, mem->rank);
> > +		pr_debug("rank: %d\n", mem->rank);
> >  	if (mem->validation_bits & CPER_MEM_VALID_BANK)
> > -		printk("%s""bank: %d\n", pfx, mem->bank);
> > +		pr_debug("bank: %d\n", mem->bank);
> >  	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
> > -		printk("%s""device: %d\n", pfx, mem->device);
> > +		pr_debug("device: %d\n", mem->device);
> >  	if (mem->validation_bits & CPER_MEM_VALID_ROW)
> > -		printk("%s""row: %d\n", pfx, mem->row);
> > +		pr_debug("row: %d\n", mem->row);
> >  	if (mem->validation_bits & CPER_MEM_VALID_COLUMN)
> > -		printk("%s""column: %d\n", pfx, mem->column);
> > +		pr_debug("column: %d\n", mem->column);
> >  	if (mem->validation_bits & CPER_MEM_VALID_BIT_POSITION)
> > -		printk("%s""bit_position: %d\n", pfx, mem->bit_pos);
> > +		pr_debug("bit_position: %d\n", mem->bit_pos);
> >  	if (mem->validation_bits & CPER_MEM_VALID_REQUESTOR_ID)
> > -		printk("%s""requestor_id: 0x%016llx\n", pfx, mem->requestor_id);
> > +		pr_debug("requestor_id: 0x%016llx\n", mem->requestor_id);
> >  	if (mem->validation_bits & CPER_MEM_VALID_RESPONDER_ID)
> > -		printk("%s""responder_id: 0x%016llx\n", pfx, mem->responder_id);
> > +		pr_debug("responder_id: 0x%016llx\n", mem->responder_id);
> >  	if (mem->validation_bits & CPER_MEM_VALID_TARGET_ID)
> > -		printk("%s""target_id: 0x%016llx\n", pfx, mem->target_id);
> > +		pr_debug("target_id: 0x%016llx\n", mem->target_id);
> >  	if (mem->validation_bits & CPER_MEM_VALID_ERROR_TYPE) {
> >  		u8 etype =3D mem->error_type;
> >  		printk("%s""error_type: %d, %s\n", pfx, etype,
>=20
> Hmm, so this cper_print_mem is called for CPER_SEC_PLATFORM_MEM section
> type.
>=20
> With the change above, the other caller __ghes_print_estatus() won't see
> the error messages if they're debug. Do we want that?
>=20

Because most of data in CPER are empty or unimportant. To avoid too much
disturbance to end users, it is worthy to do that. Moreover, I reserve
another way via trace to show these data.

> --=20
> Regards/Gruss,
>     Boris.
>=20
> Sent from a fat crate under my desk. Formatting is fine.
> --

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSW3kkAAoJEI01n1+kOSLHnUoP/1CprkDqHmPTcT7chsDp+HfN
To4cURQXPv0egNuXWqkQCZ9Af/AEwpv1ERI4iTVaC5riQMyOLdnT8hW+5MmFT1h9
gkaQ0Ss8BMx42Z3E0NoCV/Z+qCrmtyk4XTBCnAssX8+35UMeCncZXSNk0w/fMmhi
a6rEUreR7kxumSSmOcNuml4OdCZWwMuy0MiagOPiw4Snnsdn2NEzhtE+jTCWVxpH
3t8ZApLL95Yn/8Abmjr3KasGDf8ladm0z+0VAOEb5kCEVFAvxGoKR9bxffyGfrHL
NYlfRSd8RdczBTSwaNUyoy383KHasBTTRSGJ22LovjOq8NlaMvh5Qr1ArdAsEyIV
2r2yFdo3RmPguSsj5fw4YFfVC/iq176Q0WY4XKmC8s9zD/KDUHJ+Cv9t+iFpEGad
NGvB90AEpdOlHFJk85bxkqAeUMVvQpi2K70eFCSNXBd7yHF2qFq+gM2QaJGz/RJs
BFDxoVH0WDDlKmPrU5Sg9m00yUVrbA3sFPfuNKOFKayWh9qgmdbtDsLs8nZCUJYe
H9r0a9QWba6pxbXCOiaD/JXHBP4RPR2e4DfsGF/5o/Qq7y7U4MZtbpcW/0X3KUH/
5wNe+Nt/i0R0R5WUClT+M3luLaq9JDEidzhc1xbdY5mY1oXAaKnajIlKy71Dj2ew
/ae8jnI1i0iAkirFS+e3
=11rt
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
