Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaDOWje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:39:34 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34349 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaDOWjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:39:33 -0400
Date: Tue, 15 Apr 2014 23:38:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140415223849.GJ12304@sirena.org.uk>
References: <1397480885-11962-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140414210429.GJ25182@sirena.org.uk>
 <534CE16D.8010508@free-electrons.com>
 <20140415100922.GN12304@sirena.org.uk>
 <534D1DDA.40207@free-electrons.com>
 <534D252B.8060009@metafoo.de>
 <20140415125654.GD12304@sirena.org.uk>
 <534D357F.9040906@metafoo.de>
 <20140415164613.GF12304@sirena.org.uk>
 <534D85F3.5050009@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Or8LRHETumScJgaM"
Content-Disposition: inline
In-Reply-To: <534D85F3.5050009@metafoo.de>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v2] regmap: smbus: add support for regmap over smbus
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Or8LRHETumScJgaM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 09:18:11PM +0200, Lars-Peter Clausen wrote:
> On 04/15/2014 06:46 PM, Mark Brown wrote:

> >Please note what I said about convenience - if lots of devices have
> >exactly the same set of constraints to set up it's possible sensible to
> >have a standard way of specifying them.  It's going to be a bit easier
> >to just say it's smbus than to remember exactly what that means.

> Maybe, but the only shared constraint is reg_bits = 8 (and if it is pure
> smbus use_single_rw = true).

I thought there was some other stuff at the edge of the protocol, though
perhaps I misremember.  We do also have the thing with implementing the
bulk write differently.

> It's a bit of an exotic case, there seem to be only two I2C controller
> drivers in the Linux kernel that have support for both raw I2C and native
> SMBus and neither of them don't seem to be fairly recent (i2c-powermac.c and
> i2c-pasemi.c). And on the other hand most devices are SMBus compatible have

Blackfin was another - I didn't look that far to be honest since the
first few that I found did it.

> extensions like being able to write/read multiple register in one transfer
> if raw I2C access is available, which is something we want to make use of if
> available.

Sure, if the device supports it.

> And the other thing to consider is that a client driver currently has no way
> to query whether the controller driver supports native SMBus or only
> emulated SMBus. This is surely something that can be added to the I2C core,
> but this is necessarily something that we require before any SMBus support
> is added to regmap.

Right, that'll take a couple of minutes though.

> So in conclusion I think the best way forward is to create a patch that
> checks if native I2C is available, and if not falls back to either
> SMBUS_{WRITE,READ}_BYTE or SMBUS_{WRITE,READ}_WORD operations (Depending on
> whether val_bits is 8 or 16). Such a patch, I think, has the most effect for
> the least amount of work since it is rather simple and self contained and
> allows all devices which are SMBus compatible to be used with SMBus-only
> controllers. Everything else discussed in this thread (optimizations for
> special cases, convince helpers) can then be implemented on top of that.

Indeed, like I've been saying there's several orthogonal things going on
here and that's one of them.

--Or8LRHETumScJgaM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTbT2AAoJELSic+t+oim9jekQAI277Xlh7oy6XOUp9Grhsit/
sL6P4HqwZHEGt7OJAHjY2khk5fJJHkpIIt5DKFZWp5gXOLJDM0YODikRohua55bb
SLwpZ/khblP3OI43Eq0gziInNpaFz8LmJjplvIqIvhQ3gys5HIjxzYkyykRxnvm/
8XltisnpkiO0Rr84YHCNMh7kqQ/bRDYEIFV399YCHsAyTTExc4uikkqiacAJgh06
K9M1IvKpBkiRn/sePE+CcwF1WfcO5DN8TcVBJmBzK9Nsd41UuLed8PqOsZA76RFk
hjOxJWxEefqbB5jpY98ooZ/t8gOi/RG/sqJhILYl1bMNjJuF9iNChCU742egnjWu
HsdU9/LAF5CnMJCLbiFFOeAcqIy2eggnFZSyDpIhW/z6nXlQzYrFZ0V9xwb3FIjO
+GQaZolqk2cvkzQ1QDCpYDpWl9ZedimB8o9UpjM1NqdJjYpx7U+MwnIjd1DE1luJ
R1nEbtSNvmDSbvUt7XtQIlXnWZqmze9OrDu4GF92FQWAa7xfc904we6VB+bxpUgx
qoj4/K+QuuUvnlLekhpvNBoqlbj+/ej0U0D2qwrVlxn7Ws801EIE4zg4m98fzNgy
fglaor5VAtVkn5r93+S2JPcDasyMa7C4PHPEHxKTOEtmV+rnxXQhrOQj6t6dp7SK
2tQX8i4g8SHf/FdXL9Pb
=JSVB
-----END PGP SIGNATURE-----

--Or8LRHETumScJgaM--
