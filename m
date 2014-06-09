Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934749AbaFIW5h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:57:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34567 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932990AbaFIW5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:57:35 -0400
Date: Mon, 9 Jun 2014 23:57:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Marcel Ziswiler <marcel@ziswiler.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, thierry.reding@gmail.com,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, stefan@agner.ch
Message-ID: <20140609225707.GB5099@sirena.org.uk>
References: <c5522b0efcbfc7690dcde6aaf78b9dd568f99604.1401665237.git.marcel@ziswiler.com>
 <39a8704a4c8170d6b0620a1e5e44042eae6d8810.1401665237.git.marcel@ziswiler.com>
 <538CA24B.1010602@wwwdotorg.org>
 <538CA635.4050502@ziswiler.com>
 <20140602221627.GP31751@sirena.org.uk>
 <538D64FD.2010909@ziswiler.com>
 <20140603094537.GQ31751@sirena.org.uk>
 <538EBACB.70100@ziswiler.com>
 <20140604111755.GG2520@sirena.org.uk>
 <5396322D.6030003@ziswiler.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTRY+exx+ndMGui/"
Content-Disposition: inline
In-Reply-To: <5396322D.6030003@ziswiler.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] arm: tegra: enable igb, stmpe, i2c chardev, spidev,
 lm95245, pwm leds
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTRY+exx+ndMGui/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 12:16:13AM +0200, Marcel Ziswiler wrote:
> On 06/04/2014 01:17 PM, Mark Brown wrote:

> >You're saying you're controlling it from userspace.  This is a
> >particular detail of what you are doing in your system.  You happen to
> >want to control the devices you are hanging off the system with
> >userspace drivers but that's just what you're doing right now.

> Sorry, I don't get it. Yes, spidev is to control stuff from user space just
> like i2c-dev however bad that might sound.

There is absolutely nothing wrong with that.  What there is a problem
with is putting that implementation detail into a device tree, if
someone comes along and writes an in kernel driver for the same device
the device tree needs to continue to work without modification as it is
an ABI.

> >No, that's in the controller node - the chip selects are described
> >there.  The child node references a chip select number that the master
> >has and describes what's connected to that chip select.

> Well, unfortunately SPI without any chip select is just plain simply
> useless. It won't work.

I'm sorry but I'm not seeing how that follows on from what I said?

> >It's a perfectly fine way of controlling things from userspace if that's
> >a sensible way of controlling devices but that does not mean you should
> >describe it in the device tree in that fashion.

> Only that without describing such a chip select in the device tree spidev
> won't ever work.

Again I'm not sure how that follows.  To repeat, the chip selects are
described on the SPI controller and referenced by the child devices when
they are instantiated by chip select number.  Please refer to the SPI
bindings if this is unclear, or be specific in what is unclear.

--dTRY+exx+ndMGui/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTljvAAAoJELSic+t+oim9An0P/3RxzDx9GwZPbpmuH40ISZuL
s/+IAqMR4LHBxTzyfKrwLNAfJIdlNhgDGdoIugWSMHac9s0wGuCYY8ZdZtG10jQs
lhLgX6ukE6QP9foEXYGWTvID9/97NQVc41e/qCBkD3xQ43gfI3A4uKvMsjEPCbuf
IAOwzPY0HPTVEbgcJGhusyRG4NspSR5RtjD/+kzviOk6N2VJLZjUFLkuxtxQ+aN1
BLK12fYari6/KEPEPkh4hnpd5RjXESixlqiMWqBByGcQ/hijJaJra7y70yJQQnzN
bt2E65VC6j9yUnKraS3GkjZ3Zv9haQEJit0dmNcC/C9NqZcHqhFS9xTs8oO6MhMq
cGo9RYYUoQ62nGLNcEPmVg88aMaE8LDjJBk5ER+GKVXnKV05jGyn+29Ncv2cjoaW
oTgvpaQH8f7Tle43zrhp5p71bACGDfSEQANpOtzk+68I48nT3/gB3V5DOEuUsZr9
Km+OubEnrZNbtpXBSixGjfxqdQsAfXGlD7VdmNC31HpRCcKTIdGN4232PBYEgvSz
7pztw5UCDl2wySKGW338781o/8kgfxuVFVL2Ah+vAL+ocO8jafbMpMTIH4hasIMx
2lu6fv5uylbPc1q5I04zeE0p7ZtMMnjTVfXThLPDkaq82PkLwQP3mbe9PZOtm1B8
KwaN876TZxBEGFt3uu0Q
=EnxH
-----END PGP SIGNATURE-----

--dTRY+exx+ndMGui/--
