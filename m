Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398Ab3LPDSm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 22:18:42 -0500
Received: from ozlabs.org ([203.10.76.45]:57537 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab3LPDSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 22:18:40 -0500
Date: Mon, 16 Dec 2013 14:18:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Borislav Petkov <bp@suse.de>, Matt Fleming <matt.fleming@intel.com>
Subject: linux-next: manual merge of the tip tree with Linus' tree
Message-Id: <20131216141835.0ded286276730efcf7fed52e@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__16_Dec_2013_14_18_35_+1100_fPYZ=ppb6lN5jg_A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_Dec_2013_14_18_35_+1100_fPYZ=ppb6lN5jg_A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
arch/x86/platform/efi/efi.c between commit 04bf9ba720fc ("x86, efi: Don't
use (U)EFI time services on 32 bit") from Linus' tree and commit
f4fccac05f7f ("x86/efi: Simplify EFI_DEBUG") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

diff --cc arch/x86/platform/efi/efi.c
index cceb813044ef,f8ec4dafc74e..000000000000
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@@ -690,9 -692,13 +692,7 @@@ void __init efi_init(void
 =20
  	set_bit(EFI_MEMMAP, &x86_efi_facility);
 =20
- #if EFI_DEBUG
 -#ifdef CONFIG_X86_32
 -	if (efi_is_native()) {
 -		x86_platform.get_wallclock =3D efi_get_time;
 -		x86_platform.set_wallclock =3D efi_set_rtc_mmss;
 -	}
 -#endif
  	print_efi_memmap();
- #endif
  }
 =20
  void __init efi_late_init(void)

--Signature=_Mon__16_Dec_2013_14_18_35_+1100_fPYZ=ppb6lN5jg_A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSrnEOAAoJEMDTa8Ir7ZwVgz8P/2U8vh5ZWOxB8oROWNdBIKSm
SOJbP2Q/73nI3h0r5xLPmMT5f46MIlt8XN07bIJBBWqDk1yePGWbhIBuNtGB7xNv
9dW02/bS2ar4e6pneOXqjEFManb++7bjALhxWvqPnROT/JZ/6qfMPn8Pss/1EkGN
LRMmLFGJpogyEtqIeZdJt4Xq2Ype8bNc9uuCIobrzkEnEm0u+8rS7L31tbBdZ92w
RXmOU3Y17pNGbHSwFQOcQAz4jjFocYqW8NKt32m4fqZPP9v+qKNO7GplC6vUwAQm
vZHo9BmmjIi94gHfx/pjbB2RTCXHhA6bU6cEQrPNnsVwduJJYJ42Y0OslaKw4NH5
nxo53pP7oN6bLy4/Yd07rIcArJWdWOtr9pvgtNzmI2tI9HrDQ0YI7+1CPNq5o9HF
gDH6bSr4M39s+3ENIGeT3cg25NYoFqhnHllY6vQmU1W+/CD0xoL5+wJVQdAkCiQw
UDmfjLfhQYXsPlbXRXC0GgP9ubYbpX63alUEI+e0PNBaA8t+cGBNgkHeqDAuyi5O
bi7os/DUEgcQvQ9ZEHEAlTjUarcDg3rhEf35ykUy835Z7sFbD6ORjcGvTDV7usBu
44D14nRYcogenv75FU8cqY6IEXNvTuSvnA/5FiT7la0YdGJWHud2w9nTCdGRr1LR
UO+IOQvFaIZ9p+jdJu44
=gFDG
-----END PGP SIGNATURE-----

--Signature=_Mon__16_Dec_2013_14_18_35_+1100_fPYZ=ppb6lN5jg_A--
