Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab3BKGo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 01:44:59 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:54974 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3BKGo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 01:44:58 -0500
Date: Mon, 11 Feb 2013 07:44:52 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: Arto Merilainen <amerilainen@nvidia.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5,RESEND 8/8] drm: tegra: Add gr2d device
Message-ID: <20130211064452.GA16676@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-9-git-send-email-tbergstrom@nvidia.com>
 <20130204125618.GD595@avionic-0098.mockup.avionic-design.de>
 <511095F9.6040607@nvidia.com>
 <20130205095403.GF20437@avionic-0098.mockup.avionic-design.de>
 <5112C9C5.8080205@nvidia.com>
 <20130208070734.GB15429@avionic-0098.mockup.avionic-design.de>
 <51183E8D.1090607@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <51183E8D.1090607@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:l9TExT8sNqbTsp8VcNMT8c3/L8NDd2inU78Nc2OS//i
 3vWTXnE1OAV1zflvK5n1F+Pq2H3cVAtotbqOF5abIkFRd1LbiU
 aPpol8u8bPCD4DyFMGt0eR2pCY7ZN0qjDhfsrgzL0mJg86Fboz
 JNugSmT1dw+wLx7+cP/xh5Jm1ET25DwMW6EQEpcExvGgMHY1XF
 wL/SQXpqVdyhtm/Ykjy8IyncqF0CGXMDNDNNuy2095iNC/zU+i
 Sevm0t7IArDEsNFelsnlFO8oyS4zHMaw66JFYBCAl9fvN/WuWb
 UfMNSKOiKNeYuOLsMbruqj1Xmw5D5g9E6XfA+6XhsOIPB3VqHM
 Zfj9Icm96x7u+ViQoX6YXZfJDec6x6s/YZ8/+388DC2qjdq3vR
 zr0a6h2YgqfZlA2uhVMXfAJ+3qp+hEpe4g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 10, 2013 at 04:42:53PM -0800, Terje Bergstr=C3=B6m wrote:
> On 07.02.2013 23:07, Thierry Reding wrote:
> > On Wed, Feb 06, 2013 at 01:23:17PM -0800, Terje Bergstr=C3=B6m wrote:
> >>>> That's the security firewall. It walks through each submit, and ensu=
res
> >>>> that each register write that writes an address, goes through the ho=
st1x
> >>>> reloc mechanism. This way user space cannot ask 2D to write to arbit=
rary
> >>>> memory locations.
> >>> I see. Can this be made more generic? Perhaps adding a table of valid
> >>> registers to the device and use a generic function to iterate over th=
at
> >>> instead of having to provide the same function for each client.
> >> For which one does gcc generate more efficient code? I've thought a
> >> switch-case statement might get compiled into something more efficient
> >> than a table lookup.
> >> But the rest of the code is generic - just the one function which
> >> compares against known address registers is specific to 2D.
> > Table lookup should be pretty fast. I wouldn't worry too much about
> > performance at this stage, though. Readability is more important in my
> > opinion. A lookup table is a lot more readable and reusable I think. If
> > it turns out that using a function is actually faster we can always
> > optimize later.
>=20
> You're right about performance. We already saw quite a bad performance
> hit with the current firewall, so we'll need to worry about performance
> later.

I guess the additional overhead of looking up in a table vs. an actual
function being run will be rather small compared to the total overhead
incurred by having the firewall in the first place.

> I'll take a look at converting the register list to a table. Instead of
> always doing a linear search of a table, a bitfield might be more
> appropriate.

I don't know. Just a plain table with register offsets seems a lot more
straightforward than a bitfield. In my opinion an array of offsets is a
lot more readable than a field of bits. Especially since you can't just
setup a bitfield easily with initialized values.

Thierry

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRGJNkAAoJEN0jrNd/PrOhaN4P+wQ2oLQaiDWjCPh7T/fVRYc2
E+dRsXBYb6KVTUdJ7wI5IekGsM8IOyzTHRQ+X8zgWdUPCou8mcDCTXcwzvWbR3vc
8BI0JjJ9A4CX0iZh1R8cqI9yNQVT1ntHQ7d+e4D9t0deZfyHqmW3W6ew+zdokJMO
BFoYqekBZXsAmAHmWdJBxtAMEREapc3o9crGkJrk2bZp4rHP8MEm+s+U4mtyPyf1
UPg7pP5LKacFOwYDGLtmpM22T5ZRCGSjD/q/uTofYjzqRv/0+eC3Md0+2Vtx/tps
cpPt0MSFzuUA+eONk62LlCLASm5exRfpWatLrO5IQRy+GL/eq7770ygpfJjBDco2
vvzVAAQOcY9f3NGld5ApaSYF48WyNZgdO3SW5/SULWxGXympNE1Sx1NMI//J4EPS
wau2lqw6sNOpuwfVmdz4XHe8gn0EZJDRRjt3bmLBhrqdFUuVtVr53XOIyxBC7eB4
L32RV+LwGf0NePkBjSruwtW1nySGmAhelJnuwvZ53u9vwsgdWrNVo5XA8kE0jmNd
lVi4aC0m0iACcvo8OlbP9H0U6yGWWT2KpitxLgPI7FFTeyAgnLr9nV8qN43qV0Yw
/rycpZ6QeIpJKiIS+hvJAnCIBbK7Gs91Irlu1avSabeG04m4nF3V4+yWXSBu4L+y
7vQM61sG8aep7sGhMIyf
=WOrU
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
