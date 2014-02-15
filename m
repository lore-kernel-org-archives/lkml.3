Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbaBOP1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 10:27:40 -0500
Received: from sauhun.de ([89.238.76.85]:37351 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbaBOP1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 10:27:39 -0500
Date: Sat, 15 Feb 2014 16:27:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-i2c@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: designware-pci: Add Baytrail PCI IDs
Message-ID: <20140215152736.GF2579@katana>
References: <1391524279-23409-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HCdXmnRlPgeNBad2"
Content-Disposition: inline
In-Reply-To: <1391524279-23409-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HCdXmnRlPgeNBad2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 04, 2014 at 04:31:19PM +0200, Mika Westerberg wrote:
> Intel Baytrail I2C controllers can be enumerated from PCI as well as from
> ACPI. In order to support this add the Baytrail PCI IDs to the driver.
>=20
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Basically fine, one question:

> -	snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci-%d",
> -		adap->nr);
> +
> +	if (adap->nr < 0)
> +		snprintf(adap->name, sizeof(adap->name), "i2c-designware-pci");
> +	else
> +		snprintf(adap->name, sizeof(adap->name),
> +			 "i2c-designware-pci-%d", adap->nr);

Maybe we just drop the "-%d" suffix entirely?


--HCdXmnRlPgeNBad2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS/4doAAoJEBQN5MwUoCm2GB8P/j9VCAviKxfPzMl1/+dAV7nD
qTbdMaUTqSN3hSiBFGEbYnSr8r2rJeliJGW9h/Hr2UjmtRky9SqXSV2lscenPOjM
fqKOBUsvsbiqNcl40XhvSdqVA9n4KXW+5BXAUXCMSzzuZkafjy7vn3jyiWflavdK
YNIP30fyIm4afPEONhBA+Wu/rsVnc9dnWdgmLe9sZsezSjSYB/c4zTqpScqgi9Py
doLWbA/phExjqpunI5/v9arDRDi/ac75L6rwbIdkmEMqyARXpjgvwAPDwG/s8ugT
ml7IU3EcvSYIxBqh9L1pg2Gi7rlSTRPjrboA2H4CRGZYhqzA6Tt/lkKVarUDHg1x
TsvNW3QXWLGYme8EHT30o+6gEa6uxe3+974MhdXPzmczDw2u9M3AkVUTA15mCiEr
RrIiifQgeuowZig8hCKrXdiy+lfkCpM82EZQac98r2vA/PN0OqfSzQ/9TfjndAYN
tJJP0HyVNQYnNonvtyvGP1sfZbB4X575zDSY8K2iaAVoq1w1V+iuh6qPLnhY41TW
sGpT4FKoupofmds3Xkashi0HuuPbszJR57lvdBiAJLtWDSc0xeR3ZX73c+ZgLqad
fveVVnVhZBlI5u3y0Lg9BCnwK9pSncSkvYxukz0Z/497OncgBS6zK5Ls12ca9Ju0
Tc3c4FAIXbOWSRSwvMEe
=1GZm
-----END PGP SIGNATURE-----

--HCdXmnRlPgeNBad2--
