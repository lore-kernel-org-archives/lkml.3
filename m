Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756711AbaAGEU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 23:20:56 -0500
Received: from ozlabs.org ([203.10.76.45]:34050 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbaAGEUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 23:20:54 -0500
Date: Tue, 7 Jan 2014 15:20:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: linux-next: manual merge of the tip tree with the pm tree
Message-Id: <20140107152043.6595eb01fbe10a5b32952fbf@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Jan_2014_15_20_43_+1100_vQxbrKtQM6BG4Sw7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jan_2014_15_20_43_+1100_vQxbrKtQM6BG4Sw7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tip tree got a conflict in
drivers/acpi/processor_idle.c between commit 6cb85b2b9df9 ("ACPI /
cpuidle: fix max idle state handling with hotplug CPU support") from the
pm tree and commit 16824255394f ("x86, acpi, idle: Restructure the mwait
idle routines") from the tip tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/acpi/processor_idle.c
index 1fc455b8ce17,f90c56c8379e..000000000000
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@@ -783,18 -780,6 +778,13 @@@ static int acpi_idle_enter_simple(struc
  	if (unlikely(!pr))
  		return -EINVAL;
 =20
 +#ifdef CONFIG_HOTPLUG_CPU
 +	if ((cx->type !=3D ACPI_STATE_C1) && (num_online_cpus() > 1) &&
 +	    !pr->flags.has_cst &&
 +	    !(acpi_gbl_FADT.flags & ACPI_FADT_C2_MP_SUPPORTED))
 +		return acpi_idle_enter_c1(dev, drv, CPUIDLE_DRIVER_STATE_START);
 +#endif
 +
- 	if (cx->entry_method =3D=3D ACPI_CSTATE_FFH) {
- 		if (current_set_polling_and_test())
- 			return -EINVAL;
- 	}
-=20
  	/*
  	 * Must be done before busmaster disable as we might need to
  	 * access HPET !

--Signature=_Tue__7_Jan_2014_15_20_43_+1100_vQxbrKtQM6BG4Sw7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSy4ChAAoJEMDTa8Ir7ZwVei0P/At8p4VELYY3DR4ZlHLwimdr
wPRcm/nuk4LUuEHNgkEt5x44QlZcRjb7SSuUO/TZ0HG+cRvx+G4be06sLshp/20G
C8eScN+Mk82Zclhn0J2Oe+C37THT24CYQt3fBsWCBplncz8F37b2AUgx6hChW2nc
HAPzf9lg4fj1CEhsZ2kpfG2nBVQ2DorBT71/OvuTpqC5ooyTQfKuAOetTK7ZqP8R
vlGp7qoh1NUdfYzJah6jEcgTMQJRPnAaLfiHbr+aKiweDp/oiEwmSQL+41r5vVq6
yXgchx/31OMbzAbHqCD1k0rwC/5n9oYr+YJGefASUAAVqtjKDTRAnEKwVl5xfQ2A
pXM4jIhjna4c9LZIVppnKFIvSueUvTXXcpOKbh382g5nubCnXTNE5h1y6yc+3gIG
GhDBBr4NjV3mg3HdB9cdr6+3yaZs48o09lg6eMVAaJqusrnCDws9/Io6pB6PtiXf
lXB/y5njf5qLJlAOtdhE18adPP1VKCju6rZQOvD2pQQWxh3yESO41NRGG9uV9o3v
Y7wZumTTpk4z8ZkxK+shbr9yftMndPMGV6ixmN735q5Pi/4hfFS3FyKVCTzEul6e
r0fAAzxgi1tdZvCVMuqlLOq1B2++UUQIf+Ug64Hp6W6G0r9LiiWFpCGlE0UMydLH
A4AHxy0nr/VeGGSZ1HQq
=XVgD
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jan_2014_15_20_43_+1100_vQxbrKtQM6BG4Sw7--
