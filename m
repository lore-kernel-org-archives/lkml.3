Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbbAYM7N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 07:59:13 -0500
Received: from mail.kernel.org ([198.145.29.136]:41798 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbbAYM7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 07:59:11 -0500
Date: Sun, 25 Jan 2015 13:59:05 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Todd Brandt <todd.e.brandt@linux.intel.com>
Cc: linux-pm@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, todd.e.brandt@intel.com,
        jacob.jun.pan@linux.intel.com, sameo@linux.intel.com,
        lee.jones@linaro.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        david.woodhouse@intel.com
Subject: Re: [PATCH v2 2/3] mfd/axp20x: add support for fuel gauge cell
Message-ID: <20150125125905.GB2719@earth.universe>
References: <cover.1421957474.git.todd.e.brandt@linux.intel.com>
 <0d1c6b3e06c3195a87d72ca5ec8456748af463ca.1421957474.git.todd.e.brandt@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="+g7M9IMkV8truYOl"
Content-Disposition: inline
In-Reply-To: <0d1c6b3e06c3195a87d72ca5ec8456748af463ca.1421957474.git.todd.e.brandt@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+g7M9IMkV8truYOl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 22, 2015 at 12:52:06PM -0800, Todd Brandt wrote:
> Register definitions and platform data structure
> for fuel gauge cell devices.
>=20
> Signed-off-by: Todd Brandt <todd.e.brandt@linux.intel.com>
> ---
>  include/linux/mfd/axp20x.h | 43 ++++++++++++++++++++++++++++++++++++++++=
+--
>  1 file changed, 41 insertions(+), 2 deletions(-)
>=20
> v2: same as v1 and is already accepted, re-included for continuity
>=20
> diff --git a/include/linux/mfd/axp20x.h b/include/linux/mfd/axp20x.h
> index 81589d1..dfabd6d 100644
> --- a/include/linux/mfd/axp20x.h
> +++ b/include/linux/mfd/axp20x.h
> @@ -124,10 +124,27 @@ enum {
>  #define AXP288_PMIC_ADC_H               0x56
>  #define AXP288_PMIC_ADC_L               0x57
>  #define AXP288_ADC_TS_PIN_CTRL          0x84
> -
>  #define AXP288_PMIC_ADC_EN              0x84
> -#define AXP288_FG_TUNE5			0xed
> =20
> +/* Fuel Gauge */
> +#define AXP288_FG_RDC1_REG          0xba
> +#define AXP288_FG_RDC0_REG          0xbb
> +#define AXP288_FG_OCVH_REG          0xbc
> +#define AXP288_FG_OCVL_REG          0xbd
> +#define AXP288_FG_OCV_CURVE_REG     0xc0
> +#define AXP288_FG_DES_CAP1_REG      0xe0
> +#define AXP288_FG_DES_CAP0_REG      0xe1
> +#define AXP288_FG_CC_MTR1_REG       0xe2
> +#define AXP288_FG_CC_MTR0_REG       0xe3
> +#define AXP288_FG_OCV_CAP_REG       0xe4
> +#define AXP288_FG_CC_CAP_REG        0xe5
> +#define AXP288_FG_LOW_CAP_REG       0xe6
> +#define AXP288_FG_TUNE0             0xe8
> +#define AXP288_FG_TUNE1             0xe9
> +#define AXP288_FG_TUNE2             0xea
> +#define AXP288_FG_TUNE3             0xeb
> +#define AXP288_FG_TUNE4             0xec
> +#define AXP288_FG_TUNE5             0xed
> =20
>  /* Regulators IDs */
>  enum {
> @@ -236,4 +253,26 @@ struct axp20x_dev {
>  	const struct regmap_irq_chip	*regmap_irq_chip;
>  };
> =20
> +#define BATTID_LEN				64
> +#define OCV_CURVE_SIZE			32
> +#define MAX_THERM_CURVE_SIZE	25
> +#define PD_DEF_MIN_TEMP			0
> +#define PD_DEF_MAX_TEMP			55
> +
> +struct axp20x_fg_pdata {
> +	char battid[BATTID_LEN + 1];
> +	int design_cap;
> +	int min_volt;
> +	int max_volt;
> +	int max_temp;
> +	int min_temp;
> +	int cap1;
> +	int cap0;
> +	int rdc1;
> +	int rdc0;
> +	int ocv_curve[OCV_CURVE_SIZE];
> +	int tcsz;
> +	int thermistor_curve[MAX_THERM_CURVE_SIZE][2];
> +};

Acked-By: Sebastian Reichel <sre@kernel.org>

-- Sebastian

--+g7M9IMkV8truYOl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUxOiZAAoJENju1/PIO/qaYnIP/0elT4jd6qjLNb8aOWD1A5Gg
OJ6svuzpu5AUpEWmkuXoIMuQcyuYRytWaTmI09wl91Tv6gtVDSDOk5CaI84WMZ4w
s9xWu8oIr/ewDnjSISikTkQJQEJKIBs6DAoU6rH4oaEaMwKjPd/pRzkZFNRQk0GV
kp68rgH1bZ7Lwl1zyZEjEVzxYHF/eNXr3tb0pCOzgVH7R88Luy11v9XneWtH6Gwb
61KsSQRGSwCJh762VHU9Lhh1X+1sJ3bBvaKLGGS0mrkB653icyK7TCvIfxFDRsf+
VzC1VRwVWEy118GvLV9aB82RV2aijd2y9fDQDMiNqX3VkDYg5oLJzWHIwe+dOdk2
vsK8pqC22pTsjoBicCjbfdOWYPM9syNQCBXqIJebUA336s/6MegbItu9D3oXdn6P
93mcZokU0X+lDM9+lqArvFhG1Z5JG3HwB19VauING4rF5Nd+nnZV0GgXksW/T9oI
iREQ0rdGKJNr59JXGCLwf12e30Qi+L5iyMw4H+K0JOBI1705+YepCd8XysUXTPN4
txTnXl4Tu1iZAUGMy82KBso70k+F/XW7o70KvR5I08s+Ge2Ax95+s0jh1NDLE4Xi
SSvvhgayl08BeeaoRu5Rkk6ndG0ckG303wHC0nJaQ0E9mw0UBX6qpYQ7S+PsrWxK
iyMRHOlF4u9RlnbgN6IC
=hmYb
-----END PGP SIGNATURE-----

--+g7M9IMkV8truYOl--
