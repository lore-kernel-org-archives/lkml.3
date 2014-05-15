Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaEOCdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 22:33:39 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:46806 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbaEOCdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 22:33:38 -0400
X-Greylist: delayed 714 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 May 2014 22:33:38 EDT
Message-ID: <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: LXC development mailing-list <lxc-devel@lists.linuxcontainers.org>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jens Axboe <axboe@kernel.dk>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 22:17:31 -0400
In-Reply-To: <20140515013245.GA1764@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-xwE/0EVYjC+gonao3CxK"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4F2HefI025457
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1400725065.55664@YcKm71YsGuPSDMyRe8DcSQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xwE/0EVYjC+gonao3CxK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-05-14 at 18:32 -0700, Greg Kroah-Hartman wrote:
> On Wed, May 14, 2014 at 04:34:48PM -0500, Seth Forshee wrote:
> > Unpriveleged containers cannot run mknod, making it difficult to suppor=
t
> > devices which appear at runtime.

> Wait.

> Why would you even want a container to see a "new" device?  That's the
> whole point, your container should see a "clean" system, not the "this
> USB device was just plugged in" system.  Otherwise, how are you going to
> even tell that container a new device showed up?  Are you now going to
> add udev support in containers?  Hah, no.

Oooo...  I can answer that...  Tell me if you've heard this one
before...  (You have back in NOLA last summer)...

I use a USB sharing device that controls a multiport USB serial device
controlling serial consoles to 16 servers and shared between 4
controlling servers.  The sharing control port (a USB HID device) should
be shared between designated containers so that any designated container
owner can "request" a console to one of the other servers (yeah, I know
there can be contention but that's the way the cookie crumbles - most of
the time it's on the master host).  Once they get the sharing device's
attention, they "lose" that HID control device (it disappears from /dev
entirely) and they gain only their designated USBtty{n} device for their
console.  Dynamic devices at their finest.

I worked out a way of dealing with it using udev rules in the host and
shifting devices using subdirectories in /dev.  I got the infrastructure
implemented but didn't finish the specific udev rules.

> > Using devtmpfs is one possible
> > solution, and it would have the added benefit of making container setup
> > simpler. But simply letting containers mount devtmpfs isn't sufficient
> > since the container may need to see a different, more limited set of
> > devices, and because different environments making modifications to
> > the filesystem could lead to conflicts.
> >=20
> > This series solves these problems by assigning devices to user
> > namespaces. Each device has an "owner" namespace which specifies which
> > devtmpfs mount the device should appear in as well allowing priveleged
> > operations on the device from that namespace. This defaults to
> > init_user_ns. There's also an ns_global flag to indicate a device shoul=
d
> > appear in all devtmpfs mounts.

> I'd strongly argue that this isn't even a "problem" at all.  And, as I
> said at the Plumbers conference last year, adding namespaces to devices
> isn't going to happen, sorry.  Please don't continue down this path.

I was just mentioning that to Serge just a week or so ago reminding him
of what you told all of us face to face back then.  We were having a
discussion over loop devices into containers and this topic came up.

> greg k-h

Regards,
Mike
--=20
Michael H. Warfield (AI4NB) | (770) 978-7061 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0x674627FF        | possible worlds.  A pessimist is sure of it!


--=-xwE/0EVYjC+gonao3CxK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3Qjw8DrlnVnRif/AQjJhAf/V7/DjdThOkci5Pk0jQoijhtl8+7LYQV1
vRP/l65/Ys4zMqqOI+XUJxzGn4MFn42YmiJCVLqSzTH8ZYSEz02OlIckJBYhenjt
tNyNeqOuu2qeFbF/ZA3E0Gj9pE1Ybvp+T9TEusjWvZLGZNJaA9o6HM2NpVE+uYFi
qo0iwD7AbTDJSxkIguARrLkabnAiO+e2dAATZNqq+6FsB5sNJiqcgDtY0bnE4oXo
zjEfOwBLhz9t3K0Yw7rbsiTD9QHPRZjyNCxnemUHYaf45uQ6nvXRva7oo+YsJWFd
eIGCkrTpLJZ/6m3CC23DKBDNkNc7mbH9KXVvSuvRVRip6bcOizXELQ==
=YK7z
-----END PGP SIGNATURE-----

--=-xwE/0EVYjC+gonao3CxK--

