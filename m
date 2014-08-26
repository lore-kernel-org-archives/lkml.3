Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144AbaHZIta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 04:49:30 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60762 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934037AbaHZIt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 04:49:27 -0400
Date: Tue, 26 Aug 2014 10:49:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Jon Loeliger <jdl@jdl.com>, Mark Rutland <mark.rutland@arm.com>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140826084922.GG17263@ulmo>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
 <20140514141914.446F7C4153D@trevor.secretlab.ca>
 <20140821140211.GD19293@ulmo.nvidia.com>
 <53F64624.5000403@ahsoftware.de>
 <20140822131919.GX21734@leverpostej>
 <20140825093931.GB2399@ulmo>
 <E1XLu15-0002DP-6o@jdl.com>
 <20140825133714.GH4163@ulmo.nvidia.com>
 <20140826084208.AE5F0C40989@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTZ8bGhNySVQ9LYl"
Content-Disposition: inline
In-Reply-To: <20140826084208.AE5F0C40989@trevor.secretlab.ca>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UTZ8bGhNySVQ9LYl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 09:42:08AM +0100, Grant Likely wrote:
> On Mon, 25 Aug 2014 15:37:16 +0200, Thierry Reding <thierry.reding@gmail.=
com> wrote:
[...]
> > There are somewhat standardized bindings for the above and especially
> > for bindings of the type that clocks implement this is trivial. We can
> > simply iterate over each (phandle, specifier) tuple and check that the
> > corresponding clock provider can be resolved (which typically means that
> > it's been registered with the common clock framework).
> >=20
> > For regulators (and regulator-like bindings) the problem is somewhat
> > more difficult because they property names are not standardized. One way
> > to solve this would be to look for property names with a -supply suffix,
> > but that could obviously lead to false positives. One alternative that I
> > think could eliminate this would be to explicitly list dependencies in
> > drivers. This would allow core code to step through such a list and
> > resolve the (phandle, specifier) tuples.
>=20
> False positives and negatives may not actually be a problem. It is
> suboptimal, certainly, but it shouldn't outright break the kernel.

There could be cases where some random integer in a cell could be
interpreted as a phandle and resolve to a struct device_node. I suppose
it might be unlikely, but not impossible, that the device_node could
even match a device in the correct subsystem and you'd get a wrong
dependency. Granted, a wrong dependency may not be catastrophic in that
it won't lead to a crash, but it could lead to various kinds of
weirdness and hard to diagnose problems.

Thierry

--UTZ8bGhNySVQ9LYl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/EoSAAoJEN0jrNd/PrOhIdgQAJqaVIyBb472+KcPmbk9iH8Z
vQBg9uMfX66v+zvanycOpe0NCa7JHoxCOCTu5t8XWKd+8md9t0P87xjDKgOP2XZE
sZSTUpcLrZABWUjwULjNfPdo3osmlMHOfnqL7Mgyi509PGuCMVLW9cpjUJt9W6Vb
8OahWkFt1h2oZlYYR/EI/TcrbuzyfK6a7oSUOsA0A9YfY4X0xovFkxuhSpFVF+C0
IxkwPMQZX5/rCxzoPQXBgcn14mYkmRS5Sc+by1PtLKPkvzZnXHpNkRDavEz3Zqv2
sx1RvMNeGpMJdIajY8XafRniwsTMt7sIRjjcQhrn247hCJyJ/kKjjRgrVeS/r4Ld
rZ+Ftynq6kZRxQ4ULDZFFry1QZB14Fp8Bx2vAkO6opbeGlLy/wEHFQaQDfv3sfDG
7yS7q3Vzrj2UBjNp76aqO5IeD3TAlA3O/XyYD9KSgTEezLDPbrOcfELuEhGm3B8+
UH5xMzx5TvIy8rbNNdSBA5tiIC7r6fDd3+YfQ+N8ZpqMmruD6Qxzr/bD2SU8+ZwL
p9wR8AA5lFoLYSNVRqsH5liotJt0zTbsZ+UNqPojb2Ai9Fbv4SUKWDPQ5wcZEh/b
9bBE3cw4/hbjWGlIF2n8jSZysh2+8qPeiRaWdOWxQm3AXK2GU5v96tflz4FRK+DI
aMnpkwTIRudbJ3m298vR
=OhnR
-----END PGP SIGNATURE-----

--UTZ8bGhNySVQ9LYl--
