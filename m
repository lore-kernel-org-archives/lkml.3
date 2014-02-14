Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaBNATs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:19:48 -0500
Received: from ozlabs.org ([203.10.76.45]:50619 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbaBNATq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:19:46 -0500
Date: Fri, 14 Feb 2014 11:19:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IlJhZmHFgiBNacWCZWNraSI=?= <zajec5@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>, John Crispin <blogic@openwrt.org>
Subject: linux-next: manual merge of the wireless tree with Linus' tree
Message-Id: <20140214111939.58ecc154f74a9ea273df795a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Feb_2014_11_19_39_+1100_6ROuI1Q7jrsrN7Gr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Feb_2014_11_19_39_+1100_6ROuI1Q7jrsrN7Gr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next merge of the wireless tree got a conflict in
drivers/bcma/driver_gpio.c between commit 2997609eb4c9 ("bcma: gpio: add
own IRQ domain") from Linus' tree and commit 6b6ee88774ae ("bcma: gpio:
register all 32 GPIOs") from the wireless tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

[Aside, Ralf: that commit in Linus' tree is committed by you but has no
Signed-off-by from you.  There were a couple of others there as well.]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/bcma/driver_gpio.c
index 25f9887a35d0,39dadf5342c6..000000000000
--- a/drivers/bcma/driver_gpio.c
+++ b/drivers/bcma/driver_gpio.c
@@@ -215,10 -95,8 +215,10 @@@ int bcma_gpio_init(struct bcma_drv_cc *
  	chip->set		=3D bcma_gpio_set_value;
  	chip->direction_input	=3D bcma_gpio_direction_input;
  	chip->direction_output	=3D bcma_gpio_direction_output;
 +#if IS_BUILTIN(CONFIG_BCMA_HOST_SOC)
  	chip->to_irq		=3D bcma_gpio_to_irq;
 +#endif
- 	chip->ngpio		=3D 16;
+ 	chip->ngpio		=3D 32;
  	/* There is just one SoC in one device and its GPIO addresses should be
  	 * deterministic to address them more easily. The other buses could get
  	 * a random base number. */

--Signature=_Fri__14_Feb_2014_11_19_39_+1100_6ROuI1Q7jrsrN7Gr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS/WEgAAoJEMDTa8Ir7ZwV63AP/0H1abBLj1OXS7J/X2WCc057
za8w+86FNdQRqVcg/6vXk9wRwQEX30FN9VaOVItgf13fIX/R874yfkQxV3Tr1tU/
vOptAui2IGD8JQX+UEntRBagk5wE3omg7jgHmrpaX7I2vXCXbd0UX9d+OggQN5hJ
gPnFBkXo03knr5LEE3S3CL3GN8lxMQIYb1pqVhByT+0un8Y5D8wDRnKZmZiE6DL6
enL6xFFikxK050tqmcNePwlhPlz4V6tuaGgKLVvTJ7pZOB8Wx1xfvmMHuaQGL9PT
Fj526QD0Ls0DTEDvsyUSXHOjtF72q1RbyDbPY3fpk//SlOmlXtEmdGTSYcLwLktV
Zj9FhGKDg6Qj+1KV6nakbFm9cUsXPhO99wRs+3947jfDmqVWXH4VybQCt+Z2G2b+
IdjrM1q+nZFYQehoiCMj39ANKG0Y+E9Y30PUn0+3esVz//wDE9qDknp0U4dJMYLJ
b50RARFiNyG+irdalfsPKza9D8pUSmzy3xYYS92x8f3rBU8Yma0RkOuMNhyFxzVN
Ct2wTr4NTbWTIptFD9M1uv+OC/unDDjWntQd69TC4u0q9g7TpEfSucK61praqsr+
Vv8xGW0vL6rTEsTGW7xshLCdNkf+43uYJMi1hMKxhUqomU1Kv/DH2dQoUJS2aGCC
06iAQ+wZbbW5hdawEpEi
=Hh+l
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Feb_2014_11_19_39_+1100_6ROuI1Q7jrsrN7Gr--
