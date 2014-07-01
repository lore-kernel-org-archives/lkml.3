Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaGAMMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 08:12:18 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42630 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaGAMMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 08:12:15 -0400
Date: Tue, 1 Jul 2014 13:11:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Alexandre Courbot <gnurou@gmail.com>
Message-ID: <20140701121142.GM23300@sirena.org.uk>
References: <1404215726-2480-1-git-send-email-broonie@kernel.org>
 <20140701120622.GJ32514@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="++AYaZ8Lu7KET2DY"
Content-Disposition: inline
In-Reply-To: <20140701120622.GJ32514@n2100.arm.linux.org.uk>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Still free GPIOs using gpio_free()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--++AYaZ8Lu7KET2DY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 01, 2014 at 01:06:22PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 01, 2014 at 12:55:26PM +0100, Mark Brown wrote:

> > Even though we mostly use GPIO descriptors internally we still use
> > gpio_request_one() to request so we need to pair that with gpio_free() to
> > release the GPIO.

> This doesn't explain the reason...  I see the current GPIO code doing this:

> void gpio_free(unsigned gpio)
> {
>         gpiod_free(gpio_to_desc(gpio));
> }
> EXPORT_SYMBOL_GPL(gpio_free);

Huh, good point (though it still seems a bit neater to match up the
request and release functions I guess).  Linus?

--++AYaZ8Lu7KET2DY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsqV7AAoJELSic+t+oim9hx8P/A49uh67cTLXgee75EUJEsHd
nBWG8NFCQHnQxWCcfNqNL38YJ+fZYkmfAcu7NYbJ38bF+40S0EZxGHMFjbwtAL4V
ZASVDF5cB+/UR71lViItgsxD4Hxtm8X8fiQLwcAuwPphq8rAnplRJThmLngdc2Fx
0Ks4Rppk0V2H4jFv3XWi5Tub/mOf+ZeY5gE7Era8AED/HpYFacYtbTaXY6GeK3E9
j5Cha3nH++AMHprGdz8p+mvAaO9+bvgie60lqhyKiwdCi7wXJ9YnLz+62prgwaMh
Yvwssxx2IMyT2e52q/gaq5NhkWV4oaZaSpWoV/LfzKrajaDwVIfiDZuG8C978vUe
q60v+Yc0er3w2tm9ahPMAo687ybHTTitNhIDcVh9BQOrm7TvxXcYLy34T58MRcnr
Q3l9Du7/lUN2slSK/7u211sr/vofajd64rZETzPvifdfK5aKzj4VpLL5ck4XFHrh
s53rZ5Vmd4/q7mgGc+vug5QOtlwQLT6FOystbgCyKL0c646pwB757WtJvJD9gni6
Kgr6ysjR3UvXj4IjaEqjlT9I987OgFXjHhFxBgjkUc11kkozr7dNn8SBg0g41rdT
DqWD3SoRfLkNLPvYH3yMhRbxCDevvS9qIfIAMgleLV+C30mH+0j2iL6JEfLDhI20
pCw4IniUNxkzqnMd9WQa
=d5wr
-----END PGP SIGNATURE-----

--++AYaZ8Lu7KET2DY--
