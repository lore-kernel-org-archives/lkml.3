Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368Ab3IPKNS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 06:13:18 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43509 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3IPKNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 06:13:16 -0400
Date: Mon, 16 Sep 2013 11:12:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Kevin Hilman <khilman@linaro.org>, linux-i2c@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20130916101249.GX29403@sirena.org.uk>
References: <1378913560-2752-2-git-send-email-mika.westerberg@linux.intel.com>
 <87vc25pvvm.fsf@linaro.org>
 <20130913065434.GZ7393@intel.com>
 <87bo3whjz4.fsf@linaro.org>
 <20130913145022.GC7393@intel.com>
 <20130913173149.GE7393@intel.com>
 <87ioy4e8bw.fsf@linaro.org>
 <20130915064139.GJ7393@intel.com>
 <20130915124744.GW29403@sirena.org.uk>
 <20130915132823.GL7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AUFJoFQLqfvosQXp"
Content-Disposition: inline
In-Reply-To: <20130915132823.GL7393@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/9] i2c: prepare runtime PM support for I2C client
 devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AUFJoFQLqfvosQXp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 15, 2013 at 04:28:24PM +0300, Mika Westerberg wrote:
> On Sun, Sep 15, 2013 at 01:47:44PM +0100, Mark Brown wrote:
> > On Sun, Sep 15, 2013 at 09:41:39AM +0300, Mika Westerberg wrote:

> > > 	1. In I2C core i2c_device_probe() we power on the I2C controller
> > > 	and attach the client device to the ACPI power domain. Just like in
> > > 	this patch but we don't touch the I2C client device runtime PM.

> > > 	-> This should allow the existing drivers to keep using whatever
> > > 	runtime PM strategy they have chosen.

> > There should be no explicit need to power on the I2C controller if it's
> > implemented the same way the existing ones are - just have it power
> > itself on when it is doing a transfer.

> The problem is that the ACPI child device can't be in higher power state
> than its parent (and this is also what the runtime PM expects). If we don't
> power the I2C controller device before we power on the I2C client device
> that rule is violated and we get an complaint to the console.

That's definitely an ACPI specific (probably x86 specific ACPI?)
requirement not a generic one, on some systems it would increase power
consumption since the controller will need to sit on while the device is
functioning autonomously.  Even though the controller power consumption
is going to be minimal the power domain it is in may be relatively
large.  Can't the power domains for ACPI deal with this requirement, for
example by making the I2C slave power domains children of the controller
power domain?

--AUFJoFQLqfvosQXp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSNtmeAAoJELSic+t+oim9ibgP/1XbgRoewTbRWjwDer80m+JP
E4wVyN9NnxjbIYLozbpm3zGgQvD24Uz0TXZUB4NZKehZH9CI8IDZxXYnpKiu8zVC
osb++hB66BgHNJxn1WjXPPWiLYqsj0SLpFMSQMqFKS0o/J63d38GdhFIyQEbUN8U
VNRWw8KiDfANWjYXtGCd4TImOw4Z9dLiH54UhpeOXSofZl5fqL/PoSUqdxUYlnM4
GXRF8IET70rBnv2mQJu6OMvrYXc0i8KV1xY651LaVSGpdF3yWBVkDYL+lsMrD59a
BERUq7SaRgHJv3gMhoLa1HT03Wv0tv+g5PFEg3pcgCvkKYlctPj4qCBt38WAkoYE
QTIgTXiKNTbFgGtpw5kTxjN9gwVvWGJ7VBPPtzIEMRYxrXCHi12qS1J+zMuJjlVh
AmIaHJVFsXp2q0JLw5N6Hpcltq1FM2wnN3bPVto9lqT3ZKV4CZxnwMdnW9WXATv6
HgoL5GrjBjFcOLqKYz4xnNeCak+y7rfVGnXNJjVgiH/RTwmC8SmBPmoY7VbIqdHm
FVaS1WS/FfA5OeCEx6XM8pCd7Eqk+aHmfgu5XTh3xNmd8gP2poNay3lkmplDzgn7
1Inlz9DT/55O7fHNmM01yb3pmi6zNzgf7D3L89WE3Kk8YBR+z1IyTjgTcO+54vUE
F8IzpQCjjfxpNjNq9Eyl
=XVEx
-----END PGP SIGNATURE-----

--AUFJoFQLqfvosQXp--
