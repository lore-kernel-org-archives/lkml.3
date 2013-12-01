Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3LALdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Dec 2013 06:33:50 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49012 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab3LALdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Dec 2013 06:33:45 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [patch] Staging: tidspbridge: make mmap root-only so it is not a security problem
Date: Sun, 1 Dec 2013 12:33:41 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ivajlo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        =?utf-8?q?=D0=98=D0=B2=D0=B0=D0=B9=D0=BB=D0=BE?=
	 =?utf-8?q?_=D0=94=D0=B8=D0=BC=D0=B8=D1=82=D1=80=D0=BE=D0=B2?= 
	<freemangordon@abv.bg>,
        sre@ring0.de, omar.ramirez@copitl.com, tony@atomide.com,
        felipe.contreras@gmail.com, s-anna@ti.com, nm@ti.com, ohad@wizery.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org, nico@ngolde.de
References: <6662B6F95D1C4783A007CAC82A8DA641@ivogl> <20131201034501.GA10803@kroah.com> <20131201112610.GA19791@amd.pavel.ucw.cz>
In-Reply-To: <20131201112610.GA19791@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2324707.1fnfYfEOIv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312011233.41989@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2324707.1fnfYfEOIv
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 01 December 2013 12:26:10 Pavel Machek wrote:
> Hi!
>=20
> On Sat 2013-11-30 19:45:01, Greg KH wrote:
> > On Sat, Nov 30, 2013 at 11:58:23PM +0100, Pavel Machek wrote:
> > > On Sat 2013-11-30 14:05:53, Greg KH wrote:
> > > > On Sat, Nov 30, 2013 at 09:42:37PM +0100, Pavel Machek=20
wrote:
> > > > > mmap in tidspbridge is missing range-checks. For now,
> > > > > make this interface root-only, so that it does not
> > > > > cause security problems.
> > > >=20
> > > > Please fix this properly and don't paper over the real
> > > > problem here.
> > >=20
> > > Well, if the driver is left uncompilable, I'm pretty sure
> > > it will bitrot.
> > >=20
> > > I do have the hardware, but I'm pretty sure current
> > > mailine does not have enough support to boot Maemo, so it
> > > is non trivial for me to test changes here.
> > >=20
> > > And yes, I'd like to get N900 to better shape, but there's
> > > more urgent work to do there. Such as "make sure N900
> > > still boots once omap moves away from device files".
> > >=20
> > > [It seems like check should be that
> > >=20
> > > vma->vm_pgoff << PAGE_SHIFT >=3D pdata->phys_mempool_base
> > > and vma->vm_end - vma->vm_start + (vma->vm_pgoff <<
> > > PAGE_SHIFT - pdata->phys_mempool_base) <=3D
> > > pdata->phys_mempool_size .
> > >=20
> > > But... this is some kind of DSP coprocessor, and I am not
> > > sure if just exposing its address space to untrusted
> > > processes is good idea.
> > >=20
> > > Heck, are you sure this is security problem in the first
> > > place? Yes, it is unchecked mmap. So what? If the device
> > > is 600 root.root, and if the DSP can take over main
> > > system,
> > >=20
> > >         if (!capable(CAP_SYS_RAWIO))
> > >        =20
> > >                 return -EPERM;
> >=20
> > Will that break userspace?  Who opens and mmaps this device?
> >  If you don't know if users do this, how can you say this
> > patch isn't going to break things just as much as not
> > having the driver there at all?
>=20
> On maemo, /dev/DspBridge is mode 666. I tried looking up with
> fuser who might use it, but that one does not seem to work on
> maemo.
>=20

Hi! See my previous email. gst-dsp plugin using /dev/DspBridge,=20
so any application which using gstreamer for viewing videos will=20
use it. Try for example builtin media player and some h264 video=20
with low resolution. Or directly gst-launch.

> So yes, this would "break" existing users... OTOH maemo does
> not work on mainline kernels, and never did. (Maemo is not
> open source).
>=20

If you apply some patches to kernel and also userspace, you can=20
run Maemo with (patched) upstream kernel. Just install CSSU devel=20
and kernel patches from linux-n900 tree. Then you can test it.

> Anyway, tell me what you prefer. We seem to have chicken and
> egg problem here... I can create the patch but not test it.
>=20
> 								Pavel

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2324707.1fnfYfEOIv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKbHpUACgkQi/DJPQPkQ1IGZgCfZM4Kfd7tG8TPtDPcf9iM0wyK
QOMAoJ5s/4vIQJDb3YYM981zMtSsex6E
=Wd5l
-----END PGP SIGNATURE-----

--nextPart2324707.1fnfYfEOIv--
