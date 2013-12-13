Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3LMEC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 23:02:57 -0500
Received: from ozlabs.org ([203.10.76.45]:52868 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab3LMEC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 23:02:56 -0500
Date: Fri, 13 Dec 2013 15:02:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the pinctrl tree with Linus'tree
Message-Id: <20131213150247.db3f0bfa2a2ac01caa49c43a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Dec_2013_15_02_47_+1100_Kd4zAu6FvpJS09jj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Dec_2013_15_02_47_+1100_Kd4zAu6FvpJS09jj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/sh-pfc/pfc-sh7372.c between commit 71493de7e55a ("sh-pfc:
sh7372: Fix pin bias setup") from Linus' tree and commit 5b46ac3a7723
("sh-pfc: Rename sh_pfc window field to windows") from the pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

diff --cc drivers/pinctrl/sh-pfc/pfc-sh7372.c
index cc097b693820,bcdd5c3cdcf0..000000000000
--- a/drivers/pinctrl/sh-pfc/pfc-sh7372.c
+++ b/drivers/pinctrl/sh-pfc/pfc-sh7372.c
@@@ -2584,8 -2573,8 +2573,8 @@@ static void __iomem *sh7372_pinmux_port
  		const struct sh7372_portcr_group *group =3D
  			&sh7372_portcr_offsets[i];
 =20
 -		if (i <=3D group->end_pin)
 +		if (pin <=3D group->end_pin)
- 			return pfc->window->virt + group->offset + pin;
+ 			return pfc->windows->virt + group->offset + pin;
  	}
 =20
  	return NULL;

--Signature=_Fri__13_Dec_2013_15_02_47_+1100_Kd4zAu6FvpJS09jj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSqobrAAoJEMDTa8Ir7ZwVTkkP/1walEKw7N/73wPnlIwIqJgE
cU4GaCkjF+j/eM/iRoDsixMgQTPxYk05JtolCWytzRibz8Xvo4HAsqTIuZ15XqVl
/cYwHqKSaMaC1rEDJtEpcU1Pxc4JMYq4RWr+XM+tfdSyJ8yCX08GXPM4hU7BY0tf
0peqxMsJ7RPhNeJmZEMcPlnfdZZc6Wai9fEP5ecfE12IoAJB9do5YcrCvk/K4k0K
VQsRX+ScqBb5htpOQjIKEDzGPmqqA+DltHIQeliMXICJHGOSWIIu2AQbi60gxkhA
2E5KYbTluDMtf5zlEi4Ow8ETOVY7UpiHkvClT6hoPLpwjqRvY+ZH50v6aRIpthAR
JUvgsTXWB0XorZNSUCbCpF3cNqrAacqbXuQBE9IjS+Wmf6kjYn+pswzmddFCeh1Y
mEhFJQXrnLclS9fGSdlapAZkZcQbZWWtCEWaGvMdgwFG/J6BA51wezQMzBTd0WN1
NrKLcaDXiHcF3jFL4L05k0kX+Iv7fHgKMw19rD61HC7hhUfLa55YvvQPt2aRaFUu
XAFAXjplsue+Y85Xkh2rPGcVUifCUoCZ33v6ONuubnErSffb0LSFR/aF9qExBBaw
YauoexdWYvzTiWzCKTknKsSjsFXbIPTEV4mnM4wi+W+723jecQbcbPHGwEY0qtT0
6qYErSsPrTMgQLjL3UeJ
=4iD1
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Dec_2013_15_02_47_+1100_Kd4zAu6FvpJS09jj--
