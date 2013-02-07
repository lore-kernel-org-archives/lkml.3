Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758368Ab3BGMap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 07:30:45 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38959 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab3BGMan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 07:30:43 -0500
Message-ID: <51139E63.2030302@ti.com>
Date: Thu, 7 Feb 2013 14:30:27 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Clark <robdclark@gmail.com>, <linux-arm-kernel@lists.infradead.org>,
        <patches@linaro.org>, <linux-kernel@vger.kernel.org>, <arm@kernel.org>,
        Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] OMAPDSS: enable omapdss for ARCH_MULTIPLATFORM
References: <1358891160-9534-1-git-send-email-robdclark@gmail.com> <3969096.QosOfOb9QT@wuerfel> <511392B0.4040409@ti.com> <201302071155.12565.arnd@arndb.de>
In-Reply-To: <201302071155.12565.arnd@arndb.de>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enig130366AC9C2C8C21C382B3A5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enig130366AC9C2C8C21C382B3A5
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2013-02-07 13:55, Arnd Bergmann wrote:

> omapdrm still has the 'select' statement in it if you only send the
> first patch, so it should not be possible to disable omapdss when
> it is actually needed.

Yes, you're right. After adding ARCH_MULTIPLATFORM, the kconfig enables
omapdss fully even if enabled by select. So select is only a problem if
omapdss is enabled when omapdss's dependencies are missing.

> I suggested doing only the minimum that is needed to unbreak the
> allyesconfig build, which is to enable just omapdss but not omapfb
> and the displays, in case they don't actually build on anything else.

omapfb and the displays build also fine on all platforms. But it's true
that they are not needed to fix allyesconfig.

> I would suggest only the first patch, since Linus quite specifically
> asked only for serious bug fixes. I think an allyesconfig build
> breakage is serious enough, but doing multiple patches for one
> bug should not be necessary and is much harder to justify.

Well, as I see, the bug is omapdrm using "select", not "depends on". So
if I'd have to pick one patch, I'd send 0003. That would fix allyesconfig=
=2E

Applying only 0003 means that omapdrm (and omapdss) won't be built on
ARCH_MULTIPLATFORM, but building omapdrm on ARCH_MULTIPLATFORM is a
feature added in this merge window, so leaving it out is not a regression=
=2E

But I'm not sure if I'm being overly pedantic here. Patch 0001 would fix
allyesconfig, and allow building omapdrm with ARCH_MULTIPLATFORM.
However, the fixing there happens as a side effect, and so the 0001
patch isn't even called a "fix" in its subject. That's the reason I'm a
bit reluctant with the 0001 patch as a fix.

 Tomi



--------------enig130366AC9C2C8C21C382B3A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJRE55jAAoJEPo9qoy8lh71w+QP/35YWrYN4cI5mYlq1fybXu0d
JPFHgdvxwqcNx83AHhv6rImqgLBgiHaPxOBwzuY/c1i4LH71NO3mojrYD6esLt24
o3+H4kwnNUoCTUwfy6vC8AHXpDAGdh/VaKTrSAi0ccrnAvUTFWRp/icGjVeibmjR
mVtxmxo70dUNp8YFWLMZLYwZn25Ek0Xnk807yCfacniRAWLA72fKaa/JLeawSHzl
Av2jP6oWDEVt53SLlRXirb5O3oBUlT7CyxZwiD6aOIvnUDsZQ/q2CuzH/2ZLUssj
Arozyv3BqKuOQ28h4utxEoSiP5+3eBLW603TTjirodMInaH7UfGXTyUWQdQlbs4t
8BgvvP3dPygB7WIBBJKSgzH5Dig1qkcGLlTiud/pb8sMngJDUlZAOAQhyV09zDh4
OvFutXVBhu1/9szwk+EN/7KBEnwRMJfF976aJET/BLA76UyXHhfcr/e4jXh90wWp
zwBMnqS5LFySBBWq6gPbqniwTj3WjMNd8QpZCAk/sFrBqlsUmMBGfbMaKMdmR94u
hO+2yeEoOE4xPfi9c77DT45jAYnGaN1Ot1iBmatFSphUhwTNkbyTDSR/jjGoCo7w
JEarLIPKhtZGrnsfedqUEEXZzIsvXw6VxYB2nLLLjSdWkmm90BSQukf6Q/dZAOwN
RoXop9A5/yGk6bidxRUR
=vDkf
-----END PGP SIGNATURE-----

--------------enig130366AC9C2C8C21C382B3A5--
