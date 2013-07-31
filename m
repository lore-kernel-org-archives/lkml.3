Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab3GaLuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:50:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37254 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab3GaLui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:50:38 -0400
Date: Wed, 31 Jul 2013 12:50:27 +0100
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
Message-ID: <20130731115027.GN9858@sirena.org.uk>
References: <1375232669-27846-1-git-send-email-festevam@gmail.com>
 <1375232669-27846-2-git-send-email-festevam@gmail.com>
 <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
 <20130731111853.GJ9858@sirena.org.uk>
 <20130731113244.GI2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EAhnSkGTpVKzLkT2"
Content-Disposition: inline
In-Reply-To: <20130731113244.GI2810@htj.dyndns.org>
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


--EAhnSkGTpVKzLkT2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2013 at 07:32:44AM -0400, Tejun Heo wrote:

> Yeah, if all resources are allocated using devm - note that you can
> hook in non-devm resources using devres_alloc() - all resources which
> would be necessary for the interrupt handler would have been allocated
> before the irq was allocated, right?  And thus they'll of course
> released after the IRQ is freed.  The problem arises when devm and
> non-devm releases are mixed as non-devm ones would happen before all
> devm ones messing up the release sequencing.



> > OK, that's helpful.  It'd be good to document this if it's something
> > the API is intending to guarantee, though - devres.txt doesn't mention

> Oh, it's definitely guaranteed.  Nothing would work otherwise.

Most things would work just fine - most of the uses of devm_ are just
resource allocations that can safely be freed in essentially any order.
It doesn't really matter if you free the driver's private structure
before you free the clock that's pointing to it or whatever since
neither has any real connection to the other.

> > this and it's not something I'd intuitively expect to be the case.

> Oops... I guess I forgot to mention that.  Care to submit a patch?

I'll take a look.

--EAhnSkGTpVKzLkT2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+PoAAAoJELSic+t+oim90oYP/R1hUn2PdDJMDhs9WORFUV+X
nvosSy0PiX9W23Mq7vfVJ6+5Zl2YAJEtVWjhz3uTqWidRw1d1z40F6CBQ6yxn34D
BxcWuYW6boyF/ZCBsOMIuuq+IPkroRk6Pl9rXlAMzLJg1qE9Jbu2sLAyHyE0YY7f
A0VQqvDWW5AsoiKzXqwexCjau3pUuxcfdELwN3YP9fN0WmGm1whkIla6306VJRrS
3L0y/Tyn3ADFyMdg8WIvs7gm1XCjcxSn7UAX3ixiYfC8/auG1MmFXf5hcQElarUc
OeWXppvfdg8wrnh5xDxVWvElarTHlxTJZTZQwgdba2m8D4Lq9wDUdSWBvo4BFe9c
cmOhG3kqXPZLc/oymQg+HAFJRfp8d+W3GWlf7touM/NwAxtAdPYP4hp9Vd3kVzmF
5wxb1jmXjD6AOtXR1LyuvpQFU5cCGtkg7hLQd16agX1rhFdC8X4dlFP+7Mj6fxlz
6sWZRExruNzEabdagfAef1BfB9dRQhefiNaKmId0sxnvZqRnP5XqfPYX9l89w9sC
5UdYtrbfztu9y6fwLX0vaOe8T0dmzmfCrthW9RO9s5rn7fOwh6G74pczAwZ4xBT9
Pz05teJgqT7Ow0ySf00c9084+KQtIONqEd6Neh7cMq2E4LEmzHfTENdd8prfgKaA
pzQ8PvfarGO0q3wTt3M1
=ICNH
-----END PGP SIGNATURE-----

--EAhnSkGTpVKzLkT2--
