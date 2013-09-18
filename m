Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab3IRDMt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 23:12:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53139 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3IRDMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 23:12:48 -0400
Date: Wed, 18 Sep 2013 13:12:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        George Cherian <george.cherian@ti.com>
Subject: linux-next: build failure after merge of the gpio tree
Message-Id: <20130918131237.b8272e45ec6c4ebf360cb4e5@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Sep_2013_13_12_37_+1000_cp0aiI_vM2ahoyCN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Sep_2013_13_12_37_+1000_cp0aiI_vM2ahoyCN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpio/gpio-pcf857x.c: In function 'pcf857x_irq_domain_map':
drivers/gpio/gpio-pcf857x.c:206:2: error: implicit declaration of function =
'set_irq_flags' [-Werror=3Dimplicit-function-declaration]
  set_irq_flags(virq, IRQF_VALID);
  ^
drivers/gpio/gpio-pcf857x.c:206:22: error: 'IRQF_VALID' undeclared (first u=
se in this function)
  set_irq_flags(virq, IRQF_VALID);
                      ^

Caused by commit 21fd3cd1874a ("gpio: pcf857x: call the gpio user handler
iff gpio_to_irq is done").

set_irq_flags() only exists on arm (and arm64).

I have used the gpio tree from next-20130917 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__18_Sep_2013_13_12_37_+1000_cp0aiI_vM2ahoyCN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBCAAGBQJSORopAAoJEECxmPOUX5FEyYoP/jN80s8NHyODtL37dsKff8uf
7kquFFDquOkyecp42OCIZnj9nS9ZAhJrtyfMg/XChHu8jpgQUeOpuVlZ4Db1yC7O
PSlpik/gJGJdMWJvoovWTpIu9CLLh4hHgDESNXS/btc+IRsl4D7OFoAZDDJj4L+y
HnA+wA20WdQQeVXSN8XCGj4O5Pk595B5NOaGC106aGSDNp9ClhJCv5bFQSk7vSTl
mAEF0bhlQRojrNQ5eNfFXd+650P/vSvE36lEvSWsUzY/cNPe758f6P6yqdpoJ4xo
Hbwef1fYFsHHPI+9xrrPZXY1krCTI7T0SFSJ44QM9fFTTuZbj7j9HaBozG9qrTY1
mQn6pH0TQWWAobus2Z4o4BmQjAjB6iKMsYeocCxel1/AWr/M/VfhYMnU+RbmC7N3
aa1kyzrg6bCop64xhuAwp4D/swYLShDMnJUCJZuT4dXOpI9BJ/FsAM4m+Aaq4RjG
JBskOp6t5sfPmlnnFKV4yLtKbG3vw/c4uO45AGm45fLcx3xhVshzUk6HHErTLXHL
+TjiZ1+feZQSXqKNdXSkKKb+ymNl9jhy3gRk2ANjANJ1wuaKgV2MqYefdDR73Sfe
pxaMyT6daTaJh89jyCSho2ZcQ0cNldeqPECL3sPdpldarTnqr2rlmqNbGwlEp7WB
zgyPpI9lYgqMOZ6Fi9HE
=0GWJ
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Sep_2013_13_12_37_+1000_cp0aiI_vM2ahoyCN--
