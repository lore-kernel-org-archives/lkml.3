Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaBXGXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 01:23:24 -0500
Received: from ozlabs.org ([203.10.76.45]:33551 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbaBXGXX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 01:23:23 -0500
Date: Mon, 24 Feb 2014 17:23:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>
Subject: Re: linux-next: build warning after merge of the tip tree
Message-Id: <20140224172313.2560c05d9e0b189acf8731bf@canb.auug.org.au>
In-Reply-To: <20140223221217.4f09b9d1.akpm@linux-foundation.org>
References: <20140224151732.7461213fabef4fc1bbca8213@canb.auug.org.au>
	<20140224165621.843089bb746605469e016e5d@canb.auug.org.au>
	<20140223221217.4f09b9d1.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__24_Feb_2014_17_23_13_+1100_NdXE2nRzaGliz=TX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Feb_2014_17_23_13_+1100_NdXE2nRzaGliz=TX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Sun, 23 Feb 2014 22:12:17 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> Doh, I missed that.  I don't know if it's "allowed" or not, but it's
> clearly the wrong thing to do - the whole point of asmlinkage is to
> export the thing to other compilation units.
>=20
> So I suppose this:
>=20
> mm/process_vm_access.c:416:1: warning: no previous prototype for `compat_=
process_vm_rw' [-Wmissing-prototypes]
>=20
> should be squashed by giving it a prototype.  Something like

Or maybe it should be static but *not* asmlinkage like process_vm_rw() ?

As far as I can see it is only used in mm/process_vm_access.c.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__24_Feb_2014_17_23_13_+1100_NdXE2nRzaGliz=TX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTCuVVAAoJEMDTa8Ir7ZwVhMYP/j9louE1VVVvHm+9fCIxk9fO
ZoOouyH5DMWSyESR2wABSFTG3EqOPT/nSi2TRXSTUbcHzPNNzH4r8/INf8vxPdxi
mm8gYq2xyi2x2OPBMneJyVuEuALUgjWUBWZRlyIhpPpKdKh+/78IixmBwIOmLGFr
jyTx0b5cwgAR22NQ1Bt7NFeAx+XSSuFhmO4Hv02qHwrKOO6ftue6lhtf+/yJvSBb
AQV9pYs0C0dV9mnay4AdPaDbcx9/Rzf3vJ4c8+syxgDoDLJJMKN3U3lFgyo86HGH
Imx1NC8rR7Vi/cGXWlySB15y1W6JvNn5Td8wynL+GCMcAUwM9vDWMg/6A/gO6h57
aiy1QBPapf7KAlxqVC3ixLW9aTBNhDOBnjXJnobLpcm6PPJNn8WJpNljm5U2G3eF
h67RrVAcEdZDNahJjmrR6JMwATCWz2s2fDsQA6Cm/ULPa2AItuRhOJg7YbsgslyN
AazBzUqROqZeHYMIK5t+mU4pULVJkE/cpTtgMRG8iwZ/W1NLK/Ur7Sc3CgNmC7mQ
6wpjznLWcVtrbaGOZNQyXWp+yXX4GAewibTZFDj7F0MCFRu1nBs/tRb4p8kvfQ7K
WUydD1Og0arcQrTzvOMB83/jFlrg2rbvNK/CoFCz+bE0HIF9/lw4JRIOzMZVY/zQ
GE15484r7nduJatvak2L
=kHOB
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Feb_2014_17_23_13_+1100_NdXE2nRzaGliz=TX--
