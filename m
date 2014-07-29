Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbaG2CU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 22:20:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:55410 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaG2CUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 22:20:25 -0400
Date: Tue, 29 Jul 2014 04:20:20 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, devicetree@vger.kernel.org,
        linux@arm.linux.org.uk, jason@lakedaemon.net,
        khilman@deeprootsystems.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bcousson@baylibre.com, tglx@linutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 13/35] arm: omap: irq: call set_handle_irq() from
 intc_of_init
Message-ID: <20140729022019.GB4421@earth.universe>
References: <1406582183-696-1-git-send-email-balbi@ti.com>
 <1406582183-696-14-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="V0207lvV8h4k8FAm"
Content-Disposition: inline
In-Reply-To: <1406582183-696-14-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V0207lvV8h4k8FAm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 28, 2014 at 04:16:01PM -0500, Felipe Balbi wrote:
> this will let us drop .handle_irq and .init_irq fields
> from our generic machine_descs.
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  arch/arm/mach-omap2/irq.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/arch/arm/mach-omap2/irq.c b/arch/arm/mach-omap2/irq.c
> index e6997c5..e452411 100644
> --- a/arch/arm/mach-omap2/irq.c
> +++ b/arch/arm/mach-omap2/irq.c
> @@ -314,6 +314,8 @@ static int __init intc_of_init(struct device_node *no=
de,
> =20
>  	omap_init_irq(res.start, nr_irq, of_node_get(node));
> =20
> +	set_handle_irq(omap2_intc_handle_irq);
> +
>  	return 0;
>  }
>

if you respin the patchset you may want to call omap_intc_handle_irq
directly. It makes the review of the patchset less confusing.

(I was wondering why omap3 can call omap2_intc_handle_irq until I
noticed, that your previous changes made both functions simple
wrapper functions for omap_intc_handle_irq)

-- Sebastian

--V0207lvV8h4k8FAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJT1wTjAAoJENju1/PIO/qa1OgP/jx26mJVpIDfor+3QG6ER8cI
CI+pDLoC62c6vRnoPJgQfqLD/7yZ1VaeZMJtaUSGmj+DG6JVHJF3QD09JTcvb62f
fI3FTu6Hp+wZ362HIfUyih+liT8fuy9DVP9MirQ4PTVBN6FO9xB/11Owu4n1FhSg
s3JoML3NiNsgbg0J0pHPSXpt24EoyLfzp/7gSe4QxOK//pg1eoUzrSmTsISQGE9U
GojrD6u/7ialr8pbq9f5wxuxsIBaUUcnFioOempWU3M24nwHs0meTIKWhLNSM7CM
s/pSCwlFi7QRds69hAL60au1q+Mb2Dwy9tP8VB70gDpR2IsK5vROmpTiJy9++nzr
EZ9l05fIny5VJ2j6YZ3ZPk1tXvC/wQGr9L9cfP+8pXIi6oY4bcAKhHfHvrBlT84C
siswVV8cKElgjdAprt+igqDVOpWpin7vEqJ7NbU3/YAO2AD/L63VbDYQ+kGByYH8
yjDbecym3ydtcLMVy5unqR+QPAA+yK5235+vz1KAVZ8iTfHmXNxrXNvzoZ3fqwYr
mHhi6vz1yoJhXaFoLFvgVF9vPoRc80y8wZeMMkoXDJyyXopDCsZEyqb2L5MFuqv7
ImPIXGb/Qr7eu9NKGKSwfcrBmas1I2tlS8RuF5dln50dT5f9hmC3viF0WonJb90H
L81vBOMb3bU74joY+a3D
=9sGy
-----END PGP SIGNATURE-----

--V0207lvV8h4k8FAm--
