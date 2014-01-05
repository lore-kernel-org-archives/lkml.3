Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaAEXUn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 18:20:43 -0500
Received: from ozlabs.org ([203.10.76.45]:60786 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbaAEXUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 18:20:41 -0500
Date: Mon, 6 Jan 2014 10:20:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christian Daudt <csd@broadcom.com>,
        ebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20140106102031.8ecedbad59dddbc8aa0946ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_10_20_31_+1100_5Gja8rk9olyAcxvq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_10_20_31_+1100_5Gja8rk9olyAcxvq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/Kconfig.debug between commit 753d12434da3 ("ARM: 7932/1: bcm:
Add DEBUG_LL console support") from the arm tree and commit caad0b41de69
("ARM: add Marvell Berlin UART0 lowlevel debug") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

diff --cc arch/arm/Kconfig.debug
index 9afabbb5e798,bda94e46e8d6..000000000000
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@@ -106,17 -94,14 +106,25 @@@ choic
  		depends on ARCH_BCM2835
  		select DEBUG_UART_PL01X
 =20
 +	config DEBUG_BCM_KONA_UART
 +		bool "Kernel low-level debugging messages via BCM KONA UART"
 +		depends on ARCH_BCM
 +		select DEBUG_UART_8250
 +		help
 +		  Say Y here if you want kernel low-level debugging support
 +		  on Broadcom SoC platforms.
 +		  This low level debug works for Broadcom
 +		  mobile SoCs in the Kona family of chips (e.g. bcm28155,
 +		  bcm11351, etc...)
 +
+ 	config DEBUG_BERLIN_UART
+ 		bool "Marvell Berlin SoC Debug UART"
+ 		depends on ARCH_BERLIN
+ 		select DEBUG_UART_8250
+ 		help
+ 		  Say Y here if you want kernel low-level debugging support
+ 		  on Marvell Berlin SoC based platforms.
+=20
  	config DEBUG_CLPS711X_UART1
  		bool "Kernel low-level debugging messages via UART1"
  		depends on ARCH_CLPS711X

--Signature=_Mon__6_Jan_2014_10_20_31_+1100_5Gja8rk9olyAcxvq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSyejGAAoJEMDTa8Ir7ZwVWcIP/1TxaPOmhIl1CgO1A8bKRQMB
jmQ5OfUhoSX/1CpESlIW5B9cVG8ENRFxhennPvaJWYpfMqWGjHYeRWIuAyBx7YcA
e7rYI6SOGb9JJ1wAf3jJat1Tu0zuUK6RfJIG86Vs2FFOH/Z8h5CFbvlznkMzSzx7
cHaiipO8h7+WRXmtWAK3IRoIrSkWd6f5QqeD9/jqAKgn2kcHaIQQfGIGDzqGb7it
9d83MdJVVJeHG6Sff+xEPo/sp91WoBPHlooddlCi6oYYIlPuP/eqIx8AmLNlWsOQ
pCvKPF0Q4hyqmU7rZtFv58EpJCvZw2+n5uAj5DP1CwpIB+FLeTAvBjkrIJ6hZfzf
l2Ud8US9MmgFHtxR42xLFSMB+oewRaKf9f3NfpVu136V26Ffypr/YF4BwCSxXOhf
ymX7YsaP6TbHWu8L1ZKN6LWtG4VG7P6wLwSTmxtVos1CScIQTvQd5vMWbpttFKXX
AbVZTbru+CkVNgQ360Ri88IEDvtL+2Yz5W1uUnkxDjwxLvWzXbtPLmAVdNaOCDNo
4/XK7cqw2/EGKTn0Nd7CUwAUC+mEY6a2HIw4SoNs4ZGp/mUNJxKP2djM1Fia/OWO
udiSmX5kf7ZMQV3ZWj9M9nW2cjJsJTQgaMrkUHvpXyw4qZtwnXR7QiEa/SosMknv
f2mzzBPphkaM24mDwOYG
=O8O3
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_10_20_31_+1100_5Gja8rk9olyAcxvq--
