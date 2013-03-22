Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3CVFUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 01:20:19 -0400
Received: from ozlabs.org ([203.10.76.45]:33882 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752534Ab3CVFUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 01:20:14 -0400
Date: Fri, 22 Mar 2013 16:20:11 +1100
From: Tony Breeds <tony@bakeyournoodle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 02/34] arch: Consolidate tsk_is_polling()
Message-ID: <20130322052010.GB31022@thor.bakeyournoodle.com>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Magnus Damm <magnus.damm@gmail.com>
References: <20130321214930.752934102@linutronix.de>
 <20130321215233.446034505@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <20130321215233.446034505@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2013 at 09:52:57PM -0000, Thomas Gleixner wrote:
=20
> +/*
> + * Idle thread specific functions to determine the need_resched
> + * polling state. We have two versions, one based on TS_POLLING in
> + * thread_info.status and one based on TIF_POLLING_NRFLAG in
> + * thread_info.flags
> + */
> +#ifdef TS_POLLING
> +static inline int tsk_is_polling(struct task_struct *p)
> +{
> +	return task_thread_info(p)->status & TS_POLLING;
> +}
> +#elif defined(TIF_POLLING_NRFLAG)
> +static inline int tsk_is_polling(struct task_struct *p)
> +{
> +	test_tsk_thread_flag(p, TIF_POLLING_NRFLAG);
> +}

On powerpc (at least) this is used before it's declared.  Also I think
you're missing a 'return' in that function.

*cough* https://www.kernel.org/pub/tools/crosstool/ *cough*

Yours Tony

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBCAAGBQJRS+oKAAoJEEsCiJRY75GKRQMQAI6f6lV/cIRU2zTZYJ9SGCkI
yvaP28K4yJYofT4jDkWVKd8iQOICm2UXik4j5H+8wXOUo7rgN7NvfRiiZWVlbe4H
1GI8Kw/+7nhNuS/f/Mud/wK+81Nkx907kT+5cttqszOawepoOrX0/UTMRerfEHhN
P7sRspjQULKvGJ6MrsMyIXO0fJzb3B9BT8b1CmjLxJbSp+aLz9c/E4ho4QY4yi41
0T7z/44u/YLEGwxU7IUNJaXoL211vc7fUXObSjTY8Mcnv4iciyOOI6bLOwfHaPQp
jJ/A3ZcNXHoRWlg/gGGJtQA6RLvQdLpcr7RyY9782GPy4aORxV+JfQWKaXZlo/CJ
KKdsmYkdCgWpqqTPiMry6rnOtMOASaR7EmSz9KqBdocpYlEjC39k4q+t29cZKV2g
W9ThFaNIBHJD313bGLyWciLO7b6HNA8EloHDMfEV/GrLyGzAAgUMTI6oCUaWnYcY
+4rItpcG0LSdpxuggCtoGOO7mIyuvJgZmfDgz52H3tollTuMWcN00bEASBoKwhn2
O845JKv5axf6OvzCDuumM+IOeGANASMJKh0EVDQWUI+H1onHlAZxBiyrXHEdTg0r
NDtPC0RCTYxuO6MILVBmmgg0PWjYLq2biPN4jxr+oprcnbFtUYnyIGJSC8js9WI6
Sbtj99g0lI6jp3wBI8Dc
=x4VK
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
