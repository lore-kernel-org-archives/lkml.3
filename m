Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932602Ab3GKQN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:13:57 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:46302 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932183Ab3GKQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:13:56 -0400
Date: Thu, 11 Jul 2013 18:13:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT] irqchip: sun4i: Remove wrong irq_ack callback
 implementation
Message-ID: <20130711161353.GV11243@lukather>
References: <1373121329.13289.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BuBclajtnfx5hylj"
Content-Disposition: inline
In-Reply-To: <1373121329.13289.2.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BuBclajtnfx5hylj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Axel,

On Sat, Jul 06, 2013 at 10:35:29PM +0800, Axel Lin wrote:
> According to the datasheet[1], the Interrupt IRQ Pending Registers are
> read-only. The implementation of sun4i_irq_ack() looks wrong because it w=
rites
> to these read-only registers.

Right, but the datasheet also says that these registers are "clear"
register, which might indicate that it's actually R/W.

I actually used one of the code dump from Allwinner for this driver, so
I'm not exactly sure about wether irq_ack is needed or not.

I'll test this and let you know.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--BuBclajtnfx5hylj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR3tnBAAoJEBx+YmzsjxAgKh0P/3sosYL++aInoaU77DhU1lbq
W1AvKsmejYo7cLLygdMXACGYaPAoYVndxgjAwJS0ybThsds7A/COsi2oVMyp+hhr
laeg492F3M9uL1/NM1t3A6dG5dLN9hijvESDwhldR8TwGKL0a2xx9yj3OKjh2vsJ
tfwTWyFcpW+fyKnSdDm+JM0CgP5fKFllo9y9tIMkV0RaT+iqoPmLqtJQuR0UCVCd
WfnqgNXv60uSBIH7xByGTrGymRKEVyMaH8JGYBaO++7D+kJ6UkRhV4N7n9dlv1fP
TYiSUgvh+UeTe7rJYJJrcaXAku7t4dEKrac4TaigZW00RxjfBNuI4p72NXms3BNh
c6h93pfoprVcNu695eR52w9wwgPV/oHB1jnvJ1GzW2UH0WNtwXG98X3oJSw6dFdZ
HlJvEyNpMGUOXSeEZeMOx79aE/ga6f+iqB0tMrTE0JUFF5CJ/OKMycuFctCjev67
xIzZ9KBhtGofrt2cmspK1UvLiSeWaLFViKBIvrkM8Vq1PaR3i/LloRbpUzq1VekF
3RjXVKJzzVbxQKLiaWv/g3PPD9KCDhMGujdaQUatNYbk7udY7awVOZipQRoCoB8l
67wfcv9itJmWbsRRrfe/6SS2lhmcmOmqhIRik5oV7la1hXfsd6rwjBi0EkaWldlf
R+D4Mjuok0iHYIY5kW6p
=mVTg
-----END PGP SIGNATURE-----

--BuBclajtnfx5hylj--
