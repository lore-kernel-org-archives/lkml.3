Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbaGCVei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:34:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56667 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754073AbaGCVeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:34:36 -0400
Date: Thu, 3 Jul 2014 16:34:25 -0500
From: Tyler Hicks <tyhicks@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kbuild test robot <fengguang.wu@intel.com>,
        Oleg Nesterov <oleg@redhat.com>, kbuild-all@01.org,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Halcrow <mhalcrow@us.ibm.com>, ecryptfs@vger.kernel.org
Subject: Re: [trace:ftrace/core 1/3] include/trace/syscall.h:39:6: error:
 'TIF_SYSCALL_TRACEPOINT' undeclared
Message-ID: <20140703213425.GB5089@boyd>
References: <53a1e7ba.ZIiv6DbOB78b9RzY%fengguang.wu@intel.com>
 <20140618211559.76bdea15@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="St7VIuEGZ6dlpu13"
Content-Disposition: inline
In-Reply-To: <20140618211559.76bdea15@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--St7VIuEGZ6dlpu13
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2014-06-18 21:15:59, Steven Rostedt wrote:
> On Thu, 19 Jun 2014 03:25:46 +0800
> kbuild test robot <fengguang.wu@intel.com> wrote:
>=20
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-tra=
ce.git ftrace/core
> > head:   72fa1a896d8ef355e81270667803ceb16a3dd13f
> > commit: 32def52ce8faec72c353b6304ca98176687e18f1 [1/3] tracing: Fix sys=
call_*regfunc() vs copy_process() race
> > config: make ARCH=3Dxtensa allyesconfig
> >=20
> > All error/warnings:
> >=20
> >    In file included from include/linux/syscalls.h:80:0,
> >                     from fs/ecryptfs/keystore.c:29:
> >    include/trace/syscall.h: In function 'syscall_tracepoint_update':
> > >> include/trace/syscall.h:39:6: error: 'TIF_SYSCALL_TRACEPOINT' undecl=
ared (first use in this function)
> >    include/trace/syscall.h:39:6: note: each undeclared identifier is re=
ported only once for each function it appears in
> >=20
> > vim +/TIF_SYSCALL_TRACEPOINT +39 include/trace/syscall.h
> >=20
> >     33		struct ftrace_event_call *exit_event;
> >     34	};
> >     35=09
> >     36	#ifdef CONFIG_TRACEPOINTS
> >     37	static inline void syscall_tracepoint_update(struct task_struct =
*p)
> >     38	{
> >   > 39		if (test_thread_flag(TIF_SYSCALL_TRACEPOINT))
> >     40			set_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> >     41		else
> >     42			clear_tsk_thread_flag(p, TIF_SYSCALL_TRACEPOINT);
> >=20
> > ---
> > 0-DAY kernel build testing backend              Open Source Technology =
Center
> > http://lists.01.org/mailman/listinfo/kbuild                 Intel Corpo=
ration
>=20
> My allyesconfig build passed with flying colors. Although we should
> probably still add the include of thread_info.h into trace/syscalls.h,
> there's no reason that ecryptfs/keystore.c includes linux/syscalls.h.
>=20
> I suggest adding the patch below.
>=20
> -- Steve
>=20
> From 58029546c4acf896b9ce01a820e0093e37bb98be Mon Sep 17 00:00:00 2001
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> Date: Wed, 18 Jun 2014 21:12:38 -0400
> Subject: [PATCH] ecryptfs: Remove unnecessary include of syscall.h in
>  keystore.c
>=20
> There's no reason to include syscalls.h in keystore.c. Remove it.
>=20
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---

Hello! Sorry for not being active in this thread.

I don't see a reason for keystore.c to include linux/syscalls.h. I'll
get this patch applied to my next tree and push it during the next merge
window. Thanks!

Tyler

>  fs/ecryptfs/keystore.c | 1 -
>  1 file changed, 1 deletion(-)
>=20
> diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
> index 4725a07f003c..831c5f8529be 100644
> --- a/fs/ecryptfs/keystore.c
> +++ b/fs/ecryptfs/keystore.c
> @@ -26,7 +26,6 @@
>   */
> =20
>  #include <linux/string.h>
> -#include <linux/syscalls.h>
>  #include <linux/pagemap.h>
>  #include <linux/key.h>
>  #include <linux/random.h>
> --=20
> 2.0.0.rc2
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe ecryptfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--St7VIuEGZ6dlpu13
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTtcxhAAoJENaSAD2qAscK168P/1BBhOUCinPk5llgamWnsooh
dRuD5LffZMrHBXKsNFz0JH+Idf2ywTbA/JVGu0RC6aZxpZTf+lssNA7TaeBQ3f9A
WFky2e1YfA3FRyexaVY71Wi76T+nsu5/FdDWS96aZf1MbE/nv8F5xVstKJpaMy3O
OMEwpqu88tVF8jJNgLfG1GjD0+82X3hlLGYpWzwshYbzTZ9EjpUnOr5wUfHyPRyo
iBKPsiA07kiggULuVK/1PxHweJEXFIMJf6d4Ut/zKm7e9KZHkZbDsPWQ8OS68Vi4
FPKfYyuvBYI4eAAwRQKoMYowr0FDuwL3fwh+4m3EGm5PMvl2rOjfQ1VCGZFQE8ID
l27ynh6Vu1rD5ubLgEkA4Um8B81wSgpIrVIuDzUI3f8df3xNcOlUsyiinXTH25yO
Iwy5bpYyZNulJJAKMdc44s6kWHdZERY2v8gUbwCfIynFbZUZUKf4HPzZJP5P5RCi
nS4P4dEuMLIB0ZanUcGXl0GyeMkwxLjpSl4MUl0tOUPpZNKpOhoWFWJtMDyrjD+D
dfHni2MDd4Zq56kPZNjZquc7Cp0uIqjmO7ssYfAWX8Fg884sMDh73hjw7u6lY3jD
hoieFumhcmW/VZlmAVRpdILUGWUrR+wx/MddZRvFoRb29O+xantNd1+Cp1764Oc2
HB5fo2W47oniPCjFDF3W
=AOmM
-----END PGP SIGNATURE-----

--St7VIuEGZ6dlpu13--
