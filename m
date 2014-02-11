Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaBKDBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 22:01:11 -0500
Received: from ozlabs.org ([203.10.76.45]:34231 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186AbaBKDBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 22:01:08 -0500
Date: Tue, 11 Feb 2014 14:00:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: linux-next: build failure after merge of the tip tree
Message-Id: <20140211140059.acf8dd51bfa5dfbb738d2de0@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Feb_2014_14_00_59_+1100_57sUphbkTXEt_4GL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Feb_2014_14_00_59_+1100_57sUphbkTXEt_4GL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the tip tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

arch/powerpc/platforms/cell/spufs/sched.c:86:0: error: "MAX_USER_PRIO" rede=
fined [-Werror]
 #define MAX_USER_PRIO  (MAX_PRIO - MAX_RT_PRIO)
 ^
In file included from include/linux/sched.h:6:0,
                 from arch/powerpc/platforms/cell/spufs/sched.c:26:
include/linux/sched/prio.h:38:0: note: this is the location of the previous=
 definition
 #define MAX_USER_PRIO  (USER_PRIO(MAX_PRIO))
 ^

Caused by commit 6b6350f155af ("sched: Expose some macros related to
priority").  A quick grep shows that MAX_USER_PRIO is defined in
include/linux/sched/prio.h, but not used anywhere (except in
arch/powerpc/platforms/cell/spufs/sched.c where it is also defined)?

I have used the tip tree from next-20140210 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__11_Feb_2014_14_00_59_+1100_57sUphbkTXEt_4GL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS+ZJvAAoJEMDTa8Ir7ZwVFMQP/jNDyxY5c16ewD1kRtb9NGba
7XUKZOD4Pt8G7U+UzPvwZbJpsrYiRda3U9FjGL2wh21hk3L5eAfr/6EgNrLRcr5T
tQR7sW2mhhxi5HbufDKDfaWf8amhE9wwJdS3I8DdWq/Z0oePHHAmGWflEFjM9x6m
bvdAXRk2GpOhPh8JdgzAxyc4cPwFqTIWdwbPsmo1fap1+XdmAHhB1ex01UEMrVRn
r4thWOLnPom7mOrepb3v8AXPPsIcsRI+CIJstUeeAJOP+YzahiMlPgxNUzAJCYwc
XWCoWnJdqCFtHo/X9oHjKiT31UFzU0GrZlS6WJF66wAAdSAqaijkOABhutME61+Q
l4cM9mBQzV/REevkR2IFJlP6V1rt/L5jVzcK3AJKnxsnHxKiRLyXf0Awx5rNiLFe
rhO0F1+dUtP6AHaURgyBOnweQJUyUN4TaBKf8t/roUOuWvxhUR1mye2UXMhyNG4G
zQtoPh6jdFBcMk1xyWNNcKzq4iOAvyfioSiHiUSf4Oi6w2umHlK3fEojHmIJNN/W
F4sgAm2mgBTk1Y8y2tDAWIipCiw9RrSA4MWRXKneDEIXVcJ1++/fkK58FHkaCNZy
Zl2yGpw1sjWP5Va5H3HuqJJgNQjXIJMOKJk9X4rkm9bWDJhvKNLoRNc9HQX8PmHs
ZjVXNNIy21iyMCKEHPsA
=X6Zz
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Feb_2014_14_00_59_+1100_57sUphbkTXEt_4GL--
