Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab3FGTGw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:06:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:39309 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012Ab3FGTGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:06:50 -0400
Date: Fri, 7 Jun 2013 22:05:43 +0300
From: Felipe Balbi <balbi@ti.com>
To: Grygorii Strashko <grygorii.strashko@ti.com>
CC: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH 3/5] i2c: omap: handle all irqs befor unblocking
 omap_i2c_xfer_msg()
Message-ID: <20130607190543.GD15295@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
 <1370630768-4077-4-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SFyWQ0h3ruR435lw"
Content-Disposition: inline
In-Reply-To: <1370630768-4077-4-git-send-email-grygorii.strashko@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--SFyWQ0h3ruR435lw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 07, 2013 at 09:46:06PM +0300, Grygorii Strashko wrote:
> ARDY|NACK and ARDY|AL are set together in OMAP_I2C_STAT_REG, which will be

Have you seen that happen ever ? AL is Arbitration Lost, we never put
OMAP in a multi-master environment before.

ARDY | NACK I also find it a bit hard for those two to happen together
since ARDY will be set when you can change controller's register
*again*, mening that a transfer has completed.

Also, we need to follow what the programming model says. And, I don't
have docs with me right now, but IIRC it tells us to bail out if any of
the error conditions are met.

--=20
balbi

--SFyWQ0h3ruR435lw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRsi8HAAoJEIaOsuA1yqRELAgP/joYRVxoz4XuBODyelCVUVIG
dw9OOtolUyaBhLUgDybfvvl9C1QDvb6bRB2m5sn1WpNBYUe7HTyc7rfr6X5ka7Wh
xUSeUP3LMqV3gJKt7yhMPJXvj2TeLfKH+6HSSh3RFu0lvvimPZ+o7CTeMTEXJCYo
XghUGa8mvoRPxqpOdazeWfvhbOXibzhYGIMZK9CxV1lEW/NKMp/QhuX+QSku4zZ2
N0zTO0tcSbdleQYtNdkdiVxNuAbS7Oimlfj9cSUkY2V+Tknw6dRA085LtEKvBtv2
BYxc0zOdTf4n+KTDgzEeWHWXo8GaiohwSe0SSptmXjLcaMlguX1blyXBTYgDnJg5
cqlMBppMWZkLHZvXU8fYdn0SMXyftrzvadQ7GyjQoTTeFWSY3yKAjEGsbS0HG6l8
ZVvLUhpkUtaLXns5DKbnd3LXEvpeADkzz2GKX1r3l+i7ZlQMO/woeEMtig5SLh/K
+7tR717CoPz3Cr9QmAffK4JysFPPNLDjUcN1gy3oJrmd53rp77XCOA/AwgHvU7J9
SXyxj6r8Tv4fU0Kz6HAqNiB5g/Y5xKZq7Rz99uHL5TkgRMvgcBNNzD/gDO7a5UYe
ptQxaSbQMDYlSN7Q3IajYBcq14g1fdD6tyZ82hDn0Q6ZY1NNThigXGRZQobGHNJe
Kd2PpvRVxGesarmCARDP
=zHoN
-----END PGP SIGNATURE-----

--SFyWQ0h3ruR435lw--
