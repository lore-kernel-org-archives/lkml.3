Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508AbaEHOeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 10:34:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:44079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336AbaEHOeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 10:34:08 -0400
Date: Thu, 8 May 2014 16:34:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] treewide: remove all open implementation of
 nice_to_rlimit()/rlimit_to_nice().
Message-ID: <20140508143404.GV11096@twins.programming.kicks-ass.net>
References: <e1f9c9f2023719e0738e16cd6807c74c68b08fad.1399532322.git.yangds.fnst@cn.fujitsu.com>
 <a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xFHWmGwbilGjB8dh"
Content-Disposition: inline
In-Reply-To: <a568a1e3cc8e78648f41b5035fa5e381d36274da.1399532322.git.yangds.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xFHWmGwbilGjB8dh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 06:33:49PM +0900, Dongsheng Yang wrote:
> As there are already two inline functions in prio.h to handle the convert=
iion
> between nice value and rlimit style value of priority, this patch remove =
all
> open implementation of these two functions.
>=20
> Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
> ---
>  drivers/staging/android/binder.c | 2 +-
>  kernel/sched/core.c              | 2 +-
>  kernel/sys.c                     | 6 +++---
>  3 files changed, 5 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/b=
inder.c
> index 179b21b..9311bb6 100644
> --- a/drivers/staging/android/binder.c
> +++ b/drivers/staging/android/binder.c
> @@ -436,7 +436,7 @@ static void binder_set_nice(long nice)
>  		set_user_nice(current, nice);
>  		return;
>  	}
> -	min_nice =3D 20 - current->signal->rlim[RLIMIT_NICE].rlim_cur;
> +	min_nice =3D rlimit_to_nice(current->signal->rlim[RLIMIT_NICE].rlim_cur=
);
>  	binder_debug(BINDER_DEBUG_PRIORITY_CAP,
>  		     "%d: nice value %ld not allowed use %ld instead\n",
>  		      current->pid, nice, min_nice);

One does wonder WTF binder is smoking.. must be strong stuff. That's
some qualitee crackpot code there.

--xFHWmGwbilGjB8dh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa5XcAAoJEHZH4aRLwOS6PVMQAKWgVWkR3gG7Wr3xBjPLuIoP
n09TeAjUxYarSFcD5HkLkSjlpDdYDHIHr+orzYGpSG/Kt36GglFQ9XmYg94qIdv1
zme6P18hkNw2zIV2gMRZopN5TIU/z8MoiIOu3UCH0A4wlBkcOpDwKCar6N7F5UXn
7ORFXWdunTzUF/rQG1lB2IrSzw+s5CW01YDJqjf7W/TJc5VuhgEkzfjxPE4I1Toi
gG3S1Yukz0rnCh2X9XB7P7C9vSbH6GsCJygzPXv/5wFhdi5dKwe4Xzjo+hdBl8yr
eIlgfJVhueuyIAbNtNGQPDBGUVkLGOBoT4bK+G0TmUdcG9v/p5ZNDXq1ExYYmOpm
+1h3LzAIBhC4PoNdu2MmC4r5CjjTVQ1l+ctMmNUCa+BqJBKywhmB7pjHPmSx+28o
EJkeCv/H5h3XO8zUOh67HMndEwm8lL1w3iwDSLEqJEdNKEK8PC2IDCWpe8vS/YEz
ln7uOlEMEcMOdESW/mmQ9AF6UD7akKWOXvqTWi48SIuhRBrQpsczWkyylqPee+ie
AR9qA7r1CcIaEunCBikT2KhDtG0CiCnHYqfXfdRsvrAH6ndINPJTEferAm6p9g7L
lmIMmdiDojiD7AdQo5OM2IZAF2BshLWMKw9pwKDUkiVWCdxIEnM9mIUh0IR4E9Oi
ji3/DExNrxsX5ScL7UyP
=itLN
-----END PGP SIGNATURE-----

--xFHWmGwbilGjB8dh--
