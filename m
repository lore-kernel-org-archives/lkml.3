Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967630Ab3HILoc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 07:44:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34520 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934248Ab3HILob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:44:31 -0400
Date: Fri, 9 Aug 2013 12:44:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20130809114426.GZ6427@sirena.org.uk>
References: <5204BFC7.4090106@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z8fvYVVi1MVTXPE1"
Content-Disposition: inline
In-Reply-To: <5204BFC7.4090106@nsn.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] regmap: flat: use the cache_present bitmap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z8fvYVVi1MVTXPE1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 12:09:11PM +0200, Ionut Nicu wrote:
> As opposed to the other regmap cache implementations,
> regcache_flat didn't use the cache_present bitmap for
> figuring out whether a register was cached or not, nor
> did it mark a register as present in the cache when
> regcache_flat_write() was called.

> This caused incorrect behaviour, such as returning
> value 0 for non-volatile registers without first reading
> their value from the device and storing it in the cache.

The goal with the flat cache is to do as little work as possible for
things like memory mapped devices where the cache operations are
actually noticable in comparison with the I/O costs.  I would therefore
exapect that anything using the flat cache would want to ensure that the
cache is fully populated at init time, reading back from the device if
nothing else (by setting num_reg_defaults_raw but not providing values),
rather than do additional operations in the data path.

--z8fvYVVi1MVTXPE1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBNYXAAoJELSic+t+oim9LioQAJVAGE13aXWkdSKq7DGTV+F1
b5c61ISk7Ysofp6D/dA7BKJ2CnNwDuEvTJiGuRvjr1PJfoseQuEzzKJwleG29bxq
Q17Jw1LMFf+Ep7Z1sGvcsnGt5k+aw75wt5NTFmCv9zIh/Sy9gJhOpqXLaWAiWJs2
3BHWczwlOUfPP9RhkqoSqQnz2fFCC6veipKJrYirdxTDX/yroTNq2EifGY4zfdML
mqHrxNYo3hCocYRb/nBVidIFcx6AS4FIXGCujUiHY3ODdQLQEvByozk+xRU60bKt
bQ6+nsFZWyTbY6Z5dPgornMN7SkGBLM3TFYKpmoEVZr5r9QMLyZzrzYKXOqHeq0q
XAaZPLVBIabTnbIWdFxxW7NOnrF0KhQi8ezirYjxX8/cDiP8hxWLhbviiwHX+Rdp
zDL9w/qTuLri9Jbe9b2e7nAPfzEXm9mi21yexO15E8TBYwXbFtosw9L6/xhxazhC
y1NNxgq/jHNBfvAqT9i0QR8A592E/CD8tlRk3Sih+yk2hadIF27qEaXuSPDZbOIQ
tD/EANoiELlQfVvShKM+N1LEkpwJcGtZTU9NMYlsm4m1dkDCXu76XYJF68idzAxH
Wl4f4NVAiQqwi+t5D/Qz7IjaFcDqvMsqZbfiP7O4bRK9jLJh8ghFPNZbonzi/T3T
vNXvsRfuHBefjnxKxgGn
=n+Dx
-----END PGP SIGNATURE-----

--z8fvYVVi1MVTXPE1--
