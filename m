Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab3FQEVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:21:37 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54912 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3FQEVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:21:35 -0400
Date: Mon, 17 Jun 2013 14:21:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Dave Airlie <airlied@linux.ie>
Subject: linux-next: manual merge of the fbdev tree with the drm tree
Message-Id: <20130617142120.b42dafb967974d3906a43fc9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_14_21_20_+1000_9P_cQyBS7OvTq7WB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_14_21_20_+1000_9P_cQyBS7OvTq7WB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the fbdev tree got a conflict in
drivers/video/of_display_timing.c between commit f583662347c6 ("video:
display_timing: make parameter const") from the drm tree and commits
fcf7e6e5bd84 ("videomode: don't allocate mem in of_get_display_timing()")
and ffa3fd21de8a ("videomode: implement public of_get_display_timing()")
from the fbdev tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/of_display_timing.c
index 2894e03,9c0f17b..0000000
--- a/drivers/video/of_display_timing.c
+++ b/drivers/video/of_display_timing.c
@@@ -53,13 -53,12 +53,12 @@@ static int parse_timing_property(const=20
  }
 =20
  /**
-  * of_get_display_timing - parse display_timing entry from device_node
+  * of_parse_display_timing - parse display_timing entry from device_node
   * @np: device_node with the properties
   **/
- static struct display_timing *of_get_display_timing(const struct device_n=
ode
- 						    *np)
 -static int of_parse_display_timing(struct device_node *np,
++static int of_parse_display_timing(const struct device_node *np,
+ 		struct display_timing *dt)
  {
- 	struct display_timing *dt;
  	u32 val =3D 0;
  	int ret =3D 0;
 =20

--Signature=_Mon__17_Jun_2013_14_21_20_+1000_9P_cQyBS7OvTq7WB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvo7FAAoJEECxmPOUX5FE5mcP+wWfcT4MuB4zIGJej3CBOQrV
gs3/6LNB5TDIr9fAeDsINBjeYY2K+NhWYxp6G+nf1lWFDXi1k7TNAph5uJOzUbNc
LQZz5beM2XYJgYqJYfd1P2UHwPXd7EHmcawOV+B42Wkbyn5ayfouKf1rxtZyQjxT
EwIxeGq4aZ3FkI0wVzYWITTyCuXp/v8XLk7mKPTV1LqYuQevbUUcQT+g+Xv8+sVD
Zxji8NzhrZtAlrvrlYOQnhilHRKASGA4nnwydZ/fC6/NqH54Dn2pT39w3/I6zP8h
mwZN7bMbhsClpUUQU7KH5AJGIf8rtp06QwO4U8y6MfdOqUNTkN0Su7R9E8ERXFMn
7MjwVgogJXjUX74QPKtKv8N4bXnG0dYU2G9FRI0wfzMUIKIx0jnZR6Wktpq8nQFF
SKsNJWUhECipknsB/Do6ofL6m+g+TTJJ4PTtKYPP4fhaWLgIvlsoKs+KYWgHVuWC
cK7SrIdgS1LFs2LNqzBcL2XIhdKOjVPau1NtP5AR03bBxONAG3V5VcZYUYqKbE12
QegHgnsbHxj0D0zZ4pL7/d5fFK7uqlzoP4G8glo/hTCY30JGYYjIepzs8h5O56Mo
pB4HmfsVOfkI8do0dL4hKhmYXDy5ztoI4L9i78XAVkrdSJi466YjcWEfreO9g3Iv
oacwjSo27LXNB4L9/0uG
=X2Oz
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_14_21_20_+1000_9P_cQyBS7OvTq7WB--
