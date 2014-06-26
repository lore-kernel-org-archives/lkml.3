Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbaFZA7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:59:36 -0400
Received: from ozlabs.org ([103.22.144.67]:43802 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757154AbaFZA7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:59:34 -0400
Date: Thu, 26 Jun 2014 10:59:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linuxppc-dev@lists.ozlabs.org,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] sched: Fix compiler warnings
Message-ID: <20140626105928.5f375f0c@canb.auug.org.au>
In-Reply-To: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
References: <1403658329-13196-1-git-send-email-linux@roeck-us.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/wF5KR9VSDmitSY4.rX/W0Xh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/wF5KR9VSDmitSY4.rX/W0Xh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

[I know I'm a bit late to this, but ...]

On Tue, 24 Jun 2014 18:05:29 -0700 Guenter Roeck <linux@roeck-us.net> wrote:
>
> diff --git a/arch/arm/kernel/topology.c b/arch/arm/kernel/topology.c
> index 9d85318..e35d880 100644
> --- a/arch/arm/kernel/topology.c
> +++ b/arch/arm/kernel/topology.c
> @@ -275,7 +275,7 @@ void store_cpu_topology(unsigned int cpuid)
>  		cpu_topology[cpuid].socket_id, mpidr);
>  }
> =20
> -static inline const int cpu_corepower_flags(void)
> +static inline int cpu_corepower_flags(void)
>  {
>  	return SD_SHARE_PKG_RESOURCES  | SD_SHARE_POWERDOMAIN;
>  }

The only reference to this function is to take its address, so "inline"
is useless, right?

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 306f4f0..0376b05 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -872,21 +872,21 @@ enum cpu_idle_type {
>  #define SD_NUMA			0x4000	/* cross-node balancing */
> =20
>  #ifdef CONFIG_SCHED_SMT
> -static inline const int cpu_smt_flags(void)
> +static inline int cpu_smt_flags(void)
>  {
>  	return SD_SHARE_CPUCAPACITY | SD_SHARE_PKG_RESOURCES;
>  }
>  #endif
> =20
>  #ifdef CONFIG_SCHED_MC
> -static inline const int cpu_core_flags(void)
> +static inline int cpu_core_flags(void)
>  {
>  	return SD_SHARE_PKG_RESOURCES;
>  }
>  #endif
> =20
>  #ifdef CONFIG_NUMA
> -static inline const int cpu_numa_flags(void)
> +static inline int cpu_numa_flags(void)
>  {
>  	return SD_NUMA;
>  }

The same is true of those three, but then they would have to be moved
into a .c file and replaced with prototypes ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/wF5KR9VSDmitSY4.rX/W0Xh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTq3B0AAoJEMDTa8Ir7ZwV8zMP/2IaL9O+TWfB5xl3Shi30PuI
3/ThTtgA+dpwGmts0zA3tr1MfsgHE0BEw5z9LQzkd4auTIEjHKhK57eOO0o+BH3Z
Dj9TdVMceRON45IA1En23y8bN0CdGl+82kXfvC7Nkkol1fDaHdHWtaQC/HmNzYFU
51nT1YhawSpBdn0EyxFhWpIOFCu5gTw/qbgKa3nMv7vWMlnrFffTdf3NlQS2bXEN
1t9EuBpL472hpnhdr8e8oDP7v4v4ZN9NZ4e/OUvoRnMBRRJpeFh+B63ipZOiEZIR
s655tHiF6P5FL3nDvN78ZrJ481kE3zRJhkEzShns4MWiXMgdgChO6bEcf80B88d8
RKH1rjXLpBhZhAOcBRyQMc2KT7j1sS+IBZhyMueHD0IJ36gVXyZMs+uNfw8xQ0MU
0JfCvQlQwRRj8lwbyUN+muMP7FutWT2kHnHJNcB03Gu9wZvwISW0R21JlkVVrfMs
kK5344O3VvGik1iW4Bs9S4YPBghC6dGqBMlNXOW0mHEpKza/Vu3bh0al6l9sRETx
2Y9xPfyUbXuD+VhE4AsYBa22JGpWFtTWM6TK/w2A1DNuNIhaKZjACxyC3ajmwiZF
4w/wgQKOdwQCyUsZIer+ASkgN5dKcQOs8EiY7VyX8lc4DGNEaPI6pV6FdLJRyHyd
G23T3ps+VvfZJgGSMdlQ
=0rW7
-----END PGP SIGNATURE-----

--Sig_/wF5KR9VSDmitSY4.rX/W0Xh--
