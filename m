Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946AbaHMUea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 16:34:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33981 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaHMUe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 16:34:28 -0400
Date: Wed, 13 Aug 2014 21:34:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, devicetree@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-spi@vger.kernel.org,
        wsa@the-dreams.de, linux-arm-kernel@lists.infradead.org,
        pawel.moll@arm.com, mark.rutland@arm.com, galak@codeaurora.org,
        gregkh@linuxfoundation.org, kyungmin.park@samsung.com,
        m.szyprowski@samsung.com, t.figa@samsung.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140813203406.GU17528@sirena.org.uk>
References: <1403105372-30403-1-git-send-email-s.nawrocki@samsung.com>
 <1403105372-30403-2-git-send-email-s.nawrocki@samsung.com>
 <53B59221.5080100@samsung.com>
 <20140725214231.5177.86866@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U75PZdtY8vGTLDHE"
Content-Disposition: inline
In-Reply-To: <20140725214231.5177.86866@quantum>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH/RFC V8 1/1] clk: Support for clock parents and rates
 assigned from device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U75PZdtY8vGTLDHE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 25, 2014 at 02:42:31PM -0700, Mike Turquette wrote:
> Quoting Sylwester Nawrocki (2014-07-03 10:25:53)

> > I would appreciate a DT, SPI or the I2C maintainer opinions.

> Yes, Acks from SPI and I2C maintainers would be good. I might need to
> drop those parts of this patch if they don't come through :-(

So, I just noticed this.  The reason I didn't see this earlier is that
it was buried at the end of a large clock API patch rather than a split
out patch for the SPI subsystem so it fell towards the bottom of
my review queue.  There seems to be no dependency on adding the feature
as part of one commit so it should really have been split out.

Please don't assume that people are going to look in detail at patches
that aren't obviously for them - I know I end up ignoring a lot of what
I get sent since I get CCed on a lot of random things for no apparent
reason (or get tediously large numbers of resends of things that are
tangentially related), I imagine others do the same.  If you're doing
that please draw attention to it, splitting out per subsystem is the
best way of doing that.

This is particularly unfortunate since I am actually a bit confused as
to why we need to open code this for every bus rather than doing it in
the driver core, there doesn't seem to be anything at all bus specific
going on here.  Why can't we just call this from the driver core?
Having the feature work for some buses and not others is going to get
old fast.

It's also not clear to me why we're passing false to of_clk_set_defaults()
when we do call it - it's quite common for I2C and SPI devices to be
clock providers and have clock trees.  As far as I can tell the
reasoning is that what's actually going on here is that this is actually
a mechanism to defer the initialisation to adding of the clock providers
in which case contrary to the documentation for the function it's
actually about device registration.  Is that right?

--U75PZdtY8vGTLDHE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT68u6AAoJELSic+t+oim98wgQAJp7tAJdU9zMPvuBFYZbp2VX
vyhwdDreO6IHBEnhUtPMfFfTxikL3TSHBcsozARYN7mu1cDzxEYR/8gSJQoSheA4
IlqnqIBpPhGH06MCX7wIRBRDnh7e5hPSdasA2aSa+ehgJIR8cJ4/ua/BuG4dpZph
xP3wFZ/AtkMxVeqOK/tTtvMKZftuG9ro4T5NumZIbwDPeX3TUk29KzJYMlYJR64H
C6aAHcQfd59xZJrAP76P1nM0zXllnOjgJrGZngY1/KNOue9BbccTTPBH16HtWVO0
+JFwJ2vaBUvqYFtoSRtdjHmFPUfLzsSQLe7XSe77OBoFbydnjhcYfEB/kYwJEdB7
gZLe1ktGaUdGKjWFehxtKWT1CbHQFu02cDGIRPOwuW88lN4jppR+rYB60WAs0tBm
F6+ygFRo/E7hHr9ajceEhVZyhl7hTxceP3O9OOS5aupma6P+ai4fFscUPR0lRT1C
WNod5/e7/d6VCGYFixff9EJVFi8v+Wry+Ed4VW6lu3EOqkfvi8Rik3BfQ0Q8fzdV
pNadlgMlq3mhUWsY+9gyXHkL0GqKgOMZtoVcMGjkB8kVGsPX8fs5ZqbtNDwGwpcz
KVuCndSl7KlidBuRF6EzkHRF0+zqC6F8ZL4WtEnjLA3fK2XrEm6rUInQqIYHEQte
yP2lm9fcMyMRdbvwS7Au
=yAzq
-----END PGP SIGNATURE-----

--U75PZdtY8vGTLDHE--
