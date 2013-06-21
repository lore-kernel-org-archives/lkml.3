Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030530Ab3FUG1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 02:27:04 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48282 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335Ab3FUG1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 02:27:01 -0400
Date: Fri, 21 Jun 2013 16:26:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suman Anna <s-anna@ti.com>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic Pallardy <loic.pallardy@st.com>
Subject: linux-next: manual merge of the arm-soc tree with the mailbox tree
Message-Id: <20130621162656.bb94e0fa8b6813781b804a73@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__21_Jun_2013_16_26_56_+1000_Ca6BAZCSC8ZIcBRX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Jun_2013_16_26_56_+1000_Ca6BAZCSC8ZIcBRX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/mailbox/Kconfig between commit a1824eaab70f ("mailbox: OMAP:
introduce mailbox framework") from the mailbox tree and commit
c869c75c16b3 ("mailbox/omap: move the OMAP mailbox framework to drivers")
from the arm-soc tree.

I fixed it up (I suspect not properly - see below) and can carry the fix
as necessary (no action is required).

It looks like we have two different versions of these changes in
linux-next now, so please clean it all up.  i.e. can I just drop the
mailbox tree now?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/mailbox/Kconfig
index 438ea21,c8b5c13..0000000
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@@ -16,45 -16,38 +16,63 @@@ config PL320_MBO
  	  Management Engine, primarily for cpufreq. Say Y here if you want
  	  to use the PL320 IPCM support.
 =20
- config OMAP1_MBOX
-        tristate "OMAP1 Mailbox framework support"
-        depends on ARCH_OMAP1
-        help
-          Mailbox implementation for OMAP chips with hardware for
-          interprocessor communication involving DSP in OMAP1. Say Y here
-          if you want to use OMAP1 Mailbox framework support.
-=20
- config OMAP2PLUS_MBOX
-        tristate "OMAP2+ Mailbox framework support"
-        depends on ARCH_OMAP2PLUS
-        help
-          Mailbox implementation for OMAP family chips with hardware for
-          interprocessor communication involving DSP, IVA1.0 and IVA2 in
-          OMAP2/3; or IPU, IVA HD and DSP in OMAP4. Say Y here if you want
-          to use OMAP2+ Mailbox framework support.
-=20
 +config DBX500_MBOX
 +	tristate "DBx500 Mailbox driver support"
 +	depends on ARCH_U8500
 +	help
 +	  Say Y here if you want to use DBx500 Mailbox driver support for
 +	  power coprocessor access on Ux500 and Ux540 families
 +
 +config MBOX_KFIFO_SIZE
 +       int "Mailbox kfifo default buffer size (bytes)"
 +       default 256
 +       help
 +         Specify the default size of mailbox's kfifo buffers (bytes).
 +         This can also be changed at runtime (via the mbox_kfifo_size
 +         module parameter).
 +
 +config MBOX_DATA_SIZE
 +	int "Mailbox associated data max size (bytes)"
 +	default 64 if DBX500_MBOX
 +	default 4
 +	help
 +	  Specify the default size of mailbox's associated data buffer
 +	  (bytes)
 +          This can also be changed at runtime (via the mbox_kfifo_size
 +          module parameter).
++
+ config OMAP_MBOX
+ 	tristate
+ 	help
+ 	  This option is selected by any OMAP architecture specific mailbox
+ 	  driver such as CONFIG_OMAP1_MBOX or CONFIG_OMAP2PLUS_MBOX. This
+ 	  enables the common OMAP mailbox framework code.
+=20
+ config OMAP1_MBOX
+ 	tristate "OMAP1 Mailbox framework support"
+ 	depends on ARCH_OMAP1
+ 	select OMAP_MBOX
+ 	help
+ 	  Mailbox implementation for OMAP chips with hardware for
+ 	  interprocessor communication involving DSP in OMAP1. Say Y here
+ 	  if you want to use OMAP1 Mailbox framework support.
+=20
+ config OMAP2PLUS_MBOX
+ 	tristate "OMAP2+ Mailbox framework support"
+ 	depends on ARCH_OMAP2PLUS
+ 	select OMAP_MBOX
+ 	help
+ 	  Mailbox implementation for OMAP family chips with hardware for
+ 	  interprocessor communication involving DSP, IVA1.0 and IVA2 in
+ 	  OMAP2/3; or IPU, IVA HD and DSP in OMAP4/5. Say Y here if you
+ 	  want to use OMAP2+ Mailbox framework support.
+=20
+ config OMAP_MBOX_KFIFO_SIZE
+ 	int "Mailbox kfifo default buffer size (bytes)"
+ 	depends on OMAP2PLUS_MBOX || OMAP1_MBOX
+ 	default 256
+ 	help
+ 	  Specify the default size of mailbox's kfifo buffers (bytes).
+ 	  This can also be changed at runtime (via the mbox_kfifo_size
+ 	  module parameter).
  endif

--Signature=_Fri__21_Jun_2013_16_26_56_+1000_Ca6BAZCSC8ZIcBRX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRw/IwAAoJEECxmPOUX5FE1FUP/23L8uQFRIoFffhGoR3+tzak
hBT9qLb+B1CAOyq6DManYnX1xflFo17beO9zswQSJQSYcLrcdg+5xWfT7F994Vil
yO01iybtoUsDgbBbmuXu70RcmSlYXZmxeEYm31uTUS8fCbJKEdy9+FcPuftOdEBu
0iRaMqJ75xQQDW8gRDgQzuJktBwuNDjEtHc0LQCLb3gcmwqf9eBYOaAFHeHVDu/R
S9pbnl1DPKHNFiZhIImEny57btuUu2b30C5rr/yGHsgQBhYAV4p6rBc3csFAMufi
4ho39uShms32RctcJtP4qZY7uXKagS70Dqb+x3ghajUQZKCf7J4z1ZAH15InPuTi
ZCquqhuoYvYak70zVC4kmmQzEpIGiFXWZC6LA18rmWKlWTV7aupouaV933a/gmQT
fZlHhFN+wPg5iYHqLiI6HOkDcL0HXrQ+3iHAAkloHWsE7QtaxR5NT2O9S4IGUcfS
65q9BeS12NrnpEr7U5Ul+2MEvX3LtfjCGjVXQaP2hazpE9Quh08A+uZPa2u72AJ5
hVoMKTY1ePszZlrUzDOTqLh8G/E3wQyYBffXFOILcHIUc9NV3ySPBLdgmMoE0/uT
FajsZsTpjqLqpHP+io65/WKnuJvJc7wxpNRivpiiJgBL6sDPu2Ef25Li6KPKUGEy
fdLuKZM3qvrMWSCxSCks
=ki3S
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Jun_2013_16_26_56_+1000_Ca6BAZCSC8ZIcBRX--
