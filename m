Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3LPEk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 23:40:28 -0500
Received: from ozlabs.org ([203.10.76.45]:34056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752459Ab3LPEk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 23:40:26 -0500
Date: Mon, 16 Dec 2013 15:40:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        WingMan Kwok <w-kwok2@ti.com>, Roger Quadros <rogerq@ti.com>
Subject: linux-next: build failure after merge of the usb-gadget tree
Message-Id: <20131216154020.9d7f9dacf60e41b775d44223@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Dec_2013_15_40_20_+1100_q.uc/1kkFhUeveZ+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Dec_2013_15_40_20_+1100_q.uc/1kkFhUeveZ+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

After merging the usb-gadget tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/usb/phy/phy-keystone.c: In function 'keystone_usbphy_probe':
drivers/usb/phy/phy-keystone.c:96:4: warning: passing argument 3 of 'usb_ph=
y_gen_create_phy' makes pointer from integer without a cast [enabled by def=
ault]
    USB_PHY_TYPE_USB2, 0, false);
    ^
In file included from drivers/usb/phy/phy-keystone.c:25:0:
drivers/usb/phy/phy-generic.h:18:5: note: expected 'struct usb_phy_gen_xcei=
v_platform_data *' but argument is of type 'int'
 int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *n=
op,
     ^
drivers/usb/phy/phy-keystone.c:96:4: error: too many arguments to function =
'usb_phy_gen_create_phy'
    USB_PHY_TYPE_USB2, 0, false);
    ^
In file included from drivers/usb/phy/phy-keystone.c:25:0:
drivers/usb/phy/phy-generic.h:18:5: note: declared here
 int usb_phy_gen_create_phy(struct device *dev, struct usb_phy_gen_xceiv *n=
op,
     ^

Caused by commit 25acdd08fd71 ("usb: phy: add Keystone usb phy driver")
interacting with commit bd27fa44e138 ("usb: phy: add Keystone usb phy
driver") which was merged before v3.13-rc1 and is included in the
usb-gadget tree.

I have used the usb-gadget tree from next-20131206 again for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__16_Dec_2013_15_40_20_+1100_q.uc/1kkFhUeveZ+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSroQ4AAoJEMDTa8Ir7ZwVhO8P/RpwuCJr+h4xmKpQR+78i5lZ
+a5vYUT5pNRhc/xa7JHA6WKrhiG/8d1lDdWU28Kc71JkkWqXaC6bM4j9oHRcfQ+m
dnnVgTNSWvJ/p/1oapzHli8YAolcB2nSZ3fQgiPmQqQo1zCJ0A5y7WnYUWNqRPIt
JXGuX4q0FzO/jppav5/Si8oWEGGmE9dHHrJqJ7zPangA4JgbyP7E7OW89rpHhjwT
1j4DhBAaWjN+JM8KXhWG3bhOkAAfB3p3uiAT8cJXZfsEqJZNlxXuHVBNUXeiIxs2
ZHWjrloDvrY7sHvgMOuh6DN2U87Ve80CFqZ5MHYtOCj3Q9szmEk6pObeHOb8zbYw
sabyu0A375+VpuEmQfQvyB5QAUE1X9qJ00v33OqLy3stAtfhQajFXajYuTEKJXPj
WpMxhLmnGDbo7a8O3NSlo4WxFlwgba23MH2/NQ2EbCGYWiIDgRSPvljGVp0+RQmQ
cmUxW01XdxWNBP+sxUEq7FbGjHMyq61EfTT4t10ViAnSckjJZ2izL+iaU1U5QXfq
xRpXyabUEWRE0eyg8QldaDtCa2SrpZCBqekv0/31tEiz1bIbIx6Yt3/7iuCdTMV8
XRyKUtO+IPvic+LfJS6xOXUM/loFiTxpasaRW3Sii8IxkSct/eNSX5YPC4x6mIan
0rWvG9DMFdko28+azl9R
=vJ6q
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Dec_2013_15_40_20_+1100_q.uc/1kkFhUeveZ+--
