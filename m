Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaGaLkc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:40:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:36033 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbaGaLkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:40:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,771,1400050800"; 
   d="asc'?scan'208";a="581659152"
Message-ID: <1406806772.18327.14.camel@intelbox>
Subject: Re: [Intel-gfx] [BUG?] 3.16-rc6 ... at
 drivers/gpu/drm/i915/intel_pm.c:5997 intel_display_power_put+0x12d/0x160()
From: Imre Deak <imre.deak@intel.com>
Reply-To: imre.deak@intel.com
To: Ian Kumlien <ian.kumlien@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        intel-gfx@lists.freedesktop.org
Date: Thu, 31 Jul 2014 14:39:32 +0300
In-Reply-To: <1406753579.31042.1.camel@gmail.com>
References: <1406158393.13064.1.camel@gmail.com>
	 <1406280517.17325.3.camel@intelbox> <1406753579.31042.1.camel@gmail.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-pynzEJKgtWAgyKTkJL8l"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pynzEJKgtWAgyKTkJL8l
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-07-30 at 22:52 +0200, Ian Kumlien wrote:
> Sorry for the delay, it's been damned hot - vacation is over and
> overtime has been all the rage at work...

No problem, thanks for the feedback.

> On fre, 2014-07-25 at 12:28 +0300, Imre Deak wrote:
> > On Thu, 2014-07-24 at 01:33 +0200, Ian Kumlien wrote:
> > > Try four, now including CC lists for the intel driver...
> >=20
> > Could you give a try to the 2 patches at:
> > https://patchwork.kernel.org/patch/4437061/
>=20
> Didn't quite get that it was two separate patches at first, but when i
> did i also spotted a v2 of the patch set.
>=20
> I applied:
> https://patchwork.kernel.org/patch/4648961/
> https://patchwork.kernel.org/patch/4648951/
>=20
> On to 3.16-rc7 (there was some fuzz but it applied fine)
>=20
> I didn't see any OOPS:es (didn't scroll around too much) but otoh the
> screen never turned off? (it's one of those silly mac things, the apple
> is still lit) and the machine doesn't "suspend/sleep" anymore.
>=20
> AFAIR it does, after some coaxing, on the unpatched kernel (ie, not the
> first time but the second time i turn down the lid, i tried three times
> and play:ed with brightness as i assume you can see in the log)

Hm, I can't see how these patches could prevent system suspend. Also
according to the dmesg you sent suspend didn't even start, so I guess
you're seeing a separate issue. Maybe the lid notification isn't
properly handled, but I can't really help tracking that down.

In any case to reproduce the particular bug in question (or see if the
fix works) you need to get the machine to suspend/resume somehow. One
way is to 'echo mem > /sys/power/state' as root and resume by pressing
power button or similar; could you still try this, again sending the
dmesg?

Thanks,
Imre


--=-pynzEJKgtWAgyKTkJL8l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQEcBAABAgAGBQJT2ir0AAoJEORIIAnNuWDFy4YIAPQ877LD2hOVSRWhZz4dSY28
IC1yzMJFCCmeSdZrvd16WaGr5DD33GJwjyr8Kf+00ud/e6rl1s9E/Fm7JrsPNT2i
tlIA/0zAiUbFNRiuag5EKwlSRCi/abbz0sjGGO+e5yHY7PcWj7w42KR0JETsuWzs
HZBUNYE2RIanJrisW5D3NvTcrkguPfb5fmI4YXbld/hz3sX5tF3Bl+bMWajl0Ye7
dX2SIuVmQIdCGqVHrkYX0oUnHC+FEkVc9NuhsrSFf8E9GVE9NibmkcGqH40yGLkZ
3fmpjiB4/EkPIxbuP/fTsIQQnzzo1TCV5OJrziNnFKy7vm4/iePS2bBjcQ0kJVI=
=dV2S
-----END PGP SIGNATURE-----

--=-pynzEJKgtWAgyKTkJL8l--

