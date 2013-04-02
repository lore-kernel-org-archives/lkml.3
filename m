Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778Ab3DBGL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:11:56 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41236 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab3DBGLy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:11:54 -0400
Date: Tue, 2 Apr 2013 17:11:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the usb-gadget tree with the  tree
Message-Id: <20130402171143.ba5dc16d004310542d611b79@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_17_11_43_+1100_RZF=Td1z=QVOKKuP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_17_11_43_+1100_RZF=Td1z=QVOKKuP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/chipidea/udc.c between commit adf0f735e61a ("usb: chipidea:
move debug files creation/removal to the core") from the usb tree and
commit dc9e2873b740 ("usb: chipidea: let udc-core manage gadget->dev")
from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/chipidea/udc.c
index e502e48,9bddf3f..0000000
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@@ -1700,19 -1742,18 +1684,13 @@@ static int udc_start(struct ci13xxx *ci
  		retval =3D hw_device_reset(ci, USBMODE_CM_DC);
  		if (retval)
  			goto put_transceiver;
 -		hw_enable_vbus_intr(ci);
  	}
 =20
- 	retval =3D device_register(&ci->gadget.dev);
- 	if (retval) {
- 		put_device(&ci->gadget.dev);
- 		goto put_transceiver;
- 	}
-=20
 -	retval =3D dbg_create_files(ci->dev);
 -	if (retval)
 -		goto put_transceiver;
 -
  	if (!IS_ERR_OR_NULL(ci->transceiver)) {
  		retval =3D otg_set_peripheral(ci->transceiver->otg,
  						&ci->gadget);
  		if (retval)
- 			goto unreg_device;
 -			goto remove_dbg;
++			goto put_transceiver;
  	}
 =20
  	retval =3D usb_add_gadget_udc(dev, &ci->gadget);
@@@ -1732,8 -1773,8 +1710,6 @@@ remove_trans
  	}
 =20
  	dev_err(dev, "error =3D %i\n", retval);
- unreg_device:
- 	device_unregister(&ci->gadget.dev);
 -remove_dbg:
 -	dbg_remove_files(ci->dev);
  put_transceiver:
  	if (!IS_ERR_OR_NULL(ci->transceiver) && ci->global_phy)
  		usb_put_phy(ci->transceiver);
@@@ -1768,7 -1812,7 +1744,6 @@@ static void udc_stop(struct ci13xxx *ci
  		if (ci->global_phy)
  			usb_put_phy(ci->transceiver);
  	}
- 	device_unregister(&ci->gadget.dev);
 -	dbg_remove_files(ci->dev);
  	/* my kobject is dynamic, I swear! */
  	memset(&ci->gadget, 0, sizeof(ci->gadget));
  }

--Signature=_Tue__2_Apr_2013_17_11_43_+1100_RZF=Td1z=QVOKKuP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWnafAAoJEECxmPOUX5FEn9AP/13r2M8TbCOmb90hTP+MqGcS
PoeRpUOSex8A8L3Ciq/bbJUhPRVGQk8mFwt9g9QL8b4fi1lC8DjaWJBzXLOWoLsZ
PSJvBYlzdUe59KfQBAk/w/S2pxa81ZWywPU8QnZXhDr0YPbERvTcYNVLSd+aCPRm
JZwTxF1F31jaQ23ao/1bZP2c/YH7yVO+9/TQTVRaXm8z8+YnR1QBahi1CVXyE8Ml
2oEmxEJNjzfstxk3k4hZoCWTK8jTKDNb4YR82lSp+vMrvsA0E/2ruQDCyMTFJwjF
+HqZ1uzWC4ZgxbiR7Mh6MxhxCFsVA5OUdIQc6b8w2t1uKMmbM3pwH44lSyw4mcKn
CaPDfROieTembvlKiJ2YQLVlg2/QzEzFthBOsEebed1oavi99DFswhSt4uWph4oI
9Boi2pNqAvGYkIoW7I0HW/ZE1AtNgK3Op7bSt2OX5+nklvZ1zGdBs5GipeZkjubi
VLNAVl4uavQi/hUxeHNvb5ga/MRJH3ZAXuFPEpjtxBunBrXa3rFiqJR64qKBJRm5
hlvcaG3Ow9853SVW9t6RRh2UvCRInogstOxQrIeDaznq+28n+UDSKBczrKpo0hHp
R3GaDLrET/stEh5+1wJu+4pij7pyrzNudfKAwy8xFdo2aLhQalV3898RoQQyKbgk
OGQaPC3bCG1DsVPTM+VV
=ScmT
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_17_11_43_+1100_RZF=Td1z=QVOKKuP--
