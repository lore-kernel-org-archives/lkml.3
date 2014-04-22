Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbaDVV1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:27:36 -0400
Received: from ozlabs.org ([103.22.144.67]:34068 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758532AbaDVV1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:27:32 -0400
Date: Wed, 23 Apr 2014 07:27:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Briggs <rgb@redhat.com>, sparclinux@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the audit tree
Message-Id: <20140423072718.56b31d2afcd65c7b210a1d77@canb.auug.org.au>
In-Reply-To: <1398184360.2596.7.camel@flatline.rdu.redhat.com>
References: <20140422162207.55e3d9f09244de281b9798cc@canb.auug.org.au>
	<1398184360.2596.7.camel@flatline.rdu.redhat.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__23_Apr_2014_07_27_18_+1000_kcDcY2x9hfJ80tOp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Apr_2014_07_27_18_+1000_kcDcY2x9hfJ80tOp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, 22 Apr 2014 12:32:40 -0400 Eric Paris <eparis@redhat.com> wrote:
>
> I swear I saw this and I fixed it.  Drat.  Do we want to do it this way?
> Above in syscall_get_arguments() they use
>=20
> #ifdef CONFIG_SPARC64
>         if (test_tsk_thread_flag(task, TIF_32BIT))
>                 zero_extend =3D 1;
> #endif
>=20
> Is CONFIG_SPARC64 a better choice than:
>    defined(__sparc__) && defined(__arch64__)

I have no idea, I just copied the test from thread_info.h.

> Maybe even better would be to copy what you suggested in powerpc:

That would be better, except ...

> diff --git a/arch/sparc/include/asm/syscall.h b/arch/sparc/include/asm/sy=
scall.h
> index fed3d51..49f71fd 100644
> --- a/arch/sparc/include/asm/syscall.h
> +++ b/arch/sparc/include/asm/syscall.h
> @@ -128,8 +128,7 @@ static inline void syscall_set_arguments(struct task_=
struct *task,
> =20
>  static inline int syscall_get_arch(void)
>  {
> -	return test_thread_flag(TIF_32BIT) ? AUDIT_ARCH_SPARC
> -					   : AUDIT_ARCH_SPARC64;
> +	return is_32bit_task() ? AUDIT_ARCH_SPARC : AUDIT_ARCH_SPARC64;
>  }
> =20
>  #endif /* __ASM_SPARC_SYSCALL_H */
> diff --git a/arch/sparc/include/asm/thread_info_32.h b/arch/sparc/include=
/asm/thread_info_32.h
> index 96efa7a..acd2be0 100644
> --- a/arch/sparc/include/asm/thread_info_32.h
> +++ b/arch/sparc/include/asm/thread_info_32.h
> @@ -130,6 +130,8 @@ register struct thread_info *current_thread_info_reg =
asm("g6");
>  #define _TIF_DO_NOTIFY_RESUME_MASK	(_TIF_NOTIFY_RESUME | \
>  					 _TIF_SIGPENDING)
> =20
> +#define is_32bit_task()	(0)

Shouldn't that be (1) ?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__23_Apr_2014_07_27_18_+1000_kcDcY2x9hfJ80tOp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTVt7BAAoJEMDTa8Ir7ZwVU8YP/Aipzyc/qfUxbaEepyLrH76s
tM7OQUif2CHZI5TMqJb/9W1d0aJajhrZ9ywBWOBkU0j1liJNSijsi3SUH+OvXijo
KpKx7MIsnviBwFm/SWRSs+C5aWtRY6D2R4F1k19IG1IWQQEoQS+n/rEK/wRRrcEU
GJCYvHDrAmrDq02ubY0to7M2rwwgWM4StPxez6fUEiepQvcIQWQQ5bytPoFNMDTF
mEY9XbjdEOPWYs3WKJam1IQVsbH6h1iatooBe4xtn3va6NCx1yvfo1LWhjY2496/
mOAEBgG5Q7X6+mWIlX9Hq1J97+W4LsjAkQyHAHPPb29rD1CZpEJdDrZWEH2PK2be
dBLKtEtPuU6VuH1+fDpUwKY+5U8lGkNWOnvZAil1mnIChZYtvc2IQzZ2wBvGuIIf
fq2e8y3vuD772EBqRrRvXk7uPALcJpuT2B9UiNBeNGaY4FcV/OT8FCjQ1fllq3xt
hxEBWbTX5Gsa4XMjMTyAmGgk2DFi1zeQ3/GiAGk9Tvh8IDh0JkaA1sjPXyDF0Fy5
gNBPHF26QckRLaHNx/ADJcYkKnVict2rCWjq4pmHrnaAOXA+tYZb1QZ44f+ERuny
2zqg2e4JBzxIvAYsduXq9DcH9w66hqykxvDirjorad/96jezNvzkz/x95kIuGWuH
3N0AWbZiD6MwE8lwx1C4
=aVmu
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Apr_2014_07_27_18_+1000_kcDcY2x9hfJ80tOp--
