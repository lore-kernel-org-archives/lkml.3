Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab3G3EIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 00:08:24 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35278 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3G3EIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 00:08:22 -0400
Date: Tue, 30 Jul 2013 14:08:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rong Wang <Rong.Wang@csr.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-Id: <20130730140810.a61155d064e33248faef323b@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__30_Jul_2013_14_08_10_+1000_KqQ5SSRfOOYTgVOG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Jul_2013_14_08_10_+1000_KqQ5SSRfOOYTgVOG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/gadget/udc-core.c between commit 1894870eb424 ("usb: gadget:
udc-core: fix the typo of udc state attribute") from the usb.current tree
and commit 5702f75375aa ("usb: gadget: udc-core: move sysfs_notify() to a
workqueue") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/udc-core.c
index 13e25f8,3122ab9..0000000
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@@ -105,6 -106,13 +106,13 @@@ EXPORT_SYMBOL_GPL(usb_gadget_unmap_requ
 =20
  /* ----------------------------------------------------------------------=
--- */
 =20
+ static void usb_gadget_state_work(struct work_struct *work)
+ {
+ 	struct usb_gadget	*gadget =3D work_to_gadget(work);
+=20
 -	sysfs_notify(&gadget->dev.kobj, NULL, "status");
++	sysfs_notify(&gadget->dev.kobj, NULL, "state");
+ }
+=20
  void usb_gadget_set_state(struct usb_gadget *gadget,
  		enum usb_device_state state)
  {

--Signature=_Tue__30_Jul_2013_14_08_10_+1000_KqQ5SSRfOOYTgVOG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR9zwuAAoJEECxmPOUX5FEI14P/3qO6PCDKF9R8YlKTZqhM5xf
UVZpeQdx5DC79dcPtVp2Q5r0sn2dg9uk9EKBVY4alxWcPxb3ToIVNEErC3bYmpjD
da1IOOgcvrMozf/H4i0amSeH9wcGbh/60JsSZ89eor5fIiyWQVuxItOpYD8xyNTE
qpaxhCHF43li3BOjfzPphk2yyxEynQfKDO8JIpxqX7SoEQub9V6fcknuZAB67uzG
HCga5XZWm8wDxcI/41EHi0OPDOz8HpGngHLKvWui2h9Q7dzwsMTeyKGQPCtCVyY4
AcQM4j4WmNmPG5jJcuwl08LgtzboowAqtpagmV+z3XgebDHQ058QoGXi4Vi3Csbr
GWvo/G8oLRNrEldrkmeDS0ktvepMw0+L4CGFuQkW5tb2jzLAgQDcZ+h3x2EkKnDR
zER1dZNgBzz6whRHwP6LgMKngu9RI+++Rb+zRc3DMRTn6auTOO62Jc0LdZB0MotZ
VdpzEXrxcdMHiiGMtSzdOIOaTMWr4eaG/dV7RFI1xikGzZLGD2oC4aHn++e0mtZS
LCESGVfxQFKwa4GkKEYnXxDBdE/mCIZHlMg0qZM+AVBTP1gmb0LV4GvWXnja/U33
BkB+fe2/KEunl6FqE8gEcGJlGJ3u1fryKgRDuM/fBv4bp8h/b33Xanjdj4QvmLCH
yf4gZ84pAqXoDvDOcGNS
=lzMB
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Jul_2013_14_08_10_+1000_KqQ5SSRfOOYTgVOG--
