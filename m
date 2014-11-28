Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751035AbaK1GdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 01:33:12 -0500
Received: from ozlabs.org ([103.22.144.67]:57229 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbaK1GdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 01:33:10 -0500
Date: Fri, 28 Nov 2014 17:32:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Wolfram Sang <wsa@the-dreams.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Chen <peter.chen@freescale.com>
Subject: linux-next: manual merge of the usb tree with the driver-core tree
Message-ID: <20141128173246.241262c4@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/iJdwW6chG2znZh/To8wO5bW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/iJdwW6chG2znZh/To8wO5bW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/chipidea/core.c between commit 5bc879a6a271 ("usb:
chipidea: drop owner assignment from platform_drivers") from the
driver-core tree and commit 8076932ff2fc ("usb: chipidea: add system
power management support") from the usb tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/chipidea/core.c
index 947ed6e78be2,e14eafb2a05e..000000000000
--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@@ -751,6 -867,8 +867,7 @@@ static struct platform_driver ci_hdrc_d
  	.remove	=3D ci_hdrc_remove,
  	.driver	=3D {
  		.name	=3D "ci_hdrc",
+ 		.pm	=3D &ci_pm_ops,
 -		.owner	=3D THIS_MODULE,
  	},
  };
 =20

--Sig_/iJdwW6chG2znZh/To8wO5bW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUeBcfAAoJEMDTa8Ir7ZwV50wP/2/FlHkfBt0O5QBPDEOXfp8U
YtTYIjTzXexats4FddJPKBhhvkHwrAfoaeYKzglGVXd9Htw8bTmXpixYaBQKnsVw
uCIJ8QI7B5u8sIEVmWH3NANQwtxlSuOo8UNKgzX4ZYR9Od/+Ch47YpDUXw9TLOAu
fG9wbBwq5iPCm61tzGTsdtuubBjfla3Uj0C3rqFTRbOuvITEEHM0eeyFzv81K8uu
XscGErM5h62NyFwpzMIcbqsNy+S2yeHi6ibA5jkaJiXHoPuakjZ0kJa+7BOFKe7V
yLkjo2GsXcHvjDtB1Ka3bkVJydr6nBeQOqlUQc5XdYmrXey5cZQvnL4TqC1/pUgP
zBd5WYSrM0AXGUEbpq0bYcDhh9jfBJCoeJgpmE+5mLib8S5E2jvQT0Z0zARvuGpe
dIQiBDNlKRwG/QrJHtcN+FiBEBncNFQY1cVZmVZ3kHeu4TwyVRdgu616/MGZ+xd1
5eXIcuqlFciowC90M856wqDSVuZb2iUufbegGmgFa/qckIZ7A64gYd7LymhySdyB
PGd2lUUGT2F4h7JddyaeIn4zkmR1+63PwlQhHrD0YiGmhDgl3M29gU2XRBxk0scv
KOL6WstyYpu0SNt2iMMA/sOUkcT8Nbh6C286GruwxDW6g/inQb0YHOuYZ1KL0xr+
Yg471YcpSTJuQQaBNTpH
=lSJk
-----END PGP SIGNATURE-----

--Sig_/iJdwW6chG2znZh/To8wO5bW--
