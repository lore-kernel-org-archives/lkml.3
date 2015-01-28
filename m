Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933535AbbA2CMP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:12:15 -0500
Received: from mail.kernel.org ([198.145.29.136]:51952 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbbA2CMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:12:13 -0500
Date: Wed, 28 Jan 2015 23:35:10 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org
Subject: Re: [PATCH] Devicetree binding for omap3-serial & bcm2048 combination
Message-ID: <20150128223509.GA11785@earth.universe>
References: <20150128093501.GA17338@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <20150128093501.GA17338@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Jan 28, 2015 at 10:35:01AM +0100, Pavel Machek wrote:
> Nokia N900 contains bluetooth module connected on serial
> port. Unfortunately, serial and bluetooth are rather closely coupled,
> so standard serial driver can not be used, and we really don't want
> /dev/ttyS1 to be published for internal port of bluetooth
> stack... Hence solution below.

Actually that's not true. If one takes a deeper look into Nokia's
bcm2048 driver one can see, that it's using more or less the same
protocol as other bluetooth modules (H4) with some custom
extensions. The only special thing are two additional GPIOs, which
are enabled before sending data, so that the bluetooth chip and the
omap can wakeup each other. I don't think one can speak of "closely
coupled" for this.

The only reason you needed this hacked DT binding is, that you do
not want to properly fix the bcm2048 driver, so that it can use the
omap-serial driver.

-- Sebastian

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUyWQbAAoJENju1/PIO/qa1u0P/RbKspoMqtUZeOjtLiZ6FB/Z
W/8kmi0VY+skufN2RLysbJa+NEMImCDSNjdJuTNela7l/1SJDFn2CKqlqM9t8Tdn
mHzKGZLtVwQ2GVFvJ6fzItZc67mmETKJNkN+JBBxw6kV9hNBionMb+TEpFVOKgD6
6o86qTIbP+O83YeMhUlUGnMxcrwP7FudCqibglsreSZaMZzrW6stCM0TPR948bPP
Y/jIkKf/PPEsh2POAKwUgmkxiuzv1NBeP0pIF0Garjo7OLApzNd7YHrUEO69mb2h
QSRtt+0BbCN79bB18On4XOc93P86psZfLM0GHa+Jpu2om6km4Qvtyo2AH0NTaLDT
0tIu38MFA1C+imbuRqWmXp39SWq2GGO2RoXM4RiF2D/6A12S44fnTnFmn/8psMa0
M9MBqfftaelaXsCO/IH1S6CrPjXD0rJbXGCO2UMDO+SS7lvSxNp3SFb9cUkrXXXz
Ommx5bCChPgJ5hI2co3z5EeEKYyBQm6uLWVXdvBq1jXjEU8b0Fk5eDt4ATPP2DW4
+ohsDNPJ6U9LznQA124vWQNNy4dVDuW+KcJc+Rx7ubBGbkC7f1wZZnUy4EOo9EP0
bDVX9xsyjriNwxRZngzz/mikb4BXRmKpmm62KIwEEDpUV7qvgKGMryAoF+OkYBW7
+3llsXCjcpj2eQJFU77u
=NZKs
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
