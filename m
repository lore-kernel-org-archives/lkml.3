Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaGNIPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:15:37 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42909 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbaGNIPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:15:32 -0400
Date: Mon, 14 Jul 2014 10:15:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5/8] of: Add Tegra124 EMC bindings
Message-ID: <20140714081524.GI2081@ulmo>
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
 <1405088313-20048-6-git-send-email-mperttunen@nvidia.com>
 <20140711145146.GA6523@ulmo>
 <53C00A57.5070102@kapsi.fi>
 <53C38D07.4030402@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G3juXO9GfR42w+sw"
Content-Disposition: inline
In-Reply-To: <53C38D07.4030402@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G3juXO9GfR42w+sw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 10:55:51AM +0300, Mikko Perttunen wrote:
> On 11/07/14 19:01, Mikko Perttunen wrote:
> >On 07/11/2014 05:51 PM, Thierry Reding wrote:
> >>On Fri, Jul 11, 2014 at 05:18:30PM +0300, Mikko Perttunen wrote:
> >>>...
> >>...
> >
> >In this case, all the registers that will be written are such that the
> >MC driver will never need to write them. They are shadowed registers,
> >meaning that all writes are stored and are only effective starting from
> >the next time the EMC rate change state machine is activated, so writing
> >them from anywhere except than the EMC driver would be pointless.
> >
> >I can find two users of these registers in downstream:
> >1) mc.c saves and loads them on suspend/restore (I don't know why, that
> >shouldn't do anything. They will be overridden anyway during the next
> >EMC rate change).
> >2) tegra12x_la.c reads MC_EMEM_ARB_MISC0 during a core_initcall to
> >calculate a value which it then writes to a register that is also
> >shadowed and that is part of downstream burst registers so that doesn't
> >do anything either.
> >
> >The reason I implemented two ways to specify the MC register area was
> >that this could be merged before an MC driver and retain
> >backwards-compatibility after the MC driver arrives.
> >
> >If this is not acceptable, we can certainly wait for the MC driver to be
> >merged first. (Although with the general rate of things, I hope I won't
> >be back at school at that point..) I assume that this is blocked on the
> >IOMMU bindings discussion? In that case, there are several options: the
> >MC driver could have its own tables for each EMC rate or we could just
> >make the EMC tables global (i.e. not under the EMC node). In any case,
> >the MC driver would need to implement a function that would just write
> >these values but be guaranteed to not do anything else, since that could
> >cause nasty things during the EMC rate change sequence.
>=20
> Having taken another look at the code, I don't think the MC driver could =
do
> anything that bad. There are also two other places where the EMC driver
> needs to read MC registers: Inside the sequence, it reads a register but
> discards its contents. According to comments, this acts as a memory barri=
er,
> probably for the preceding step that writes into MC memory. If the regist=
er
> writes are moved to the MC driver, it could also handle that. In another
> place it reads the number of RAM modules from a MC register. The MC driver
> could export this as another function.

Exporting this functionality from the MC driver is the right thing to do
in my opinion.

> That said, I still suspect it might not be worth it to divide this between
> two drivers.

If we don't separate, then we make it easy for people to break things in
the future. Both drivers may not be accessing the same registers now,
but if there's no barrier in place to actively enforce this split, then
it's only a matter of time before it gets broken. A typical way to
ensure this is done properly is via request_resource() (called by the
devm_ioremap_resource() function). That will fail if two drivers try to
use the same memory region, and with good reason.

Thierry

--G3juXO9GfR42w+sw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTw5GcAAoJEN0jrNd/PrOhCZIQALFRtXCpN1vSJdh6HOtM1i2C
ElDEF1Qev+GaZMM3T5Qr/4+3keLHINqiyynCgh0H/nyRh4G8Q4KkRaxLz7rcQ++a
A4VMndmmA9viyx9z9+UFhpolsSI5rrdTjiYUzW1pHz92V/2yrt1VFF6vt4v3fKqY
Ms8OesISjY8Y3JKalhqt0bO9llpo+kIiPprGABkIFGV7lSMZjiNEwQoITQUOfhsd
iHnD0Xr+uPpBg0jXT4MBbAahcDHnsamhFZh4KIIxg3HZME8VY28kE1Ysa/ZuMkQ4
vrh8FyBE4T8UvZij+2oOBRlVY86PmQ5F+opa3skzos/CGAf1LVZJ8hr4Pf02gFuF
3VjNuwZiHHyRN01fn096MSwg+9aFMtVfLfzrMTyS10Nz67/BNu9MHn9L7EDR1LFE
2tV303yo8FK0W9aEQrgnMrKPnN5PoxROU456BENPF/E4PtLbkOLRcoe4WAL/2j78
HqADUlCvN19p4RQUsnz0s5Yl2LN+XE8b7sKEwndwjtY5+qS0YzphjuFpqleNuapO
TLYQOhj1joxqXune25g9bCtE2Zh0uTxE1TNET0hSSqd/X/PBeLDxuaFupAtZG9Xa
MApgFyyBV5/ANJI7Sdm6H34qcWTou44kwg501jUgYcjbmifg86Fz/vwc8370FLeQ
+fYPykPP5QSES8VWV4F8
=4UeU
-----END PGP SIGNATURE-----

--G3juXO9GfR42w+sw--
