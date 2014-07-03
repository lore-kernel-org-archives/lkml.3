Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180AbaGCI5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:57:10 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:6223 "EHLO smtp4.mundo-r.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750817AbaGCI5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:57:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiwFAPoZtVNbdWOb/2dsb2JhbABagw2EG8MuAYEKFnWEAwEBBSMEQBIQCxgqAgJXBhOIRgGsDpwAFxiPCgeCd4FMBaY3iECDRQ
X-IPAS-Result: AiwFAPoZtVNbdWOb/2dsb2JhbABagw2EG8MuAYEKFnWEAwEBBSMEQBIQCxgqAgJXBhOIRgGsDpwAFxiPCgeCd4FMBaY3iECDRQ
X-IronPort-AV: E=Sophos;i="5.01,594,1400018400"; 
   d="asc'?scan'208";a="244054737"
Message-ID: <1404377815.4537.20.camel@fourier>
Subject: Re: [PATCH] ipoctal: request_irq after configuration
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Federico Vaga <federico.vaga@cern.ch>
Cc: Jens Taprogge <jens.taprogge@taprogge.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        industrypack-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Thu, 03 Jul 2014 10:56:55 +0200
In-Reply-To: <1404377638-23387-1-git-send-email-federico.vaga@cern.ch>
References: <1404377638-23387-1-git-send-email-federico.vaga@cern.ch>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-kgFNvYx84FXD0ZGgxilM"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kgFNvYx84FXD0ZGgxilM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-07-03 at 10:53 +0200, Federico Vaga wrote:
> The request for an IRQ handler must be done after whole configuration. Th=
is
> was not the case for this driver which request the IRQ in the middle of
> the configuration. Sometimes, it happens that something is not completely
> configured, we recieve an interrupt thus we stumble into troubles in the
> IRQ handler.
>=20
> Signed-off-by: Federico Vaga <federico.vaga@cern.ch>
> ---
>  drivers/ipack/devices/ipoctal.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoc=
tal.c
> index a7ec6f9..72fd761 100644
> --- a/drivers/ipack/devices/ipoctal.c
> +++ b/drivers/ipack/devices/ipoctal.c
> @@ -344,13 +344,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal=
, unsigned int bus_nr,
>  			 &block_regs[i].w.imr);
>  	}
> =20
> -	/*
> -	 * IP-OCTAL has different addresses to copy its IRQ vector.
> -	 * Depending of the carrier these addresses are accesible or not.
> -	 * More info in the datasheet.
> -	 */
> -	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
> -				       ipoctal_irq_handler, ipoctal);
>  	/* Dummy write */
>  	iowrite8(1, ipoctal->mem8_space + 1);
> =20
> @@ -411,6 +404,14 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal=
, unsigned int bus_nr,
>  		dev_set_drvdata(tty_dev, channel);
>  	}
> =20
> +	/*
> +	 * IP-OCTAL has different addresses to copy its IRQ vector.
> +	 * Depending of the carrier these addresses are accesible or not.
> +	 * More info in the datasheet.
> +	 */
> +	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
> +				       ipoctal_irq_handler, ipoctal);
> +
>  	return 0;
>  }
> =20

Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>

Greg, Would you mind picking this patch through your driver-core tree?
Together with "ipoctal: protect only the real critical section" patch.

Thanks,

Sam

--=-kgFNvYx84FXD0ZGgxilM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJTtRrXAAoJEH/0ujLxfcND37gP/14fU8XpJU1Mqrk83/bKRzkP
0oH5byv++z2P81Y2hTtWJmX6lUQ+5YdNeZtwCY5lZnliAKaADh2c7DhxNPf3/AWD
bQ6DBvmQQRmN4+jIcfZ6T5W3TpiCFXFsG472qGx6JeKANUHU4TG3YbJIQVAQ8o28
ROWbvB/xa4qSBENV6EEjFCJJ8XrUAldJdUyvYlX2UGWFgMP5DWgBOUpHEkvuy0Ef
5gH9QAv44wwlb0DVXqQod1MLvI4dn8fT67DhKjdc2J+aVLagzbnPk/2yXatPwCHX
mlxev7Z3EGIsGCjMceQL9vA6TRx3SzVdkLLx3O6xpL86pxoO87HnuYT2Pmpk+/4K
C8PtX683IdOvThLAX153Cq87rKoRAhJ4WtP0cXfsAZSJbrZQOhvW64pk7jgD8KgB
RZ9PZc9tCJ0Hq48kIu+AVE0u0VSfMtig3Bbk06TsHKD7hYiQFug8ti+Zi6fmUGkY
W1u3TUpQ2Qt3JGPpxuLgAv3RqAW9yJw5VoqiosTp8GYZZn8cQvA8iU6a4wYvKZAg
UZ7SauBJ/+1FaERuX6l74YWTeFFp+Rni9U2qXzeYoLMKhCAux2liKIaJd9EyGOXH
KRdBe1rYUZ3TiS2TyC8gO3/eq6iP5tnFpTtSiXKNj2VhrUzTnZezGq3go6Dp45Tg
9V4oI0zAopvFj8g8ORrz
=LCPp
-----END PGP SIGNATURE-----

--=-kgFNvYx84FXD0ZGgxilM--

