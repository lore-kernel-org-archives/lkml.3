Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932878AbaFDHxc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 03:53:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:45301 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176AbaFDHxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 03:53:31 -0400
Date: Wed, 4 Jun 2014 09:53:24 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: umgwanakikbuti@gmail.com, mingo@kernel.org, tglx@linutronix.de,
        nicolas.pitre@linaro.org, daniel.lezcano@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] sched,idle: Clear polling before descheduling the
 idle thread
Message-ID: <20140604075324.GI30445@twins.programming.kicks-ass.net>
References: <cover.1401841482.git.luto@amacapital.net>
 <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kx4ftX6R+7MpDimS"
Content-Disposition: inline
In-Reply-To: <ad9dcf321a5b74e72a1b63a0d59c8ddc68509c0f.1401841482.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kx4ftX6R+7MpDimS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 05:29:50PM -0700, Andy Lutomirski wrote:
> @@ -229,6 +234,8 @@ static void cpu_idle_loop(void)
>  		 */
>  		preempt_set_need_resched();
>  		tick_nohz_idle_exit();
> +		__current_clr_polling();
> +		smp_mb__after_clear_bit();

barriers always need a comment, and I'm not entirely sure why you put
this one here.

Merging the NR set and POLLING tests into a single atomic made the
entire barrier situation somewhat more complicated and I really need to
rethink that.

>  		schedule_preempt_disabled();
>  	}
>  }
> --=20
> 1.9.3
>=20

--kx4ftX6R+7MpDimS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjtB0AAoJEHZH4aRLwOS6TtwP/0ev62LZNcJn8KMI8kAt0brE
qNDKGCvhk71P9zRmUG335rc0BgvtqEerZFqcKnOwuvLyk8ZQZeCx/+1JEkUulrWS
UTBpvYmzW/iFinQPhr+S8iL371fM/l5/DtdVDLTrSUmFpcvur+23NiWkdmnuoYv6
Dsd+ovJPKF0z07ct/3uIDcBUHAFI5/CqKB5lJCG/HjM3/2oofED5L0qr809fds8m
PN6F+zQ6cmTIVZ6qO0OzjdjBAfcH2JP1guMIwa9Sx6mEG/BIrDFvTe07hgHkN6hl
LvF+3dFfaC0+0yR0PNeyNs98wpdMMwKMt+j3Vj6yEWWWtdX8UymAqUUL5BmdUpdB
6ZHm27yeT1KSX9zNmuMQqEwTcnSTjfkdRzAH+dEnZ7PjCyUHP+I4RPQYn8n2utaC
g/InxBa0yixph0uTthOk5Ja4OpU+d0k2NCYLa7kvEB54MRdB9H3HCU6p2YzK8Sp/
PGmQuPO9GiN/Yq9l3yXxldJhjaglIiZtWeB2XOLOx+nnkc9Q3sV3WC1rgzUYwx90
1Ua5F1vfvf5hXAb9TTLFhjw16C91pgDER3Cx9DjikSvllRQQk7Adz7xhxIlbmB8X
8GYrGxIASANLv67rEJyjdy1CHD+hDRhD/QqRZ0HSFtFummLaWWcBdRCWfYHcibx3
Wb/QNtvSKXRArL10pylN
=9L8V
-----END PGP SIGNATURE-----

--kx4ftX6R+7MpDimS--
