Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbbAPGYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 01:24:00 -0500
Received: from ozlabs.org ([103.22.144.67]:49871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbbAPGX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 01:23:58 -0500
Date: Fri, 16 Jan 2015 17:23:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Robert Baldyga <r.baldyga@samsung.com>,
        Mian Yousaf Kaukab <yousaf.kaukab@intel.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-ID: <20150116172346.4add4867@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/1X_x/iG5aeLsDf2joUdW9aI"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1X_x/iG5aeLsDf2joUdW9aI
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/dwc2/gadget.c between commit 62f4f0651ce8 ("usb: dwc2:
gadget: kill requests with 'force' in s3c_hsotg_udc_stop()") from the
usb.current tree and commit c6f5c050e2a7 ("usb: dwc2: gadget: add
bi-directional endpoint support") and 1141ea01d5fa ("usb: dwc2: gadget:
kill requests after disabling ep") from the usb-gadget tree.

I fixed it up (I think - see below) and can carry the fix as necessary
(no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/dwc2/gadget.c
index 79242008085b,882a1a8953f5..000000000000
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@@ -2927,8 -2960,12 +2964,12 @@@ static int s3c_hsotg_udc_stop(struct us
  	mutex_lock(&hsotg->init_mutex);
 =20
  	/* all endpoints should be shutdown */
- 	for (ep =3D 1; ep < hsotg->num_of_eps; ep++)
- 		s3c_hsotg_ep_disable_force(&hsotg->eps[ep].ep, true);
+ 	for (ep =3D 1; ep < hsotg->num_of_eps; ep++) {
+ 		if (hsotg->eps_in[ep])
 -			s3c_hsotg_ep_disable(&hsotg->eps_in[ep]->ep);
++			s3c_hsotg_ep_disable_force(&hsotg->eps_in[ep]->ep, true);
+ 		if (hsotg->eps_out[ep])
 -			s3c_hsotg_ep_disable(&hsotg->eps_out[ep]->ep);
++			s3c_hsotg_ep_disable_force(&hsotg->eps_out[ep]->ep, true);
+ 	}
 =20
  	spin_lock_irqsave(&hsotg->lock, flags);
 =20

--Sig_/1X_x/iG5aeLsDf2joUdW9aI
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUuK58AAoJEMDTa8Ir7ZwVCIAP/j2+sM7lYBmRaP/LZgo15Hs7
CnHbuCzRjy5VDEnd6zvnrCL37sQKuDvJmxfmLLUHA+3Vmvq80nqoBYr5vhxLsFUX
kZIT4gtv+lKqEWSOXXdSk0pTdQ3UTnh1pYt+lNBgVGMA4Y7k2DjUANgjpRCi88yB
LdenqITL7StkQKu8ikiybwgvrYdLR7/qpZGpQlsnrf6VpkjalNwy/fSH+xRL5HVX
BD6Ef+4XCjk492sfjduCA80fSAcwunnOeaYoio1RqEAGSpPXA0c6uW8BZz/D8Ipb
SnZf+ugwPdJRRKGKvw6XsQVxki4y0JSi6HCF2F8otJqClrK4I0R1LpQr1sxNrZbv
uTLslfej7AsW00m0hzKV6e1m+gT1z0OVkHsUvpsiEf4qk7P6SwGJp4pRPHvxih9n
CLw0o3K27dxKxCex67Ab2swc6tYkhBKCExWNQtgv1k0NBot3p6rToNF1xzWHGRMm
mV1aAe5pf7+SdEqjA7jcFxD21gKqZDllRZua4/mnJ4RKwzbqsG5RZwusvlwvdVQ9
cjUPOCx7G/LiYQCp7uLFjlX7IkXQEedbY8TePABi0ELQJsntaSjtG5bXSwzR/gUW
iaXAnapLETet6uSIqJRyEdx+WHZYtKwmKsoZaUEQlDIzLYkyylD2uALGQWlX9RFi
wkWDeFB3N64Dqm1iYMAx
=Jjni
-----END PGP SIGNATURE-----

--Sig_/1X_x/iG5aeLsDf2joUdW9aI--
