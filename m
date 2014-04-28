Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755698AbaD1BeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:34:12 -0400
Received: from ozlabs.org ([103.22.144.67]:43783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680AbaD1BeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:34:06 -0400
Date: Mon, 28 Apr 2014 11:33:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>, <andrew@lunn.ch>,
        <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: linux-next: manual merge of the mvebu tree with the arm tree
Message-Id: <20140428113359.95298f9a895dda6fbbb06f12@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__28_Apr_2014_11_33_59_+1000_sd/PU55UjPo4=FLH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Apr_2014_11_33_59_+1000_sd/PU55UjPo4=FLH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the mvebu tree got a conflict in
arch/arm/mach-mvebu/board-v7.c between commit b21770945fa2 ("ARM: l2c:
remove unnecessary UL-suffix to mask values") from the arm tree and
commit 2865b82e9e19 ("ARM: mvebu: remove unnecessary ifdef around
l2x0_of_init") from the mvebu tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-mvebu/board-v7.c
index c6bd79f64744,bc0283f0dd88..000000000000
--- a/arch/arm/mach-mvebu/board-v7.c
+++ b/arch/arm/mach-mvebu/board-v7.c
@@@ -57,11 -75,10 +75,10 @@@ static void __init mvebu_timer_and_clk_
  {
  	of_clk_init(NULL);
  	clocksource_of_init();
+ 	mvebu_scu_enable();
  	coherency_init();
- 	BUG_ON(mvebu_mbus_dt_init());
- #ifdef CONFIG_CACHE_L2X0
+ 	BUG_ON(mvebu_mbus_dt_init(coherency_available()));
 -	l2x0_of_init(0, ~0UL);
 +	l2x0_of_init(0, ~0);
- #endif
 =20
  	if (of_machine_is_compatible("marvell,armada375"))
  		hook_fault_code(16 + 6, armada_375_external_abort_wa, SIGBUS, 0,

--Signature=_Mon__28_Apr_2014_11_33_59_+1000_sd/PU55UjPo4=FLH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTXbAMAAoJEMDTa8Ir7ZwVPlUP/0aTYjvey2LkFkmv7ukAKD5W
Za/ZCeya5pJc3e1YBHbQoaYy2DWsq8thBa1ZBgh9nlagR+pzPaXD0k+jP2MLoo2x
cENXkTJ7M2MtRtnB/muyoCdIbLaImGN9e+XE3bkLntvh5+J37ObTaoQq9ulPM96e
O8o0ZOxYEY/u80p71UF7UnGe8SlnXzviu/Ke71VlCXdb6a7LlQQpja1FaoGKy1FZ
qvrdoWcmleR/oxkXrOM7Y48+OmXxVPDxR097/4fk4bspQF87uxJsrTBoXo6ekDqW
37RepoqyqdxXtp50So6DZDl1HiIyU37hEmVk3M6c7K//nFL0NjJXEuwDh1StUoin
M0OpOri62KgFPK+//MnO86H+vj7/b6C11HyG6fsux6fO7atOUQG8mxEhacAhpsKg
hSaovWprUH8PgOH5YgBg7XLo79ARo96Bzjkd0UgV2Fxlb2v5R2SCnSQSXUIVhU6Q
T6FX4SrrJbXi5F3KwGFlb5IYcGCTl1JtkGaeHG+e1LWUbSjqBs1X1o6Mh42pjtGY
Eq0GvIW0jlw7w025qIoeloyeh5oqR5CNhogHmcPd5FkwL66Hr3Bx4apxEg58cfwc
NG6pymWwRPb1Mx8Nje5stWSkeVSgRWStbYJ1+uLdw1wPpoQLWd6H6S1RH+ikIWt0
FRnoB7iFj1oswykMCjmy
=2KF5
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Apr_2014_11_33_59_+1000_sd/PU55UjPo4=FLH--
