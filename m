Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbaG2IcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 04:32:03 -0400
Received: from ozlabs.org ([103.22.144.67]:34515 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaG2IcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 04:32:00 -0400
Date: Tue, 29 Jul 2014 18:31:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <treding@nvidia.com>
Subject: linux-next: build failure after merge of the gpio tree
Message-ID: <20140729183153.0e77a6f6@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ND75AaXd3eD72uQWfGBoCRD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ND75AaXd3eD72uQWfGBoCRD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio tree, today's linux-next build (arm
multi_v7_defconfig) failed like this:

In file included from arch/arm/mach-tegra/board-paz00.c:20:0:
include/linux/gpio/machine.h:24:2: error: unknown type name 'u16'
  u16 chip_hwnum;
  ^
include/linux/gpio/machine.h:31:19: error: field 'list' has incomplete type
  struct list_head list;
                   ^

Caused by commit 0a6d315827ee ("gpio: split gpiod board registration
into machine header") or an interaction of that with commit
a0524acc94c9 ("ARM: tegra: Sort includes alphabetically") from the
arm-soc tree.

linux/gpio/machine.h needs to include some of the same files that
linux/gpio/driver.h does.  See Rule 1 in Documentation/SubmitChecklist.

I have used the version of the gpio tree from next-20140728 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ND75AaXd3eD72uQWfGBoCRD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT11v+AAoJEMDTa8Ir7ZwVOSsP/0roHkJHLb5c1D87YzvznsIw
SwPiEeyRQ7KvkZAO3rRJH9H1fYLJ/+nyA5cV4nLDgHg4fMPlsw/LPzA48+yHh7Wd
sR55bupZI2j9jNZd9nh+/SibaI1pEaiXGvnLGfazYt5Hl+MBD21Drsk/Fot1708f
K/EkbKHjlKtbl1LzzSM5exLpZ/wb8//C4In7DYItOcd1gRt/g8OdtWHAG+lcyRgf
5D/jqO40kzbKN4lMp+rLPHCc/NBADm0jecijh3YPsrSKJZx6l+QLpqe5yZob0jq3
hW5JshQAbAxz1PiMJU27E9q0ajRHqk6XKFWxLBFRHsT51Kr1pzkyeck/jOh1BD0u
U7gdgHzmai+Rjw6wuja35d3WQn3YQrDxZipPTg3l5yby+a1Sf6vNcUdhTj7gipaG
B7vUwKv6e0NqXjzFYL4XqNLuL9UPl6dZeLV9iKK30qB1V7koAjfLQS+J6/HdRE4s
svtlS5Jftp0IQrVkM6pULNbEPQtp72gWrhV7PifF2C46PGVpsgQ4onJB4mejOCeM
FUxHc2BMpb22zZtS66RJRYifK2qDsIzIcbGAt/Wb0fi+jXphV3FPL2olpVI4J9/I
HhmMJyDBNFt1BupSC4qMCEcN2akzqvBWyfb3qvHUrU3BB93XoyVRDQZ5ghRq01d2
qgQ5QjaJEeG2F6eNvJ87
=8zQG
-----END PGP SIGNATURE-----

--Sig_/ND75AaXd3eD72uQWfGBoCRD--
