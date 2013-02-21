Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab3BUCFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:05:06 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58361 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884Ab3BUCFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:05:04 -0500
Date: Thu, 21 Feb 2013 13:04:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Clark Williams <williams@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20130221130458.5193a135446da5921bfe0ca5@canb.auug.org.au>
In-Reply-To: <20130214133016.94f67186e65534b58d81cbc4@canb.auug.org.au>
References: <20130214133016.94f67186e65534b58d81cbc4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__21_Feb_2013_13_04_58_+1100_bUWqfCzsIOL.RfDW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Feb_2013_13_04_58_+1100_bUWqfCzsIOL.RfDW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 14 Feb 2013 13:30:16 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the tip tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>=20
> drivers/thermal/intel_powerclamp.c: In function 'clamp_thread':
> drivers/thermal/intel_powerclamp.c:360:21: error: 'MAX_USER_RT_PRIO' unde=
clared (first use in this function)
>=20
> Caused by commit 8bd75c77b7c6 ("sched/rt: Move rt specific bits into new
> header file") interacting with commit d6d71ee4a14a ("PM: Introduce Intel
> PowerClamp Driver") from the thermal tree.
>=20
> I applied this merge fix patch and can carry it as necessary:
>=20
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 14 Feb 2013 13:26:22 +1100
> Subject: [PATCH] sched/rt: fix PowerClamp Driver for define move
>=20
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/thermal/intel_powerclamp.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_p=
owerclamp.c
> index ab3ed90..b40b37c 100644
> --- a/drivers/thermal/intel_powerclamp.c
> +++ b/drivers/thermal/intel_powerclamp.c
> @@ -50,6 +50,7 @@
>  #include <linux/tick.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
> +#include <linux/sched/rt.h>
> =20
>  #include <asm/nmi.h>
>  #include <asm/msr.h>

The above fix is now needed when the thermal tree is merged with Linus'
tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__21_Feb_2013_13_04_58_+1100_bUWqfCzsIOL.RfDW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJYDKAAoJEECxmPOUX5FESMAP/38ie8UjrcQapvfIOVLa4Q6s
5NIkobGiLgI4Id3LkJ+XR1lSufHpJPyPFIhPcSebb5g6WYRko7T7na57CGMDMapQ
AEzyv3fll3Xccx9wV9Z4oWYgvVXbKsZ0seb1QO2VqPdCSNsR1JoQssvIbNWvUBDF
T5QndKAmoouV06OO4CYGFBAPBcJSgMdmEICk9b+2u79aMftQ82XmYhO06Q/w2UGj
HvnnNe6X6pC77aihZ9rzemnKVzu6Pug9pMlkX8DUzfUF+pLoR18rY43vLoU21MZS
Zor9t/AJsK6wDUJ/WYkCzBY4eEXlkXur04Rq8Z6tspo2Y8288DAfvrPvoRrU9e5h
xx5VuvBkSQzxESj+So7eeLNpj1cH+2RsRKjoeVsPixKw86g/Km0VvL7YTiTbvEDY
LqI4ZoKTP/1gxB0O4Ufjjkm6IcHHU1eYnCtnelOr+xrE1SL96tgOVNuFPA4Hpz4Q
pFH7i8MIirWOMEVxxcXOsVzZMkqJPPAHoJ/Iy8/MHGKdX2NdlIMuEwLaQNuXgpY1
8x+T7OcKI1Xw8t4ud4uUc7L1nykDWsvuDKJALrlMko/ntOWXoaIeAiPqllQ3qKbE
E9Wx066jnbIeMNZDB3sWJI0zQhKvSy5gMe9NI831KznzbfI9PmzXuwTrUP2BayiB
HVNkm4ExXgiiGnAozAZ4
=X6yG
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Feb_2013_13_04_58_+1100_bUWqfCzsIOL.RfDW--
