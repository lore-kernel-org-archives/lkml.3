Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760647Ab3DBH57 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:57:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34824 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab3DBH55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:57:57 -0400
Date: Tue, 2 Apr 2013 18:57:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chanho Min <chanho.min@lge.com>
Subject: linux-next: build failure after merge of the final tree (tty tree
 related)
Message-Id: <20130402185747.c4d8c60880025b242953da63@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_18_57_47_+1100_3gPegBl4i9VQ9bkI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_18_57_47_+1100_3gPegBl4i9VQ9bkI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (arm defconfig)
failed like this:

drivers/tty/serial/amba-pl011.c: In function 'pl011_rx_chars':
drivers/tty/serial/amba-pl011.c:1199:11: error: 'struct uart_amba_port' has=
 no member named 'dmarx'
drivers/tty/serial/amba-pl011.c:1200:8: error: 'struct uart_amba_port' has =
no member named 'dmarx'
drivers/tty/serial/amba-pl011.c:1201:8: error: 'struct uart_amba_port' has =
no member named 'dmarx'
drivers/tty/serial/amba-pl011.c:1201:31: error: 'PL011_DMA_BUFFER_SIZE' und=
eclared (first use in this function)
drivers/tty/serial/amba-pl011.c:1201:31: note: each undeclared identifier i=
s reported only once for each function it appears in
drivers/tty/serial/amba-pl011.c:1202:19: error: 'struct uart_amba_port' has=
 no member named 'dmarx'
drivers/tty/serial/amba-pl011.c:1204:26: error: 'struct uart_amba_port' has=
 no member named 'dmarx'
drivers/tty/serial/amba-pl011.c: In function 'pl011_set_termios':
drivers/tty/serial/amba-pl011.c:1671:9: error: 'struct uart_amba_port' has =
no member named 'dmarx'
drivers/tty/serial/amba-pl011.c:1672:6: error: 'struct uart_amba_port' has =
no member named 'dmarx'

Caused by commit cb06ff102e2d ("ARM: PL011: Add support for Rx DMA buffer
polling").  This build does not have CONFIG_DMA_ENGINE set.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Apr_2013_18_57_47_+1100_3gPegBl4i9VQ9bkI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWo97AAoJEECxmPOUX5FEkdsQAJpX0mNm7n4Qnc/7GRBH0HcO
1MlnUE4WPda2VarJVhN80vjzidzaSMV6deQK9wjqXcyAOgpjeNBJ+PJ4FtgWloOU
Dsd1AeWBDVNgo1u95MPC/Sc7zcDS/wSuuAhwJ1zGoeZli95GANnSk//rtNuvRC4z
/E5d4p75NKFlMxYbrzrtWAM8XMJdNRBtSGypBkE4SIFjKl36LNspbnLSN6v/XXZK
faigIfWFPi3Ei9C9gCIu4V/+OJC1l9SE7iSNzQbtil2sPGnWnJ3Cpi8XDrCLAaw5
RWA0CeFy+Mt4rQJKm8hekCyIcuN2lPb/vNsS+fccV2QAAOb831/yL0wed68l2TDe
fEf3bN3uzLDsVexAVhXD6OF2jLmu2UeVfg9lsO4EZxKBGw7NqouJxyMthKHzw+vC
IkBnzII8LEyROrOZ+BiMPT0Os8RbiPHjOv6s5rmHUN9KPhPOIFBK1KhSO5tWAggT
vgo1yAYQ7VchiSSaLx9vlap9KBvhdAcKjhAcZEXpfy18aNVKSPFn9Dfjm17bGZ6X
3560YQn+KYYzjHodPhycHPTIIn4WN3QZJVPP13CtQS1au0GXsB3yLXYfCuhcFlPi
43BVBOzL+tdLUuTCsNXVapblBAEgNUHx81KDlc9eqSxlESr3LP8UwgsD/UVT4l9+
KyN+4CXsDHU2r6M4ISgI
=FTI4
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_18_57_47_+1100_3gPegBl4i9VQ9bkI--
