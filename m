Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab3HMIR3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:17:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33095 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab3HMIR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:17:26 -0400
Date: Tue, 13 Aug 2013 18:17:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: linux-next: build failure after merge of the final tree (usb-gadget
 tree related)
Message-Id: <20130813181719.e2dea691c1e3c19bd6306983@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Aug_2013_18_17_19_+1000_Yfg23fz4eZOs+3aN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Aug_2013_18_17_19_+1000_Yfg23fz4eZOs+3aN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/usb/phy/phy-am335x-control.c: In function 'am335x_control_usb_probe=
':
drivers/usb/phy/phy-am335x-control.c:117:2: error: implicit declaration of =
function 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
  if (IS_ERR(ctrl_usb->phy_reg))
  ^
drivers/usb/phy/phy-am335x-control.c:118:3: error: implicit declaration of =
function 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]
   return PTR_ERR(ctrl_usb->phy_reg);
   ^

Caused by commit 3bb869c8b3f1 ("usb: phy: Add AM335x PHY driver") from
the usb-gadget tree.  Forgot to include linux/err.h.

I have reverted that commit for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__13_Aug_2013_18_17_19_+1000_Yfg23fz4eZOs+3aN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSCeuTAAoJEECxmPOUX5FELx4P/1bd3rj4rqtW2d4q4WhJhpsV
8GEVnkxooDEFkDAnv3Oh/yr4zyOOHnEJhv2Eis/ShKIIU1Wol5dmoZTNHGORm0i6
CQN7PAobj/Xxd0j4hjUBnxi4vWdYnHaGm6S7LVtVfvJcZvqSypGDYOU3x/VrhuJr
HHQaompp/LLyILx0hAbVVL1CaA7f3HVIOrUEs0JeDgDIVJpNaMgwl+/zHA2Zg8Vq
O5SbZFFg8FHWHgrYrORRk1TGwJMKwhqxKL5UB5ATflouNrs8n2ZzFb/RTy4t27fU
+Pp+t/gXSS13D1kQ6JOM8kazn/CrwebcMWtIGhhf+F+gYjO8ZKZSEpKwlybFVzQ4
vFxRZNQYwJrKORqlXM1XpsH08QgoCHbfmPxRGbR0WeNceIrsZgWIDWNSm6FG3+x8
KzqpXzceYMCNcDiBxobsudGvCMWCM/4oJ3XnSwGk191uTgi6uH7aqX3rg/OAJ6DO
9C8AZf3E60eEV6iuJtx3gU1frXYN7L4auaJ8eDZOtETPoQEkyxGIpZAdB5RBOP6p
F79PP6hGNrr4sxq2V2y0o6MqLrdIyc3RHhSYBQ8osBik/ABhx3HeUjuQZlZTF6Nu
64t6LUXCg3zeyQlevrDp2nkDjSdlGoJUt+zoDabK9DzkcsEE02Ryak4z+cr/utXU
RyYyaYHLLis93aO4kCoz
=WAzo
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Aug_2013_18_17_19_+1000_Yfg23fz4eZOs+3aN--
