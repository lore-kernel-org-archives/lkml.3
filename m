Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959Ab3CPTgG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 15:36:06 -0400
Received: from mout.web.de ([212.227.15.4]:65372 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab3CPTgB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 15:36:01 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kernel@vger.kernel.org
Subject: RAMster selects HAVE_ALIGNED_STRUCT_PAGE on 64 bit systems when it should not
Date: Sat, 16 Mar 2013 20:35:59 +0100
Message-ID: <1577953.rJTZvHtihu@tacticalops>
User-Agent: KMail/4.10.1 (Linux/3.7.10-gentoo-gnu; KDE/4.10.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5173705.3zXMljTsZa"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
X-Provags-ID: V02:K0:Y+HVODDgXj8PnZiw7BNsJ6IJQawnBkSwQdVVLayGrpZ
 P0rys6wRJeD9J4IdB956DoeVi43bnk+Mbpc5DsAdoQnSnvTzKO
 XifRqpNreVClVAe7bH8ht+WnrmAaJpDoqfzg10UHOlWXx9eQhE
 B6YtTtg6FL6t6AmwRgouTioDIpBifdWcmwti4NpNboes2778YZ
 jhsV+/tN+uLRrwttdz6tQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart5173705.3zXMljTsZa
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"

At drivers/staging/zcache/Kconfig:13 it says

config RAMSTER
	bool "Cross-machine RAM capacity sharing, aka peer-to-peer tmem"
	depends on CONFIGFS_FS=y && SYSFS=y && !HIGHMEM && ZCACHE=y
	depends on NET
	# must ensure struct page is 8-byte aligned
	select HAVE_ALIGNED_STRUCT_PAGE if !64_BIT
	default n

However, there is no config section for the symbol 64_BIT, so !64_BIT will 
always be evaluated to true, and therefore RAMSTER will always select 
HAVE_ALIGNED_STRUCT_PAGE, disregarding any breakage.

64_BIT should probably say 64BIT which has corresponding config sections in 
arch/{x86,ia64,mips,s390,tile,alpha,arm64,sparc,parisc,powerpc}/Kconfig and 
arch/x86/um/Kconfig.

I do not know if there are any bad consequences about this, but I guess this 
should be reviewed and fixed, probably by just removing the underscore from 
64_BIT in drivers/staging/zcache/Kconfig.

Regards
Martin Walch
-- 

--nextPart5173705.3zXMljTsZa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlFEyZ8ACgkQM6S4K8IXn9dATQCgjLCemlSYDUbSIKUmPXeN35Oz
5UoAoLUkQ+m6wKO7K2yyG9xgl/qaS8Oj
=UC0L
-----END PGP SIGNATURE-----

--nextPart5173705.3zXMljTsZa--

