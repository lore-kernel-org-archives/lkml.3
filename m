Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab3CRC43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 22:56:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:43873 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab3CRC41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 22:56:27 -0400
Date: Mon, 18 Mar 2013 13:56:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kurt Van Dijck <kurt.van.dijck@eia.be>
Subject: linux-next: build failure after merge of the char-misc tree
Message-Id: <20130318135614.ff04cf3d56fc64e2988a912c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__18_Mar_2013_13_56_14_+1100_u2n8XocuFnu=DGOw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Mar_2013_13_56_14_+1100_u2n8XocuFnu=DGOw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the char-misc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/net/can/softing/softing_cs.c:343:1: error: expected identifier or '=
(' before '&' token
drivers/net/can/softing/softing_cs.c: In function '__inittest':
drivers/net/can/softing/softing_cs.c:343:1: error: 'softingcs_driver_init' =
undeclared (first use in this function)
drivers/net/can/softing/softing_cs.c:343:1: note: each undeclared identifie=
r is reported only once for each function it appears in
drivers/net/can/softing/softing_cs.c: At top level:
drivers/net/can/softing/softing_cs.c:343:1: error: expected identifier or '=
(' before '&' token
drivers/net/can/softing/softing_cs.c: In function '__exittest':
drivers/net/can/softing/softing_cs.c:343:1: error: 'softingcs_driver_exit' =
undeclared (first use in this function)
drivers/net/can/softing/softing_cs.c: At top level:
drivers/net/can/softing/softing_cs.c:335:29: warning: 'softingcs_driver' de=
fined but not used [-Wunused-variable]
drivers/net/can/softing/softing_cs.c:343:1: error: 'init_module' aliased to=
 undefined symbol '&softingcs_driver_init'
drivers/net/can/softing/softing_cs.c:343:1: error: 'cleanup_module' aliased=
 to undefined symbol '&softingcs_driver_exit'

Caused by commit a750fa4edd9e ("softingcs: use module_pcmcia_driver").

I have used the char-misc tree form next-20130315 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__18_Mar_2013_13_56_14_+1100_u2n8XocuFnu=DGOw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRRoJOAAoJEECxmPOUX5FEK80P/RIZZNpGNfnb5m3f8OFzHf7F
4JAD/eq6a7kVwrtfRdq6LXOc0NIcIMRnPHCpMFhkgpJxU7z4dyfXuKo+dLGWRsSl
3GporKQJXDqRFUOjrTiTXAWlKuluQgwWjx6/OwjSS1y9djYVFrTC20LcdL+oBOVK
bu46b4X6WYmE0BO9idfeXO+cSEPEjeFQxYppHGFnCgNbuNtfqBwH8mQB6ud3rVql
mmssBipmVFEV4dG7l2ulHGz88EYHX3RrydybmsOip6PJBKf3hgAUdNFYYUJHLf2F
IAVf7Qx/WPfXhkBGFThHn97j8Y6RITw46dQ9I7Yn2jADBGmOSybMmsU7uEu2drmz
n/BrqXODzehgbIIhLg8yUN5wHZ/Hi9qCdc2gJpOLFT6jYIVZWst5FeYdPZmA6w17
cmLLj8DR0KMDZtq/An40/jI7qmtBbrBr1MnQRW+Zqy8K6d99QeTXU8V8mjazt1/B
c/4xaDbC1K2cKRqvNzJ6LkpwaDYy16fe5Is51GBkRWOVjvsSkdv5I8YvY7p3B4yJ
jQq3wyXeQqjCqk4i3cYkY/vId1LpOA5oNRhtf6Y20wgZBKHlsjdMTHB0xD85rW9c
1pnT8tCE58KQgNZ+RQ1dat+0LApuHJpgNWML8l22tSN+EDLy8dkXR7djGbuQSJtn
szcdwKkis06zPnmH2CWX
=AKAw
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Mar_2013_13_56_14_+1100_u2n8XocuFnu=DGOw--
