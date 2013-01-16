Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644Ab3APRB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:01:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36919 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab3APRBy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:01:54 -0500
Date: Wed, 16 Jan 2013 19:01:22 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@linux.intel.com>
CC: <arve@android.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mikechan@google.com>
Subject: Re: [PATCH 03/10] goldfish: tty driver
Message-ID: <20130116170122.GB6377@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
 <20130116165902.15183.60134.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20130116165902.15183.60134.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 16, 2013 at 04:59:03PM +0000, Alan Cox wrote:
> +static int goldfish_tty_probe(struct platform_device *pdev)
> +{
> +	struct goldfish_tty *qtty;
> +	int ret =3D -EINVAL;
> +	int i;
> +	struct resource *r;
> +	struct device *ttydev;
> +	void __iomem *base;
> +	u32 irq;
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if(r =3D=3D NULL)
> +		return -EINVAL;
> +
> +	base =3D ioremap(r->start, 0x1000);

missing request_mem_region(), in fact you could just use
devm_request_and_ioremap().

> +	if (base =3D=3D NULL)
> +		pr_err("goldfish_tty: unable to remap base\n");
> +
> +	r =3D platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	if(r =3D=3D NULL)
> +		goto err_unmap;
> +
> +	irq =3D r->start;
> +
> +	if(pdev->id >=3D goldfish_tty_line_count)
> +		goto err_unmap;
> +
> +	mutex_lock(&goldfish_tty_lock);
> +	if(goldfish_tty_current_line_count =3D=3D 0) {
> +		ret =3D goldfish_tty_create_driver();
> +		if(ret)
> +			goto err_create_driver_failed;
> +	}
> +	goldfish_tty_current_line_count++;
> +
> +	qtty =3D &goldfish_ttys[pdev->id];
> +	spin_lock_init(&qtty->lock);
> +	tty_port_init(&qtty->port);
> +	qtty->port.ops =3D &goldfish_port_ops;
> +	qtty->base =3D base;
> +	qtty->irq =3D irq;
> +
> +	writel(GOLDFISH_TTY_CMD_INT_DISABLE, base + GOLDFISH_TTY_CMD);
> +
> +	ret =3D request_irq(irq, goldfish_tty_interrupt, IRQF_SHARED, "goldfish=
_tty", pdev);

this is way over 80-chars, also could use some devm_request_irq().

> +	ttydev =3D tty_port_register_device(&qtty->port, goldfish_tty_driver, p=
dev->id, &pdev->dev);

over 80-chars.

> +MODULE_LICENSE("GPL");

the comment header in this file says it's GPL v2, so this should be:

MODULE_LICENSE("GPL v2");

--=20
balbi

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9tziAAoJEIaOsuA1yqREdAIP/RXnv/78JPwjvVlcJ6JOzvzm
956GSAjZchTkuPI2BLclguCylh+nexBv2h9t3pC8q4ANbzG0TFHyTfzvizvtcdPB
+Otq30w/P+j9DyMfETON0LK4tKBTYp2o++jpWpV1tYFve1QjrwTyL33tukx5GEH8
bfCUlzvZvIj7TlT5nizS4hUnr97X0xVc0iitwbIxqOyi/4ucIIfmr3E3s0u/M63y
j6wOV09FxQkuMAdvyF1nTAKiyKnE6kBUZPZfg8N3H/5hhmxNXehl/0mGw8kNZzqH
B51fmI3fkUuj0BXrqgxVpc5tLaUD4HfHZxYpoJ6FcXMtNWmfcqsAdSluf4VHF3ya
UiAf64P9RtGAerfyrDWPmb7EeQ9MVWFqfOMVfwkO5P+LiMwT4oPOvZIATCRN802k
wKcI4MO7OnobiwdhJNpaOCAp8ltVC8KBudlJInh0U6RI3Hrk6CPHBoyoY/hcECW5
F5hMEYGo+5rORZF+Ijn6xD4x4ZnlPgYNkfUx7Y9mSeK5MlEaxuoaQ1AClJUbR/T5
PG9yk43Bye+QBgsxyTWrsx300yDRkFGf5FjKQDMMtf++FUWWUqEJKxLGi3+JZjJC
ydMNB828ewV7xa9vr1PPspdHQb0mY58esy1sWy023I3U4pFqUYVsApKnSpTz5qYW
hyVKTx9KJZ/qF8vgESfo
=D0N2
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
