Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab3JBTuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 15:50:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41863 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385Ab3JBTug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 15:50:36 -0400
Date: Wed, 2 Oct 2013 20:50:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20131002195029.GH27287@sirena.org.uk>
References: <1380716219-32039-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TmwHKJoIRFM7Mu/A"
Content-Disposition: inline
In-Reply-To: <1380716219-32039-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH] regulator: core: Add ability to create a lookup
 alias for supply
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TmwHKJoIRFM7Mu/A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 02, 2013 at 01:16:59PM +0100, Charles Keepax wrote:

> Following our discussions around the Arizona regulator
> bindings here is an effort at putting a mechanism into the
> regulator core to alias registering of a supply from one
> device to another.

This seems basically fine, though I do have a few comments below.

Bulk versions of the API would also make sense - it's likely that more
than one supply will need to be mapped - and please also add managed
versions so people don't have to write cleanup code.

> I have a couple of patches that update the Arizona driver to
> use this that I will send in if you think this looks along
> the lines of what you were suggesting.

This seems like someting that should be in the MFD core, or at least
that there should be helpers in the core.  Something like a set of
mappings in the mfd_cell so it's all data to the drivers.

> +       struct device *dev;
> +       const char *supply;
> +       struct device *alias;

Please use a more meaningful name for dev.  It might also be worth
allowing rewriting of the supply name since we'll probably find other
applications for things like modular board designs where name rewriting
is useful; since it's a function call with a parameter list it's harder
to add later than it would be with a struct.

--TmwHKJoIRFM7Mu/A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTHkBAAoJELSic+t+oim9950P/3hK2QKengAN8ug1C0sZViNy
ke1BRZwP219/sohVt9TYOmFeI93SPTSTIp/5wHtAhMzCrOgO8gT4rg2k9Vhpm48N
t2j4//7fy4gteoH7AdQbEHOcaqxyoybYr3GiuqAsTjPAdtIg20l1sK9WLL7ZkLV7
pKQkXMVqpFACAgSwnXUtRW1sG/wLyir7XJzWGSKOXEHYoTtg+XG95B9Ec0rUOx7q
Sy+nEOvPvIQ8KjiYATOssLK7+DflffN5UuBpnuqPcSL/jDupwWsn93MraT8fDTZ6
nmYKg8q0xAL8I+CL3l+9kUGvxFP1y1/Gxv6y/eYktOKnckJQaGxA7wQDhEct0uSB
TVjgPCYs905iUKiSIQLcEtlzNZG367KB0k9lav/bq1LMQ2ri4iOaY0K55oV8yOK1
Hmyg0lbDfAf87GCBidaS3X8vLjgA2VJjnd3EYmQqBRa8GtoLEsyooTeeTnSr+4Xk
YK/qpIBv5HjW8b6fkbUNKrdnIECnegPM8KxzneTytP+No1LeDOBvGeBcBADUzGW3
kmKOibClKG1TDr5t8J3yc+8dDYhd2NeuEr4yTaaemGxhWx5o9bmeS5ise8XZf4Sj
M5EiYzKsDOuwnC+MX2SVqNfma88tU1VRdGRsXRJHufpyxH6BnNgd5/ojthtXQHZG
FKW4ip64beQ+4uYIB5dF
=CcHe
-----END PGP SIGNATURE-----

--TmwHKJoIRFM7Mu/A--
