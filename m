Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbaE1Izu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:55:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48097 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaE1Izs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:55:48 -0400
Date: Wed, 28 May 2014 10:55:38 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Dave Jones <davej@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf: Differentiate exec() and non-exec() comm events
Message-ID: <20140528085538.GR11096@twins.programming.kicks-ass.net>
References: <1401266704-22572-1-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v3gsnnLXiLKXzTq3"
Content-Disposition: inline
In-Reply-To: <1401266704-22572-1-git-send-email-adrian.hunter@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v3gsnnLXiLKXzTq3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 28, 2014 at 11:45:04AM +0300, Adrian Hunter wrote:
> perf tools like 'perf report' can aggregate samples by comm
> strings, which generally works.  However, there are other
> potential use-cases.  For example, to pair up 'calls'
> with 'returns' accurately (from branch events like Intel BTS)
> it is necessary to identify whether the process has exec'd.
> Although a comm event is generated when an 'exec' happens
> it is also generated whenever the comm string is changed
> on a whim (e.g. by prctl PR_SET_NAME).  This patch adds a
> flag to the comm event to differentiate one case from the
> other.
>=20
> In order to determine whether the kernel supports the new
> flag, a selection bit named 'exec' is added to struct
> perf_event_attr.  The bit does nothing but will cause
> perf_event_open() to fail if the bit is set on kernels
> that do not have it defined.
>=20

> --- a/include/uapi/linux/perf_event.h
> +++ b/include/uapi/linux/perf_event.h
> @@ -302,8 +302,8 @@ struct perf_event_attr {
>  				exclude_callchain_kernel : 1, /* exclude kernel callchains */
>  				exclude_callchain_user   : 1, /* exclude user callchains */
>  				mmap2          :  1, /* include mmap with inode data     */
> -
> -				__reserved_1   : 40;
> +				exec           :  1, /* flag comm events that are due to an exec */
> +				__reserved_1   : 39;
> =20

Yah.. that's just sad :-(

the only capabilities mask we have is in the mmap() page, so without
mmap()ing we have no way to test that.

Would it make sense to call it comm_exec?

--v3gsnnLXiLKXzTq3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJThaSKAAoJEHZH4aRLwOS6PxYP/2sXO0OdUl+zKKwHnC6Vkgb7
XB8w6JV38+YOln66xiObOzv/m13FP1RSrbDlpVyWsDshJES2S6KoO6cXDeSvjVfC
RJzhJfTgAi+Q2dP/k4HXzmc0Jsg1w+HHJqGfDLYLDOqZtt8nOFqBlmOo3t8Dsg5k
+S7phBtqRLSey/mPWf5fLqvlZ88LKRRkWGUFEkxdRWBzOuvteCZYqSo4ZFA3yjxE
uuBAH08dN8WmRhfXDKZtCjhcEhKwrFJ1YL/xgsDjqm95dWTVkC1o/1+LA3piO9yc
eLI7CER3HA7TMQN5gSxwqGROSTvXptOiTuQmFrNODsVMtyDqRRVHDodRcV5KGuZ0
e0DkyqYdZrdptCVCpa/w9UKqCRbeYPlW0vt7MDCZZy/n8yNXLEWsDuZZklJEr9kf
0iO17HSWfzhAqG9KLYuv90iC2jev5qOiAWxzL4BzEjfYWk118vOdAYRT4HHNyIPw
m7dRWkAZWSSXhMsOB3gTBAYOfTJ0tDJPESLtXKPpvnr3ZeL1PIihDdTrgEmY8EDD
onB1PmC3gEzXOH9yJsxk/eEIqpcJDiregqsIlnF4BYFidi6oRRKfee0RN7J2XAwv
H73ImFb9ilciTAvYMOmm0dfIL/IlDUsxWSjPueKt4ZRlcFCu9yXC1FCVzogabbfD
+sz3obDmOLLtmGXl9BOT
=Balh
-----END PGP SIGNATURE-----

--v3gsnnLXiLKXzTq3--
