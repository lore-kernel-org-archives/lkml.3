Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaE0CoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 22:44:12 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:55022 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaE0CoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 22:44:09 -0400
Message-ID: <1401158362.7572.138.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 11/11] loop: Allow priveleged operations
 for root in the namespace which owns a device
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Marian Marinov <mm@1h.com>, Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 26 May 2014 22:39:22 -0400
In-Reply-To: <20140527013634.GA3524@mail.hallyn.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <1400103299-144589-12-git-send-email-seth.forshee@canonical.com>
	 <537EE129.1020603@1h.com> <20140526091614.GA13666@ubuntu-mba51>
	 <1401118325.7572.82.camel@canyon.ip6.wittsend.com>
	 <20140527013634.GA3524@mail.hallyn.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-pXpgdNorLKyAfXhH9rg6"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4R2dNMA028766
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1401763170.63373@FLkMklkL6gzJGxzat8FWrw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pXpgdNorLKyAfXhH9rg6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-05-27 at 03:36 +0200, Serge E. Hallyn wrote:
> Quoting Michael H. Warfield (mhw@WittsEnd.com):
> > On Mon, 2014-05-26 at 11:16 +0200, Seth Forshee wrote:
> > > On Fri, May 23, 2014 at 08:48:25AM +0300, Marian Marinov wrote:
> > > > -----BEGIN PGP SIGNED MESSAGE-----
> > > > Hash: SHA1
> > > >=20
> > > > One question about this patch.
> > > >=20
> > > > Why don't you use the devices cgroup check if the root user in that=
 namespace is allowed to use this device?
> > > >=20
> > > > This way you can be sure that the root in that namespace can not ac=
cess devices to which the host system did not gave
> > > > him access to.
> >=20
> > > That might be possible, but I don't want to require something on the
> > > host to whitelist the device for the container. Then loop would need =
to
> > > automatically add the device to devices.allow, which doesn't seem
> > > desirable to me. But I'm not entirely opposed to the idea if others
> > > think this is a better way to go.
> >=20
> > I don't see any safe way to avoid it.  The host has to be in control of
> > what devices can and can not be accessed by the container.

> Disagree.  loop%d is meaningless until it is attached to a file.  So
> whether a container can use loop2 vs loop9 is meaningless.  The point
> of Seth's loopfs as I understood it is that the container simply gets a
> unique (not visible to host or any other containers) set of loop devices
> which it can attach to files which it owns.  So long as the host can't
> see the container's loop devices (i.e. so it unwittently mounts it when
> looking for a particular UUID for /var), it won't get fooled by them.

> So in this case *if* we can do it, a purely namespaced approach - meaning
> that we restrict visibility of a particular loopdev to one container - is
> perfect. =20

And in that "*if" is a cloud that says "then a miracle occurs" and that
miracle needs a lot more detail.  How that translates into what is and
is not visible and what can be mimiced in a container becomes important
(to say nothing of notifying its udev).  I think this loopfs thing is
the answer for the loop device case, we just need to clear up those
details and exorcise the devils we find in them.  The loop devices are
unique while they strangely seem to work with minimal leakage already
(all meta data at this time).

Seth remarked that, maybe, he's not paranoid enough.  You know that I'm
a well trained professional paranoid and I accept if people think I'm
overly paranoid (is that even possible?).  Even paranoids have enemies
and just because you're paranoid it doesn't mean they're not out to get
you.  While I admit that total isolation is virtually (excuse the pun)
impossible that doesn't mean I don't strive to maximize the isolation
and analyze the possibilities and consequences of compromise.

As I stated, "I don't see any way to avoid it".  I would love to be
proven wrong.  It would permit my life to be so much more easy.  But how
can we allow this without the host in control of it and directing things
to the containers?  A container may request something and the host can
grant it but the container should not be capable of demanding a device
over and above the control of the host.  How do we define the rules that
say what a container can do and what it cannot do without it involving
knowledge in the host (whitelisting as Seth call's it) of what is and is
not allowed in the container?

We already have the problem that the container devices.allow and
devices.deny are major and minor based, which we know is fundamentally
flawed in a udev environment.  We specify major:minor in the
configuration files as if they are cast in cement (which they are in all
common cases) but they are not in the general case.  Greg K-H hammers on
this frequently.

The loop devices are unique and deserve a unique solution, I'll agree.
But I'm also comfortable that the host should have rules and procedures
to whitelist hard devices and loop devices and manage their transfer
and/or sharing into the containers.

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-pXpgdNorLKyAfXhH9rg6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU4P62sDrlnVnRif/AQiYjwf+PfWJZBO7GpcUX2RVsrgoOowIGaOyqrUO
J+rVo41UsQNigubnOxl2crTk/aGYHBf4mRns9IVqHoOxlWfd6SLIkv6Sn6aWMXFu
M3tS+FqP0zDA9colXRVphvN4z+LnynYWe34aNuR6f90x94OX1qBclZng5cg3UhI3
NdjAX7Q9iYWHmyHZ39Ml2OMfK4yaWce0JdN9pWG+3XJO0MSANDfaUbLLCOw4AIdn
sC8dBcyWm1mVf3Ab5zeR2fFG1X6w8LP0BxtSqgR3klsQsXyB9o72HfFSlJn2NRYw
1vhtIRpuzkvU5aRm9dggOx2Rkv8Tqt7DZhZGlbWxrz5jD/wOt4aoGQ==
=RmAS
-----END PGP SIGNATURE-----

--=-pXpgdNorLKyAfXhH9rg6--

