Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932206AbaJGR5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:57:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48423 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881AbaJGR5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:57:24 -0400
Date: Tue, 7 Oct 2014 12:57:13 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
Message-ID: <20141007175713.GA16781@saruman>
Reply-To: <balbi@ti.com>
References: <20141007165149.GT24720@saruman>
 <Pine.LNX.4.44L0.1410071310550.1504-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1410071310550.1504-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 01:15:32PM -0400, Alan Stern wrote:
> > > Here also I agree. Zombie mode should "mock" the function until first
> > > next enumeration or unbind. It should not be possible to bind gadget
> > > with function in zombie mode to UDC. Zombie mode should "pretend" only
> > > as long as gadget is bound and enumerated.
> >=20
> > Not really. We shouldn't even coonect to host until adbd is running.
> > Now, when adbd crashes we fix adbd. If it gets killed due to OOM we
> > can't even say "ok, we'll buffer USB requests until adbd is restarted"
> > because, well, we're running out of memory.
> >=20
> > So, OOM we can't fix. Soon enough, another daemon (mtpd, ptpd, whatever)
> > will be killed and another function will be left unusable.
> >=20
> > As for adbd/mtpd/ptpd crashes, those need to fixed and kernel should not
> > have to deal with them in any way.
>=20
> It seems to me that we should imitate what an ordinary USB device would
> do.  If part of the firmware crashes, generally you would expect none
> of the endpoints associated with that function to work.  Either they
> refuse to accept output from the host or they stall everything.  But
> endpoints associated with other parts of the firmware might very well
> continue to work okay.

dunno, I have never seen a USB device firmware crash and I don't think
anybody deliberately does anything to make sure other parts of the
device work. If it _does_ work, I'd assume it's really by chance.

> Don't buffer requests.  Either allow the internal FIFOs to fill up or
> else reject everything.  Any reasonable host will start getting timeout
> expirations and will realize that something is wrong.

Right, but if we allow this, I can already see folks abusing to connect
to the host early and only when necessary do some trickery to e.g. start
adbd (not saying Android will do this, just using it as an easy
example).

Sure, we can deactivate and only activate when files are opened but is
there any guarantee that when a process receives segfault that we will
have, from FFS point of view, any information to know that the thing
crashed ? I mean, a userland application can register its own handler
for SIGSEGV/SIGKILL, right ? And that handler could very well just call
close() on all file descriptors. Then how do we differentiate a normal
close() from a "oh-crap-I-died" close() ?

--=20
balbi

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNCl5AAoJEIaOsuA1yqRErSsP/335Kmp+OeKYGsIviBRoULLv
q99LWAZprlSEzuv+L8tymxXtRv04P3ZJ90CuCUSW5xgiUDl6ckXKkIYANF2HVoWm
G25WJINDEULOIj49wdjdwSpJpdFPr+o57PZWSHHHqvSegx8wuv6BBrnaTqchNI9J
/WTCbNe72SAU7bDQNBpUYakgDkbJP/5bgUxH/raiFJZaEA7ObIWndgaB7JfC7EwW
PLSy0FyPOtsTMt1IL07NvtnR/GtA95KcM/D0rNyD0Ss+1/NFB+b87ZQ/k/NlfDRw
2+iXoD0WYIhBbyrKuinsv48tn6XLSmuLVwN/eDBzmA4rLapNBtefBrJEgEPZxBgs
ZxbGMVklFK4G4RC6/QAa6jH43l4Ku5J/fBkGhwwaKuooAePBkE8yFlG9sY4oeZOr
YOwxe72C3Xqi/RCGiG3S6AdGVVHmnKz2NbWxrXWJv5Ct5rAOKRK2fgNY8u75NOmR
ZystpRxtNWjJuGybUsYGbavQu1wKwwQKuQ+872qUl2ZFvC6pBlOMWxmjgcCgZAPn
ZdgOO2OpGw5bqNsUkfh9DJ/vitz17RUdaujP2XfviwNFTbZ1v7tuED4TYO7rSr35
oHpQjfF77slS5NePztpWsofHIOcn4+polTjmggPYJ9aXtZCVKQ9TxVM4uGmCKCcf
8AXztIe/k5xRAK29fvCC
=kfxx
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
