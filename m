Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab3D3Jwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 05:52:54 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44479 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758972Ab3D3Jwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 05:52:53 -0400
Message-ID: <517F9472.2030106@ti.com>
Date: Tue, 30 Apr 2013 12:52:50 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>
CC: "Balbi, Felipe" <balbi@ti.com>
Subject: Kconfig "softdepends" idea
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2UTACVJFDKXJDPETFRMKN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2UTACVJFDKXJDPETFRMKN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

I have an idea to improve the Kconfig dependencies, especially for
subsystem maintainers. First a bit of history:

I recently changed the Kconfig rules for omapdss driver to not depend on
OMAP platform, as the driver itself uses no OMAP specific APIs, and can
be compiled fine on, say, x86.

This got nack'ed by Linus, as omapdss is used only on OMAP, and allowing
it to be visible for other platforms is just extra clutter. I think
that's a valid point.

However, I think there are valid cases to allow a driver to be compiled
for other platforms. First two are quite minor, but I think the third
one is a major use case. I say here "omapdss" but you can replace it
with any driver that has build dependency to some platform.

1) Building omapdss with arm compiler should show all relevant warnings,
but in reality it seems that the compilers for different architectures
have slightly different behaviors. Building omapdss with a compiler for
other architecture is a good way to check for any possible errors. Also,
direct arch dependencies in a driver are generally a mistake, and
compiling with another compiler would bring these issues up.

2) When developing a new SoC, the IP in question could be in a, say,
FPGA board, attached to a PC. The same driver would thus be needed for
x86 also.

3) When making changes which affect drivers for multiple platforms (say,
fbdev changes), it is very difficult to compile test the changes. I
recently made changes to a bunch of fb drivers, and I think I managed to
compile only a few of them. To compile them all, I'd need to install all
the various cross compilers and find out which kind of kernel config is
needed to get the driver enabled.

If, on the other hand, the drivers would only depend on things they need
to get compiled, it gets much easier to compile test.


So, my idea is to have a new kind of Kconfig dependency. I'll call it
"softdepends" in lack of better name. A driver maintainer could use
"softdepends on ARCH_OMAP", instead of "depends on ARCH_OMAP", to say
that this driver does not actually build depend on ARCH_OMAP, but for
all normal purposes it does.

Normally, this would result in the same behavior as the normal
"depends", and Linus would not get a questions whether he wants to
enable this OMAP specific driver or not, and the driver would not be
visible on the menuconfig.

But the user could enable the driver if he explicitly so wants. Perhaps
a Kconfig option such as "ignore softdepends", enabling of which would
allow the user to enable the drivers that use softdepends. Or, maybe
just require the user to add the config option manually into his .config.=


Now, I don't have much knowledge of the Kconfig internals, so the above
implementation ideas are just rough ideas to show the point.

Thoughts?

 Tomi


------enig2UTACVJFDKXJDPETFRMKN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRf5RyAAoJEPo9qoy8lh71q/QP/iLx04HLm16lbubNCPbqoDda
K+KKQZ+42pItBLOGl36tkWk48f+XRhxfy60izy6IrOzrVgHTyiIxTYz4d3ToFswl
tkxq8SSJS8mehr6/5sHb3vkzxWCKnLHUIJcSCKPJd12NNB3CE+onQzldlwONP7ER
i/Yppb9Puxj7fA9LUE1dNM0AMfun93lWiZlfmBDFyXojkpobc1yfxt7/XqYDhKDN
+vop+jufOQMeNUul8Ae/cZW2UrTiGarOmg4E60LUXFNz/27LXbzdWg/YxuFcLLxw
E7vakZDorYHW6cKkMqU8w1x6AyZWdkKLE6OBkvngGenl9Sp40WEYiAjg5/D3AXq2
7SAYIyWPQml2wzAKQOVgEDfvYgRQx8JBHT1/FbOLqKfK/ZqQU66b9oJm8R1OvVs/
3w3Ic+QD6xdEEi8HNqzWhczGjWorgqL+o6YYDs/ZgQE3QhyEl/1RCDlNY7a7md2y
WbDV+xDpNDTD8gJ9jeX4K5bwWWf/GXFpuKIi+ufvRQaikA7ZFs+Vfs/7jT+SlR8+
EXZ25CLwUXfHd/njTdJqwPESNy/UPRJt6Y/kIn2wE/pf+FB6IYDOlE8dH/IWldJe
oOXLB/q4Z1QT+e9gH3w1gQHRWcOiGYGxoxXPb7C+K8ujGbkWoUSgRt1DKx1ARcEv
BM1rZSo1lnzG0EsPLNHx
=wmE2
-----END PGP SIGNATURE-----

------enig2UTACVJFDKXJDPETFRMKN--
