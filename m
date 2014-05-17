Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbaEQNAF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 09:00:05 -0400
Received: from romulus.wittsend.com ([130.205.32.3]:54061 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbaEQNAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 09:00:03 -0400
Message-ID: <1400331458.3540.41.camel@canyon.ip6.wittsend.com>
Subject: Re: [lxc-devel] [RFC PATCH 00/11] Add support for devtmpfs in user
 namespaces
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Michael H.Warfield" <mhw@WittsEnd.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 17 May 2014 08:57:38 -0400
In-Reply-To: <20140516043532.GA14149@kroah.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
	 <20140515013245.GA1764@kroah.com>
	 <1400120251.7699.11.camel@canyon.ip6.wittsend.com>
	 <20140515031527.GA146352@ubuntu-hedt> <20140515040032.GA6702@kroah.com>
	 <1400161337.7699.33.camel@canyon.ip6.wittsend.com>
	 <20140515140856.GA17453@kroah.com> <20140515174254.GM21073@ubuntumail>
	 <20140515221551.GB13306@kroah.com> <20140516014959.GD22591@ubuntumail>
	 <20140516043532.GA14149@kroah.com>
Organization: Thaumaturgy & Speculums Technology
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-eZAbz0l7quROkwTMuJGN"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner-ID: s4HCvdug020476
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-SpamScore: s
X-WittsEnd-MailScanner-From: mhw@wittsend.com
X-WittsEnd-MailScanner-Watermark: 1400936267.86541@QPBVDOtQ2juZIhTpfiWNgA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eZAbz0l7quROkwTMuJGN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-05-15 at 21:35 -0700, Greg Kroah-Hartman wrote:
> On Fri, May 16, 2014 at 01:49:59AM +0000, Serge Hallyn wrote:
> > > I think having to pick and choose what device nodes you want in a
> > > container is a good thing.  Becides, you would have to do the same th=
ing
> > > in the kernel anyway, what's wrong with userspace making the decision
> > > here, especially as it knows exactly what it wants to do much more so
> > > than the kernel ever can.
> >=20
> > For 'real' devices that sounds sensible.  The thing about loop devices
> > is that we simply want to allow a container to say "give me a loop
> > device to use" and have it receive a unique loop device (or 3), without
> > having to pre-assign them.  I think that would be cleaner to do using
> > a pseudofs and loop-control device, rather than having to have a
> > daemon in userspace on the host farming those out in response to
> > some, I don't know, dbus request?

> I agree that loop devices would be nice to have in a container, and that
> the existing loop interface doesn't really lend itself to that.  So
> create a new type of thing that acts like a loop device in a container.
> But don't try to mess with the whole driver core just for a single type
> of device.

Yeah, a lot of dynamic devices (like serial devices) can be handled in
user space with the proviso that we could use some way to tickle udev
and hotplug in the container with events.

But the loop device is the real ugly duckling here.  It's a unique case
of an on-demand device with a shared control device that's not really
hot-plug and not really deterministic enough to be handled purely in
user space.  It presents unique challenges unto itself.

Makes sense to me.

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


--=-eZAbz0l7quROkwTMuJGN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEVAwUAU3dcw8DrlnVnRif/AQjCkAf/VSd1MQJOpj9YVpmiU7ygCAocio8Csppn
NxUoicMC78F9tv0vsXjS889QnhstQojNcxMyQsxQqug21CW6VdY3nyDTrfnxgF3b
vZ7ZOXoiM8EJI/mRa7A3kd3VAuh9PqJE2qnIfp/LBppnTu/PjRIoktJmaCO8Yiip
iat+LZiVQvn4JUHJNCKAXA9rvEi7ZZZmG/Pkgj4gfGozJrYLDGLicll0J8Dtvh/i
9T8NpKzWf5M57nslCbLLkBWkeUVpzjNb2t6FUoUdhX2MNiYkjEe1HperQGCl9JBY
czjNiXRwjwnaRm6yU0Q6Xe+XketT+4zLtgFjcjw363CrV5QhNaioFQ==
=LTnx
-----END PGP SIGNATURE-----

--=-eZAbz0l7quROkwTMuJGN--

