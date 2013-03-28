Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab3C1Akz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:40:55 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43424 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754392Ab3C1Aky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:40:54 -0400
Date: Thu, 28 Mar 2013 11:40:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20130328114043.b83caaadbd48417f5814e6cc@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__28_Mar_2013_11_40_43_+1100_.Q/lZ7WRkBWXGvjW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Mar_2013_11_40_43_+1100_.Q/lZ7WRkBWXGvjW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/hid-multitouch.c between commit 4c43755506ec ("HID:
multitouch: fix touchpad buttons") from Linus' tree and commit
5b62efd8250d ("HID: multitouch: remove useless last_field_index field")
from the hid tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/hid-multitouch.c
index 82e9211,aceaf6c..0000000
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@@ -680,11 -723,7 +727,7 @@@ static void mt_process_mt_event(struct=20
  		if (usage->usage_index + 1 =3D=3D field->report_count) {
  			/* we only take into account the last report. */
  			if (usage->hid =3D=3D td->last_slot_field)
 -				mt_complete_slot(td, field->hidinput->input);
 +				mt_complete_slot(td, input);
-=20
- 			if (field->index =3D=3D td->last_field_index
- 				&& td->num_received >=3D td->num_expected)
- 				mt_sync_frame(td, field->hidinput->input);
  		}
 =20
  	}

--Signature=_Thu__28_Mar_2013_11_40_43_+1100_.Q/lZ7WRkBWXGvjW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRU5GLAAoJEECxmPOUX5FEWCQP+wZ/mxf7PiKL1HLMou4kQYsq
hyLppX6U9vOzbHE1E4qBFKjs4SXZVpUtH/x6Hy6/rlNP+77INlQnNInxYZYmi7e9
SCTfvsd5j4NQc4Un6bx9i7jS10+ICTzHjj2CZwP5u4CNJvixKxFHSy2QQuSJXEhR
GvY9J1Y03SdyIHrzTUQCBf+Aev5x82TeGrn5lSCZZ2pFAGU/E0+aCs6rcOS4wSsN
BRtvhinOdBGnSHqcnQB6k4O9+OJ4dxthB9BNOskyY0aw+mNKgtk1BkXwRXV6HUq3
Vah6b0s3lNbqaFGkbSvvf+/cL0QizeFOLfxuiNVHHMPXBnJBquI2qUmt5vKkmM+k
eVSpRp+RnYrMSZgo0AeRCCpzljSVnBVVVIsgxsyds5feRTwoZlSlUbFrP+18qThG
0cUNbahUJcAllYDikUy5CfXjwd9Acq2vSWbn10H/Ld4iZk8IAI62G7ek0R0Idc9p
qNSbUWaI22S4ACehuqbuwtbLXKoI/nLf0Rifb2ip3qYWCYyzhpP6Q7L7vwiFflpm
yU/DksYfznhSRQ9NgF7UACx7ElXtI1MhmmgukGjeWt5Ta8xKSWKyNDvBDnFW7H59
Nfr2HabqzltTf6FhJcdzpDsT8j5rSMvikSGTjsQCaJ5dinOAQsY7YWX0XxKSo/OG
EhjDLEPN+dLHx+JAXWFY
=VLw2
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Mar_2013_11_40_43_+1100_.Q/lZ7WRkBWXGvjW--
