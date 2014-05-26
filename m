Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542AbaEZAhY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 20:37:24 -0400
Received: from ozlabs.org ([103.22.144.67]:60883 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbaEZAhX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 20:37:23 -0400
Date: Mon, 26 May 2014 10:37:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Heiko Stuebner <heiko@sntech.de>
Subject: Re: linux-next: manual merge of the samsung tree with the arm-soc
 tree
Message-ID: <20140526103715.09c491e3@canb.auug.org.au>
In-Reply-To: <20140526101741.102768b2@canb.auug.org.au>
References: <20140526101741.102768b2@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/oSKioG343S1swRJNdYJH.PM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/oSKioG343S1swRJNdYJH.PM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 26 May 2014 10:17:41 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the samsung tree got a conflict in
> arch/arm/Kconfig.debug between commit 7098cff2a3f4 ("ARM: debug: qcom:
> make UART address selection configuration option") from the arm-soc
> tree and commit 1899de289497 ("ARM: S3C24XX: use generic
> DEBUG_UART_PHY/_VIRT in debug macro") from the samsung tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).
>=20
> --=20
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>=20
> diff --cc arch/arm/Kconfig.debug
> index 6ff3dc661fdd,4678870f8ee8..000000000000
> --- a/arch/arm/Kconfig.debug
> +++ b/arch/arm/Kconfig.debug
> @@@ -966,10 -1007,10 +1003,11 @@@ config DEBUG_LL_INCLUD
>   				 DEBUG_IMX51_UART || \
>   				 DEBUG_IMX53_UART ||\
>   				 DEBUG_IMX6Q_UART || \
>  -				 DEBUG_IMX6SL_UART
>  -	default "debug/msm.S" if DEBUG_MSM_UART
>  +				 DEBUG_IMX6SL_UART || \
>  +				 DEBUG_IMX6SX_UART
>  +	default "debug/msm.S" if DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
>   	default "debug/omap2plus.S" if DEBUG_OMAP2PLUS_UART
> + 	default "debug/s3c24xx.S" if DEBUG_S3C24XX_UART
>   	default "debug/sirf.S" if DEBUG_SIRFPRIMA2_UART1 || DEBUG_SIRFMARCO_UA=
RT1
>   	default "debug/sti.S" if DEBUG_STI_UART
>   	default "debug/tegra.S" if DEBUG_TEGRA_UART
> @@@ -1057,8 -1102,7 +1101,8 @@@ config DEBUG_UART_PHY
>   	default 0xfffff700 if ARCH_IOP33X
>   	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
>   		DEBUG_LL_UART_EFM32 || \
> - 		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
>  -		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART
> ++		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART \

I forgot the || at the end, sorry.  I fixed this up.

>  +		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
>  =20
>   config DEBUG_UART_VIRT
>   	hex "Virtual base address of debug UART"
> @@@ -1118,8 -1166,7 +1168,8 @@@
>   	default 0xff003000 if DEBUG_U300_UART
>   	default DEBUG_UART_PHYS if !MMU
>   	depends on DEBUG_LL_UART_8250 || DEBUG_LL_UART_PL01X || \
> - 		DEBUG_UART_8250 || DEBUG_UART_PL01X || \
>  -		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART
> ++		DEBUG_UART_8250 || DEBUG_UART_PL01X || DEBUG_S3C24XX_UART \

Same here.

>  +		DEBUG_MSM_UART || DEBUG_QCOM_UARTDM
>  =20
>   config DEBUG_UART_8250_SHIFT
>   	int "Register offset shift for the 8250 debug UART"

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/oSKioG343S1swRJNdYJH.PM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTgoy/AAoJEMDTa8Ir7ZwV9NkQAIU3Gjxdq47feyJ3OM3ZmaCA
bdUFsh7dI7GtibvWjx83s2U19Rqc9xArwe/BxmRG6aLUGKQ1V6zS89QtHmQZwHB2
JMrttw2yXobIeMZYkQzgt9o/rTjuu8ol12looXKb/GTfz93gKLLOOqo7APzW9OCp
t3pCKTqNfdbAoKfSQzn1T0kHo1ZLFF9xbn3LDRmhHrdAhCp3ZDdqg3ITvhLZPg/o
B3/ZlKIF6C71DfzDB9RIsQu66a3QbgfJzhc9/bGvZg7iml3p2FQoNn5L3qTJyj6+
mwRWm9UDNz0Wq4IyLxr0tlh+XDM3jz8gNCC0W1Uy+I6L0PQMXmW2HICk/xGTw1aA
Q5hy8/s5Z0Z7xU10HPk6ad/GLT0bVpy+amrz0/Gcb62BdLZK09b/M1wljQyrbc0q
OTbzkAXKiAmhtlgBKs4+uE0JdU6V+R6cX5pkrdXRfi/+07c2lEYT/YvnrlRGpJE7
1ZzcBordqB8tlE8WS5QEirzDhe/VDk0k4prOH5P91/s7kbCPTJVa2terEgcImN+c
ldd3R1AdIQD1n8IxHY4tX4Z9VsmhUDoTWfLSQLDMUmAybqBXN9YmR4qKyd9uAoxY
cBIbSQ63feZ9gvkvCf4XFFlEsPKA4QY7867mrGP2VW9x6fmfCfGmxxfgRmdzoux2
NMY3zuuh+Je9k80Q1M3a
=TlXW
-----END PGP SIGNATURE-----

--Sig_/oSKioG343S1swRJNdYJH.PM--
