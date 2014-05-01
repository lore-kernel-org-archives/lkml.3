Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932090AbaEAPNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:13:33 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:60435 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062AbaEAPNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:13:31 -0400
Date: Thu, 1 May 2014 10:13:28 -0500
From: Felipe Balbi <balbi@ti.com>
To: Zhuang Jin Can <jin.can.zhuang@intel.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Cohen <david.a.cohen@linux.intel.com>
Subject: Re: [PATCH] usb: dwc3: gadget: giveback request if start transfer
 fail
Message-ID: <20140501151328.GB6355@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140501063608.GA30575@intel.com>
 <20140430195829.GA3839@saruman.home>
 <20140501204452.GD30575@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <20140501204452.GD30575@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, May 01, 2014 at 04:44:52PM -0400, Zhuang Jin Can wrote:
> On Wed, Apr 30, 2014 at 02:58:29PM -0500, Felipe Balbi wrote:
> > On Thu, May 01, 2014 at 02:36:08AM -0400, Zhuang Jin Can wrote:
> > > At least we should giveback the current request to the
> > > gadget. Otherwise, the gadget will be stuck without knowing
> > > anything.
> > >=20
> > > It was oberved that the failure can happen if the request is
> > > queued when the run/stop bit of controller is not set.
> >=20
> > why is your gadget queueing any requests before calling ->udc_start() ?
> >=20
> > A better question, what modification have you done to udc-core.c which
> > broke this ? udc-core *always* calls ->udc_start() by the time you load
> > a gadget driver so this case will *never* happen. Whatever modification
> > you did, broke this assumption and I will *not* accept this patch
> > because the bug is elsewhere and *not* in mainline kernel.
> >=20
> It's found in Android using kernel 3.10.20. Android has its own
> usb_composite_driver usb/gadget/android.c (not in mainline), and it

so you found something on an old kernel using an out-of-tree gadget
driver.

> allows userspace to disconnect the pullup (i.e clear run/stop bit in dwc3)
> and remove the gadget functions like adb, mtp and then add new functions
> like rndis, acm. The problem is when you disconnect the pullup, a gadget
> maybe in the middle of queuing a request, and result in the "start
> transfer cmd failure". I think this is also a common issue for other

Android gadget needs to learn how to cope with that.

> usb_composite_drivers too. Normally, if one of the gadget deactivate its
> own function, the pullup will be disconnected, other gadgets won't get
> notified until their requests are failed. So it makes dwc3 more robust
> to deal with these situations.

Right, but Android gadget can run on top of several other UDCs and you
want to have a single one of them cope with android's bug ?

You'd be better off getting google to accept a bugfix to the android
gadget, since that's where the problem lies.

--=20
balbi

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTYmSYAAoJEIaOsuA1yqRES5AQALZg0XKhhTipPYgcoUUDnkP2
oV354oGahLfm/96geEYmKyUAdDKP6RicOz6R8AjCeRBwAH2Fg/56sHZ83hYBeY6K
Bpb/6/H2VnwNIHIntKnt8flkERkw4pO8QJfY4hsyMCT/7IyN6cYTXSO5N3CZ5pI3
5PKv0GJgPd0LKfyaTo49sgWu6iaFMmgeNdUoHRfL+enOxBCwwd69vcLdcS9U7IP8
sXnDcr6JagxDC9cAt7jvSBrHVfk2XAOHnXZ9WUHtoATz7oD11F1xmkxKhowK2ztM
AESu8rylBcK68bmt5+vPC4+I1G5tLg0xE6l2PvgTamAazDX4uR8G40D26FIl80lS
Tw8LCfUAHq0LFJQD7QVNXXrwxCgKRAEvR8Ipf1B1ZGsI5pPflK1Bi4MlGeqpEqzL
DPrH19P3dw8gjkaZ/RFZ/U9BHiM3Ynqvz32jMeYmnZMUrVYQ37lFcPO+6EmJm1my
+w+UfBbsL9S17IAT1KXCcQwd60YqSTvVupyw3L1D9LRxQYorflPORXlFVAo1Y4E/
t7i9kPOkbDDhvqCe9ejPMg9uIiZZsjsHJD7rgXycEc3elYg6hi0F4k8qJmtHwqDG
ZLmHDIclyk185hlBnmUIYevnvOl7kj62Zq5ZyAi7dCtDtFBQbiWRCnPZPz2BAkq/
FEjLb8+83LHlfoZiYwR0
=DE1I
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
