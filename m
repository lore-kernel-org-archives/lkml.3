Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461AbaCQHzu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 03:55:50 -0400
Received: from ozlabs.org ([203.10.76.45]:41208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932175AbaCQHzs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 03:55:48 -0400
Date: Mon, 17 Mar 2014 18:55:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-Id: <20140317185542.fe4554210fc1893b44289008@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Mar_2014_18_55_42_+1100_hRFLQNLJOR7gYmSw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Mar_2014_18_55_42_+1100_hRFLQNLJOR7gYmSw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/media/platform/exynos4-is/fimc-is.c between commit d265d9ac6c7c
("[media] exynos4-is: Use external s5k6a3 sensor driver") from the
v4l-dvb tree and commit fd9fdb78a9bf ("[media] of: move graph helpers
from drivers/media/v4l2-core to drivers/of") from the staging tree.

I fixed it up (see below, though I suspect it is wasted?) and can carry
the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/media/platform/exynos4-is/fimc-is.c
index c289d5a69d09,9bdfa4599bc3..000000000000
--- a/drivers/media/platform/exynos4-is/fimc-is.c
+++ b/drivers/media/platform/exynos4-is/fimc-is.c
@@@ -168,19 -167,11 +168,19 @@@ static int fimc_is_parse_sensor_config(
  	u32 tmp =3D 0;
  	int ret;
 =20
 -	np =3D of_graph_get_next_endpoint(np, NULL);
 -	if (!np)
 +	sensor->drvdata =3D fimc_is_sensor_get_drvdata(node);
 +	if (!sensor->drvdata) {
 +		dev_err(&is->pdev->dev, "no driver data found for: %s\n",
 +							 node->full_name);
 +		return -EINVAL;
 +	}
 +
- 	node =3D v4l2_of_get_next_endpoint(node, NULL);
++	node =3D of_graph_get_next_endpoint(node, NULL);
 +	if (!node)
  		return -ENXIO;
 -	np =3D of_graph_get_remote_port(np);
 -	if (!np)
 +
- 	node =3D v4l2_of_get_remote_port(node);
++	node =3D of_graph_get_remote_port(node);
 +	if (!node)
  		return -ENXIO;
 =20
  	/* Use MIPI-CSIS channel id to determine the ISP I2C bus index. */

--Signature=_Mon__17_Mar_2014_18_55_42_+1100_hRFLQNLJOR7gYmSw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTJqqCAAoJEMDTa8Ir7ZwVuSYP/jThuBEWRCa4guhII1fBK6g6
7iERKzKgs6V47v+GavpMrK7LM01K7dFYoMJ8XG+SKRn3Tm6P+q9HWOO5mVVRwYPH
DcQ/20pgf5dJWe6jrIgqmWPSbM1S9TQo7OKyUULZwyd5m1vxc+8IiGHDZ+Pkq0tH
5GpAvF2+3gtpzsrmgFW8NnqSqiI4PVzX4X8mQy4BwYCwAxQ1PiklRGKxlZxHX8E5
uV6iiCmP63pU6k/YuDCftyk/JXpGyM4QVbxneEfFWKDkzDRJCCEpCl7H1cDaJW/A
dKePNIRY3VXl+5uaotvbDKVK2M+fNjMqZVwL+CJb+NoKbdMkh1GJrRcNL20+3H8J
efHKc/QIjiZI58KLdNfhA7/C3F08Qp5dqCTb+78HPTK4QxnzRf2CQxLxUfGTpuE3
tgC6KdGkcBoEO2t78Y0lGaYSf84Zs1TGwjWbBVQWvpeM+S1i0imOE1u23ttEZX6I
OOlSN1CP83MWd2LovrRH6MD3ISey4n4eoYfef5lWGQ4XECkF35UBbRWQJzBFD3jV
8YzEF+9Ga1mC6VxAfw/VcQiYT0xMSOgV4qiNOpLPmt7YaWOvxWYG2oyciKt0jDnu
VaQA21hmJ1Kd2/AJ5xHr1Bp2fgCG4GbzkvIbVEQVDeIWa0F1fkii1y1qkqd+3I34
sg8R4TPZ4vedabQtvas6
=Of/Z
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Mar_2014_18_55_42_+1100_hRFLQNLJOR7gYmSw--
