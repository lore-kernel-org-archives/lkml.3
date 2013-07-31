Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759047Ab3GaLTO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:19:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48369 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab3GaLTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:19:12 -0400
Date: Wed, 31 Jul 2013 12:18:53 +0100
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
Message-ID: <20130731111853.GJ9858@sirena.org.uk>
References: <1375232669-27846-1-git-send-email-festevam@gmail.com>
 <1375232669-27846-2-git-send-email-festevam@gmail.com>
 <20130731073306.GZ1754@pengutronix.de>
 <20130731082054.GF8540@nchen-desktop>
 <20130731084645.GB1754@pengutronix.de>
 <20130731090512.GD9858@sirena.org.uk>
 <20130731094434.GC1754@pengutronix.de>
 <20130731095411.GA2810@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aP1ODUq80QliXAiN"
Content-Disposition: inline
In-Reply-To: <20130731095411.GA2810@htj.dyndns.org>
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


--aP1ODUq80QliXAiN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 31, 2013 at 05:54:11AM -0400, Tejun Heo wrote:
> On Wed, Jul 31, 2013 at 11:44:34AM +0200, Uwe Kleine-K=F6nig wrote:

> > > > OK, so the possible problem is that remove is called while the irq =
is
> > > > still active. That means you have to assert that all resources the =
irq

> If your driver destruction path is running while your irq handler is
> still running, it's a crappy / broken driver.  You need a deactivation
> step whether you're using devm or not.  IRQs can be shared and the
> device should be in a quiesced state before the driver detaches
> itself.  Note that you can queue deactivation routine using devm.  For
> an example, please take a look at
> drivers/ata/libata-core.c::ata_host_start().

I'm not sure I understand how this relates the problem.  The main issue
here is that for the shared IRQ case quiescing the device doesn't make
any difference since one of the other users of the interrupt could cause
the interrupt handler to be called regardless of what the hardware is
doing.  This means that we need to guarantee that anything the interrupt
handler relies on has not been deallocated before the interrupt handler
is unregistered.

> irq deregistration.  Add an explicit deactivation step using
> devres_alloc().

> devm guarantees that the destruction callbacks are called in the
> reverse order of registration.

OK, that's helpful.  It'd be good to document this if it's something
the API is intending to guarantee, though - devres.txt doesn't mention
this and it's not something I'd intuitively expect to be the case.

--aP1ODUq80QliXAiN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+PKaAAoJELSic+t+oim9F3sP/iPf8/L+4WXt7+XtU8rhRoiH
lz5kIeYHjmB654NAYi4ssnqz0OZWAhWxg6sdjXOEHaPkxUg3Yn1VMY5ZPkf4TP4c
oYuaQ7dnZDwLRZ65FA8oPdCGzutfpGLVhhWLQ+C+D7ojzCb2aU9QzO4ViGZvtVXi
swOXMbu+HXNTGi/vePCNcrMwYv9/Kdi/QTh6pPn6gihvdVv8yBnQMWfYV1Zn2430
7Zujj7GDqOmoSMp/hXcuml05c/hqlmED5jdwsH0rtzX0OsbgoFdIaImiPPtcmGg7
YiZaeakLWS4JW+iwq2jwSaLWUwmflAZUPWTNrDq79iYimedXquCZcYlFLfG4DlAD
ZwARRCMgy251XNY7Pzu6SA09Ys5sjqUHgqvcqMIwRBadbJwLeQjjUZCGViMcT0em
jPbCc46Lm5n8O9LcXDZRMMgemxYnQUvQ37nkGeZBkQUz4XkB+bSHzUNg0NosFQR+
+QkLDw/sGfe+BeswRvNhgyEerZs8QAZ9LgNTdgQTyHLSafAhRL3E9fXqc3d7Oxfm
cAvRblG+EZ0cr+EQT3p567UDpJPK+0WBiFq1vKYLSwhlPHTulI4FUHFb4kqB6o3Z
ygC945i0N3g8t7la/iIwqOFLeSAPilKLw1yU6YLyGZPlE9BxVxZSOQe2bqkB7PRW
T6c4cWFnqkFx5xWDNa5i
=s3JU
-----END PGP SIGNATURE-----

--aP1ODUq80QliXAiN--
