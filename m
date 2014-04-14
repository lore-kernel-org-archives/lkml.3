Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaDNU4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:56:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33033 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaDNU4N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:56:13 -0400
Date: Mon, 14 Apr 2014 21:55:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Jane Wan <Jane.Wan@gainspeed.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        Emilian.Medve@Freescale.com, kenth.eriksson@transmode.com,
        thomas.de.schampheleire@gmail.com, b48286@Freescale.com,
        jg1.han@samsung.com, sr@denx.de, insop.song@gainspeed.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Message-ID: <20140414205547.GI25182@sirena.org.uk>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
 <1397328516-13260-2-git-send-email-Jane.Wan@gainspeed.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOdHDkIp180r3pqZ"
Content-Disposition: inline
In-Reply-To: <1397328516-13260-2-git-send-email-Jane.Wan@gainspeed.com>
X-Cookie: Are we THERE yet?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all
 received data to user
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GOdHDkIp180r3pqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 12, 2014 at 11:48:36AM -0700, Jane Wan wrote:
> Make FSL eSPI CSnBEF and CSnAFT in ESPI_SPMODEn registers (n=0,1,2,3)
> configurable through device tree.  FSL eSPI driver hardcodes them to 0.
> Some device requires different value.

What do these do?

> Allow FSL eSPI driver configurable whether to send all received data
> form slave devices to user.  When user wants to send n_tx bytes and
> receives n_rx bytes, FSL eSPI driver sends (n_tx + n_rx) bytes on MOSI.
> For the received (n_tx + n_rx) bytes from MISO, current FSL eSPI driver
> drops the first n_tx bytes, only passes the last n_rx bytes to user.
> Some device driver has problem with this.  It requires to know all bytes
> that the slave device puts on MISO.

This sounds like a separate patch to the first one, the described
behaviour is definitely buggy and any correctly implemented Linux driver
that does bidirectional I/O will have trouble with it.  It should be
split out from the new DT bindings which are a new feature.

> ---
>  drivers/spi/spi-fsl-espi.c       |   68 ++++++++++++++++++++++++++++++++++----
>  1 files changed, 61 insertions(+), 7 deletions(-)

All DT binding changes need to be documented in the binding document.

> +/* whether to send all rx data to user per chip select */
> +static u8 *spi_raw_rxdata_to_user;
> +

No, any data needs to be part of the driver data structure not a global
variable.

> +		if (spi_raw_rxdata_to_user[m->spi->chip_select])
> +			espi_trans->len = n_tx;
> +		else
> +			espi_trans->len = trans_len + n_tx;

Why is there even an option for the buggy behaviour?

--GOdHDkIp180r3pqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTEtQAAoJELSic+t+oim9RdcP/AklGxIf2Cajbg5ktXVPd5Yo
8JygXblIVRx4thtkO+/XQkLx4dwEW56LYQAgrC8vK4LSbSQuVEqFGwOFcyJgRIZ3
v50ihORoTH0nsId6qrRtQNt+BKeZjSdDRz1oJrRpugpcZZbwEH+RGHsx0NRquiT1
fGknEAP//En8oPq/RjQvN1Iji9zWMqm02IUFpFqLBjEG9X8mE2wx2cpb5TqN7WHX
ccjtHRlLDkV0VQm7OZxA7bsu5pvMiSFrRE4tZ19hEsCSV7wOdugkiD/WN+53O50e
seLFdAukY2VfFcz0AGceoid/+ZN/C0IBfmy0F3STRnyFXyK/FjBkG3gu3SY2TAu6
pOUc8P7KImYPaFCVEUAwAuxHf2X/oTXAfScmRADFPPjps/WEwLD6B3bJDVrT3hZa
JeSmccDQ+3jYvp6AbFdyAbPAnA/vx7oN8FtTxayVx6+sROc2EQO4K8OQN0/ntYTO
Zpb1BDJs05SyviWbShRxwzOGHvuYmIk/ea1rdwGJGZ/NnUAfrIJwWsNpm24ucv+e
GoYMm6HMM2vI1UxjyazSnXY9l+rpb54vaMY6W6tAHLLNtqxq6y4YOJw7tbcht2E2
eGry0R8bihYzYxQbGWzbT1llVV+/hcJJ1ZIhfq4cShLtQ9R4ahX3/GNygmYQW1Ig
su1Z979H0wkHvohp4ZZg
=XPAV
-----END PGP SIGNATURE-----

--GOdHDkIp180r3pqZ--
