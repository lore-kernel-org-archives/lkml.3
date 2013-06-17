Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab3FQHga (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 03:36:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37188 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3FQHg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 03:36:29 -0400
Date: Mon, 17 Jun 2013 17:36:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve Capper <steve.capper@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: linux-next: manual merge of the arm64-hugepages tree with the arm64
 tree
Message-Id: <20130617173627.8bd67da7e93639cf85afcedb@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__17_Jun_2013_17_36_27_+1000_QglZN4Jw_b/uYW9a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Jun_2013_17_36_27_+1000_QglZN4Jw_b/uYW9a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

Today's linux-next merge of the arm64-hugepages tree got a conflict in
arch/arm64/Kconfig between commit aa42aa1389a5 ("arm64/xen: introduce
CONFIG_XEN and hypercall.S on ARM64") from the arm64 tree and commit
d03bb1455f3a ("ARM64: mm: Raise MAX_ORDER for 64KB pages and THP") from
the arm64-hugepages tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm64/Kconfig
index ef32eb1,308a556..0000000
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@@ -181,18 -180,25 +181,35 @@@ config HW_PERF_EVENT
  	  Enable hardware performance counter support for perf events. If
  	  disabled, perf events will use software events only.
 =20
+ config SYS_SUPPORTS_HUGETLBFS
+ 	def_bool y
+=20
+ config ARCH_WANT_GENERAL_HUGETLB
+ 	def_bool y
+=20
+ config ARCH_WANT_HUGE_PMD_SHARE
+ 	def_bool y if !ARM64_64K_PAGES
+=20
+ config HAVE_ARCH_TRANSPARENT_HUGEPAGE
+ 	def_bool y
+=20
  source "mm/Kconfig"
 =20
+ config FORCE_MAX_ZONEORDER
+ 	int
+ 	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
+ 	default "11"
+=20
 +config XEN_DOM0
 +	def_bool y
 +	depends on XEN
 +
 +config XEN
 +	bool "Xen guest support on ARM64 (EXPERIMENTAL)"
 +	depends on ARM64 && OF
 +	help
 +	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM64.
 +
  endmenu
 =20
  menu "Boot options"

--Signature=_Mon__17_Jun_2013_17_36_27_+1000_QglZN4Jw_b/uYW9a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRvrx7AAoJEECxmPOUX5FEX1EP/3H9zVicSzkgNt3xj7CFrgos
diZa+M4HCjVhvi7MxJ/DWYltxykDKxpyi4DPicmxsu664G6j/m0NXIH1ax4PKrh7
nhodlc1YSk4evUhN16uM/H+m8B9JZluCmEaNnDWngQw+PTzFZ1HQm4Ll1jLi35Oh
JwFj/y40GCI0Du/g1FSdv5UIbUhxENsXKf2xP4Wy8Y2MKVtgJSLJ5n1PFSK/z+oL
GhBRs7A2SCx0zcOXcoplLgjXefl0KTU6UsADw8n13++dGumdyzB2nxfwP+cXM7rw
kBEw5LCPxaKACUZzupAYWwL5SgfDBYFX1RheqbXyssoNUIfIOD3Dyp1IknkEJ9dF
pLIBsmWtfoS8V4srKaUu02ZhHPYhaAM82MRkG636o2oKo7EayW6pbIXfuhEYqCdo
H5ayVY1qXpRQqhSD5y3wRPh3qaNfnYsFngk/uzwBW3LLONRw7/f2GiGCLkPdkXTR
0D/6j4mDc1Hu/+FeZASU4cQY4NasZFclBh5KNmwwaPW6kkDjLeYAvdJorOt0dHG6
fg9KnwDB7Ad/+eBs7tLa0pO2q0b8zJHbSLv7ViyQDhYnHVpdhVfMhoT0rvXuF8F5
/cDQn0DtUX0WuxHo8A7bmnve1N4FSGN0o48yjq2I3vRGvpsxe/KQOFUV1ojPrb1S
luqhcrD1ym4zkbA7GWaI
=EKiN
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Jun_2013_17_36_27_+1000_QglZN4Jw_b/uYW9a--
