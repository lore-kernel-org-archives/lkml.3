Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753279AbaF0Kvu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:51:50 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32830 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbaF0Kvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:51:48 -0400
Date: Fri, 27 Jun 2014 11:50:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-spi@vger.kernel.org, Sagar Dharia <sdharia@codeaurora.org>,
        Daniel Sneddon <dsneddon@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org
Message-ID: <20140627105057.GF23300@sirena.org.uk>
References: <1403816781-31008-1-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3ozdenm5Azl6mQ8k"
Content-Disposition: inline
In-Reply-To: <1403816781-31008-1-git-send-email-agross@codeaurora.org>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: qup: Add DMA capabilities
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3ozdenm5Azl6mQ8k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 26, 2014 at 04:06:21PM -0500, Andy Gross wrote:

> +	if (xfer->rx_buf) {
> +		rx_dma = dma_map_single(controller->dev, xfer->rx_buf,
> +			xfer->len, DMA_FROM_DEVICE);

It would be better to use the core DMA mapping code rather than open
coding.  This code won't work for vmalloc()ed addresses, or physically
non-contiguous addresses unless there's an IOMMU fixing things up.

--3ozdenm5Azl6mQ8k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrUyOAAoJELSic+t+oim9g64P/0DCLX3QOf409MCNcPwrkB4k
CO/xvPxt70PNhbPO/Ari3MdqcuLJv1PtobDMlSFEgiWtE5ApwK7CbFX4O84aYjFb
mtiTQQc29mjvPzoJ2DNcfNuch4880/CseAdHBYvcgsG6787UDSt7eLJjDJLuRmnX
ccpoPKwbkPAq0klGWOGZ6vf3Kjeu4YA6Iq+s83CYhQEJ0uZr+YTBHPuauhRNsFAM
sJ7YTkc3jTLmM4nIWBtol/llL0byZcdpD/TCPwCrXqoeYJDaTqhZJ/RjFgsxKtlf
1F1gyPk4Nay/mqJ8d3HU/Yx4jj/k1rYeJAVsFvff7jwusY3+Sqyq81K6naohsi0x
PccU9xMiSv5QVBka/2i3MawsAoiqwRI1xNSY2Z1o14neJI1jz1iffMhLKuu48FwJ
hD1NXVYqm6msbGSav5KSnySuxoBZuekOty/kl3vX08mVlOmVuWnJSMnVUygK9mX9
sx1NCVdg1XL85mhyShqVH9SGM8XAh5eu2mmrJo3MyRQM7V7GqBNakRpQ9OfOFTQo
HptjIMpNwy68EkBPlS/stIO6RDWQ6W48bBcQyoUOJBuhZOY3lCx/hkYx3aI3ceBs
nLTWAyF00He0WLu50679lmg8vfxGiuIRjDC/jble/bGcWbzSRc9G1UPwdo3MmHH7
pKlT3865UCYcX0hEjxLc
=YGCI
-----END PGP SIGNATURE-----

--3ozdenm5Azl6mQ8k--
