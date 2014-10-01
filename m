Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752163AbaJAPYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:24:05 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:59012 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaJAPYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:24:02 -0400
Date: Wed, 1 Oct 2014 17:23:58 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>
Subject: Re: [PATCH v3 00/17] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20141001152356.GA15818@ulmo>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <3359318.XmOCYLZHTV@wuerfel>
 <20140929082323.GE12506@ulmo>
 <2012641.4eaGXZM5vo@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
In-Reply-To: <2012641.4eaGXZM5vo@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 11:50:13AM +0200, Arnd Bergmann wrote:
> On Monday 29 September 2014 10:23:25 Thierry Reding wrote:
> >=20
> > How about if I keep iterating this series? It seems like most failures
> > can be reproduced by doing ARM defconfig and allmodconfig builds, so
> > I'll do those and fix up any issues I find. Hopefully I can squash all
> > these before 3.18-rc1, then we can take it into linux-next early for
> > 3.19? In the meantime perhaps I can work with Olof to get a branch with
> > these patches tested on his builder? And perhaps on the 0-day builder in
> > addition?
>=20
> Yes, definitely!
>=20
> Note that I saw a lot of problems only in randconfig build tests but
> not in any of the default configurations. I'll send you the fixup patch
> soon so you can integrate that in your series.

One of the things I've seen a lot is warnings about volatile being
ignored. This is caused by my latest series dropping the volatile
keyword for the I/O accessors. The rationale being that use of volatile
should be an implementation detail of the accessors rather than the
function signature.

Unfortunately there seems to be a *lot* of code in the kernel that uses
volatile where it probably doesn't make sense. In fact all the warnings
that I've been getting are from code that uses I/O accessors on the I/O
memory, hence shouldn't have to worry about volatile. See also
Documentation/volatile-considered-harmful.txt.

Given the massive amount of changes needed to remove these warnings, is
it better to just keep the volatile keyword even if it's clearly wrong
in the context of the I/O accessors? Or should we bite the bullet and
remove all the wrong uses while at it?

I suppose if we decide to remove them we can always make that a separate
patch series.

Thierry

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJULByMAAoJEN0jrNd/PrOho90P/RcMHIyjDFLGcSHrraNPDdds
KPjvcXrlb/s2KLlLPeXdPboHvWlOXo7cMsumQimzfvMt+YC/y3y/Scp6K12WNOVX
SalNJuKXkMwQscSoAyLe5R1Q158vNxHTZWwSc2M0brCQmO6gD5S521LDMGAktiCS
gf/S0hNm9k3agSZnY1uuw/HjnhS1cl0cqh5vA4AcBcuMvz9jj9j0xgZYw1lY8fDq
AqkVcZhsFIYISpUZOgc0XXps8nbMDybqemvWeXcs5BX1WMLFYUOKRDrLtHAGa34c
bbS/Wo1j06kTWT+JJ0zDbnayo5mDFgm5B3CkJXMxKVEwOiStt5G2YM1NwO+1WXB0
aj2eim+Xm9hBauQz8rtrtlepDik/CDTax4H9/aAMEbhqQv47qCKUVdoNLnlaz/5o
Mb6slFPiboMUvUqVtJGj0iNLnPJTG2pdjQO+borMU/O7MKqQpJgji9QHKrCRf5qN
OEFG5r9hsFMLF2oKTuvkTEvoArJtx6yz7GivKH5g6EhQiBTgNYWMk6sDijhM+zYZ
rjtx2P9kJNxRz0nu2VlC3Gv6nvkRLqk76DOLKc2A80NtLFkVVUt+ATzSb3Ixc++D
ga5buevGSp2PBbPqCM68742lNN5zf4SIf0h3Viu9X4h9GAXqo+inPQb6w0xk/BWu
tDMieplUsD4FRli5F/s7
=LpfC
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
