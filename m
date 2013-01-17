Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3AQLTl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:19:41 -0500
Received: from mga14.intel.com ([143.182.124.37]:20151 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735Ab3AQLTj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:19:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,484,1355126400"; 
   d="asc'?scan'208";a="245035438"
Message-ID: <1358421664.2731.228.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] mtd: vt8500: Add support for Wondermedia Serial
 Flash Controller
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tony Prisk <linux@prisktech.co.nz>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        vt8500-wm8505-linux-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 17 Jan 2013 13:21:04 +0200
In-Reply-To: <1358272414-6266-1-git-send-email-linux@prisktech.co.nz>
References: <1358272414-6266-1-git-send-email-linux@prisktech.co.nz>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-X5RpUSkhjIONZypM2RaN"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-X5RpUSkhjIONZypM2RaN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-16 at 06:53 +1300, Tony Prisk wrote:
> This patch adds support for the Wondermedia serial flash controller
> found on WM8505, WM8650 and WM8850 SoCs.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
> v2:
> Change Kconfig depends to ARCH_VT8500 as this driver can't be used on oth=
er
> platforms.

Sparse still complains:

@@ @@
+drivers/mtd/devices/wmt_sflash.c:442:24: warning: cast removes address spa=
ce of expression [sparse]
+drivers/mtd/devices/wmt_sflash.c:458:17: warning: incorrect type in argume=
nt 1 (different address spaces) [sparse]
+drivers/mtd/devices/wmt_sflash.c:458:17:    expected void volatile [nodere=
f] <asn:2>*<noident> [sparse]
+drivers/mtd/devices/wmt_sflash.c:458:17:    got unsigned char [usertype] *=
<noident> [sparse]
+drivers/mtd/devices/wmt_sflash.c:465:25: warning: incorrect type in argume=
nt 1 (different address spaces) [sparse]
+drivers/mtd/devices/wmt_sflash.c:465:25:    expected void volatile [nodere=
f] <asn:2>*<noident> [sparse]
+drivers/mtd/devices/wmt_sflash.c:465:25:    got unsigned char [usertype] *=
<noident> [sparse]

Also, checkpatch.pl has a valid complaint:

WARNING:CONFIG_DESCRIPTION: please write a paragraph that describes the con=
fig symbol fully
#26: FILE: drivers/mtd/devices/Kconfig:131:
+config MTD_WMT_SFLASH

total: 0 errors, 1 warnings, 636 lines checked

...

> +/* WinBond */
> +#define WB_W25X40BV		0x3013	/* 512 KB */
> +#define WB_X16A			0x3015	/* 2 MB */
> +#define WB_X32			0x3016	/* 4 MB */
> +#define WB_X64			0x3017	/* 8 MB */
> +
> +
> +#define SF_ID(mfr, mdl)		((mfr << 16) | mdl)

The flash manufacturer IDs are not specific to this driver, and should
be defined in a common header.


> +
> +#define FLASH_UNKNOWN		0x00ffffff
> +
> +struct wmt_flash_id {
> +	u32	id;
> +	u32	size;		/* Size in KB */
> +};
> +
> +static struct wmt_flash_id flash_ids[] =3D {
> +	{ SF_ID(MFR_SPANSION,	SPAN_FL016A),	2048 },
> +	{ SF_ID(MFR_SPANSION,	SPAN_FL064A),	8192 },
> +	{ SF_ID(MFR_EON,	EON_25P16),	2048 },
> +	{ SF_ID(MFR_EON,	EON_25P64),	8192 },
> +	{ SF_ID(MFR_EON,	EON_25F40),	512 },
> +	{ SF_ID(MFR_EON,	EON_25F16),	2048 },
> +	{ SF_ID(MFR_ATMEL,	AT_25DF041A),	512 },
> +	{ SF_ID(MFR_NUMONYX,	NX_25P16),	2048 },
> +	{ SF_ID(MFR_NUMONYX,	NX_25P64),	8192 },
> +	{ SF_ID(MFR_FUDAN,	FM_25F04),	512 },
> +	{ SF_ID(MFR_SST,	SST_VF016B),	2048 },
> +	{ SF_ID(MFR_MXIC,	MX_L512),	64 },
> +	{ SF_ID(MFR_MXIC,	MX_L4005A),	512 },
> +	{ SF_ID(MFR_MXIC,	MX_L1605D),	2048 },
> +	{ SF_ID(MFR_MXIC,	MX_L3205D),	4192 },
> +	{ SF_ID(MFR_MXIC,	MX_L6405D),	8192 },
> +	{ SF_ID(MFR_MXIC,	MX_L1635D),	2048 },
> +	{ SF_ID(MFR_MXIC,	MX_L3235D),	4192 },
> +	{ SF_ID(MFR_MXIC,	MX_L12805D),	16384 },
> +	{ SF_ID(MFR_WINBOND,	WB_W25X40BV),	512 },
> +	{ SF_ID(MFR_WINBOND,	WB_X16A),	2048 },
> +	{ SF_ID(MFR_WINBOND,	WB_X32),	4096 },
> +	{ SF_ID(MFR_WINBOND,	WB_X64),	8192 },
> +	{ 0, 0 },
> +};

Probably this should also be outside of the driver, since it is not
specific to this driver.

> +static u32 sf_get_chip_size(struct device *dev, u32 id)
> +{
> +	int i;
> +	for (i =3D 0; flash_ids[i].id !=3D 0; i++)
> +		if (flash_ids[i].id =3D=3D id)
> +			return flash_ids[i].size * 1024;
> +
> +	dev_err(dev, "Unknown flash id (%08x)\n", id);
> +	return 0;
> +}

And this.

--=20
Best Regards,
Artem Bityutskiy

--=-X5RpUSkhjIONZypM2RaN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ996gAAoJECmIfjd9wqK0S7oQALLlfrbb72mitN8Tn3quj+sM
fN70SwQSiHgDDReJjuxmlOu0fTe1VSH+Ap+xT66HQj5OBgsoigrBLMTZnHJOj/6T
fsmIVucnolqrK6nq7fdPOAb+L//kVqM/eXfqKVl3pnlaPqYAwvCdxDHnxnJQjB0/
GkySda8PybSJLStiX+qydt3+VyU4cf+d2/6qiiemocd/BqX9nxwzNV6dogdyaAZK
22P4qMfpCRL+Z4U6MWnujZQyaaGo44NnPg9QA9CPjaK8JrbMBj9XalBYJfspbawf
CYyNyrzCSAtYvlCSirhCHn36uwAvWvBY8Vy/zXbcj+bMRogBL5ewF9q+Y0p/YQWB
AnkYR44qHTFX1Qj7EMm04t6ZXGSpcskGZemEinZvfIZPlaqYszUcVTZwJskQMJYT
mMe8WAinOJG6MsCxt4xGbmEebw8Kgd07uqyXvXWf4SwIaQmhBz8y2GcrXRLUP/s7
HQqRe6JUTTv3xlGTE/d88bUi6IvoLIMHu4Y2yH6euCxYu5IQMOJGytP0/ylrqogq
8O6ZRXK6mcvS6G38ODp8bRv/bLedNsVJwCPmtGIY8bCy46punlLa0W5APL60JAq4
xH4uGoh8/jpKNTqu+1g6dD72QBoUj/iraM9Jbikp/cLRQ/ROukpmo8TSWXExiezm
PvKWDHTt9UuWY47mFmJf
=Xz1m
-----END PGP SIGNATURE-----

--=-X5RpUSkhjIONZypM2RaN--

