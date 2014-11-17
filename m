Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525AbaKQEQj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 23:16:39 -0500
Received: from ozlabs.org ([103.22.144.67]:51393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbaKQEQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 23:16:37 -0500
Date: Mon, 17 Nov 2014 15:16:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>
Subject: linux-next: manual merge of the omap_dss2 tree with the pm tree
Message-ID: <20141117151630.35b22157@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/F5x7GT6LQLAQDd2ze62HJDc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/F5x7GT6LQLAQDd2ze62HJDc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Tomi,

Today's linux-next merge of the omap_dss2 tree got a conflict in
include/linux/of.h between commit 8a0662d9ed29 ("Driver core: Unified
interface for firmware node properties") from the pm tree and commit
6d09dc6b74ca ("of.h: Keep extern declaration of of_* variables
when !CONFIG_OF") from the omap_dss2 tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc include/linux/of.h
index 189fc53bc7df,f83ca9dddcba..000000000000
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@@ -117,16 -112,7 +115,17 @@@ extern struct device_node *of_aliases
  extern struct device_node *of_stdout;
  extern raw_spinlock_t devtree_lock;
 =20
+ #ifdef CONFIG_OF
 +static inline bool is_of_node(struct fwnode_handle *fwnode)
 +{
 +	return fwnode && fwnode->type =3D=3D FWNODE_OF;
 +}
 +
 +static inline struct device_node *of_node(struct fwnode_handle *fwnode)
 +{
 +	return fwnode ? container_of(fwnode, struct device_node, fwnode) : NULL;
 +}
 +
  static inline bool of_have_populated_dt(void)
  {
  	return of_allnodes !=3D NULL;

--Sig_/F5x7GT6LQLAQDd2ze62HJDc
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUaXajAAoJEMDTa8Ir7ZwVHCMP+wZvqbs0lTnZx8QRcdHn4D34
jhCq7UCmRq7kbeR55PhQHUgG7d+NoGYDPYTE7+XsGc7bPW2W/f9JB5QH1Oxj1dqk
ag/ybYEhUm/PiUUjVCUj4zyMtLZWd8oBCLHMGIe4gtBQ8sxBjxtUxTnzlTpHn5Qz
lkXTQIlwUOr8zhg99HJKB5A6YhgTPNgXBjkHGrr1vafa5mnuFE0wf11aq77y3AKV
Pk6S4j6SaBloi+O4zw5O4KAylgq7I9wOzIFEHjbVYEv1xfi2Y46+ixPwPAyYOA6+
XcqhMXt1LnFMDCNyCRyDbBstknLjN2DKtYxdkiFQoUy/UrJ5Vrv/GnCpQCkEiD+z
C3DCdPgAbv57kSooptsiAXpvWS8y66/kP19q0tSbY6LKWyCDmsrwFYHxiZiJJnZy
xvR5jeGV/RqPnzwuJS2jowqPA0W0Qs1e0YdMIEjsK0WpWUO/c1vkUIhtBBKywH5g
l8/5PuWFyNSMqcdlnLP4Wnnz15ZXwg21coZN09ESn0cnHTmFhuriUQh1T/SLvjgw
Ym5f2JzFujWGUK8gRdeQ3iv4RgKWjVBRjeNiFJn3mtQUmy6DexDSiuQFEEabzB88
WK4f1GIQfVePHQRBK1qtI4+xUxJ+4oH6i/BoAshq7Ha6pUOG8FdUEl0GzvguBd7F
8WrJbRV2EkQlFRfiKpzH
=/YoK
-----END PGP SIGNATURE-----

--Sig_/F5x7GT6LQLAQDd2ze62HJDc--
