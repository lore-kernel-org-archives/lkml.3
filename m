Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750792AbaEAEhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:37:35 -0400
Received: from ozlabs.org ([103.22.144.67]:43903 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaEAEhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:37:33 -0400
Date: Thu, 1 May 2014 14:37:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Anderson <dianders@chromium.org>,
        Jonathan Cameron <jic23@kernel.org>, Jean Delvare <jdelvare@suse.de>
Subject: linux-next: manual merge of the staging tree with the
 staging.current tree
Message-Id: <20140501143726.13b4ea03f25679d3e0a78fed@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__1_May_2014_14_37_26_+1000_Qi85KDme0QDrn4n2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_May_2014_14_37_26_+1000_Qi85KDme0QDrn4n2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/iio/adc/Kconfig between commit bbc28134e915 ("iio: adc: Nothing
in ADC should be a bool CONFIG") from the staging.current tree and commit
9ef080ec0c5e ("iio: adc: Fix exynos_adc dependencies") from the staging
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/iio/adc/Kconfig
index 24c28e3f93a3,6cbf34a90c04..000000000000
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@@ -106,8 -117,8 +117,8 @@@ config AT91_AD
  	  Say yes here to build support for Atmel AT91 ADC.
 =20
  config EXYNOS_ADC
 -	bool "Exynos ADC driver support"
 +	tristate "Exynos ADC driver support"
- 	depends on OF
+ 	depends on ARCH_EXYNOS || (OF && COMPILE_TEST)
  	help
  	  Core support for the ADC block found in the Samsung EXYNOS series
  	  of SoCs for drivers such as the touchscreen and hwmon to use to share

--Signature=_Thu__1_May_2014_14_37_26_+1000_Qi85KDme0QDrn4n2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTYc+LAAoJEMDTa8Ir7ZwVRuoP/ArtJNBZl/nz0d3dpfmu3Ruu
kfQs2QdtjyCfBv7rT/OdLDWxEDX5/ieFbvlrqOvPmxL2+97PlpUqNBL19koBDPtT
Ow9iThru9RTVAHyNojH0WTpKFIG8LP+NLY1WJcDpp934mszDzl5UTfPUUi51/22u
mFedFxV9QEp/8VU2GE1KX/ss1J9y3ELJnYTXaMQ0IxDtU/qmFROQNVm2dP4JF20r
x5eYA+0W9/2EVkf/BTWY27Ea40w63AF6YoPWaaanTNKCMo++0vDN+HSpfAMWZJy2
kC4Be0gVIjlFfzXtzw/3+Iaab7nQ2bNfOkV4ZnnJP/Q4cT8wraKLWJG+ojXnVgDc
Iwv2iYKrdzi5DvV5McMgxSFOKVHCfeHMs55qaMu/i+yXhFZmZ89J/QEV3b3V8v6p
7cWcWCPuvTh63mTy5maUvdT+IE9mfIy4QBsoDy+FeM1QQn0CVkpQUelUXvXFVFAP
gJGtz4vuMPYFxuPuFB3YPGl1wYUG+X2uGoc0t7sa+qjZw9+ENeDDchQnSGUbV9IY
AgR4SYsj2FBpRk4XWTe2DdGoX28FXd03FTD1VZYZlU6gwMZ2PCb9etHfLFviDd23
dUtewQg96UBkFUqYhwoEUoUcZG3nSV1GqwUSyEJVlxkC8GFks8etQUmk6uiJeOgP
0qDEszyWWMMxaOBRiakW
=hsVT
-----END PGP SIGNATURE-----

--Signature=_Thu__1_May_2014_14_37_26_+1000_Qi85KDme0QDrn4n2--
