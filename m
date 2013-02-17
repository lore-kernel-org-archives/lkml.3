Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751105Ab3BQQXs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 11:23:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42365 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750994Ab3BQQXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 11:23:47 -0500
Date: Sun, 17 Feb 2013 16:23:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <zonque@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: regmap: Question about devices with unequal register sizes
Message-ID: <20130217162337.GB1583@opensource.wolfsonmicro.com>
References: <511FBBF7.2020103@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <511FBBF7.2020103@gmail.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 16, 2013 at 06:03:51PM +0100, Daniel Mack wrote:

> The register layout is described on page 26, and they call their
> registers 'subaddresses'. Up to sub-address 0x1c, I see no problem
> mapping that to a simple 8-bit regmap layout, but above that, access
> gets trickier because registers change their sizes, which breaks the cache.

The regmap I/O code isn't making any effort to support such devices, the
hardware is just too crazy to worry about.  The best you can do is use
the no-bus support and open code your physical I/O so you can still use
the cache.

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRIQPnAAoJELSic+t+oim9FesQAI6r708lNs23ZkpNThTHypKr
o6D+lKctcRXMtkciLxIEfJkOa58w6EL3LX2zNyI/9dmcaklWWgHynEATmJMH92QK
X7JT7kibS+ddkYgNtZUyxC1cxA8oQjBnhRvL+oIQAlnJmbe2PYMq+3zic3YOeeEx
54VyFlbmFhRhSv44v4eMxCE06TainQHy3How/hzIiFRQP5pVyhGN5J9psWH1JqVN
kw1A4r8H45NsKtX6FM6tlD4yxviESL2udkFQ/74g48hGnwJLbvmcxWLpRDW74Eud
+tV0vHBFSBVc+gfuaIh22Csv/EHbIu3EuO3jGo9O2yQ0eoAxfKboV7PY5GiLwbeq
xik3MzMOElR/3/J5JNT0ETbMMJChXrQT900ueyEXaoDihpUZtFDEA1HfmKjuoOi9
y2UiHUPUlcAaxpf6mlyNb+35iC/7NYiYh3PqEnA+ZuHemHsM5dessI8R8niPTLzh
Pojihq0o1GWOh90agVvHlBn0LNK4Rdc5yAx5QFFm812RiCyh4KcRWqPA6cikZag3
vEl8IOc2IXxD5M4lsjg6LMoF40hiwbmK2e5W6gMh3tTE/JSLj4zyDvnwbhwLFRNV
Bcw62pIrmZ+qHRWtmnn4A9ybMkQ2b0uiCcBGhh3dNEfiVzRo7O8ocjOOoXY4zu2f
fs4GsrGRGkT0bqaorn7g
=dQWk
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
