Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaA2Qk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:40:57 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60930 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbaA2Qkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:40:55 -0500
Date: Wed, 29 Jan 2014 16:40:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140129164035.GC22609@sirena.org.uk>
References: <1390993850-9054-1-git-send-email-maxime.ripard@free-electrons.com>
 <1390993850-9054-4-git-send-email-maxime.ripard@free-electrons.com>
 <20140129122520.GY11841@sirena.org.uk>
 <20140129133227.GQ3867@lukather>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oJ71EGRlYNjSvfq7"
Content-Disposition: inline
In-Reply-To: <20140129133227.GQ3867@lukather>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oJ71EGRlYNjSvfq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 02:32:27PM +0100, Maxime Ripard wrote:
> On Wed, Jan 29, 2014 at 12:25:20PM +0000, Mark Brown wrote:

> > A select of PM_RUNTIME is both surprising and odd - why is that there?
> > The usual idiom is that the device starts out powered up (flagged using
> > pm_runtime_set_active()) and then runtime PM then suspends it when it's
> > compiled in.  That way if for some reason people want to avoid runtime
> > PM they can still use the device.

> Since pm_runtime_set_active and all the pm_runtime* callbacks in
> general are defined to pretty much empty functions, how the
> suspend/resume callbacks are called then? Obviously, we need them to
> be run, hence why I added the select here, but now I'm seeing a
> construct like what's following acceptable then?

> pm_runtime_enable(&pdev->dev);
> if (!pm_runtime_enabled(&pdev->dev))
>    sun6i_spi_runtime_resume(&pdev->dev);

I think you're looking for pm_request_idle() - just leave the device
started by default and kick the system to suspend it.

> Actually the IP asserts the CS automatically, the only thing you need
> to do is to set which CS to use for your next transfer in some
> register (which is what I'm doing after the !enable), and the CS will
> be managed directly by the controller. Hence, there's no way to say
> wether you want to enable it or not.

> The controller allows to control the CS manually also, if that's the
> preferred way of doing things.

Yes, that's required to provide set_cs() - it's there so that things
like the cs_change option in transfers can be factored out into the
core.  We may in future want to integrate the ability to switch between
manual and automatic management but it's likely to be more trouble than
it's worth.

> > This means we can only transfer a single FIFO of data?  I didn't see a
> > check on the transfer length.

> At the moment, indeed. And that's the first thing I check in the
> transfer_one function.

Oh, so it is - sorry.

--oJ71EGRlYNjSvfq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6S7/AAoJELSic+t+oim9g8IQAIGYMI0tc30LgFaisLrM3mPC
7FHp1g9iHlyz6rMgp1DAm3S3+toded9Ood9KM3S6U+pgYzlOjeagQYRG0a8H4wto
BO7Desp3jDQnlF3srvzDfM5MTTthAu76sjCKYvQ/3PZsMTLn07sYA/JjHKHk0NxM
rLBF1F6GkOrxatLRpers5jfYAz3EWv7VJaq1xKqwLx0/CPosPybC1QDUAazmkTnJ
YwyfnUmxEmA4thkxTapM8fn2oClZW4iuOKcFDK1BowPaeZKwsneDq6DV4a8MGsbP
JtB0qyS1Mfpt5QkSLLSHZFuxksQeRfrhesZY6PPb4eocMRmBMR/4OGEl6kxsBupN
r70IVKh0u+p0MOyoi3aaYUiphTvaPkqSUaL6SmNFaQyLxt6GezwQz0Y7LU7KmjMV
NTmnfvqdpVbWhGq2DqgADjEhAmJW/qUNSfkfZfMXL1S9l/JaNnq6hyugCQFIo2vf
u6CNI90M6BRvwHFTAfujNE8A6Z++o3a8nHdkedOyZBh5tsvCs1SpX3MzSjIbKBD1
iKH44WUxpms7Q3uxA8V8Doqt2LT02sbAimr2tN4ca/lpC5vkubzd13m7V/b1Ku4G
FWyyA2Udd0acguYJOPOHux1Ws18uk1e4cVPKhjuWkSpcr9nRmI49dA85ExhLzssv
gB7RUq0RdKBKyMx8XHHW
=r2F4
-----END PGP SIGNATURE-----

--oJ71EGRlYNjSvfq7--
