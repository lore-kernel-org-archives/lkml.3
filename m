Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbaH0EWv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 00:22:51 -0400
Received: from ozlabs.org ([103.22.144.67]:41736 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751270AbaH0EWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 00:22:50 -0400
Date: Wed, 27 Aug 2014 14:22:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: linux-next: build failure after merge of the percpu tree
Message-ID: <20140827142243.6277eaff@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/KsNXNA5Z1zohZIcanEE+h4k"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/KsNXNA5Z1zohZIcanEE+h4k
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the percpu tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

In file included from arch/powerpc/include/asm/xics.h:9:0,
                 from arch/powerpc/kernel/asm-offsets.c:47:
include/linux/interrupt.h:372:0: warning: "set_softirq_pending" redefined
 #define set_softirq_pending(x) (local_softirq_pending() =3D (x))
 ^
In file included from include/linux/hardirq.h:8:0,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
arch/powerpc/include/asm/hardirq.h:25:0: note: this is the location of the =
previous definition
 #define set_softirq_pending(x) __this_cpu_write(irq_stat._softirq_pending,=
 (x))
 ^

I got lots (and lots :-() of these and some were considered errors
(powerpc is built with -Werr in arch/powerpc).

Caused by commit 5828f666c069 ("powerpc: Replace __get_cpu_var uses").

I have used the percpu tree from next-20140826 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/KsNXNA5Z1zohZIcanEE+h4k
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT/V0XAAoJEMDTa8Ir7ZwVgAcP/1XcTon/nCqbryu99hiHm2L6
amQ8+2B6fP0AEbKeX68QnCjJjLeVRSCkNn5+mR2AgC75W9HAd/qL/6IwjECVpPn0
ziHIDK6DHRBjgoblzaU+BhzgAJN9DuncGIlZ/ffuLERja1uu1hHSYklRtwAHxYgC
JdOyd3Ex5Ux8ad1JpRHrt/xD3EoCcszNZFeqQE0L52DsxeSSznLpDsKw8bqjz6ue
h0tARKmyoE9vqbWQ2da0OmUtrZkPHUbpQH/cvvugkKw5q33ObtvtD2SUvLSe2eKz
CcHPAA8F/zQfdYRTr8HzIxtMjmNYqL9FUVNbnGe+lBFjUKCcOEcf/5G8Wcg0+LKa
lsFz8fhz1ai0RjaaZyUz7hrldK4HMYZImy+YO74poZOn2gsPnhkqmaVpvQZJo4+e
dmF6qSuAQCdXqSS71Q3+jo/gpKwDSFRam9eSMtz2QGGTWk9FI0Wn5HC9hqKlstFg
t5WRTF5131iYgh+apXTypBJBf0nOTnPM4+pn/M+sHIxOzz9XXDDK75RflHBsW0GT
s2dwMuIXS7kRETx4Q0xCCObmo/C9omou4XKMJU/LCUwwfVF4ICB2GtZj8qzdbzPd
P5gkhzs2b2D5zfxUE3RU7sUNe9o5Sp4JUzK4rmZe8IuWUF6Xz/fsgvdtjLx549nK
DvH3AsNikM/L/3fgdwHU
=NERl
-----END PGP SIGNATURE-----

--Sig_/KsNXNA5Z1zohZIcanEE+h4k--
