Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab3GIOrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:47:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35172 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3GIOrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:47:08 -0400
Date: Tue, 9 Jul 2013 15:47:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-spi <linux-spi@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        spi-devel-general@lists.sourceforge.net
Message-ID: <20130709144704.GY27646@sirena.org.uk>
References: <ff70173bee5f9223ffea2b92b903b4e46ef8b323.1373290150.git.michal.simek@xilinx.com>
 <b4458c93742bd9dfe69e3553cf377a703c945f81.1373290150.git.michal.simek@xilinx.com>
 <20130708144930.GG27646@sirena.org.uk>
 <51DADF3E.1000802@monstr.eu>
 <20130708162642.GM27646@sirena.org.uk>
 <51DC1AF1.3090401@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qVdROpInvt/uIoBf"
Content-Disposition: inline
In-Reply-To: <51DC1AF1.3090401@monstr.eu>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v1 3/4] spi/xilinx: Simplify irq allocation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qVdROpInvt/uIoBf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 04:15:13PM +0200, Michal Simek wrote:

> 4. spi_master_release()
> 5. devres_release() with irq

> If interrupt happends between 4 and 5 than it can be the problem.
> Do I understand you correctly?

Yes.

> If this is problematic case we can disable local and global interrupts
> and add it between 2 and 3 or 3-4.
> 	/* Disable all the interrupts just in case */
> 	xspi->write_fn(0, regs_base + XIPIF_V123B_IIER_OFFSET);
> 	/* Disable the global IPIF interrupt */
> 	xspi->write_fn(0, regs_base + XIPIF_V123B_DGIER_OFFSET);

> What do you think about this solution?

That's fine, though if just manually freeing the IRQ works that's also
OK...

> I have also tried to run one thing with and without this patch
> and the results are below.

> When I add this irq disable function between 1 and 2 then
> module removing stucks.

You'll need to wait until the device is quiesced at least if it's
relying on the interrupt to complete operations.

--qVdROpInvt/uIoBf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3CJkAAoJELSic+t+oim9fOYQAJADbFS77xLs6ortOeovxv5M
ZacmWAcElcu2uytl7ceJgyZJiu3UnDQu5S5/eGT2cJR/Gi8pQmBffGA9mu9ho2AA
z9kAaRkeF4Sfl6lNMjM3AYj7kvvGtxOomuMwGo2Jsxo8+dgNF+3EchYQl3tD1tkM
B6MpeIGUtg+eQQ7QBv08VX7w6zSiJZvMfTpdkIkAzL2bVWFKT+Xf2mlExRsBNwbI
rNhBDgPwfdj+talHwhrTAPe4KsN9YamhowkMY7N4WC7kMFVNKIL4+CmDAjpB76fY
EsPnFgcxF6gqaNtshNmtSNgqpk6YbMQWgWydmxNtVAZV/GUcQHtTsiR6kWyQYXTw
B+j1sb7jtbFl6Z4kAQIZ+sZL6MM9D6uULDnTXNZ7+X5noQKd3T8clwq69r1CTUw1
cBHFCXPuy/heWLLg6dOWiq1jtttHKKMLiVC2RtriiN4JCVakUJ1rQu/QJ54fawZq
OWopaSE0f5OLnAauo2s3YqxAC5vVKeRpGKVpPXb8nj6KTcI4a3Vcnh8+D89XqXXE
n/QIoWBi0705AUXBAX7XzA0nM+XydxNFolXIEdwpz1AM9yHkg4CECdA5GxanidGP
sQb/gN6TF7Qqb4KUFyHRtxa3RHnwjATW8Aa2fEaWNWZZFfIVLftijy3pBZh5KhG0
V670GHTR9UIc68ytryLe
=H1r9
-----END PGP SIGNATURE-----

--qVdROpInvt/uIoBf--
