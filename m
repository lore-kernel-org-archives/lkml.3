Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaAPD6g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 22:58:36 -0500
Received: from ozlabs.org ([203.10.76.45]:55549 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051AbaAPD6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 22:58:35 -0500
Date: Thu, 16 Jan 2014 14:58:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20140116145829.5e4fcab103b1c5c77501ee77@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Jan_2014_14_58_29_+1100_4A/t1m6mGxcZLQ5J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Jan_2014_14_58_29_+1100_4A/t1m6mGxcZLQ5J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

arch/x86/kernel/process.c: In function 'mwait_idle':
/scratch/sfr/next/arch/x86/kernel/process.c:434:3: error: implicit declarat=
ion of function '__monitor' [-Werror=3Dimplicit-function-declaration]
   __monitor((void *)&current_thread_info()->flags, 0, 0);
   ^
arch/x86/kernel/process.c:437:4: error: implicit declaration of function '_=
_sti_mwait' [-Werror=3Dimplicit-function-declaration]
    __sti_mwait(0, 0);
    ^

Caused by commit 16824255394f ("x86, acpi, idle: Restructure the mwait
idle routines") interacting with commit 7760518cce95 ("x86 idle: restore
mwait_idle()") from the idle tree.

I am not sure how to fix this so I just reverted the idle tree commit for
now (since it reverted cleanly). Please let me know if there is a better
solution.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__16_Jan_2014_14_58_29_+1100_4A/t1m6mGxcZLQ5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS11jpAAoJEMDTa8Ir7ZwVMhAP/3Nb2kS9uiLOeZhqRnyHJAf8
BBUzCbvJwqQ5+CnWlvQ+wW4N9v5iEHDCpruy/SSueuiy6fNXpu6m/Cziam4gOZSe
vdO4UWWWInS/FG/+aE0uZgYfA3SdPnhBj+P6nycsNhlycgnJvvBg5Zg7qxl6KElJ
KoJDGNSvmpkqXv6xjtTtHpn577MFahBNOpFFKH7gAVr3KwQADg2qDbR4ZBLslRal
KM6WoHjGRYb+acaGEol5H3nTRPTgWBz79Qkk7Mu2GktXzZpAbrXzeFy7QHxj7QgW
nKus+HbaUt73mwDZfDcnJeDo9gRiGHNFRkUowIpZnpc5rnEmK+WS1O3GLHJtDFQz
QK4lEqNozVok5Io6rfEChca/lPzS9LEMhsn8PdyVs7oyd84MPNpFbBxoNlwBu6BG
SK9rXCi8xD5AkI9jHMm5E3s9Dq49Hbn2D8YrXJwTj/2xC4XYgSIEP69/OAxT1cLu
6z+Y//cHbfmQZet/wt3/E9DWfRkgL7rWSJxnpOm9+ASKVY0XZkuwV+PMrkH7psZZ
4BKnli7IS/0T6ixJ3nXc/idrclhIUJb2yVJ0pybzicksv04cBSd9ZMCyEHU9rraF
4wicd/QqtINA382QwyLchKWYwsIY0NI2a3pug7s8sl9ztLsrs083bM9e9pAw8kvA
BGNyn2AQbYe5nqV1Yy29
=T0hJ
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Jan_2014_14_58_29_+1100_4A/t1m6mGxcZLQ5J--
