Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab3CVD2Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:28:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47992 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab3CVD2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:28:24 -0400
Date: Fri, 22 Mar 2013 14:28:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-Id: <20130322142811.41c24edf17de8c6809da5224@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_14_28_11_+1100_lxd2ET5lZ6tcjkeS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_14_28_11_+1100_lxd2ET5lZ6tcjkeS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/gadget/net2272.c between commit eda81bea894e ("usb: gadget:
net2272: finally convert "CONFIG_USB_GADGET_NET2272_DMA"") from the
usb.current tree and commit c36cbfc045bf ("usb: gadget: net2272: remove
unused DMA_ADDR_INVALID") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/net2272.c
index 32524b63,03e4104..0000000
--- a/drivers/usb/gadget/net2272.c
+++ b/drivers/usb/gadget/net2272.c
@@@ -58,8 -58,7 +58,7 @@@ static const char * const ep_name[] =3D=20
  	"ep-a", "ep-b", "ep-c",
  };
 =20
- #define DMA_ADDR_INVALID	(~(dma_addr_t)0)
 -#ifdef CONFIG_USB_GADGET_NET2272_DMA
 +#ifdef CONFIG_USB_NET2272_DMA
  /*
   * use_dma: the NET2272 can use an external DMA controller.
   * Note that since there is no generic DMA api, some functions,

--Signature=_Fri__22_Mar_2013_14_28_11_+1100_lxd2ET5lZ6tcjkeS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS8/LAAoJEECxmPOUX5FEtGwP/jMykrs0fuNioiJozzl7HH0x
4f+xxa0D+xmsoW669xiBc97XNtlvE+GoyU5qhw/rLlHXk8yJTJmPleMufTmKOX1X
TMSFy6QEf8m85fGuIl6olf+nbI5xPhXMep2xqY6Zd5y+uX4O9dca5lEJVzkaP4YE
+c2R/aXvItWv+/VLXXbxx3Ii14eH7B4UpURiRmd9DnquvZZMimZT/rQHfWgA73y1
097tmKgHG+NR3iQ3zFW5Gc9fG186be84i69XSGLPBldg8nBiqFDxb3p55GV82mpV
3aroG/DhtYzCiJZtHqgmE9f/XV4ffAw5nBI6NSCqQHRq37jIbDbDXuXmiEi0OFBS
WrornSSD/VdPBTBvefORhHVkAyC8VFZ6kbSER9nAKyMpCbwS9G9fRODLTzwTxBUo
qYP0nV5z9JS5vDtiWnPe17ulo4/KNw/VGjbaSvmuAcUhc+N8PI+W8bT3qPEHSoqX
QgRRydtzgeRguNvfjrEgc8A+YpwoEgBkngXTiKEfh2LrdQ5JGcPMkT2Fo3kAAxa3
FsKeQIx7zMacyJZn7uWtRShNmorGrnfyNjewP4Q/rX/+Yce64N1vFtfzjK8xQZN4
w3vZUjG7iXSNUtG9hVsRpjipvQxn5gJYL1wZkN1rFhgt84C7XKW5xGHHIcrrs9xK
vXH+MsCfAFaTL4S/5Rvu
=dyqd
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_14_28_11_+1100_lxd2ET5lZ6tcjkeS--
