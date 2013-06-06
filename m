Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932342Ab3FFKbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 06:31:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56583 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203Ab3FFKbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 06:31:07 -0400
Date: Thu, 6 Jun 2013 11:30:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <x0194613@ti.com>
Cc: Illia Smyrnov <illia.smyrnov@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Message-ID: <20130606103032.GR31367@sirena.org.uk>
References: <1370432398-7796-1-git-send-email-illia.smyrnov@ti.com>
 <1370432398-7796-3-git-send-email-illia.smyrnov@ti.com>
 <20130605120346.GZ31367@sirena.org.uk>
 <51B05FB8.6050903@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q32ofrQ8UfzBLMEG"
Content-Disposition: inline
In-Reply-To: <51B05FB8.6050903@ti.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] spi: omap2-mcspi: Add FIFO buffer support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--q32ofrQ8UfzBLMEG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 06, 2013 at 01:08:56PM +0300, Illia Smyrnov wrote:
> On 06/05/2013 03:03 PM, Mark Brown wrote:

> >Why is this defined for slaves?  Surely the size of the FIFO in the
> >controller is a property of the controller not the slave?

> According to OMAP TRM [1] the FIFO buffer can be used by only one
> channel at a time. If several channels are selected and several FIFO
> enable bit fields are set to 1, the controller forces the buffer not
> to be used.

The controller ought to be able to figure this out for itself.  As a
first pass just grabbing the FIFO on a first come first served basis
will probably work well most of the time, the device would have to be
very active for it to constantly be doing transfers on all channels.

If there's more contention than that we probably ought to be looking at
how we handle this in general, it seems like we'd have more problems
than just the FIFO to worry about.

> If there are several slaves on the controller we must select which
> of slaves will use the FIFO for SPI transfers. Also, optimal FIFO

A single controller is only going to be able to talk to one slave at
once, everything on the bus except chip select is shared.

> size is heavily dependent of the SPI transfers length specific for
> certain slave.

The transfer length doesn't seem like something that we want to be
encoding in DT, particularly not indirectly - it is obviously readily
available at runtime, variable during runtime (eg, firmware download may
do large transfers on a device that only does small transfers most of
the time) and is something that updates to the drivers could change.

--q32ofrQ8UfzBLMEG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsGTAAAoJELSic+t+oim9dfEQAJArV1dyQATWzmsuwfEfsXXg
ZNXsuLuPBaZ/jzt342a/MBDaSNeLyuxpq/w2XqP09zhydPozG00pOZJsSJgXxF9W
2mWXtDv7lo/BBbDzGjSSmocGD7fhoHkJZbF4dSVuDNQNEXB+eIkUxQJhUYi/N1k6
EmR43XboKn7FIA7eD/GPWFZ3flnx2ANygXisMpnGaAU+36hxX5CJHcQHK41+9SFx
5ZB18Qqwv8xOwdXobe/4CtDDBTKgKIn2JWQUwEAzzuE8BG1Wb95W/aQ7EhCrtJQE
tGdoLqAAS6fGSPZzpbCUZepbCswtTWqoGIY3SBt09wCBvSpysgn8SJtbkxRaeMTD
2LFzYN6xsZJ7chC1r1GAPyUxDhU01pUywApOUbF3j20n0uBhagv9gL0z51Fwnrrq
vOogf8CwC1DlQA2X+8up9YyHeZX4BQ6Y6lHv9uFSOkOw7SzD2TTxcI8+0g6JhU/5
SqZt0/E7WyDq5hjL/MfTao+uEq6dirjBQyAa0yazWo+nDS4sYPxBEXTcSmSzokI6
hFzXtGM85IB2UJiat0XgUTwUCGpVgWI2FkzoRDMs/w813I+Yd0SLHzFXdhLclKiM
4/7RkdF8hhxqLcf/1z8tPagKjOXkV1u5P4PYxsCSGA2/FR/PShwst59zcKgSJ7Ak
pRq9JpQyIwVCThfo8QPq
=gKwp
-----END PGP SIGNATURE-----

--q32ofrQ8UfzBLMEG--
