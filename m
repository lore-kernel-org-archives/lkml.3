Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3JNDgI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 23:36:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:51658 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340Ab3JNDgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 23:36:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,489,1378882800"; 
   d="asc'?scan'208";a="307356789"
Date: Sun, 13 Oct 2013 23:21:13 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Borislav Petkov <bp@alien8.de>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/8] DMI: Parse memory device (type 17) in SMBIOS
Message-ID: <20131014032113.GB12189@gchen.bj.intel.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-5-git-send-email-gong.chen@linux.intel.com>
 <20131011154048.GH5925@pd.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline
In-Reply-To: <20131011154048.GH5925@pd.tnic>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 05:40:48PM +0200, Borislav Petkov wrote:
> Date: Fri, 11 Oct 2013 17:40:48 +0200
> From: Borislav Petkov <bp@alien8.de>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
>  linux-acpi@vger.kernel.org
> Subject: Re: [PATCH 4/8] DMI: Parse memory device (type 17) in SMBIOS
> User-Agent: Mutt/1.5.21 (2010-09-15)
>=20
> On Fri, Oct 11, 2013 at 02:32:42AM -0400, Chen, Gong wrote:
> > This patch adds a new interface to decode memory device (type 17)
> > to help error reporting on DIMMs.
> >=20
> > Original-author: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
>=20
> Reviewed-by: Borislav Petkov <bp@suse.de>
>=20
> Just a question below:
>=20
> > ---
> >  arch/ia64/kernel/setup.c    |  1 +
> >  arch/x86/kernel/setup.c     |  1 +
> >  drivers/firmware/dmi_scan.c | 60 +++++++++++++++++++++++++++++++++++++=
++++++++
> >  include/linux/dmi.h         |  5 ++++
> >  4 files changed, 67 insertions(+)
> >=20
>=20
> [ ... ]
>=20
> > diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> > index fa0affb..ca3619d 100644
> > --- a/drivers/firmware/dmi_scan.c
> > +++ b/drivers/firmware/dmi_scan.c
> > @@ -25,6 +25,13 @@ static int dmi_initialized;
> >  /* DMI system identification string used during boot */
> >  static char dmi_ids_string[128] __initdata;
> > =20
> > +static struct dmi_memdev_info {
> > +	const char *device;
> > +	const char *bank;
> > +	u16 handle;
> > +} *dmi_memdev;
> > +static int dmi_memdev_nr;
> > +
> >  static const char * __init dmi_string_nosave(const struct dmi_header *=
dm, u8 s)
> >  {
> >  	const u8 *bp =3D ((u8 *) dm) + dm->length;
> > @@ -322,6 +329,42 @@ static void __init dmi_save_extended_devices(const=
 struct dmi_header *dm)
> >  	dmi_save_one_device(*d & 0x7f, dmi_string_nosave(dm, *(d - 1)));
> >  }
> > =20
> > +static void __init count_mem_devices(const struct dmi_header *dm, void=
 *v)
> > +{
> > +	if (dm->type !=3D DMI_ENTRY_MEM_DEVICE)
> > +		return;
> > +	dmi_memdev_nr++;
> > +}
> > +
> > +static void __init save_mem_devices(const struct dmi_header *dm, void =
*v)
> > +{
> > +	const char *d =3D (const char *)dm;
> > +	static int nr;
> > +
> > +	if (dm->type !=3D DMI_ENTRY_MEM_DEVICE)
> > +		return;
> > +	if (nr >=3D dmi_memdev_nr) {
> > +		pr_warn_once("Too many DIMM entries in SMBIOS table\n");
> > +		return;
>=20
> Is this and count_mem_devices() some sort of precaution against insane
> DMI tables?
>=20

Yes, but we highly expect BIOS manufactors to make is valid and complete.
> --=20
> Regards/Gruss,
>     Boris.
>=20
> Sent from a fat crate under my desk. Formatting is fine.
> --

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSW2MpAAoJEI01n1+kOSLHopUQAKNpCRoyy217ZwJwyZhXFi/T
drXDhQSsOITz4vvu4ZsgcooqODsPEhDNwcMIShkFb+c49YrH+4KYjKJrj9ePk+ao
2efn8zIyxFlV+1rBkA+sPzCB1kKN70e9TkFGSzkJ6XsDqvPN1RY9odbnMbkZC8Z0
VFvo0ReJvib4leQnUHtDF9tpUdvlrvf1Q5nFnCDWkzKepezC+V53frTbS4jTkfqg
7sQgrImTOH+uEgIEWDdmQSnDoxDhN7izTsxgYHy/dOnmi39fPCrlB9TLsKfFVx8p
SQc/HlvGAsB9sX3VBazBEfvcCjdirFbgp+scFZ9PV7krMOq7JAA2PgySXuMwOzLT
6uTUazQ8ZWKspcLsSIU0t0us13be3vAUTQ907TrZn9ln/PYJiHvO0LpiupFqrhSk
ehjEWAFFGgyhMmUsHsF+S03qq+0qzDXiiVaxACizWhYiMwlTffPV/vsXuDhplDJv
AqC0gTtcWOh4STRqxE/USs9bHvxBiU/ZYa3G57/bW0HzUVR/ttKbAi+KPmvHSEef
jwKUVefZsHT/N7WLKf3vLqGQvVkZxBElGuuYEpukYl4BkjwFnIQZssiSMd/1Eivk
ZygiTUQZIrOETJrHgT4jVhzzKoMksJNRiwOifVrk9Oevct2oSS8IXNjXvn685OXj
vve0FxejVBGkZ2wkG3XJ
=/Ch5
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
