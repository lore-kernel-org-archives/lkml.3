Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaANOuL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 09:50:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54041 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751351AbaANOuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 09:50:08 -0500
Date: Tue, 14 Jan 2014 14:50:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140114145002.GR15567@sirena.org.uk>
References: <1389699411-29135-1-git-send-email-geert@linux-m68k.org>
 <20140114125242.GE15567@sirena.org.uk>
 <CAMuHMdVmSUh8yphZ4oPR=QYp5uMS9BXgPRVuwa19S9q7jWxxiQ@mail.gmail.com>
 <20140114134528.GG15567@sirena.org.uk>
 <CAMuHMdXEsNKRxYv8gh5sDzpg_QH2RmrjYhLhCZx0QCcRN+gdOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o99acAvKqrTZeiCU"
Content-Disposition: inline
In-Reply-To: <CAMuHMdXEsNKRxYv8gh5sDzpg_QH2RmrjYhLhCZx0QCcRN+gdOg@mail.gmail.com>
X-Cookie: Marriage is the sole cause of divorce.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH/RFC] spi: core: Fix logic mismatch in spi_master.set_cs()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o99acAvKqrTZeiCU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 03:44:43PM +0100, Geert Uytterhoeven wrote:
> On Tue, Jan 14, 2014 at 2:45 PM, Mark Brown <broonie@kernel.org> wrote:

> > If we're manually setting /CS it really makes no difference what the
> > chip thinks the polarity is - something that is controlling /CS
> > autonomously can't implement this operation and something that can just
> > set it at any time doesn't need to worry if the chip thinks it's
> > asserted or not.

> Doh, so I'm the only one where it does matter, as RSPI has separate
> Slave Select Signal Polarity (high/low) and Slave Select Output Setting
> (enable/disable)...

I'm sure there's other hardware out there which has such control, it's
just that there's no value in actually using the polarity select if
we have manual control over the enable.  All you're doing is adding
complexity in drivers.

> >> > when calling set_cs() is probably OK though.

> >> Just flipping the sense of enable still needs a documentation update.

> > Huh?  Why were you updating the code then...

> "true to assert" in the documentation means that enable is true when
> enabling the chip select.
> Currently the value of enable depends on SPI_CS_HIGH. Just "flipping
> the sense of enable" doesn't change that dependency.

Oh, so the code update was purely about factoring that out of the core?

--o99acAvKqrTZeiCU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1U6XAAoJELSic+t+oim925AP/RAoKiKl9mEQuAN7KPKk+P3q
ISa5pPpkIULOKPMqVNAq7ZBVOEroZXzVTxRQEN9087QoVxh+YoOZCublm6BBPsje
/qrXWJGBBL7rn3ERoU+5N0ukuJJmCYc/IfgJw5WghyBxzrQ9mspY8cUb2PnYhVdF
d4BfOIKvCfl9wbokElW+/HAG0GXyr4dK1iwKEwl31cf7+HRDmdAa/XSeRbo5XaYJ
jVNapyg+7feImsOBiJoGoCimWxI2ou5N6CGM0pWMLCm3OHAtjBukDee26HYEEMQO
d5P+DZuJsjWlRFeyY3U0riLUuk+SMAp2HAZ1OJ7yKRoeADsiVu4dgYwB2niYlhHC
fS9khbAufcLu3YSFWUiwuu+gaRxEX4VHqWz/8o0rO6n9I1VJtsZJfb60b48MU7VU
9cOfntxEhdaa/xAq6fdVBBWu5p68kv6piq8dyus65OYTQuane2k0tQqIw9OU3gjP
UXY7W243XALeXOOv3r64+65JiTlebYnYTg83yFUJvYF8bOozj90KptdMTKha4LPR
zqTQVYDUtV9X4PqnwxAqgB0plOqvA+jw/s7YybqfNRWXuBOrVeogk+fiOwr71DFp
0iA3iH2+sFqy8EhJgcBiwQdcZtviJZxh1cFkcRMG65Xd07nLz6/N/s8Yycwzt8g5
TYO4hna6Lpq6M1Brb7Az
=ct++
-----END PGP SIGNATURE-----

--o99acAvKqrTZeiCU--
