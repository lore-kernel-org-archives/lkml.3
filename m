Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762AbaCJPVQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:21:16 -0400
Received: from sauhun.de ([89.238.76.85]:33984 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471AbaCJPVO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:21:14 -0400
Date: Mon, 10 Mar 2014 16:21:10 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c: designware-pci: set ideal HCNT, LCNT and SDA
 hold time value
Message-ID: <20140310152110.GC11592@katana>
References: <1394201571-11681-1-git-send-email-chiau.ee.chew@intel.com>
 <1394201571-11681-3-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <1394201571-11681-3-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 07, 2014 at 10:12:51PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> On Intel BayTrail, there was case whereby the resulting fast mode
> bus speed becomes slower (~20% slower compared to expected speed)
> if using the HCNT/LCNT calculated in the core layer. Thus, this
> patch is added to allow pci glue layer to pass in optimal
> HCNT/LCNT/SDA hold time values to core layer since the core
> layer supports cofigurable HCNT/LCNT/SDA hold time values now.
>=20
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
>  drivers/i2c/busses/i2c-designware-pcidrv.c |   34 ++++++++++++++++++++++=
++++++
>  1 files changed, 34 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/bus=
ses/i2c-designware-pcidrv.c
> index 87f2fc4..96417ca 100644
> --- a/drivers/i2c/busses/i2c-designware-pcidrv.c
> +++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
> @@ -58,6 +58,14 @@ enum dw_pci_ctl_id_t {
>  	baytrail,
>  };
> =20
> +struct scl_sda_cfg {
> +	u32 ss_hcnt;
> +	u32 fs_hcnt;
> +	u32 ss_lcnt;
> +	u32 fs_lcnt;
> +	u32 sda_hold;
> +};

'dw_' prefix for this struct name, please.

>  #define INTEL_MID_STD_CFG  (DW_IC_CON_MASTER |			\
> @@ -77,6 +86,21 @@ struct dw_pci_controller {
>  					I2C_FUNC_SMBUS_WORD_DATA |	\
>  					I2C_FUNC_SMBUS_I2C_BLOCK)
> =20
> +/* BayTrail HCNT/LCNT/SDA_HOLD */
> +#define BYT_STD_MODE_HCNT	0x200
> +#define BYT_STD_MODE_LCNT	BYT_STD_MODE_HCNT
> +#define BYT_FAST_MODE_HCNT	0x55
> +#define BYT_FAST_MODE_LCNT	0x99
> +#define BYT_SDA_HOLD		0x6

I'd think you can use these values directly in the struct. They are not
supposed to be used outside anyhow.

> +static struct scl_sda_cfg byt_config =3D {
> +	.ss_hcnt	=3D BYT_STD_MODE_HCNT,
> +	.fs_hcnt	=3D BYT_FAST_MODE_HCNT,
> +	.ss_lcnt	=3D BYT_STD_MODE_LCNT,
> +	.fs_lcnt	=3D BYT_FAST_MODE_LCNT,
> +	.sda_hold	=3D BYT_SDA_HOLD,
> +};

I'd prefer no tabs before "=3D", just one space.

Thanks,

   Wolfram


--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHdhmAAoJEBQN5MwUoCm2To8P/1LZO245IaBq79+gyzzKgeMW
Nsd3djYuv87QJvsspjYAYdyLZ751OXmymFaVW2r5QoMf3JqWrWWTNgwfGdCSaYR2
Pb+w0g15OG8Yu5DvUCv5ByHXlWFf46zJGU77DW+lmV4juGwTJBcF0uEo66O86Rcz
+ZEIwcjuLc+5VXs8VldK6czPUDVPN8wSWFgSE2NoyqrHbim75fFv/e7XIYRYvHNd
C30i7li+FB0Lq/xJp4mvYhtpNiYNey5pLLIV/tdBUP4o2gajlZSTDGgRpC8sijg6
iqTF/DaXFFi6aqWYSSpZqn5fvJFhO4AagIUdCeyu82Z7eU5AK0G2s/UU6wnM/2ix
uVNuo1ptc4R2jPQRqjT9iAgV3+IDNP7A0zBAPG1gA/zpVm/zyMM0dYawqMa1a1zG
cy+y2TQI6nbJ07m+EHlNz/k/Dd5QDu+ntYo55IowyrMhDyCJNV0jARygkokn4DW7
crAovwqRZ3x0uiE0QQukgL1fk8eM+U9UWEIPeXPcO3J3MCHIwKRDMgpmdOeeyupU
tJM9wwC5YjTPSgg7dRxWZfXlxuk4EM+ZYe+CYIpaqNpK59Kfx6Au9B+JknRuAbTQ
C2ubQ96OapCj8X3FQNeK+ZTLfKjy1PhApaA+zYT/OLx8fRc4nbN+HdTkocrNekIT
KxsFGe6RbRhak2elHxmq
=bp7w
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
