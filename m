Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab3BSMKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 07:10:47 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37601 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932530Ab3BSMKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 07:10:46 -0500
Date: Tue, 19 Feb 2013 14:10:13 +0200
From: Felipe Balbi <balbi@ti.com>
To: Afzal Mohammed <afzal@ti.com>
CC: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Marc Zyngier <marc.zyngier@arm.com>,
        Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, Sekhar Nori <nsekhar@ti.com>,
        Syed Mohammed Khasim <khasim@ti.com>
Subject: Re: [PATCH, RFC 1/8] ARM: localtimer: return percpu clkevt on
 register
Message-ID: <20130219121013.GO23197@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <cover.1361186097.git.afzal@ti.com>
 <e7cbb10903841ba23a93f71e7a06ae34a43adc70.1361186097.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="acOuGx3oQeOcSZJu"
Content-Disposition: inline
In-Reply-To: <e7cbb10903841ba23a93f71e7a06ae34a43adc70.1361186097.git.afzal@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--acOuGx3oQeOcSZJu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Feb 18, 2013 at 05:06:39PM +0530, Afzal Mohammed wrote:
> @@ -315,6 +315,7 @@ static struct local_timer_ops twd_lt_ops __cpuinitdat=
a =3D {
>  static int __init twd_local_timer_common_register(struct device_node *np)
>  {
>  	int err;
> +	struct clock_event_device *evt;
> =20
>  	twd_evt =3D alloc_percpu(struct clock_event_device *);
>  	if (!twd_evt) {
> @@ -328,8 +329,8 @@ static int __init twd_local_timer_common_register(str=
uct device_node *np)
>  		goto out_free;
>  	}
> =20
> -	err =3D local_timer_register(&twd_lt_ops);
> -	if (err)
> +	evt =3D local_timer_register(&twd_lt_ops);
> +	if (IS_ERR(evt))
>  		goto out_irq;

this is wrong. Will return 0 even in the error case. Correct version
would be:

if (IS_ERR(evt)) {
	err =3D PTR_ERR(evt);
	goto out_irq;
}

--=20
balbi

--acOuGx3oQeOcSZJu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRI2ulAAoJEIaOsuA1yqRELJIP/12ken2QId8yUgcsrXQQLAZ8
haabqhcm54toRT3V6PcCVxfH71+h+KceD+lte/CMk/mYkfKjdraBUDiBvzqYSZbO
jbKx+f+C1k7iRIT/6JNxWqrikpaN1+Dfiu9yVTcJx8SuIq5ZHZ4Ep5Mm6J5udsQ3
iSl0fL/Ua3wQExkfEOMTG9KxHTNxCFTogIMO3ifizP9Rfu90kgTfALdQSv58wxtu
j9X9uyJmM7SEEOSgjKEtDOuecccVsFIvfMfNq7kvrN2ZfBOUUhFtAskq4NrTx0Dn
8BqmGHUK+8m6bJmglRlM8HwsGCc623XfhoVIQZ56FDX2+BNlqMt17LKVnUBdCcKm
y3czUBomoc3YnqlJ5oFaVlqH29//VmRIGyxYzzah/ROo6sZOXekEimFAXWwgmrQn
bIuaCtuOUGi2D77sxrgtJGMwko59k8rKjUSVLZaKFplJ7Ikqtnn9y2k8z9qMJbJV
/XcdPWtyhcGuTgDr1nWiXe+T46uODVz8tDwyad6bLfKHw/FvZ0Eu40vEuw6fXqv2
nmTh6PslKk/kcjM9sMv56wV30FzaNDFtxOQgKxzPHJ9lMonnhi8fF9CkiZaZxwUB
ZmRuZyUSu/9oeLZv4FoCJBEQrNyRPkCuKdT0Z70hZFTgvsCe2cGcvA2Q1Quu0Y0X
BT/OSjQTTCt6Iql6V+um
=ItBP
-----END PGP SIGNATURE-----

--acOuGx3oQeOcSZJu--
