Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbaFPB5U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 21:57:20 -0400
Received: from ozlabs.org ([103.22.144.67]:51819 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114AbaFPB5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 21:57:17 -0400
Date: Mon, 16 Jun 2014 11:57:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: linux-next: build warning after merge of the tip tree
Message-ID: <20140616115709.3fce3a2a@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Mif+B93xJF2aCM2Wyj3jgHx"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Mif+B93xJF2aCM2Wyj3jgHx
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

In file included from arch/x86/crypto/camellia_aesni_avx_glue.c:23:0:
arch/x86/include/asm/xsave.h:73:12: warning: 'xsave_state_booting' defined =
but not used [-Wunused-function]
 static int xsave_state_booting(struct xsave_struct *fx, u64 mask)
            ^

Lots of these ...

Introduced by commit adb9d526e982 ("x86/xsaves: Add xsaves and xrstors
support for booting time").  Forgotten "inline" :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Mif+B93xJF2aCM2Wyj3jgHx
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTnk76AAoJEMDTa8Ir7ZwVX4UP/jUkHdGq9S8u9uZfYwruMwMP
LoCIjiE6ixp49KzbA1sNFF+CngAsT5GUl1G/o/wvJc/MN/VEnV/bRocj8sta5AJf
9zUDDGMsNser1J7vjMXRrKp+3JZQ83j5WPRlvNMIVGecqEg2QP+D2Wh/hytLoFKl
BgA5TCR8NPId1GzQAtvL/fnh16m1VZn6UouXgXSsYu6yDSsLPeJpRlbRXgwNZa2m
FguLbuRMl6c0TUNxP0ohexFZALXBM6hTomplt1F7YskqMtl4cu2bvZjwGX1Q1MkV
rTdkuls7T1mPXBbKA2eU8GbrwQqzB2zJ3Z1wA+pHJOhh4stAGidh/AHTUu2l3jIc
5gqJTGQSYZgL0LnNE6cPi1u2z7IdciTO+bzaMa8HrDfFFWf2zR4x4df6B4XkNEpI
nL6pLL2/Fz/eTe3PmVe+1npyb3jj+jZ2ZpsMQPfsQX1ucmrI2tchJqPXHyQWzbsh
nxhJ8DXMOcOBlgEdFLxFU0L2284qK8bi9Wvc2fTBA9F986BSZxG19aLJKSIKBdxr
FvlFK5k86Y5k/dyz+k+ldYug7N2ayq46xeVyoUftBXTQVl/ybH7lgOlNYfypOVty
pBZY5ETXfA+55r/rJYxvJ8kK3IppTnHFWggF4OtVOMePwRADhPMwLlF0hgZO9uEt
p6ijnuubAWp5iVfXhjE4
=YOWm
-----END PGP SIGNATURE-----

--Sig_/Mif+B93xJF2aCM2Wyj3jgHx--
