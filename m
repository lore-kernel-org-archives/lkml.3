Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab3BREc7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 23:32:59 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42213 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757Ab3BREc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 23:32:57 -0500
Date: Mon, 18 Feb 2013 15:32:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Manjunath Goudar <manjunath.goudar@linaro.org>
Subject: linux-next: manual merge of the usb tree with the driver-core tree
Message-Id: <20130218153242.747962940bbed03bfdb2623b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Feb_2013_15_32_42_+1100_ixNjl.R/xAQm+ZWC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Feb_2013_15_32_42_+1100_ixNjl.R/xAQm+ZWC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/host/ehci-vt8500.c between commit 148e11349b0c ("usb: Convert
to devm_ioremap_resource()") from the driver-core tree and commit
d57ada0c37ec ("USB: EHCI: make ehci-vt8500 a separate driver") from the
usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/host/ehci-vt8500.c
index 7ecf709,98d65bd..0000000
--- a/drivers/usb/host/ehci-vt8500.c
+++ b/drivers/usb/host/ehci-vt8500.c
@@@ -16,7 -16,12 +16,13 @@@
   *
   */
 =20
 +#include <linux/err.h>
+ #include <linux/kernel.h>
+ #include <linux/module.h>
+ #include <linux/usb.h>
+ #include <linux/usb/hcd.h>
+ #include <linux/io.h>
+ #include <linux/dma-mapping.h>
  #include <linux/of.h>
  #include <linux/platform_device.h>
 =20

--Signature=_Mon__18_Feb_2013_15_32_42_+1100_ixNjl.R/xAQm+ZWC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRIa7qAAoJEECxmPOUX5FEZbwP/3XX6l4bVyw+ehgQJW2HC+Wd
49MNWUcf5tQ3UBizMuVR0DOj1PrI0Ti+D1XLXHRhykiI+qf4fJT9XmNIyI2f6A8b
NNocERyGpqzbpjoJDIW6X7mGqS8gGRq78r90SpBbk9bxWo1dPJW3ViaSq0MUWgrB
9T2Z3AitL6j7fZJL0nLW03FZcXPYwmh2Ae+jB71B+tXIjFMls5jvRUZbV1ad+yid
GomeNcRAKmP64zhE2HJdsCCko6Fk78OTVcpQRpEdrv5+68PDwRAnVGUB2hylxHmd
eI/+glyn/ojGoUJbKV5a1SL5VwMnxTZvF0rtF082/MyLL8y3Gqdu3aZ8MR4fMe5V
DHljDhExzG0VoPnujThYAEIsbXjHoO37gx6EQgYnP1DVoqlqFPMXFD0I9njT6koA
vz6Ph62WQcFpNMDe3GQz6IzxTcsHldZQH2+Szf8o9fmW6guyEPzfDaWPv9B7o9r+
3TB0bLeB5YRD3JzH6TCiiE7qIRzgfXCufQak/MFnkM5t0K+7gK9mu8izcNd3zjGb
KodDcAQzHMxS5UhAZ2C5LisbG0IMUutWQkU0h6hYyU9qJ4XYULwthqRweSnP59SZ
KaUaA6T1ZrSRWMI22CzCbn284KmXzIIqZjT5YXlJfJQdM43kVjkYjjLgsc9hvsrd
+DxZv4WYFZHgLlbwrrro
=APUB
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Feb_2013_15_32_42_+1100_ixNjl.R/xAQm+ZWC--
