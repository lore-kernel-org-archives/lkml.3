Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaIZJWE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:22:04 -0400
Received: from ozlabs.org ([103.22.144.67]:54555 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbaIZJV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:21:57 -0400
Date: Fri, 26 Sep 2014 19:21:45 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Behan Webster <behanw@converseincode.com>,
        <llvmlinux@lists.linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Subject: linux-next: manual merge of the llvmlinux tree with the arm tree
Message-ID: <20140926192145.701bde05@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/hD+s0qfETB3t/8YfIjzzOk9"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/hD+s0qfETB3t/8YfIjzzOk9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the llvmlinux tree got a conflict in
arch/arm/kernel/return_address.c between commit 95e750c0bac4 ("ARM:
8160/1: drop warning about return_address not using unwind tables")
from the arm tree and commit eeb5c3a69694 ("arm: LLVMLinux: use static
inline in ARM ftrace.h") from the llvmlinux tree (which also exists in
the arm tree).

I fixed it up (I took out the now empty #else clause ... see below) and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/kernel/return_address.c
index 98ea4b7eb406,b7de88a40176..000000000000
--- a/arch/arm/kernel/return_address.c
+++ b/arch/arm/kernel/return_address.c
@@@ -57,8 -56,12 +56,6 @@@ void *return_address(unsigned int level
  		return NULL;
  }
 =20
--#else /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND) =
*/
 -
 -#if defined(CONFIG_ARM_UNWIND)
 -#warning "TODO: return_address should use unwind tables"
 -#endif
--
  #endif /* if defined(CONFIG_FRAME_POINTER) && !defined(CONFIG_ARM_UNWIND)=
 / else */
 =20
  EXPORT_SYMBOL_GPL(return_address);

--Sig_/hD+s0qfETB3t/8YfIjzzOk9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJTAyAAoJEMDTa8Ir7ZwVBGgP/i+eQq+HY20FW0t2sO1dkns8
6eyKcxRlakxb6Yc33bvMNJBcm5btrtLytOZ/PlUusyr5bKk3WAL4DdauwBWZIucC
0J3jshzNcRLF+MM9E11H/AboWQzYKUSiGpZJcLTTReWTBZzlV5hDP0EDo2GRpsvS
YPmbax7rs+5rj18AOHSwklRNEb6aNrWTdKv7zMK9F2nzReFNmIjBH2veea1WR5oZ
WUBMxOxEnZuuHKtdyclE/Q5tt6IzVRSJNWYG7uuaIlbEb6bIgxL1CajzadfwmI9W
gFPI/DgcOnaIPFcJHzWPBogDHT8uG+7i/Vz4JepbWBjWki+c+ut6J0TE5fyKo5Ub
GmhgHua7q31hTGoFFXuDj/wlT/9EyUdeBnBczPFwJ8AMZXQryDuQY6u44V2wLZsV
SOPPBpFcS2bQ7CX67/jJJf+axtQJ/K9ytRTySs8fQAzN50NdNrMSRWhniDr0R8hv
otRuCxnQCFGYUa9+58aEkyJNDiHVxqznUOw97uk4mHRSu/A4Mz8KNXx/zY5icK5F
VTdC4aQkQI2+ugI6S/0x+n4LXjYV34Plp3W8nb0Rb08SiZFgq/YQqf8zuv/EPZ6p
c4VbQBP8gUjE+YnDYYeSmQm3owUTw/awOMcxl/mOhh/krqNch/1y6bVLETj073xB
IswNTSxhSB1pJy9cxtx7
=vchH
-----END PGP SIGNATURE-----

--Sig_/hD+s0qfETB3t/8YfIjzzOk9--
