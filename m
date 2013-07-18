Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab3GROnN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:43:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60166 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757351Ab3GROnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:43:11 -0400
Date: Thu, 18 Jul 2013 15:42:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130718144241.GO22506@sirena.org.uk>
References: <1374141687-10790-1-git-send-email-sourav.poddar@ti.com>
 <1374141687-10790-3-git-send-email-sourav.poddar@ti.com>
 <20130718104233.GG22506@sirena.org.uk>
 <51E7D569.2010709@ti.com>
 <20130718131822.GN22506@sirena.org.uk>
 <20130718133158.GA1628@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mkFcsau6kMcX4bpT"
Content-Disposition: inline
In-Reply-To: <20130718133158.GA1628@arwen.pp.htv.fi>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv4 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mkFcsau6kMcX4bpT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 04:31:58PM +0300, Felipe Balbi wrote:
> On Thu, Jul 18, 2013 at 02:18:22PM +0100, Mark Brown wrote:

> > So why do we report that we handled the interrupt then?  Shouldn't we at
> > least warn if we're getting spurious IRQs?

> not spurious. OMAP has two sets of IRQ status registers. One is call
> IRQSTATUS$n (n = 0, 1, ...) and IRQSTATUS_RAW$n.

> IRQSTATUS$n will only enable the bits which fired IRQs and aren't
> masked while IRQSTATUS_RAW$n will also enable the bits which are masked.
> I could never come up with a use case where we would need to handle IRQs
> which we decided to mask, but perhaps there might be some cases, I don't
> know.

> Based on that, I believe Sourav is reading IRQSTATUS_RAW$n, then he need
> to clear the masked bits.

That's not the issue - the issue is that if none of the unmasked
interrupts are being asserted we shouldn't be in the interrupt handler
in the first place but the driver silently accepts that and reports that
it handled the interrupt.

--mkFcsau6kMcX4bpT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5/7eAAoJELSic+t+oim9keQP/3SJe7J2pK0LjYO+/4lS1LV2
bTBysL9rcqADayeXAGPIOGtQGGXLRwtwc1di/UyIz/U+nhf5ugevw7GBuTGJYyBe
wQEZxyF3rTFSETfs63NikBfPM8Qu0Y62i9tpwqkp9Wshs29NYteFP1RjbTdm3leB
vqb9gnzgAAtKOfedMick+HAd2zKp7HZfM35MHklaSfNRVyXLWKgqL7ZqWPEGM0N2
3nkRuOYhjL49801mNDF8EN/H69eNsH2wWatCPxDbKEHXD2Jrc7IFQcGMupMA18CH
hwEnVyH7mvGr/3N9TcuKbKr6kweDDKOKZqK8C9wEJOByCe/T+gQCROVIF+KXoEen
fjJA+8YfR2HqZnlq8me9JetIL49qSnIvY5VEb7fTJXredgMRFROh+/QgITE/X8tF
q17agXrggedHb7z4YXohKAkUCXBs7u9SgqVlh9o9NaDuOjQwG+EGAFPF5yGh7zQy
mABC5zl5DaQ5jtDJuP6A1YKOdS8bXavbXK0vtAp/ub8fqh19en0JnlFEuePuOR2G
+RjOebes9zgGbVBkVj2KonoP6oPoeou96aZlgXaam4Ln0ZIizQs7+L+84Rudi3zw
GuOqfEy4SirfjOS1EfJd0HgkRQXCFXT0shy8zQCTjxc0YVDQKT+zgS1aHJPDvOiN
oNkDgy71ty0pciZtIrlI
=rsqo
-----END PGP SIGNATURE-----

--mkFcsau6kMcX4bpT--
