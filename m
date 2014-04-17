Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaDQLJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 07:09:20 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:56087 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaDQLJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 07:09:16 -0400
Date: Thu, 17 Apr 2014 13:08:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] pwm_lpss: Add support for PCI devices
Message-ID: <20140417110756.GB32603@ulmo>
References: <1397672338-3510-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <1397672338-3510-1-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 17, 2014 at 02:18:58AM +0800, Chew Chiau Ee wrote:
> From: Alan Cox <alan@linux.intel.com>
>=20
> Not all systems enumerate the PWM devices via ACPI. They can also be expo=
sed
> via the PCI interface.
>=20
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> ---
>  drivers/pwm/pwm-lpss.c |  159 ++++++++++++++++++++++++++++++++++++++----=
-----
>  1 files changed, 128 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/pwm/pwm-lpss.c b/drivers/pwm/pwm-lpss.c
> index 449e372..aa8af08 100644
> --- a/drivers/pwm/pwm-lpss.c
> +++ b/drivers/pwm/pwm-lpss.c
> @@ -6,6 +6,7 @@
>   * Author: Chew Kean Ho <kean.ho.chew@intel.com>
>   * Author: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
>   * Author: Chew Chiau Ee <chiau.ee.chew@intel.com>
> + * Author: Alan Cox <alan@linux.intel.com>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
> @@ -19,6 +20,9 @@
>  #include <linux/module.h>
>  #include <linux/pwm.h>
>  #include <linux/platform_device.h>
> +#include <linux/pci.h>
> +
> +static int pci_drv, plat_drv;	/* So we know which drivers registered */

I think that rather than having everything in a single file, perhaps a
better approach would be to keep pwm-lpss.c as a common module and then
have separate drivers for ACPI (pwm-lpss-acpi) and PCI (pwm-lpss-pci).
That way you don't have to keep track of which driver was successfully
registered.

Would that work?

> +static const struct pwm_lpss_boardinfo byt_info =3D {

What does byt_ stand for?

> -static int pwm_lpss_probe(struct platform_device *pdev)
> +static struct pwm_lpss_chip *pwm_lpss_probe(struct device *dev,
> +			struct resource *r, struct pwm_lpss_boardinfo *info)

Indentation is odd here. Please align arguments one subsequent lines
with those of the first.

> -static struct platform_driver pwm_lpss_driver =3D {
> +static int pwm_lpss_probe_pci(struct pci_dev *pdev,
> +			      const struct pci_device_id *id)
> +{
> +	struct pwm_lpss_boardinfo *info;

I think this should be const to mirror the type of the byt_info
variable.

> +	struct pwm_lpss_chip *lpwm;
> +	int err;
> +
> +	err =3D pci_enable_device(pdev);
> +	if (err < 0)
> +		return err;
> +
> +	info =3D  (struct pwm_lpss_boardinfo *)id->driver_data;

There's an extraneous space between '=3D' and '('.

Thierry

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTT7YMAAoJEN0jrNd/PrOhJ9gP/0Z7O/IkxMF74Z2712vr0mZP
CeuI3AdTXXvReydhP3dnvAUWdKwqqQv3OgctONO7NMmTgsVCkPWUyn5KBI67KJp4
AXfjOL6a0j9qfBiV7aF8X12HM+r8jipnGees/9s45OqK+QH5IJva9flrabFot+e5
Lccdeavf0Z9cGQO6Ml2ZutSYZ1YCKnFx7VFBsEUiq58t7YJMEjIoFNIvpftOdHcx
3lIUIfWR1eGkmowf2BomLMfpzPVwavq9em59maFtBtrgcD0G7LkjyYDDi/1GQIav
pbf1oXvbQmAMQ1T+/42sH4K91dcyAnOaE0tCwmeCMmSDXmVo/CCNNy2mRWeL7/Hn
IpsVUSz3qtwpHMaCIsGjuK4uPopA8503cj76xBexSUjFfdtaBSUuC5phSTIKbPEo
PsbjcPEMGTbqsxmnJ8dBMhQBjOrxDvsz8AV4eb+6cvL3iSb0gADXWSCbOxlgWTkR
+5x6dR0F9pIIYpAMHDzZChVj2dIg4ZUJjJvbFrLsoxvBuWG9SMhJwXlJexk0/M2o
qJp16+Mc1lvp7KeYqwjCjOn1pTyBSdkqgD49F6kBTYikwiQwWgA6Er2KuPf9307i
gOkcQdYmaMpgwUUnS6l4dd4V0jg4lsqxavkI9oKgAcn55jrBqJ6UpQGjHbEIMbeZ
tGesr3+KpwbBabQnGEXh
=mogR
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
