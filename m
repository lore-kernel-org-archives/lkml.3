Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaKKFXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 00:23:36 -0500
Received: from ozlabs.org ([103.22.144.67]:36466 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaKKFXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 00:23:34 -0500
Date: Tue, 11 Nov 2014 16:23:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb-gadget-fixes tree
Message-ID: <20141111162322.7be1fade@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UYhITqcUA2wdGIu+Q_TCWiz"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UYhITqcUA2wdGIu+Q_TCWiz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/dwc3/ep0.c between commit 520fe7633692 ("usb: dwc3: ep0:
fix for dead code") from the usb-gadget-fixes tree and commit
ccb072de5702 ("usb: dwc3: ep0: trace ep0 TRBs too") from the usb-gadget
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/dwc3/ep0.c
index df38e7ef4976,4c86772126ed..000000000000
--- a/drivers/usb/dwc3/ep0.c
+++ b/drivers/usb/dwc3/ep0.c
@@@ -791,10 -793,8 +793,12 @@@ static void dwc3_ep0_complete_data(stru
 =20
  	trb =3D dwc->ep0_trb;
 =20
+ 	trace_dwc3_complete_trb(ep0, trb);
+=20
 +	r =3D next_request(&ep0->request_list);
 +	if (!r)
 +		return;
 +
  	status =3D DWC3_TRB_SIZE_TRBSTS(trb->size);
  	if (status =3D=3D DWC3_TRBSTS_SETUP_PENDING) {
  		dwc3_trace(trace_dwc3_ep0, "Setup Pending received");

--Sig_/UYhITqcUA2wdGIu+Q_TCWiz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYZ1UAAoJEMDTa8Ir7ZwV54gP/icWj1SxfA/Qs3UUgLRAhdth
GyLMotV7754WAQYf/RES8nZAZ/R5xC5gQyNUfsIwxGgr5Kv47ggx0x0SD7PnnneT
vFCzWigXmyuGnU8vBU4+MFLw+/3/LQIlYBFqOyZ10WonZPCBxThHLyqLQdTyerC7
NxZzLDTkxiOj/v+d1UTMxIEPrGFVFdF63gCLAVzObr5e/eBIi70/WLdcn5PwatQ4
B9W2dpg5DIrKJhzN30Trglqk96b6XnxJgn6R1MssVkC0zwgnQZMD5BI9UKnfEUtO
aWBLAlHTYod82OtVb6SSr93OFE4eycb+cfySzTH7hmJrCY7W0TCTeli1n8p1Qf+/
mKMUquq5RqVLQQxl0bSOYX0OXUVT972Xcg8gzRcy9wBqwdMYezdnqjmRFkiMjm4n
akdqAa08i1eru1GA3+n6s9dlNKrVTgSPR1sC9uayj6+N7ewAe6u/vpAk1DwRoN08
exwL1YMjFqlfhiBvMXHzYuDdZKOLyxItB9RJopd655uqx/klN2IfY/FlszhIaQV5
ku1AvNVLw+1NrCT4y6Ux6gOd6fhoNXFLsFmCu5GZgX8JpC2LFskJ75iwGRUuGz7j
x9vmX0M8JuqWOVWFm6M0kV3pilBmjfoqj7+jU+m4u6WcmFOEV4dh4WKpBOzoRV8b
SL/JYwa8X+RJ7/kDXRZK
=C4kx
-----END PGP SIGNATURE-----

--Sig_/UYhITqcUA2wdGIu+Q_TCWiz--
