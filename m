Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaJGS5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 14:57:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51118 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813AbaJGS5P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 14:57:15 -0400
Date: Tue, 7 Oct 2014 13:57:06 -0500
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Felipe Balbi <balbi@ti.com>, Krzysztof Opasiak <k.opasiak@samsung.com>,
        "'Robert Baldyga'" <r.baldyga@samsung.com>,
        <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <mina86@mina86.com>,
        <andrzej.p@samsung.com>
Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
Message-ID: <20141007185706.GC17409@saruman>
Reply-To: <balbi@ti.com>
References: <20141007175713.GA16781@saruman>
 <Pine.LNX.4.44L0.1410071429500.1504-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pAwQNkOnpTn9IO2O"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1410071429500.1504-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pAwQNkOnpTn9IO2O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 07, 2014 at 02:42:33PM -0400, Alan Stern wrote:
> > > It seems to me that we should imitate what an ordinary USB device wou=
ld
> > > do.  If part of the firmware crashes, generally you would expect none
> > > of the endpoints associated with that function to work.  Either they
> > > refuse to accept output from the host or they stall everything.  But
> > > endpoints associated with other parts of the firmware might very well
> > > continue to work okay.
> >=20
> > dunno, I have never seen a USB device firmware crash and I don't think
> > anybody deliberately does anything to make sure other parts of the
> > device work. If it _does_ work, I'd assume it's really by chance.
>=20
> I've seen it happen lots of times, but only on single-function devices. =
=20
> When it somes to multi-function devices, who knows?
>=20
> Still, with the single-function devices, firmware crashes generally=20
> don't lead to disconnections.  Sometimes they do, but usually they=20
> don't.
>=20
> > > Don't buffer requests.  Either allow the internal FIFOs to fill up or
> > > else reject everything.  Any reasonable host will start getting timeo=
ut
> > > expirations and will realize that something is wrong.
> >=20
> > Right, but if we allow this, I can already see folks abusing to connect
> > to the host early and only when necessary do some trickery to e.g. start
> > adbd (not saying Android will do this, just using it as an easy
> > example).
>=20
> We can still keep the pullup turned off until all the functions are
> ready.  That's a part of normal behavior -- unlike what happens when a
> userspace component crashes or is killed.
>=20
> > Sure, we can deactivate and only activate when files are opened but is
> > there any guarantee that when a process receives segfault that we will
> > have, from FFS point of view, any information to know that the thing
> > crashed ? I mean, a userland application can register its own handler
> > for SIGSEGV/SIGKILL, right ? And that handler could very well just call
> > close() on all file descriptors. Then how do we differentiate a normal
> > close() from a "oh-crap-I-died" close() ?
>=20
> We can't, so why worry about it?

because on close(), I want to disconnect data pullups :-) Everything has
been tore down and there's nothing else to do.

> If a file handle was closed for normal reasons then userspace probably=20
> in the middle of shutting down the gadget anyway.  If not then the=20
> user will get what they deserve.

yeah, I think the same way about a crashing functionfs daemon :-)

> If the file handle was closed for abnormal reasons, we can behave like=20
> crashed firmware.  Which means, in the end, doing the same thing as in=20
> the normal-reason case -- i.e., do nothing.  In particular, don't=20
> disconnect.
>=20
> If you want to allow for the possibility of orderly shutdown (and maybe=
=20
> even possible restart) of a userspace handler, the function library=20
> should first tell the kernel explicitly to disconnect.  Then function=20
> components can be changed around completely, and when everything is=20
> ready, userspace can tell the kernel to connect again.

I still feel iffy about it, but I must say I understand where you're
coming from. It's weird to force a disconnect, sure. I guess we could
accept this with a new option (just not 'zombie', perhaps no_disconnect
:-) but only if we still have the same "delay pullups until daemon is
running" requirement.

/me hides

--=20
balbi

--pAwQNkOnpTn9IO2O
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUNDeCAAoJEIaOsuA1yqREjHgP/iP/Dmc0TlqXxjw5rpPLkcRd
g7xjQ0Skn88oSpf8IjUassvDkdj5XsSnmqg9RYabDrc8fa0psY82srrpJ5wltbnM
zrXdmDmjXMvmg2y8tF+28+qClcJ8obGr2Kc2lzDHcOz06X3SmXGUxIKM9IyypOOT
L/rdjlPxlruYebtNNdub7np3DTjK/D6xRdaFRoCa26Eh++hPkh9bqP/3VroORdmA
YZEmjJYoA7yxUvdWh5goyam/H2+Rvf1/6D002KP3TKoACcaAsycSLFQG5i0+03uF
XRqb4GR9D1+AhQblGZ4sy3x/0O99XQZ6iW7oDkxj2mFer4KmRFuvtEA+9tBN57uU
bGWugKDAUBm/UAcxAW4S9dsVb0tvtzwfc49PpeW4mCVMeTRmi5tDz1XBnYuO29K6
5IznUasei1XHPdpeOPymoRUBM+nhPht/qhCs15I3GR8F37rKPJwoHYpdhe8qdv/r
T7kl6Vgw8zxWxM3EmOHkJXT2m6sOgVhpuKJ7dFsYzi6Rvk80l4dRNcM1z/I7JwZl
hiLajowMFLCIXLuqqx4Mh9+TS6PeO5nkCg1pZrPPgrEW+VsAAe2Lf3Etsm+7pjMJ
s4Ck+00p/AtV5hwab2TmuXgl7XCcsQhpzAOliSBJZleYKIkPSpv8sZyNuwD8j+re
P6R/9kNQkqY4EUDLHa0E
=Gt0N
-----END PGP SIGNATURE-----

--pAwQNkOnpTn9IO2O--
