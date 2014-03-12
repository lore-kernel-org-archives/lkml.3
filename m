Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336AbaCLBiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 21:38:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58161 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756209AbaCLBiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 21:38:07 -0400
Date: Wed, 12 Mar 2014 01:37:58 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg KH <greg@kroah.com>, Valentina Manea <valentina.manea.m@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <20140312013758.9fb3fcc6559a30883e15e787@kernel.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Mar_2014_01_37_58_+0000_G5bBc0aZ/TyR=1G7"
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@kernel.org
Subject: linux-next: manual merge of the staging tree with the  tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Mar_2014_01_37_58_+0000_G5bBc0aZ/TyR=1G7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in  between com=
mit f080a51bef2ca ("USB: complain if userspace resets an active endpoint") =
from the usb tree and commit 9b6f0c4b98171f2a3 ("usbcore: rename struct dev=
_state to struct usb_dev_state") from the staging tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

diff --cc drivers/usb/core/devio.c
index 12401ee4ba0e,2a8afe6754b8..000000000000
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@@ -1125,21 -1043,7 +1125,21 @@@ static int proc_bulk(struct usb_dev_sta
        return ret;
  }
 =20
 +static void check_reset_of_active_ep(struct usb_device *udev,
 +              unsigned int epnum, char *ioctl_name)
 +{
 +      struct usb_host_endpoint **eps;
 +      struct usb_host_endpoint *ep;
 +
 +      eps =3D (epnum & USB_DIR_IN) ? udev->ep_in : udev->ep_out;
 +      ep =3D eps[epnum & 0x0f];
 +      if (ep && !list_empty(&ep->urb_list))
 +              dev_warn(&udev->dev, "Process %d (%s) called USBDEVFS_%s fo=
r active endpoint 0x%02x\n",
 +                              task_pid_nr(current), current->comm,
 +                              ioctl_name, epnum);
 +}
 +
- static int proc_resetep(struct dev_state *ps, void __user *arg)
+ static int proc_resetep(struct usb_dev_state *ps, void __user *arg)
  {
        unsigned int ep;
        int ret;

--Signature=_Wed__12_Mar_2014_01_37_58_+0000_G5bBc0aZ/TyR=1G7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTH7p2AAoJELSic+t+oim9JHEP/iTSiFtXaiqSdzEhK1ks/TRy
C9ScoVixxwzcH7YaB7MeC8po04f9MskovLv5kYBP0m006JBxjfxpmjaAiUQF9XM+
8X9Flm0wUQaz4neVEHF1MYmGbFnwNR0PJfo16Ew9JioXwikGB1gMmMyKRw0yEG84
leuaStHR/NRLlAVFGryU6C8g2vtOlfeFpiYiPSnqfaPpHG8Uhxhm4MR9lHZZml+b
UwTogmRqvRBk2hHjc8pt3Iw4DTIpJUQKBXIUNp/1XaXgpoMdxjJ07P9VMolOSanx
l+EZnUirMe4sPESJoheK8CNllaxgDMRZVCJYYeV7WbVqAuI/bQxDLhzpLPBw7+cE
ThmNNOw7NIu8rHNS8Htw4BdpeYbyo0d1K7YNoCPsYJE17MsbXGqTq/O8SqwOLBR8
xaQ5NNkEHRj4yvN5znqXmq2Z5vKYXysF0+rspk9SH+UYNFO/BC14fbVlgEC8tFth
2JPc/FyVuAvvikb+Xr+t3WRsbppqZ2hERH9vjIwOelU4b5g8ooDygEAk7dLiG5NY
1z+1SF482cmgGAaZwSPbpd+E10rOCinjuqLZb4ruOI2nuQpnZb3krgcdiPehh4l4
lSYpj+zH7eCc0BQzYd+OCsvZ9MF2eZmsIj4zVLbn2RmSHdNMFcwxzUVU2wXcOcKN
odrL4CEq0nQuETh2rBI3
=i+ZN
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Mar_2014_01_37_58_+0000_G5bBc0aZ/TyR=1G7--
