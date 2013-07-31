Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab3GaPZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:25:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33734 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760249Ab3GaPZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:25:38 -0400
Date: Wed, 31 Jul 2013 16:25:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Peter Chen <peter.chen@freescale.com>,
        Fabio Estevam <festevam@gmail.com>, alexander.shishkin@linux.intel.com,
        kernel@pengutronix.de, linux-usb@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jeff Garzik <jeff@garzik.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130731152523.GW9858@sirena.org.uk>
References: <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
 <20130731115027.GN9858@sirena.org.uk>
 <20130731115527.GR2810@htj.dyndns.org>
 <20130731132708.GQ9858@sirena.org.uk>
 <20130731134215.GS2810@htj.dyndns.org>
 <20130731135751.GT9858@sirena.org.uk>
 <20130731140758.GT2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CqEE7xeKjOfIabLq"
Content-Disposition: inline
In-Reply-To: <20130731140758.GT2810@htj.dyndns.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] chipidea: Use devm_request_irq()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CqEE7xeKjOfIabLq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2013 at 10:07:58AM -0400, Tejun Heo wrote:
> On Wed, Jul 31, 2013 at 02:57:51PM +0100, Mark Brown wrote:

> > That's the only API I've ever heard of doing that.  Everything else is
> > just using it to do deallocation.

> I'm not sure why or what you're trying to argue here but take a look
> at devm_pwm_release() for example.  It calls back into low level
> driver free routine.  Are you arguing that it'd be a good idea to

That the callback is into the driver providing the PWM, not into the
driver that's using the PWM and is releasing it.

> release pci regions before this is complete?  It's just stupid to do
> any differently.  There's nothing to argue about.

What I'm saying is that in essentially all the users I've seen devm is
only being used for things like kfree() or clk_put() which aren't really
connected in any way and can happen in any order.  This (coupled with
the lack of documentation that this is supported) is why people are
nervous about anything that relies on ordering with this stuff - aside
=66rom ATA everything is just using this for straight frees.

--CqEE7xeKjOfIabLq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+SxgAAoJELSic+t+oim9LjsP/23GS4n/uPpjbb3iEoIGe5Hf
TA/XX1uK73bq+KmrUNERPrzADXu0fQmokLmL65pDqKw0Jig3bkFKgv7bSTnq12uw
DvWjp+cOXyYJVj+31wVuChs9tR4gNAv2XGETO2TaVYgvW2yc5zM7QFAIqq8wLRZp
2bcH6alqZt43r02oLNpH9PQywvQ1uRXR5XhptnjmSQ1jFRnNWWm0Eo/l5zNUwH6C
Ea5vSlc08b7YjejhTb59jcV8IK0mIYOu+5vtrAc1rR5ZAHZk8iVdkHxQn6zgW0UF
xeFItNGp2J5EAOX2/5UvcY+utIps3ecbJHKOB/eEazVwoL38lnNFa3uw8H7cj6jD
baFWJPJrAotMU0aWk3ruF3Jx5IAA1PnEtfovOBc7AGspolkaS1d87ElDKo/oeads
f4PERR8ASHgA0jCw6Qn3LW8QUaUIanOD2II4twTuw3eOHHo5ja2Lafb4Xa3S+3UE
x7YFszFAPMCR8kDXOyXFJVPD+1CxA1BT8PoE6+CyceQPkC5Nljq5AJtnmIH3tLmH
p8BIKxhDMbgoCUioR4Bl0IdfDj/ZIsJAJRII+BW/kBWQ+08aFeZLO7dvhZFir2xt
ieKkdQW3V5p4BLoAXukbA+vrs4SumOq0BHKjpx13Z7OkGmT98iKKR/eAcnENkd3w
wULS9f7w08fMl64p8UtT
=vwZS
-----END PGP SIGNATURE-----

--CqEE7xeKjOfIabLq--
