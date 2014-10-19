Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751511AbaJSJGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 05:06:30 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36435 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaJSJG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 05:06:27 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: akinobu.mita@gmail.com
Subject: Re: [PATCH 1/2] ratelimit: add initialization macro
In-Reply-To: <1408539282-5699-1-git-send-email-dmonakhov@openvz.org>
References: <1408539282-5699-1-git-send-email-dmonakhov@openvz.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Sun, 19 Oct 2014 13:06:17 +0400
Message-ID: <87ppdoctti.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dmitry Monakhov <dmonakhov@openvz.org> writes:

Ping.
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
> ---
>  include/linux/ratelimit.h |   12 +++++++++---
>  1 files changed, 9 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ratelimit.h b/include/linux/ratelimit.h
> index 0a260d8..1810252 100644
> --- a/include/linux/ratelimit.h
> +++ b/include/linux/ratelimit.h
> @@ -17,14 +17,20 @@ struct ratelimit_state {
>  	unsigned long	begin;
>  };
>=20=20
> -#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
> -									\
> -	struct ratelimit_state name =3D {					\
> +#define RATELIMIT_STATE_INIT(name, interval_init, burst_init) {		\
>  		.lock		=3D __RAW_SPIN_LOCK_UNLOCKED(name.lock),	\
>  		.interval	=3D interval_init,			\
>  		.burst		=3D burst_init,				\
>  	}
>=20=20
> +#define RATELIMIT_STATE_INIT_DISABLED					\
> +	RATELIMIT_STATE_INIT(ratelimit_state, 0, DEFAULT_RATELIMIT_BURST)
> +
> +#define DEFINE_RATELIMIT_STATE(name, interval_init, burst_init)		\
> +									\
> +	struct ratelimit_state name =3D					\
> +		RATELIMIT_STATE_INIT(name, interval_init, burst_init)	\
> +
>  static inline void ratelimit_state_init(struct ratelimit_state *rs,
>  					int interval, int burst)
>  {
> --=20
> 1.7.1

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUQ38JAAoJEFzOBSYIXfveI+4P/3/gT64llQlcacpwP3pVMmTq
C3sgMaef9WrpiqJfyDny5twqpolL9qF9CAFPsmYTAd8uaOzTU0oaAXwk+L1P3LkQ
hw90l7Ew+WhemKOBMitqHYGqz0wosbsHmDJ9MnN9YM8+oX5/TE6YgQopyleyHx+F
eIOgKTY2xIc+01JFFTViwA6Vaclz6tk808wJ+cStQesx9ZG3L2u0Fd9PSZdiKgNV
erePul1X8HDbtXjY+TP/2JSlh42aLvnL9JHZeFOOf49Y4OHXUUWemeBA6rsg9ToA
rBcVPDzqIh+xu05TT5JPVg2Zw8hUPzMfWgI3zUt+dqKGPdePWlSsJLy7/QoG5K66
u9kgHgpMJufuhxoxW+tFsikNkk8L4XzeBDOPn+HrK2kvwU5Tx6+HsiW1mxq7doPM
xOr72bBWU14OJEZIY9t8EqPTBq/urb+cBj0oDN10MrpU+jeiPmOF91b/YTd17fMm
mo9hy+ph7wutpcJi3lo1OYS+gkGQqlg3/vezxGBbCQC7a7RRA1qeYDe1DIqTcwBE
MZghob2FGPRMbSa33UvrAmmCH09k16DRi+qIjyyIzSMgl6AU/l+rhfMbwmnXSaGH
1BVsO7zdtO6hK2vjQBKZ5t/8skq13mayQ5Gty/oAlMLRBYf08YsF2j+nBoJdhFPc
+qbGIcC462Li+wlzqabd
=dfRu
-----END PGP SIGNATURE-----
--=-=-=--
