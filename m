Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3HEFFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 01:05:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:35792 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab3HEFFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 01:05:08 -0400
Date: Mon, 5 Aug 2013 15:04:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bastian Hecht <hechtb@gmail.com>, Jingoo Han <jg1.han@samsung.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the tty tree with the sh tree
Message-Id: <20130805150456.974461a9896ae4d61f044aab@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__5_Aug_2013_15_04_56_+1000_o3DHzrxeitm9e.lx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Aug_2013_15_04_56_+1000_o3DHzrxeitm9e.lx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/tty/serial/sh-sci.c between commit ada80ee7fa60 ("serial: sh-sci:
Add OF support") from the sh tree and commit 3ba35baa55fa ("serial:
sh-sci: use dev_get_platdata()") from the tty tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/tty/serial/sh-sci.c
index 5ef9300,5377502..0000000
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@@ -2588,20 -2481,9 +2588,20 @@@ static int sci_probe(struct platform_de
  	if (is_early_platform_device(dev))
  		return sci_probe_earlyprintk(dev);
 =20
 +	if (dev->dev.of_node)
 +		p =3D sci_parse_dt(dev, &dev_id);
 +	else
- 		p =3D dev->dev.platform_data;
++		p =3D dev_get_platdata(&dev->dev);
 +
 +	if (!p) {
 +		dev_err(&dev->dev, "no setup data supplied\n");
 +		return -EINVAL;
 +	}
 +
 +	sp =3D &sci_ports[dev_id];
  	platform_set_drvdata(dev, sp);
 =20
 -	ret =3D sci_probe_single(dev, dev->id, p, sp);
 +	ret =3D sci_probe_single(dev, dev_id, p, sp);
  	if (ret)
  		return ret;
 =20

--Signature=_Mon__5_Aug_2013_15_04_56_+1000_o3DHzrxeitm9e.lx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR/zJ9AAoJEECxmPOUX5FEI8kP/RbeTlkIP+mq+bpYHo/v/FBN
JNkNv54K05bNgS0l3CFNAEKrkXGi5msY5b1FwVNHILAMvt8t02KE3LFxMeBU8SMN
wQHasfsx5kf4fZXp9odc7c3coMG5XVM/biL6ypSZdRXeoFtsBbM25MPIW+4RewE5
vFM3WZfDOjeHxGiPDiWig1iFXtQCBwetOoA99+U/TEO1vu3S69oW/fk1FohTpPJb
iHPXhF6WxUKFw2bOBUUzjqFcmN2vvzMc8sdhWESvCP9UNEQBZtaFDbX98fkqk05O
//3sk4SidNO05ZMnvgnmvWNPXOzNN5Tc/3tIVtA96srEAWBAU4PVDPWvq9CmJVQe
sUJYCnUJ7RGuks7zzwWMqFCMLPi5PCnA0oMcDWHQ0jwrMWI0wIHa1wpokvxAUSt1
2SQhUFgFvtFm8CobYvpWDuZqnFZkqQZ7GjdjNCTllSLp31tL8r9hOdc3VlBccO7/
81OnFvKZSyDIDraigYN9Y4MQ3c7rnI9AiRCBct6AFRtkgwC+Bt/E0IYrGNTdA7pP
8NslMLx8pvL7JR8UaQCyqzrPE+gs2FQIuCCTFxGiV3Z2fL05sXUiGOlK5gkyHQhz
ZM0mCi+kjDysspD0wFchHgl7yYb3iROq95RPaT64LWOO8zud34P8Xj1gDdsaxM25
4kYv10DZ04O2MQ0hl+HT
=IVgv
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Aug_2013_15_04_56_+1000_o3DHzrxeitm9e.lx--
