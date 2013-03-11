Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3CKMH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 08:07:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33899 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab3CKMH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 08:07:56 -0400
Date: Mon, 11 Mar 2013 23:07:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Hogan <james.hogan@imgtec.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-next@vger.kernel.org
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
Message-Id: <20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au>
In-Reply-To: <874ngiwije.fsf@rustcorp.com.au>
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com>
	<87sj46wyf2.fsf@rustcorp.com.au>
	<5139AC39.90805@imgtec.com>
	<874ngiwije.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__11_Mar_2013_23_07_31_+1100_62uS2jEz/+EPJKnD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Mar_2013_23_07_31_+1100_62uS2jEz/+EPJKnD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Mon, 11 Mar 2013 17:05:17 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index 600494c..cd0f7c7 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -1,6 +1,5 @@
> -config SYMBOL_PREFIX
> -	string
> -	default "_"
> +config SYMBOL_PREFIX_UNDERSCORE
> +	def_bool y

Please, if you are going to do this, just have

config SYMBOL_PREFIX_UNDERSCORE
	bool

in one Kconfig file (probably arch/Kconfig) and then select it from the
appropriate architecture Kconfig files.  You could even put a help text
on it to explain why a new architecture may need to select it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__11_Mar_2013_23_07_31_+1100_62uS2jEz/+EPJKnD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRPckDAAoJEECxmPOUX5FEtR4QAJmHg46UQr9blbeK7Iqt4jGC
y0BhJpA7xD6KHvi3Rg7DMcf5OoK99NcYgl7qVt7VTx8NZJhyDOo7kdhSTy/9dBx5
3W1J4njk8Mm0t3WjLQS37NaJ8UL6o5kNzrNFtbWIiZUf2DxzlupDFNjTJsJSE6Kl
TPU8K9HK8udtK/6BcUZN8iZVR80oh5K25ySbFiTi8n2WweeSBBELJzxfLEuuFH2Z
gHkGlzLYzVUvt64huQsz/goo7mPx8iuh0UigHCfF6K3gfhwPKN/4OzlxVVx3nXGu
/fki4STZCR08f9l+YGZuOwTJCzBcovNARhi/Yef34X+XtCk1430R9DFGzUYApRae
Ma3+JCeEaBQPnwc5cPumlhsglTMSeyK9WrQZBuWNc2+5Y+hkyDcmao/zwNGa7xJc
NW0WZTT2ANS4rlrf37twnHfXb8ozrZGSv92db2plbBq2nUNpFBmo/zDUelcutYvD
Ey1mlvQ0ntqQ5KOxSNzbTO9xDaJ0c34mUA6RhauoDc7l8zHqYl+NCO09i8hShYEq
fAhQWapJt3SNYFFH4c6sJwkMVlLbcoZH/tCxfx/oSORrO4oFew8sK2obwDGboETP
JBWU/UBjIiSqxZsCKf1KJaL+xIQ21vTtWtSiQ4KMLo8283YBfC9K0eWf9txN3FBL
udL1sgYLM2cp5C5Poaor
=JI89
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Mar_2013_23_07_31_+1100_62uS2jEz/+EPJKnD--
