Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab3FBN1l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 09:27:41 -0400
Received: from 162-17-110-37-static.hfc.comcastbusiness.net ([162.17.110.37]:43608
	"EHLO stuffed.shaftnet.org" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751247Ab3FBN1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 09:27:36 -0400
Date: Sun, 2 Jun 2013 09:27:21 -0400
From: Solomon Peachy <pizza@shaftnet.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, "John W. Linville" <linville@tuxdriver.com>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        Ajitpal Singh <ajitpal.singh@stericsson.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cw1200: fix some obvious mistakes
Message-ID: <20130602132721.GB3875@shaftnet.org>
References: <1370126241-2528420-1-git-send-email-arnd@arndb.de>
 <20130602122954.GA3875@shaftnet.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f2QGlHpHGjS2mn6Y"
Content-Disposition: inline
In-Reply-To: <20130602122954.GA3875@shaftnet.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--f2QGlHpHGjS2mn6Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 02, 2013 at 08:29:54AM -0400, Solomon Peachy wrote:
> > * Add comments about passing GPIO numbers in platform_data:
> >   You should not use IORESOURCE_IO, which is for legacy ISA
> >   I/O ports on PCs, not for GPIOs.
>=20
> Fair enough.  The use of resources was something already in the driver=20
> when I inherited it, but I've seen this pattern a lot elsewhere.  Is=20
> there a specific driver I should reference instead?

Reading linux/ioport.h I don't see a type that seems to be a better fit.
It's not MEM, REG, IRQ, DMA, or BUS.  IO seems to be the only type that=20
fits.

The reason the driver uses struct resources instead of straight-up=20
numeric GPIO fields is for the 'name' field in the resources.=20

Given that the use of platform_data pretty much makes it impossible to=20
have more than one of these devices in a system at a time, there doesn't=20
seem to be a point to using named resources.

So I'll change these resource lists to using straight-up ints.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Delray Beach, FL                          ^^ (email/xmpp) ^^
Quidquid latine dictum sit, altum viditur.

--f2QGlHpHGjS2mn6Y
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iD8DBQFRq0g5PuLgii2759ARApvBAKCxR2BKY8faoJHAa/pQ7griEJY9fACg52zH
LdvP9EyQ3uhrh0CfOSL5gF4=
=BIQk
-----END PGP SIGNATURE-----

--f2QGlHpHGjS2mn6Y--
