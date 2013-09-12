Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab3ILUzq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:55:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51027 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755097Ab3ILUzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:55:44 -0400
Date: Thu, 12 Sep 2013 15:54:17 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tglx@linutronix.de>,
        <linus.walleij@linaro.org>, <santosh.shilimkar@ti.com>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>
Subject: Re: [RFC PATCH 1/4] DRIVERS: IRQCHIP: Add crossbar irqchip driver
Message-ID: <20130912205417.GA539@radagast>
Reply-To: <balbi@ti.com>
References: <1379000351-15672-1-git-send-email-r.sricharan@ti.com>
 <1379000351-15672-2-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <1379000351-15672-2-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 12, 2013 at 09:09:08PM +0530, Sricharan R wrote:
> +unsigned int crossbar_request_irq(struct irq_data *d)
> +{
> +	int cb_no =3D d->hwirq;
> +	int virq =3D allocate_free_irq(cb_no);
> +	void *irq =3D &cb->crossbar_map[cb_no].hwirq;
> +	int err;
> +
> +	err =3D request_threaded_irq(virq, crossbar_irq, NULL,
> +				   0, "CROSSBAR", irq);

this is wrong, why don't you just set crossbar up as a chained handler.

--=20
balbi

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSMin5AAoJEIaOsuA1yqREyu4QAJaLVz5bSl+9ISffvD+MIs8I
4sShRAtoc/cf39VZnSUkBMB53dOvG3XJotim3X6tQ0iIkMkC2ZI4M7anhNQ2f0xd
oBVQA4QnydnSwJZS64W9e1cqEd76a8ofiec2k53Lfb+VCMpRYeMK5s3p2Rb0axMH
5KrPjmkFv0TGAPW9XpFWoM4EQPNTslQVxzmWE0vqrpgIFmThXa/wZCWN8S7U0td1
0qkwa8Xly7/Fy/hBWyc0YHuuB9fESE2BRegBao7tBsgA8faNmpowVKNsYkVy7FYi
BF9lkg77engKl5C3IE9MxEHuHJ0sdn9LBDRRbMB42iiGGMExysQ2SjpBefkCEq//
mLOBv09eR4WOjFN7i/kFS3YQSoCk8h7G6uq48+5E5CWCULWD+EJ7A0UUpAtjroQS
jVKKHkjI6NazE70GLA70C+jCHuvWc8cdTyT2baXBd5IDotE2LqSVlaAhNlkH9Abm
BmRMMH3NaQNiwSeyxgbUTLxNgXZ/NRqqn3BVWMAFlNGrWtwQkqTDB4ZtIVaSAhb5
Fh/iUelsKirr6YpN4yD4x+RfV7tVbFKpudNKRLw8UA37pZGheJPORPz7ddJ9Hpa+
8uC/+3ZqW5EXUbYQxUAETxaXr5rO3Vt8G/ZMgzdLWjqY291AXVsoEXr9AKOA/kLM
SvOokjAH/DhKQo2rTPeC
=sD/o
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
