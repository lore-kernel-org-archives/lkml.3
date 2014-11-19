Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbaKSJfc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:35:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52666 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKSJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:35:29 -0500
Date: Wed, 19 Nov 2014 09:34:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: linux-spi@vger.kernel.org, Carlo Caione <carlo@caione.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jerry Cao <jerry.cao@amlogic.com>,
        Victor Wan <victor.wan@amlogic.com>
Message-ID: <20141119093445.GV22111@sirena.org.uk>
References: <1416264471-774-1-git-send-email-b.galvani@gmail.com>
 <1416264471-774-2-git-send-email-b.galvani@gmail.com>
 <20141118140658.GI22111@sirena.org.uk>
 <20141118225546.GA27182@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s0H35NU0PUc8VBh+"
Content-Disposition: inline
In-Reply-To: <20141118225546.GA27182@gmail.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/4] spi: Add 'last' flag to spi_transfer structure
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s0H35NU0PUc8VBh+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 18, 2014 at 11:55:46PM +0100, Beniamino Galvani wrote:

> Would it be better to introduce something like:

> static inline bool
> spi_transfer_is_last(struct spi_master *master, struct spi_transfer *xfer)
> {
>         return list_is_last(&xfer->transfer_list, &master->cur_msg->transfers);
> }

> or open code it in the driver?

Adding the helper function seems better, it means we can change the
implementation later.

--s0H35NU0PUc8VBh+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbGQxAAoJECTWi3JdVIfQe2sH/RfuVlJmbwTuMXxo8oXmtKoc
BkHQLcXVYYGZL+9M7S/W/Pk2xzSqvQuWPMUWraFk39+5XHzlieHbsFkWOd/P7H5i
0yekOEWxbVkHnRzOEBJsXlUNCJbepPUA+0YPBlIMtlTi3ClCDfPjgAZTcLDgLdH4
F6DWpQgHcU6n+bnCUGBNcas1l3v8Q73QhJCtifjxnnS2aUaQ1jZPmWSc50kA8W1i
n/HDZn3VFxnfCTJ+1z/vwAwf4BKC1SgI0qJezWIHLsI8yeG4LgIMqExnqpVXOTUF
vW4JxSeNNtEweyIiEzqLvSFdCDrXUJfYnWoueQIRsOTpUh3mMrtWhInUdg8LFK4=
=JxKc
-----END PGP SIGNATURE-----

--s0H35NU0PUc8VBh+--
