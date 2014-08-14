Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbaHNVDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:03:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35653 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaHNVDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:03:23 -0400
Date: Thu, 14 Aug 2014 22:02:53 +0100
From: Mark Brown <broonie@kernel.org>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: heiko@sntech.de, dianders@chromium.org, grant.likely@linaro.org,
        robh+dt@kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        wei.luo@rock-chips.com
Message-ID: <20140814210253.GF17528@sirena.org.uk>
References: <1407977544-2989-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DMVR+kHVjCKdhElC"
Content-Disposition: inline
In-Reply-To: <1407977544-2989-1-git-send-email-addy.ke@rock-chips.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: rockchip: return 0 if tx_buf and rx_buf are NULL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DMVR+kHVjCKdhElC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 14, 2014 at 08:52:24AM +0800, Addy Ke wrote:
> To do so, spi communication can use an empty buf to pull up CS.

> This patch merged from ChromiumOS tree.
> Cros_ec use this function to turn off CS and add a delay to ensure
> the rising edge doesn't come too soon after the end of the data.

>  	if (!xfer->tx_buf && !xfer->rx_buf) {
> -		dev_err(rs->dev, "No buffer for transfer\n");
> -		return -EINVAL;
> +		dev_dbg(rs->dev, "No buffer for transfer\n");
> +		return 0;
>  	}

We should be implementing this in the core rather than the driver - just
not even call into the controller driver if there's nothing to do.  That
way we make sure that every driver works properly.  After all, the delay
itself is implemented in the core.

--DMVR+kHVjCKdhElC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT7SP6AAoJELSic+t+oim9b2kP/17R09sfWwDcnHSoljRanevO
4FnFbkGMsAmkHwjC8MFF8bJ0V1RhD8ZCiL+0KC4HDBErCOgtkCaIcbwiyYFb/hOB
6Ft9/D1BbyM+PqgAUiugv4wB8RSwN0UkUkOyKN5HzYJz5NAB7xsHTjCGATVoswQp
S46f6JNCW3BAikBnGA9Iq6IdF1tJpw5/3UM6zFBpdjpIJy5pNFf0E9GftbgdfjIR
qo3GML9sOGVR1UYsdWkvujDb7HnRaF/ACRi06swA9cMl1kk81sy7FNPUXfPfoNdN
wO8RAJVt9ZdZOhLw51PhJjUMU3toEUnpY252g5FOdC2F2h1WN9OYmuJfkwTu3433
FQM59PfZB62Dh+UPx84LTgQD9q6pGnwyfj9o+OmPgSCzCsXOMde5LaTzuxbBCbTO
BvBPt3VbPavnvwuJ2XcC118xYjn3aD7XhFfSc6JhgP8gcyPz1xHyKJOcS15SJEFO
Rp/Ug7fZzOGRW2PyVrVxUW77xkM79K5bNJDKpgxoRl9bJ/2dBurI5poaaSLNkc6h
xIUji6FGMXZUZOySKuwYWyqGMnsz5YKB6NcK2aXQzyy1d0eArWkEXbZAIa6IPFpu
tIC1+6rJCIVT+EGIkJTsjVsL58Vdh/6fmbcDYxDpwtfn3nHbineXiQgFMyYusCH1
7XicWLyUrdA9IldCImxd
=IId5
-----END PGP SIGNATURE-----

--DMVR+kHVjCKdhElC--
