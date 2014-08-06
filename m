Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbaHFTfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 15:35:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50181 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbaHFTfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 15:35:12 -0400
Date: Wed, 6 Aug 2014 20:34:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Nick Krause <xerofoiffy@gmail.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20140806193453.GJ17528@sirena.org.uk>
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
 <17153.1407349640@turing-police.cc.vt.edu>
 <CAMuHMdVJQd0Mb8aXbd9iqkabzKdw9WSR791LxqUoVEJ1g1kaHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="id7U9qOqdBFOLQU4"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVJQd0Mb8aXbd9iqkabzKdw9WSR791LxqUoVEJ1g1kaHA@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--id7U9qOqdBFOLQU4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 06, 2014 at 08:50:15PM +0200, Geert Uytterhoeven wrote:

> To be 100% sure, I tried to find with which kernel config this warning shows up.
> It doesn't happen for omap1_defconfig with CONFIG_SPI_OMAP_100K,
> which was the most likely culprit.

> It does happen with sparc/sparc64 allmodconfig. However, changing or
> removing the READ and WRITE definitions in drivers/spi/spi-omap-100k.c
> doesn't have any influence on the preprocessed source files
> ("make drivers/spi/spi-omap-100k.i", modulo line number changes),
> for both omap1 and sparc builds.

> (Nick: I believe the above is what people really want to see)

> So I conclude they are really not used, and they can be safely removed.

> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Right, I'd already done the same analysis myself with looking for uses
myself (though I didn't go looking for how to trigger).  Nick, please do
look at the analysis Geert provided above - it is indeed exactly the
sort of thing that people would want to see, just saying what's in the
diff isn't enough especially given the well advertised quality problems
with your submissions.  You really need to explain why the change you're
making is a good idea.

I've applied the change.

--id7U9qOqdBFOLQU4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT4oNaAAoJELSic+t+oim96ssP/A94yqu+MJ74cbKu2VKKb3nS
OGZUEdzWs8XVwJC6rxohwzRpc0b0vDEAYFk3FUs5T9I79QzpQZYnK2GnCLeWGsiV
iXtZV1+ilnPLpnm8cfU6U3XbIVBug2GOuhajf3ZWqnYZ5ydLqpNMNoak1FTzwKZZ
V0GxCGZXR4tCNnRqiotL94RRDlLIfCfU4tXCaLcHIqJTxFnuDu1E7SL8DUBC89jV
/2uYhHmlQC1gnyVEZ3jvprbwTVLlqciGiA8ffFEL8hwa0vULaiUlIkPk2O5RvKV3
sS/TuVLNf1hi/GyNa6C91q2Zb/uzARb0OAIgM5Zr4xD75TnNlI/dKORvm1i/kr4h
CGM/GhNCzvDE639BBCrlKR9tdi+M1AkK4s8y2/WisvUjpoxSAe3sT9BjogFnIh8O
/FhD9emVod7XGLcejPx9ih0BA9g7BZh4BLwtA1tV/cQruW3myUieI8T2rKIagxDE
b1Hwj4uNMHK8RwYmEmISeFT0JxCGwEoOhNutXUp6WCWkQnUBMmA4YDHnK2aXn2nX
2R7Sn0UW7ZRJkQVVvMvmdOKRmWvamw125AQeF1VDvX4wcwvSl6+mXPDUapdzywfz
ljWvp1SUMOy8nRqJtViqYh5KGSMfJ71xjYbUWU9BYDpYvnnt1jGr4knGqRT44mwN
Xxhz+PVdDCbzRaWHhtHW
=0/SR
-----END PGP SIGNATURE-----

--id7U9qOqdBFOLQU4--
