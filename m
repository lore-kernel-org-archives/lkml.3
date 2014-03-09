Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaCIN4K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 09:56:10 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752209AbaCINzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 09:55:47 -0400
Message-ID: <1394373333.2861.84.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3/3] perf trace: Decode architecture-specific signal
 numbers
From: Ben Hutchings <ben@decadent.org.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Sun, 09 Mar 2014 13:55:33 +0000
In-Reply-To: <1391648441.3003.101.camel@deadeye.wl.decadent.org.uk>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
	 <1391648441.3003.101.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-oe0uB2NESve7hBIKgwGr"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.245
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oe0uB2NESve7hBIKgwGr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What's happening with this patch?  perf fails to build on alpha or sparc
since 3.13.

Ben.

On Thu, 2014-02-06 at 01:00 +0000, Ben Hutchings wrote:
> SIGSTKFLT is not defined on alpha, mips or sparc.
> SIGEMT and SIGSWI are defined on some architectures and should be
> decoded here if so.
>=20
> Fixes: 8bad5b0abfdb ('perf trace: Beautify signal number arg in several s=
yscalls')
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: <stable@vger.kernel.org>
> ---
>  tools/perf/builtin-trace.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> index 5c32dcf..25ea64c 100644
> --- a/tools/perf/builtin-trace.c
> +++ b/tools/perf/builtin-trace.c
> @@ -807,7 +807,6 @@ static size_t syscall_arg__scnprintf_signum(char *bf,=
 size_t size, struct syscal
>  	P_SIGNUM(PIPE);
>  	P_SIGNUM(ALRM);
>  	P_SIGNUM(TERM);
> -	P_SIGNUM(STKFLT);
>  	P_SIGNUM(CHLD);
>  	P_SIGNUM(CONT);
>  	P_SIGNUM(STOP);
> @@ -823,6 +822,15 @@ static size_t syscall_arg__scnprintf_signum(char *bf=
, size_t size, struct syscal
>  	P_SIGNUM(IO);
>  	P_SIGNUM(PWR);
>  	P_SIGNUM(SYS);
> +#ifdef SIGEMT
> +	P_SIGNUM(EMT);
> +#endif
> +#ifdef SIGSTKFLT
> +	P_SIGNUM(STKFLT);
> +#endif
> +#ifdef SIGSWI
> +	P_SIGNUM(SWI);
> +#endif
>  	default: break;
>  	}
> =20
>=20

--=20
Ben Hutchings
I say we take off; nuke the site from orbit.  It's the only way to be sure.

--=-oe0uB2NESve7hBIKgwGr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUxxy1ee/yOyVhhEJAQoTzxAAjZuYnd1rvjOxiMFl4rMteQoCWFH5ILho
vnHDdyNCVBD+EuqMJb+DDXrPqB9W6HzxTCUyKQbxVx4JLY5AF57rSo4sLf9y1Y0v
EWf+184Rs/abV9Bb2dPR9zv4FQ6WYjOJJAqxmTnPQ9Rq2/WfKeIJ3IbyDkszcTvu
rCyE/sxzRhMEmsPlx9464EiOEn0OVPxfeqMCDojG3VS5F/Hede8jntRKPomazTAY
TniFBj5tD9VMTu35K0ugUO+GpenIXdVDWsSVgabw1y1EwabotX2wsvHdnxPZP7Na
+Wzp8CJfOZHiMhR07Fo//iqYrJ5vzPi3Lp9o3UB4kIQwtWTZOo5ZbEkhYvllIkL5
BgiB1/9lk59cuvd9nrZVvzghMVG59f4u/PwvIVk7rfQekggJoP23bDhBVetHCwYO
snqDLPHansQMV8uzpSusO4j3dx0+iJzQpDz3iFNlknnly8J+Fna0SXBFLn1OmLaa
HU+xtOO/8fXT1tID1KLxgZFck6GucNv0TvOZtz1+kmMNHmbpswuyyqI7GcQNafYp
GjBdLnS1yobGNhGKJq6LeHqwCAHcsd6pVWRR4Jwsk29sLLOeJ74y5Cj1Hk5TEYN1
W+SvjTv8dLYgT9B3/Ahay04nsmX2IoEftjGpf1Hc/ie6tkDoFoGSJQAhRIU/ro7D
wOI7WEvjpeM=
=DrYH
-----END PGP SIGNATURE-----

--=-oe0uB2NESve7hBIKgwGr--
