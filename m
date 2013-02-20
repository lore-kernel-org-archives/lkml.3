Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935877Ab3BTEZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 23:25:17 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:56398 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935109Ab3BTEZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 23:25:16 -0500
Date: Wed, 20 Feb 2013 15:25:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Kees Cook <keescook@chromium.org>
Subject: linux-next: manual merge of the driver-core tree with the virtio
 tree
Message-Id: <20130220152507.4d7405fcb3561213b4ccd7ab@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_15_25_07_+1100_LW4=XIc.A_ZK+f1U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_15_25_07_+1100_LW4=XIc.A_ZK+f1U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got conflicts in
drivers/vhost/Kconfig and drivers/vhost/Kconfig.tcm between commit
4d8dc8b44748 ("vringh: host-side implementation of virtio rings") from
the virtio tree and commit 43893cbefc1b ("drivers/vhost: remove depends
on CONFIG_EXPERIMENTAL") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/vhost/Kconfig
index 613b074,bf24317..0000000
--- a/drivers/vhost/Kconfig
+++ b/drivers/vhost/Kconfig
@@@ -1,7 -1,6 +1,7 @@@
  config VHOST_NET
- 	tristate "Host kernel accelerator for virtio net (EXPERIMENTAL)"
- 	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP) && E=
XPERIMENTAL
+ 	tristate "Host kernel accelerator for virtio net"
+ 	depends on NET && EVENTFD && (TUN || !TUN) && (MACVTAP || !MACVTAP)
 +	select VHOST_RING
  	---help---
  	  This kernel module can be loaded in host kernel to accelerate
  	  guest networking with virtio_net. Not to be confused with virtio_net
diff --cc drivers/vhost/Kconfig.tcm
index 0218f77,7e3aa28..0000000
--- a/drivers/vhost/Kconfig.tcm
+++ b/drivers/vhost/Kconfig.tcm
@@@ -1,7 -1,6 +1,7 @@@
  config TCM_VHOST
- 	tristate "TCM_VHOST fabric module (EXPERIMENTAL)"
- 	depends on TARGET_CORE && EVENTFD && EXPERIMENTAL && m
+ 	tristate "TCM_VHOST fabric module"
+ 	depends on TARGET_CORE && EVENTFD && m
 +	select VHOST_RING
  	default n
  	---help---
  	Say M here to enable the TCM_VHOST fabric module for use with virtio-scs=
i guests

--Signature=_Wed__20_Feb_2013_15_25_07_+1100_LW4=XIc.A_ZK+f1U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJFAjAAoJEECxmPOUX5FEBBwP/1S7AGboDH8AqvJXAJnq+ZIh
zOrbB/hMwuDxeiMEOgE4ax33lvUq+v4GoFZU2fEN4PQ3gXjTBYnsPOF9D59UsStV
6htysq5S3DliW449yHLgDQuPGhmf89ttBf5TcTDckg58kDi+OK/xA4PqbO5+ntDP
Ft6YTg7Mq2tWInVUy3TiCBGu1fw8UlYiTOq5rvWfsK4HBMgq9fsCVONW+Qyxhf9P
YYblDv20orFhSU67LZg/+9Vu+on1K+WgBkeGIV4tSdGgNYGzMp787Xgy1OzGyjGR
edJRUbV2SVbSk9ynn9P/HtRRt26gcvHxuGCLIgVKV4OaEhRSW/mtb2R7bkaPj9Na
QNr3wlwncRAhq0GZxLqtNcW+UqaOPYGApgxhyTYnl0mUyVEvBKJ3X1MESRxriDhm
G6OO7UqQ/YwxsSQCK5aBWNPBeiV/x+2H0LjiyYAtHDlgu/ybzVf878rNDibSchYM
i9CbvIrGMugdCe+QSwVhdLWmdF9LUPxJ3WrVhWa/4+TWjfJxQGfJw5kP2NCKGKL3
V0+cUhzZ1+kpJ8CCc0QWGkkn6Wa/bWn+esR42kZUpuQ9ZR6bGUsDTBaSLLKVI+Ei
YVDitL3eEZRdtYpCLrdmCLHGz4SEGOne+CtaKNoOLat2SP28eyNIumQsr9TDknnh
vM4LHz/pGXbVaV67h9R7
=1kpB
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_15_25_07_+1100_LW4=XIc.A_ZK+f1U--
