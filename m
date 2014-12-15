Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaLOM4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:56:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60213 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaLOM4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:56:34 -0500
Date: Mon, 15 Dec 2014 12:55:57 +0000
From: Mark Brown <broonie@kernel.org>
To: AH <najdrozszy@gmail.com>
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        ARM/CLKDEV SUPPORT <linux-arm-kernel@lists.infradead.org>,
        GPIO SUBSYSTEM <linux-gpio@vger.kernel.org>,
        DRM PANEL DRIVERS <dri-devel@lists.freedesktop.org>,
        "ARM/S5P EXYNOS AR..." <linux-samsung-soc@vger.kernel.org>,
        "OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Message-ID: <20141215125557.GB11764@sirena.org.uk>
References: <548B7653.7020004@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jmbcokH0GrqI2Ucc"
Content-Disposition: inline
In-Reply-To: <548B7653.7020004@gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 01/15] drivers/base: add track framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jmbcokH0GrqI2Ucc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 13, 2014 at 12:12:19AM +0100, AH wrote:
> Mark Brown wrote on 12.12.2014 17:36:
> >On Wed, Dec 10, 2014 at 04:48:19PM +0100, Andrzej Hajda wrote:

> >>+		kfree(ptask);
> >>+
> >>+		if (empty)
> >>+			break;
> >>+
> >>+		track_process_task(track, task);

> >...we then go and do some other stuff, including processing that task,
> >without the lock or or any other means I can see of excluding other
> >users before going round and removing the task.  This seems to leave us
> >vulnerable to double execution.

> No, if you look at track_add_task function you will see that the queue is
> processed only if it is initially empty, otherwise the task is only added=
 to
> the queue, so it will be processed after processing earlier tasks.
> So the rule is that if someone add task to the queue it checks if the que=
ue
> is empty, in such case it process all tasks from the queue until
> the queue becomes empty, even the tasks added by other processed.
> This way all tasks are serialized.

This is all pretty fiddly and seems fragile - if nothing else the code
seems undercommented since the above is only going to be apparent with
following through multiple functions and we're relying on both owner and
list emptiness with more than one place where a task can get processed.

> >I'm also unclear what is supposed to happen if adding a notification
> >races with removing the thing being watched.

> The sequence should be always as follows:
> 1. create thing, then call track_up(thing).
> ...
> 2. call track_down(thing) then remove thing.

> If we put 1 into probe and 2 into remove callback of the driver it will be
> safe - we are synchronised by device_lock. But if, for some reason, we wa=
nt
> to create object after probe we should do own synchronization or just put
> device_lock around 1. The same applies if we want to remove
> object earlier. This is the comment above about. I will expand it to more
> verbose explanation.

You can't rely on the device lock here since this isn't tied to kobjects
or anything at all - it's a freestanding interface someone could pick up
and use in another context.  Besides, that isn't really my concern - my
concern is what happens if something asks to wait for=20

--jmbcokH0GrqI2Ucc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUjtpdAAoJECTWi3JdVIfQZ0QH/iMfDK/L9XpgMZHOWJDq1X3N
HfV1l6yDxaz5H8Css3wMm4KFpVS39H5LIFxhijJdQmX15+F6rPqKnvKCvHb6A05b
ZoXJoGPePUPOIXK7iivTO+WqhckHzpxDxJ7lghuOSb/40UOZRbvnfFUWIzB4cP+o
4pvUfA1lckvXEuGc1ucMzQjzGmvahrxDWeK6Yha349tl1UDf5gTX9eA2LWLSvaHG
++koEZ+F5LM4PM01lpMSdkCeTPmPrVlhes9SVtHZBk676AkSuxx2XGoUDcN3xaTE
ttvbqHAfE7VtfcBbIB0mwwggl6iA96wKjwslINLQHO5ZXU9dUy0NOFqMtjUWgNk=
=oZ29
-----END PGP SIGNATURE-----

--jmbcokH0GrqI2Ucc--
