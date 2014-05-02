Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaEBQKu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:10:50 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41924 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaEBQKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:10:48 -0400
Date: Fri, 2 May 2014 11:10:42 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: gadget: giveback request if start transfer
 fail
Message-ID: <20140502161042.GO4631@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140501063608.GA30575@intel.com>
 <20140430195829.GA3839@saruman.home>
 <20140501204452.GD30575@intel.com>
 <20140501151328.GB6355@saruman.home>
 <20140503040541.GC19925@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hSZb4FHl1C2xfsUy"
Content-Disposition: inline
In-Reply-To: <20140503040541.GC19925@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--hSZb4FHl1C2xfsUy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, May 03, 2014 at 12:05:41AM -0400, Zhuang Jin Can wrote:
> On Thu, May 01, 2014 at 10:13:28AM -0500, Felipe Balbi wrote:
> > On Thu, May 01, 2014 at 04:44:52PM -0400, Zhuang Jin Can wrote:
> > > On Wed, Apr 30, 2014 at 02:58:29PM -0500, Felipe Balbi wrote:
> > > > On Thu, May 01, 2014 at 02:36:08AM -0400, Zhuang Jin Can wrote:
> > > > > At least we should giveback the current request to the
> > > > > gadget. Otherwise, the gadget will be stuck without knowing
> > > > > anything.
> > > > >=20
> > > > > It was oberved that the failure can happen if the request is
> > > > > queued when the run/stop bit of controller is not set.
> > > >=20
> > > > why is your gadget queueing any requests before calling ->udc_start=
() ?
> > > >=20
> > > > A better question, what modification have you done to udc-core.c wh=
ich
> > > > broke this ? udc-core *always* calls ->udc_start() by the time you =
load
> > > > a gadget driver so this case will *never* happen. Whatever modifica=
tion
> > > > you did, broke this assumption and I will *not* accept this patch
> > > > because the bug is elsewhere and *not* in mainline kernel.
> > > >=20
> > > It's found in Android using kernel 3.10.20. Android has its own
> > > usb_composite_driver usb/gadget/android.c (not in mainline), and it
> >=20
> > so you found something on an old kernel using an out-of-tree gadget
> > driver.
> >=20
> > > allows userspace to disconnect the pullup (i.e clear run/stop bit in =
dwc3)
> > > and remove the gadget functions like adb, mtp and then add new functi=
ons
> > > like rndis, acm. The problem is when you disconnect the pullup, a gad=
get
> > > maybe in the middle of queuing a request, and result in the "start
> > > transfer cmd failure". I think this is also a common issue for other
> >=20
> > Android gadget needs to learn how to cope with that.
> >=20
> Agree.
>=20
> > > usb_composite_drivers too. Normally, if one of the gadget deactivate =
its
> > > own function, the pullup will be disconnected, other gadgets won't get
> > > notified until their requests are failed. So it makes dwc3 more robust
> > > to deal with these situations.
> >=20
> > Right, but Android gadget can run on top of several other UDCs and you
> > want to have a single one of them cope with android's bug ?
> >=20
> > You'd be better off getting google to accept a bugfix to the android
> > gadget, since that's where the problem lies.
> >=20
> I agree. I'll try to push the fix to google.

alright, thanks

> It's really hard to fix the race condition (for me), as any gadget or
> /sys/class/udc/soft_connect can just disconnect the pullup anytime they
> want. The only thing I can do is giving back the request to the
> gadget if the condition happens.

even in that case, gadget driver's ->disconnect() will be called and
that should be enough to tell the gadget driver 'hey, don't queue
anything right now because you're not talking to any host'.

cheers

--=20
balbi

--hSZb4FHl1C2xfsUy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTY8OCAAoJEIaOsuA1yqREPKkP/ROo3uo6B4fIwAH9Eyf/7yA1
3B1hXtynRf9WlfObxNxz0XpvhoYER/MpwEL2MLSNQJEG1JWgM49i9nO7cOEJOKEy
4g/otLRAZFRZssXS93dBuFTf3Xl2RIzNqdhtoerE0Gzk70hpGziP0qI10UxPEpSR
2o93EB02ImSOMaM0+UrAQJo1x4oOUarfu85NOpna2wB2C8MaoxeG+BVZkXxoxcIt
cB58gMux8Jy/wcWvdsSpwaG++KmNT6YE84jL5gyTikKsv5uaq5TloJBnXgzaGJcd
kIdZW1MgAqt7rbQNF8cS1wVFxKjKK8gYdIFthqp/QAlChp6Z8+b0Itt6zpUmUZFi
Tn/ESk53vslmspZWFFKz6CsYjWCffaRD96QJKH80K+sHNiMYw3CzMxT585QaWsFd
klHEZrEXw/27sOhy5d9IaZ/KaD/k4In0uKHLXZZM+TMitwgW4h8hGtw2Q3lufjEp
pgJj64wyoWRj4ut+SIIHMXqRRQfL6MPVQf+iCEb/VQQaF8VXZkwItISHg1qEwNoC
bkETreCZDcr955XDG8+nTtmRtgbceY1bbIALPIqLDP1X3bNTBBYzx5KrybBkTnQr
WQn4+a2fmqtKIZ/gGexhTfLaeHXRePVa8l5F/vAE4qVNWCVGy/WmFIeqaA7nEITO
Iam6hCoUEO46is7F+1P0
=Y6Ev
-----END PGP SIGNATURE-----

--hSZb4FHl1C2xfsUy--
