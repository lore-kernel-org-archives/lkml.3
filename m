Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaGQGws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 02:52:48 -0400
Received: from ozlabs.org ([103.22.144.67]:38522 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504AbaGQGwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 02:52:45 -0400
Date: Thu, 17 Jul 2014 16:52:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: linux-next: manual merge of the usb-gadget tree with Linus' tree
Message-ID: <20140717165238.2e056cba@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/AcrTNHBEI669Ml7DJOT7IdL"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AcrTNHBEI669Ml7DJOT7IdL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
include/uapi/linux/usb/functionfs.h between commit 091221417853 ("usb:
gadget: f_fs: resurect usb_functionfs_descs_head structure") from
Linus' tree and commit f0175ab51993 ("usb: gadget: f_fs: OS descriptors
support") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/uapi/linux/usb/functionfs.h
index 24b68c59dcf8,b66fae77c08c..000000000000
--- a/include/uapi/linux/usb/functionfs.h
+++ b/include/uapi/linux/usb/functionfs.h
@@@ -33,14 -32,37 +32,45 @@@ struct usb_endpoint_descriptor_no_audi
  	__u8  bInterval;
  } __attribute__((packed));
 =20
+ /* MS OS Descriptor header */
+ struct usb_os_desc_header {
+ 	__u8	interface;
+ 	__le32	dwLength;
+ 	__le16	bcdVersion;
+ 	__le16	wIndex;
+ 	union {
+ 		struct {
+ 			__u8	bCount;
+ 			__u8	Reserved;
+ 		};
+ 		__le16	wCount;
+ 	};
+ } __attribute__((packed));
+=20
+ struct usb_ext_compat_desc {
+ 	__u8	bFirstInterfaceNumber;
+ 	__u8	Reserved1;
+ 	__u8	CompatibleID[8];
+ 	__u8	SubCompatibleID[8];
+ 	__u8	Reserved2[6];
+ };
+=20
+ struct usb_ext_prop_desc {
+ 	__le32	dwSize;
+ 	__le32	dwPropertyDataType;
+ 	__le16	wPropertyNameLength;
+ } __attribute__((packed));
+=20
+ #ifndef __KERNEL__
+=20
 +/* Legacy format, deprecated as of 3.14. */
 +struct usb_functionfs_descs_head {
 +	__le32 magic;
 +	__le32 length;
 +	__le32 fs_count;
 +	__le32 hs_count;
 +} __attribute__((packed, deprecated));
 +
  /*
   * Descriptors format:
   *

--Sig_/AcrTNHBEI669Ml7DJOT7IdL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTx3K7AAoJEMDTa8Ir7ZwVTH0P/Av+mD7TttaVFeRSf3oR53Uo
OqjCeBcN8dbZDnlyHVRpEwd8CqvPmtfRWDOTJmhsCstHswswci60bq2U6NTDwUAk
ByUc/Nv+GmFybt//X5A8/amB7VVOTopIZdhrknXbJffBpLxW0t3FxAMcBFgw4WKm
zrHsncWVwvI30EwvQ9PUAVUbpDTzzcK0BdC/D++BcIAe3brJDP/83gwXNVxCx0OU
oCZW26lHWKenkuV84LEV2TT4/SThuxHd6UEldV8bnoWSkxBWIxvI/E+Ehm9Rpxus
pkSBO1nMYuYv6Q3Ti7ITkYWiwSmN6Zo18a98uaxXSaNDEkTaVcmf3ocO5MtF9STj
Y0Dpt5jnTo1wIBenwNrKo0OLU4iydH5QNYRYmpEIH9SftOOFX80+5fOWAtU8tjSS
KOaFlhA5PUiOmR9AOLp7fZKS8WkTvHg/UvYd8tdM7uS7SeVf5e2df4wzf56UGMep
copyh98Bywc4F3/ryp9Krq96AV0G53Drk7tW+6yQduAogGPx/VT8ZRA5F8eJ3D6w
PH6jn5eA4AKYwQK0lSOTHXfwhtlsuqGEidn6g2VVU3x58TQkUSEM27/egSXjG1NV
12KMqLAplN1/J5EN1HUVWXZ3tDti4SWRhXXCWE6RYFcyv2xRF8FPtK/hwbTlfroQ
Nvq9zJ+TszdOxKzZMJUr
=kmV/
-----END PGP SIGNATURE-----

--Sig_/AcrTNHBEI669Ml7DJOT7IdL--
