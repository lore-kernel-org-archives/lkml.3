Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219AbaHON7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 09:59:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48651 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbaHON7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 09:59:19 -0400
Date: Fri, 15 Aug 2014 15:58:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        George Spelvin <linux@horizon.com>,
        David Howells <dhowells@redhat.com>,
        AKASHI Takahiro <takahiro.akashi@linaro.org>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] GCD: add binary GCD algorithm
Message-ID: <20140815135855.GG19379@twins.programming.kicks-ass.net>
References: <1408106956-12986-1-git-send-email-zhaoxiu.zeng@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mrH/dmIXFaN9gE1e"
Content-Disposition: inline
In-Reply-To: <1408106956-12986-1-git-send-email-zhaoxiu.zeng@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mrH/dmIXFaN9gE1e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2014 at 08:49:16PM +0800, Zhaoxiu Zeng wrote:
> Because some architectures (alpha, armv6, etc.) don't provide hardware di=
vision,
> the mod operation is slow! Binary GCD algorithm uses simple arithmetic op=
erations,
> it replaces division with arithmetic shifts, comparisons, and subtraction.
>=20
> Signed-off-by: Zhaoxiu Zeng <zhaoxiu.zeng@gmail.com>
> ---
>  lib/Kconfig | 15 +++++++++++++++
>  lib/gcd.c   | 31 ++++++++++++++++++++++++++++++-
>  2 files changed, 45 insertions(+), 1 deletion(-)
>=20
> diff --git a/lib/Kconfig b/lib/Kconfig
> index a5ce0c7..80e8e54 100644
> --- a/lib/Kconfig
> +++ b/lib/Kconfig
> @@ -177,6 +177,21 @@ config CRC8
>  	  when they need to do cyclic redundancy check according CRC8
>  	  algorithm. Module will be called crc8.
> =20
> +#
> +# GCD
> +#
> +choice
> +	prompt "GCD implementation"
> +	default GCD_ALGO_EUCLIDEAN
> +
> +config GCD_ALGO_EUCLIDEAN
> +	bool "Euclidean algorithm"
> +
> +config GCD_ALGO_BINARY
> +	bool "Binary GCD algorithm (Stein's algorithm)"
> +
> +endchoice

Does this result in the user being asked which GCD algo he wants? If so,
I think that's bad.


> +#else
> +	r =3D a | b;
> +
> +	if (!a || !b)
> +		return r;
> +
> +	r =3D r ^ (r - 1);
> +	if (!(a & r))
> +		goto even_odd; /* a/c even, b/c odd */
> +	if (!(b & r))
> +		goto odd_even; /* a/c odd, b/c even */
> +
> +	/* a/c and b/c both odd */
> +	while (a !=3D b) {
> +		if (a > b) {
> +			a -=3D b;
> +even_odd:
> +			do
> +				a >>=3D 1;
> +			while (!(a & r));
> +		} else {
> +			b -=3D a;
> +odd_even:
> +			do
> +				b >>=3D 1;
> +			while (!(b & r));
> +		}
> +	}
> +#endif
>  	return b;
>  }

So I looked at wikipedia (I wasn't aware of this algorithm, clever
though), and am still somewhat puzzled by your 'r'.

What's 'wrong' with their iterative version, or what's better about your
'r' stuff?

--mrH/dmIXFaN9gE1e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT7hIZAAoJEHZH4aRLwOS6xDcP/0XVBEYuhjcS9qlIWCEa3wAB
etX1E+YOocWTXIWVyMWF7609I+ZGz1gu2ZFiis3adLfbLESlUbI4HsYLne1qcawI
yuYYJ6RMN4IC968GB519Up8r567u4yGzWgI6szY590aDa09vf+VuhaH+mEkOEvaa
zwMrNw6w0BWrKo/GsLh0R6XNroagsrPuHJQx8Db/gMLeLNK2B3zfWKLSl3YjzUm+
gwyxKqiWdl11dxlDR7KjBCvzWDw3brciGTuGBs0Zjx5nPY3VgR7D3+WzoDoQjjYd
CKJ9Iwopfe+iY4YAS0Z3rUM60R1yHr5XkAHWOmBuaWBUrr10qa3NN0252aNMl1dh
cn4gqBV3Y09MyveuyKd4FN7x94EIgdXhZUSS9PT8RB1x5nsx2PtQgRJG4AILuBhQ
kiR62BoKMrNfIbjKcqNHEDnkk0dMsqz0cvIAoL1651aL8cMA6/sc9VMTNkmRFcrS
u25bOzcpBXC1vHyeG4+URRfAeExK/TWp9PX7FOk/1eVganiw4NWVl738cYQwEB8N
qNMPVAuUm/pNXT7ZV0f9m0fxB/9Qw9e9b41fH2CVfGvw2U6HFL7PtnSzd82IJ4r5
8wJ653DOLuosoKcWs+wWXkzP1v3gtQIgXHnuMgT5Hm/dRtKdf6fuNqskfJHPjGm6
coENGHOQpPLZcfyfFSZ3
=/lwb
-----END PGP SIGNATURE-----

--mrH/dmIXFaN9gE1e--
