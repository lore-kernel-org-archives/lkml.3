Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab3FLT7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 15:59:25 -0400
Received: from mail-bk0-f43.google.com ([209.85.214.43]:63890 "EHLO
	mail-bk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3FLT7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 15:59:22 -0400
Date: Wed, 12 Jun 2013 21:59:18 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] pwm: Fill in missing .owner fields
Message-ID: <20130612195917.GA31835@mithrandir>
References: <1371036553-32263-1-git-send-email-thierry.reding@gmail.com>
 <CAK9yfHyUT7KUkY3g2WJ7XiisLL5mvJuenv=UEK_9OqwfF7s4Zg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
In-Reply-To: <CAK9yfHyUT7KUkY3g2WJ7XiisLL5mvJuenv=UEK_9OqwfF7s4Zg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 12, 2013 at 05:05:18PM +0530, Sachin Kamat wrote:
> Hi Thierry,
>=20
> On 12 June 2013 16:59, Thierry Reding <thierry.reding@gmail.com> wrote:
> > Some drivers don't set the .owner fields of the struct device_driver or
> > struct pwm_ops, which causes the module usage count to become wrong.
>=20
>=20
> Recently a patch [1] was added to solve this issue of missing .owner
> fileds in struct platform_driver.

Yes I saw that, but thought it might be good to initialize them anyway.
Especially since a couple of the drivers are I2C and I believe there's
no similar patch for those. It shouldn't be difficult to come up with
the corresponding patch, though.

I wonder if it'd make sense to remove all the explicit assignments of
=2Eowner =3D THIS_MODULE in platform drivers once the patch you mentioned
has been merged. Cc'ing Greg to find out what he thinks about it.

> Probably something similar could be done for struct pwm_ops too?

Possibly. The issue isn't quite as bad in the PWM subsystem since I'm
now aware of the problem and will look for it specifically in the
future. It's a different matter for struct device_driver since that's
used all over the place.

Thierry

> [1] https://patchwork.kernel.org/patch/2612961/
>=20
> --=20
> With warm regards,
> Sachin

--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuNMVAAoJEN0jrNd/PrOhHKIP/Ar6oOexcWa7CP95Gm3c2n0T
hA3cw5vNcvOE++lWIir4G/5M4VCFMTvd/b//lYWdyccWiQZmXFj8Pwq1VmpTnFvA
1b4fJJtDckycENXGikMQJOMw6t67u7a+qdZ5Njxi1RuWoCKO2S/mjReOwaZ6SsEn
Esn7iIMlmlEWUPLDODSLnkGNEUg3Sw/TmJqSahw8/tbnPjI+Ujz2F8KJyZDrzJhu
4i1wdRhd3f28JLziHhvg6kbormh3n5Kznf0ksCc91H9r+GtxahMozd9qnIF2aeCu
9nBV1mJitEQV+2HSzadHrkugWALruWYE/Q/OSxKh297dpySU4jgTU50JaO6N7jsx
7WG4xdWENMw1TsHZIvc/He1QKWyIFlZFpnnfW36Mh87FYF9ABpycXohc4n3n2cWx
XGX10qM2eI/9A8AGNg8PYg9S5Ic1sWO+ALum6HxFxQZ9PXj8vbq8GSDnnGqGJ+4a
wpru/75iwsg3ONkNTn6OF+HMtkUEpZBqaDTCUo2nHKC3z7yeLzS+3u6+IPMyXGtq
l2XzOuD5jG4E6ZVJW7Y5MKBXJ5dUMBUyEQPBIUIB2X8ghhFRKdcpO9ucIFlX3FXT
wvlCwVZWXCIyvbis5Hb1x812XIo1TuXmf9lIiOglvAgDX8YfpqOUPiGdq8A87qgD
58l2fruNMs869NZnpDg2
=aOYT
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
