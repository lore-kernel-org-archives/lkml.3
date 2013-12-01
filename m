Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab3LAJrg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 04:47:36 -0500
Received: from mail-bk0-f51.google.com ([209.85.214.51]:45468 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357Ab3LAJrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 04:47:33 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not a security problem
Date: Sun, 1 Dec 2013 10:47:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        sre@ring0.de, omar.ramirez@copitl.com, tony@atomide.com,
        felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com, ohad@wizery.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, nico@ngolde.de
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl> <20131130225822.GA26031@amd.pavel.ucw.cz> <20131201034501.GA10803@kroah.com>
In-Reply-To: <20131201034501.GA10803@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2384527.IylTJQFWFc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312011047.30468@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2384527.IylTJQFWFc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 01 December 2013 04:45:01 Greg KH wrote:
> On Sat, Nov 30, 2013 at 11:58:23PM +0100, Pavel Machek wrote:
> > On Sat 2013-11-30 14:05:53, Greg KH wrote:
> > > On Sat, Nov 30, 2013 at 09:42:37PM +0100, Pavel Machek wrote:
> > > > mmap in tidspbridge is missing range-checks. For now,
> > > > make this interface root-only, so that it does not
> > > > cause security problems.
> > >=20
> > > Please fix this properly and don't paper over the real
> > > problem here.
> >=20
> > Well, if the driver is left uncompilable, I'm pretty sure it
> > will bitrot.
> >=20
> > I do have the hardware, but I'm pretty sure current mailine
> > does not have enough support to boot Maemo, so it is non
> > trivial for me to test changes here.
> >=20
> > And yes, I'd like to get N900 to better shape, but there's
> > more urgent work to do there. Such as "make sure N900 still
> > boots once omap moves away from device files".
> >=20
> > [It seems like check should be that
> >=20
> > vma->vm_pgoff << PAGE_SHIFT >=3D pdata->phys_mempool_base and
> > vma->vm_end - vma->vm_start + (vma->vm_pgoff << PAGE_SHIFT -
> > pdata->phys_mempool_base) <=3D pdata->phys_mempool_size .
> >=20
> > But... this is some kind of DSP coprocessor, and I am not
> > sure if just exposing its address space to untrusted
> > processes is good idea.
> >=20
> > Heck, are you sure this is security problem in the first
> > place? Yes, it is unchecked mmap. So what? If the device is
> > 600 root.root, and if the DSP can take over main system,
> >=20
> >         if (!capable(CAP_SYS_RAWIO))
> >        =20
> >                 return -EPERM;
>=20
> Will that break userspace?  Who opens and mmaps this device?=20
> If you don't know if users do this, how can you say this
> patch isn't going to break things just as much as not having
> the driver there at all?
>=20
> thanks,
>=20
> greg k-h

Maemo and harmattan userspace using gst-dsp (gstreamer plugin)
for using tidspbridge. It opening /dev/DspBridge and then it calling:

mmap(NULL, seg->size, PROT_READ | PROT_WRITE, MAP_SHARED | 0x2000 /* MAP_LO=
CKED */, handle, seg->base_pa);

Because it is gstreamer plugin, every application can use it (under non roo=
t too).

Can you check if above problematic kernel code is what this gst-dsp mmap ca=
lling?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2384527.IylTJQFWFc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKbBbIACgkQi/DJPQPkQ1JcpgCeIS0xkAmTi0NArwVBBqooxnSS
ROMAn3aggkvPhTrhrYTA6HzQPZ494eT5
=HiQM
-----END PGP SIGNATURE-----

--nextPart2384527.IylTJQFWFc--
