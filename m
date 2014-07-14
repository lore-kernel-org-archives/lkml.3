Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756191AbaGNQKK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:10:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52733 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbaGNQKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:10:02 -0400
Date: Mon, 14 Jul 2014 18:09:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, luto@amacapital.net,
        hpa@linux.intel.com
Subject: Re: [PATCH] perf: Add vm_ops->name call for mmap event name retrieval
Message-ID: <20140714160947.GB9918@twins.programming.kicks-ass.net>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="M9u+pkcMrQJw6us1"
Content-Disposition: inline
In-Reply-To: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--M9u+pkcMrQJw6us1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 05:57:19PM +0200, Jiri Olsa wrote:
> Following patch added another way to get mmap name:
>   78d683e mm, fs: Add vm_ops->name as an alternative to arch_vma_name

Please add to your .gitconfig:

[core]
        abbrev =3D 12

Also, you failed to CC the two people involved in that.

> The vdso vma mapping already switch to this and we no longer
> get vdso name via arch_vma_name function. Adding this way to
> the perf mmap event name retrieval code.
>=20
> Caught this via perf test:
>=20
>   $ sudo ./perf test -v 7
>    7: Validate PERF_RECORD_* events & perf_sample fields     :
>   --- start ---
>=20
> SNIP
>=20
>   PERF_RECORD_MMAP for [vdso] missing!
>   test child finished with 255
>   ---- end ----
>   Validate PERF_RECORD_* events & perf_sample fields: FAILED!
>=20
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  kernel/events/core.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/kernel/events/core.c b/kernel/events/core.c
> index 67e3b9c..4799676 100644
> --- a/kernel/events/core.c
> +++ b/kernel/events/core.c
> @@ -5266,6 +5266,12 @@ static void perf_event_mmap_event(struct perf_mmap=
_event *mmap_event)
> =20
>  		goto got_name;
>  	} else {
> +		if (vma->vm_ops && vma->vm_ops->name) {
> +			name =3D (char *) vma->vm_ops->name(vma);
> +			if (name)
> +				goto cpy_name;
> +		}
> +
>  		name =3D (char *)arch_vma_name(vma);
>  		if (name)
>  			goto cpy_name;
> --=20
> 1.8.3.1
>=20

--M9u+pkcMrQJw6us1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxADLAAoJEHZH4aRLwOS6iIAP/RVeRwxhM029l23DL/uIxUml
0cfLkFkjSRhzs7/kYZkcj1NdV0vo0J78kMVpvH5Yqw+MvooejlGwmwxYiujsFDL8
9pkLrStgfuWpl4EXa+YN6aH0eEqgyhX3zZ9ERgUZuRPRTt6M9XnT5BFXacgkVXYX
2H+KwqcS9Stdi8eSUoNGjXASp6qP5PJLzzFW+CVONSXMU2qv4KwWucr8F3yW/W33
4yUlC0OHz6OasNvfWe/xYFG6x+WhmIapT/S8WVtyvZy55AAJ82D94BfLmFQf1FBD
76OyJ7RvE+dpDBcu85VBuWDBLRxNxWmZqxvk+5AzSuZzx0kynpFzJ2YagOh2tqqg
4Dzqc8r/xUm48kzI4G6gsSfxE5oRHGWzRSc/zCMCCleKEXeSzIeAcKWRPoVQDV7b
G4aCaRszqylXNp+kF1jedDyqQAmN8nqWzIxZh3Tc7FFDk9C6NIAjWTk5aA8H2rFE
FfCo0OzFAPcGDwNpUqV0ybaWnpORQdbyJFatnWnmp4YNBWpfBnFc5tJ7q5/LARJG
72Q0zj+74rAIC4JTzJcUsN6BUnQGouCjAhN+xS//I53fNpPnMsufHrIB2WPr3NyB
fGaqw2+xklkr3NVpxPNCZzXiHQ2z7UPcTEqhUq3N+tY47c5hkTqrlaKBOArun4lM
WbcPVxNHKdwejwCSeSWd
=z0/x
-----END PGP SIGNATURE-----

--M9u+pkcMrQJw6us1--
