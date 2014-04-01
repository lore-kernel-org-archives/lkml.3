Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaDAWt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 18:49:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56700 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaDAWt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 18:49:26 -0400
Date: Tue, 1 Apr 2014 17:46:54 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: <r.sricharan@ti.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, Darren Etheridge <detheridge@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] irq: crossbar: improve allocate_free_irq() complexity
Message-ID: <20140401224654.GA23786@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396392259-27437-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <1396392259-27437-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2014 at 05:44:19PM -0500, Felipe Balbi wrote:
> current algorithm in allocate_free_irq() is O(n),
> by just keeping track of last allocated IRQ with a
> simple unsigned integer, we can find a free IRQ
> in O(1).
>=20
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>=20
> compile-tested only as J6 DTS is currently missing crossbar
> altogether :-(
>=20
> There's a drawback with this patch which I'm not sure if we
> should care a lot because I couldn't entirely grasp when is
> domain->xlate() called and if we will map/unmap IRQs in runtime
> or will this *always* be done only during boot.
>=20
> If we're talking about runtime IRQ remapping, then this, clearly,
> won't work. But if this will be done only during boot up, then we
> avoid iterating over the irq_map array each time we try to translate
> a new IRQ prior to mapping it.
>=20
> Comments are highly welcome as I'll probably learn something new
> about the IRQ subsystem ;-)
>=20
>  drivers/irqchip/irq-crossbar.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/drivers/irqchip/irq-crossbar.c b/drivers/irqchip/irq-crossba=
r.c
> index fc817d2..1c4da5a 100644
> --- a/drivers/irqchip/irq-crossbar.c
> +++ b/drivers/irqchip/irq-crossbar.c
> @@ -31,6 +31,7 @@ struct crossbar_device {
>  	void __iomem *crossbar_base;
>  	int *register_offsets;
>  	void (*write) (int, int);
> +	unsigned int current_irq;
>  };
> =20
>  static struct crossbar_device *cb;
> @@ -52,16 +53,15 @@ static inline void crossbar_writeb(int irq_no, int cb=
_no)
> =20
>  static inline int allocate_free_irq(int cb_no)
>  {
> -	int i;
> +	int current_irq;
> =20
> -	for (i =3D 0; i < cb->int_max; i++) {
> -		if (cb->irq_map[i] =3D=3D IRQ_FREE) {
> -			cb->irq_map[i] =3D cb_no;
> -			return i;
> -		}
> -	}
> +	if (cb->current_irq =3D=3D cb->int_max)
> +		return -ENODEV;
> +
> +	current_irq =3D cb->current_irq++;
> +	cb->irq_map[current_irq++] =3D cb_no;

this increment is bogus, thought I had committed already, please ignore.

--=20
balbi

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTO0HeAAoJEIaOsuA1yqREkUsP/RfrAURpcHy8fYrJF1yDB/Sc
IYt8C4admWWOdanDWh/3t7Xud5iV0fOFo//n/juAS7AfnoBJ8jY1X0ucAOny+Yts
6JV74YfW4KBMNqpSwqxD4nN2/sxqBcDxjESw8eeOU03m2ayERKqXU7N/Nd++UUJA
Tz5n2KVE4ibXoVT/CsNCGnSp9yJpFaOpRGfJ05WLedo3f7GP6b+j35GITz+s8FoY
/+CAqjrojG9RTGhKJGXoADK+vtOr8l5PZ7uGG48Q7BeIa5+bQMwiITORUsqUpE14
rQtz2G+VLLsENjdhfWYNsImpHc73mlvtgtoAisRgv+diK0gWAvFiRJuO/BLVfKpN
5nfQxDZ4k/WqS7pYIBtGwCbegz2F38LaLkd3tQqgAfRYljupg9bhvZR8zJ/ow+G7
zvPFvLV/76nowhU+Zda9H14hlOHPuhzIVl3a68M++EqdIQRDzKnSlIcRcPsMW78C
armu8C1oRrCWxb/4BXB2cXmb9iWDepi4QGfeMI3c8mVOnde/YlBDC5JjvOBveBts
GdTv9uEFuFktkotu5JNbjZf4Ben5jUsqWn1nT91YlsMka7uFT785722yTFc+smiT
r9NEh7BEUWtDsZ7VNxtqQqsOtiwPZHJu71QNu7Mflb1IC0SulmgsXfn9p5JLILGp
A1eoaGkmA7NigoczHJBn
=l4UO
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
