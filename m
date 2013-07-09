Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab3GIOkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:40:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55607 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753879Ab3GIOku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:40:50 -0400
Date: Tue, 9 Jul 2013 15:40:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: balbi@ti.com, Sourav Poddar <sourav.poddar@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@linaro.org,
        rnayak@ti.com, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130709144043.GV27646@sirena.org.uk>
References: <1373290980-17883-1-git-send-email-sourav.poddar@ti.com>
 <1373290980-17883-3-git-send-email-sourav.poddar@ti.com>
 <20130708203330.GA28322@kahuna>
 <20130709065143.GC5552@arwen.pp.htv.fi>
 <51DC072F.40704@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W8H4ZJu+ON5Wa/ox"
Content-Disposition: inline
In-Reply-To: <51DC072F.40704@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 2/3] drivers: spi: Add qspi flash controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W8H4ZJu+ON5Wa/ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 09, 2013 at 07:50:55AM -0500, Nishanth Menon wrote:

> with this input and looking closer, I think I see what you are saying now:
> dra7xxx_qspi_prepare_xfer -> does a pm_runtime_get_sync
> dra7xxx_qspi_unprepare_xfer -> does a pm_runtime_mark_last_busy,
> pm_runtime_put_autosuspend

> In between these calls, you have the remaining xfer calls going on.
> we are assuming here that autosuspend timeout should be greater than
> the time to complete the worst case transfer.

No, autosuspend will do nothing so long as there are references to the
device held.  The effect of autosuspend is to delay power down after the
last reference has been dropped, otherwise things run normally.

--W8H4ZJu+ON5Wa/ox
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3CDoAAoJELSic+t+oim9mlQP/1O+Zz4BGus/wyIG4C7J3ypQ
kcnb4c0jRkB+8qr0827e3FBaxf9+acKEHD6D62l0aJjtlbyNKbg9WNFEVxFHRcdC
niNie4ImofcIrlBkf4xKZ4h20jYEN+Mf9GdmEWd6QR5Df6RrGRJfCTNcZVjA3GhZ
DbaeCt1bAejD/hRv7sEwlUy9sKl+Ggx42im/zf1sGdL7bbJwAn8aZ7T0LQGyv1uX
a8p24UXX+sLCnHYQUUANUdL9H9dfGHxz9/f/q0/VVG8NXHjB5Ck1HvlzAtDLR4p1
IRCQ34zOKDlnix0ltH/2MOendAQzO0VeDU1g2a68TQjHkIolTOMr/jFDqdKjf8L0
p+go/0gYSFYFoTo3vhVIe5LQ6e1gO5OMwX8vcI6yrGKaN5lJutQ32mcrZ4TOym4W
MEfIG0VZK8UPD8GEcgcCI6NEYUyGwGlosxk8g2C5l7OWi8T2ksbWj1rM6LnInYwB
tgw7IPjfj3XPpwJOWOjAboMcEKyZ4w2/wrhDiIUZYtnDIlzZKVq+lI6OrQi1bOv8
3pQ9sROQHGBCzjyulyU9HMQoNF8ZUqZNaffIy75G7ydQ1yUPtlIUIsscD+DTU87z
beGkcRV4jrDW/M7iTPwlUvjvknoeVBIDbWWFo7crVK8Jj+EoqtSIxKtcRcGnTr26
Cjci4NzQqXFaOLSIXndk
=LrUV
-----END PGP SIGNATURE-----

--W8H4ZJu+ON5Wa/ox--
