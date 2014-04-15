Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaDOMLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:11:21 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33827 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaDOMLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:11:20 -0400
Date: Tue, 15 Apr 2014 13:10:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140415121042.GV12304@sirena.org.uk>
References: <1397292335-5516-1-git-send-email-boris.brezillon@free-electrons.com>
 <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140414210429.GJ25182@sirena.org.uk>
 <534CE16D.8010508@free-electrons.com>
 <20140415100922.GN12304@sirena.org.uk>
 <534D1DDA.40207@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="D2rVImvqWGvKULsk"
Content-Disposition: inline
In-Reply-To: <534D1DDA.40207@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over SMBus
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--D2rVImvqWGvKULsk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 01:54:02PM +0200, Boris BREZILLON wrote:
> On 15/04/2014 12:09, Mark Brown wrote:

> > OK, so if this a realistic issue then it seems like it's better to
> > implement three different buses - there is not really any common code
> > between the various paths.

> Okay, I'll create 4 different busses (one for each access type).
> BTW, should I keep these implementations in the same source file
> (regmap-smbus.c) ?
> And, should I keep one method to register an smbus regmap or should I
> provide one method per access type and get rid of the
> regmap_smbus_transfer_type enum ?

Do something that looks tasteful in implementation.

> >   This would also mean that you avoid having
> > gather write when it can't be implemented.

> Correct me if I'm wrong, but they all support gather write.

Everything except for the block transfers is writing one register at a
time, actually looking again everything that can only write one register
at a time ought not to be implementing the buffer based stuff at all and
should instead be hooked into reg_read() and reg_write() - it's not able
to implement the API properly in any of the cases, it's unpacking the
buffer which the upper level code already supports.

> > The code is also not validating the lengths for two byte values.

> I'm not sure I get this one.
> Do you mean I should check that val_size is a 2 byte multiple ?
> If this is what you meant, then I should also check it for block transfers.

Yes.

--D2rVImvqWGvKULsk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSG/AAoJELSic+t+oim9YfgQAIOeHZLTXavt0P3hiPP/aA8h
UVbnVFujlalNlgebgyKfIXubFwcPVnsVY59lFl+baPGP91O4QLhTCwrGWSaFJKbk
TrIvh/f2gRkPxSka9QeZnOqhpvqqmbHdqCGTyTonWcsHSQKYOixGIfd1V90yWfuq
BU3vZ7/ARLz4ySWtxeiUU/V/glSyyYKEu4nw1mtMKnf2DtFaLypFQval4Dgql0Sh
4YP0jM7PcBOJJY/LSzmYf25xt3rGh8dPRynYQwcDPc00oIEKxrZVBzhve+s2buJ1
M7nnGHG+Rc9mGzcKiSpFDLkMpwbD4bQVnMOAz5ZCpenpKIdyqImXRWfgP1nGQbM6
McASGlLoZfis1UNk77yc60pgi2R0QbcnIhRS4ujas0RKm9wkvUdDEYTjNG6RBduL
YeQ61Siw6LG97pcuX7salMa8zInt+LRHLAubRMatZnce0h87HaXgnOfRCWB8STKG
gDOYKr7+2NC0vNraPDMYyZ9hMDxtczc/a47MGFk/GTirAzHW3adlt73yum+ysjHb
NF8e8TBE37D9Ge05KQnQZ1W+UvfdGirj7shWjf0hOXZ7J2Y5rsgIQSlvZ3UvQfP3
wH+A7K6ORKvXVmQbW0dWK3pAFIZI7/DDAnmySgGs8xIcj1fV03A0Moy2xPlQorwZ
L6dHiJNgFljigLdjZIXC
=erIE
-----END PGP SIGNATURE-----

--D2rVImvqWGvKULsk--
