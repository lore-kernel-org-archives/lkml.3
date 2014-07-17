Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933594AbaGQOzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 10:55:12 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57740 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932865AbaGQOzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 10:55:10 -0400
Date: Thu, 17 Jul 2014 09:54:30 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 5/5] tty: serial: Add 8250-core based omap driver
Message-ID: <20140717145430.GF10459@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405521903-5877-1-git-send-email-bigeasy@linutronix.de>
 <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <1405521903-5877-6-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jul 16, 2014 at 04:45:03PM +0200, Sebastian Andrzej Siewior wrote:
> +static int omap_8250_startup(struct uart_port *port)
> +{
> +	struct uart_8250_port *up =3D
> +		container_of(port, struct uart_8250_port, port);
> +	struct omap8250_priv *priv =3D port->private_data;
> +
> +	int ret;
> +
> +	if (priv->wakeirq) {
> +		ret =3D request_irq(priv->wakeirq, omap_wake_irq,
> +				port->irqflags, "wakeup irq", port);
> +		if (ret)
> +			return ret;
> +		disable_irq(priv->wakeirq);
> +	}
> +
> +	ret =3D serial8250_do_startup(port);
> +	if (ret)
> +		goto err;
> +
> +	pm_runtime_get_sync(port->dev);

should this pm_runtime_get_sync() be placed above
serial8250_do_startup() call ?

--=20
balbi

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTx+OmAAoJEIaOsuA1yqREXvUP/2yCby14pHxqFB5UG35KRJrW
hKSm6gOymTnc/6Mj5CLs0/gSLqbwUfa4DaHAlAFfVLqVtHc5LTgxvkYqwMSs0xyM
RFSt3jDAYerQmX/DR2o6NQc2HdKZ2atlHxvTi8Eh5FMvymBaXp0o+9KamZ/HKDv3
XBMTZFpiq/gXdY5Bxv4CWe3tqymb8TKXHI1Qwo9bN7dcEt/sATIf3YGAEllJ+NTU
/kzMs/n87ToxvPSnSnC23iBrfMjZH8tHRs/xVKQuBIJdl5neyrtm8opOCdchbx3H
xpkfI1ppEnIjv82WwvbpIwFdrSlxJrPQ/TVcWKVLkpTfcyB0fFOFCabdyFK+gKzX
04/geMGV3CQO0wJbJAkX+zvPi5aSyisea+q8gMitiJpcHwjr/B/aVXab1G5xUuos
MfKt+B7CuA+4WXJ4glar643FVvLCbOoTYdn0cqLhdGMo1mzYnZWI+iP0ay7F3sHR
Lb/mx2KddwwuSRciZysH+n5fSTGKxO1X+SqHWV4okGLAasDCJu3rizTqKDd8cMpQ
BYaYFHSjmEWGPzvtgU0/cLrN51QsilD5eFZs4MnzfR8HnnQYd9UHFidj36gA9lP2
MUsGUzvOJ4uTqygV0PQraUyqFg9lY4TxqZiZ+0kFiitKcH2FXoHnGfdc5CMmHkpl
wLW3LMhzmZvFrMgPnK8c
=l83T
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
