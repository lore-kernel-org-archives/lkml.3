Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795Ab3IJM2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 08:28:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51225 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751244Ab3IJM2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 08:28:21 -0400
Date: Tue, 10 Sep 2013 13:27:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20130910122754.GK29403@sirena.org.uk>
References: <1378733679-19500-1-git-send-email-mika.westerberg@linux.intel.com>
 <1378733679-19500-2-git-send-email-mika.westerberg@linux.intel.com>
 <20130909154028.GP29403@sirena.org.uk>
 <20130910075100.GK7393@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4wKa0rmtotUGtIt6"
Content-Disposition: inline
In-Reply-To: <20130910075100.GK7393@intel.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RESEND 1/2] i2c: prepare runtime PM support for I2C
 client devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4wKa0rmtotUGtIt6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 10, 2013 at 10:51:00AM +0300, Mika Westerberg wrote:
> On Mon, Sep 09, 2013 at 04:40:28PM +0100, Mark Brown wrote:

> > How is this going to interact with client devices which are already
> > enabling runtime PM for themselves, and what are the advantages of doing
> > this over having the client device enable runtime PM for itself (given
> > that the client still needs an explicit put() adding)?

> My understanding is that you can call pm_runtime_enable() several times
> (provided that pm_runtime_disable() is called as many times). So that
> should have no effect on the current drivers that already take advantage of
> runtime PM.

Not quite...

> There is one difference though -- runtime PM is now blocked by default and
> it needs to be unblocked from the userspace per each device.

...as you say.

This seems crazy, why on earth would we want to have userspace be forced
to manually go through every single device and manually enable power
saving?  I can't see anyone finding that helpful and it's going to be a
pain to deploy.

However I had thought it was just a case of the drivers doing a put()
instead of their current code to enable runtime PM (you mention that
later on)?  That seems both sensible and doable, though it would need
doing as part of the conversion to avoid regressions and I'd expect it
does mean that SPI needs to be converted at the same time.

> For the advantages compared to each driver handling it completely
> themselves:

> 	- Few lines less as you only need to call _put().
> 	- It follows what is already been done for other buses, like PCI
> 	  and AMBA .
> 	- The I2C core makes sure that the device is available (from bus
> 	  point of view) when the driver ->probe() is called.

I can't understand your last point here at all, sorry.  Can you expand
please?

> > Given that it's relatively common for devices to have both I2C and SPI
> > control it seems like it'd be sensible to keep the policy common between
> > the two buses to simplify driver implementation.

> Yes and IMHO if I2C and SPI follows what has already been done for other
> buses it should make the driver writer's job easier as the usage is similar
> from one bus to another.

So then the obvious followup question is why this is even something that
needs to be implemented per bus?  Shouldn't we be enhancing the driver
core to do this, or is that the long term plan and this is a step on the
road to doing that?

--4wKa0rmtotUGtIt6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSLxBHAAoJELSic+t+oim9OrkP/27mdXqxA7FOIavipPs6i2zl
QhED8Wzz/j3bk9Zon94JPMfYSr+rUwc0UtvZyOJKk1o9XUBU95wRBJsqmBLGaG43
kymYTpOd9S9CivELs5C6YWtJ3dsnMdQFTEViXboIbO4AYRvpMzHuPAuNsCl6EFsR
chtMJ+loHVPcyC1EXfW2MGPElpyWsCnmyrQ50RoxMB65VTaDWRDAlJ9YoIBR5sVR
vtUmcZtJBVVto1dPTK7CWt6CNW4LAKHsmfGwxyOiveFxwRw9VdL1i5M43GL6UH9c
wdQlwrDrJ7SwIl85NzIoqEehciq/J+WG2o6LEuLz18jMCs1K5TKa9GXeAtYp3x/N
1T7SCkvHWq30VNkalikELEqAJwaG9OVsV8uxKDa654m1RH2LmaLkH2RSI+vKWoQf
us4OIXOPwxs6Z35i2ubfJ049ueGNybktozeeqWsCIAklAX7CU4d69lVvzkLXWnfS
YjRK39YCoP4hDujlUF1O+lITs4M+RIzrlknYZ0SJ7zKHf2AflDpkJ6OA34Vh7b6G
P6ycDTvqmblCHRGaQsiCsQuVUsdjbQfuaEQazWJmWIjFkveWY4eqQnwQj4el86gb
sTTTcBmKoNzLVmDOnnWNYGui39SOA4Pd6MrDU2vl9HQqlk5C8zXYegg4+Tjgwt4n
fhCcOw0xC3zFQs38n8yq
=PR2z
-----END PGP SIGNATURE-----

--4wKa0rmtotUGtIt6--
