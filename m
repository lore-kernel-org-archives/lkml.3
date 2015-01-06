Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbbAFPfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 10:35:37 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:54762 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620AbbAFPfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 10:35:32 -0500
Date: Tue, 6 Jan 2015 16:35:28 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Ilia Mirkin <imirkin@alum.mit.edu>
Cc: Vince Hsu <vinceh@nvidia.com>, Stephen Warren <swarren@wwwdotorg.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Roy Spliet <seven@nimrod-online.com>
Subject: Re: [Nouveau] [PATCH nouveau 09/11] drm: export some variable and
 functions to resue the PM functions
Message-ID: <20150106153526.GS31830@ulmo.nvidia.com>
References: <54A20F4D.4040100@gmail.com>
 <54A2198A.4000707@nvidia.com>
 <20150105153252.GI12010@ulmo.nvidia.com>
 <CAAVeFuK-SgUbtHADX4-pXN5_ayzvEd+1KxJOBcRe2tmDfHaLEA@mail.gmail.com>
 <20150106114953.GD31830@ulmo.nvidia.com>
 <54ABD49A.6080501@nvidia.com>
 <20150106143729.GN31830@ulmo.nvidia.com>
 <CAKb7UvgomyQkiwfGTdyuU-muE-_pPxOSmeXh9uQ6-ri0HHxLrQ@mail.gmail.com>
 <20150106145054.GO31830@ulmo.nvidia.com>
 <CAKb7Uvh6ttvssYqe+3Qqq+RvckoBmYAKv2XY2w7hBFNwi93rew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U7F658e60E1K4csu"
Content-Disposition: inline
In-Reply-To: <CAKb7Uvh6ttvssYqe+3Qqq+RvckoBmYAKv2XY2w7hBFNwi93rew@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U7F658e60E1K4csu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 10:03:36AM -0500, Ilia Mirkin wrote:
> On Tue, Jan 6, 2015 at 9:50 AM, Thierry Reding <thierry.reding@gmail.com>=
 wrote:
> > On Tue, Jan 06, 2015 at 09:44:01AM -0500, Ilia Mirkin wrote:
> >> On Tue, Jan 6, 2015 at 9:37 AM, Thierry Reding <thierry.reding@gmail.c=
om> wrote:
> >> > On Tue, Jan 06, 2015 at 08:27:06PM +0800, Vince Hsu wrote:
> >> >>
> >> >> On 01/06/2015 07:49 PM, Thierry Reding wrote:
> >> >> >* PGP Signed by an unknown key
> >> >> >
> >> >> >On Mon, Jan 05, 2015 at 08:50:18PM +0100, Alexandre Courbot wrote:
> >> >> >>On Mon, Jan 5, 2015 at 4:32 PM, Thierry Reding <thierry.reding@gm=
ail.com> wrote:
> >> >> >>>On Tue, Dec 30, 2014 at 11:18:34AM +0800, Vince Hsu wrote:
> >> >> >>>>Hi Emil,
> >> >> >>>>
> >> >> >>>>On 12/30/2014 10:34 AM, Emil Velikov wrote:
> >> >> >>>>>On 23/12/14 10:40, Vince Hsu wrote:
> >> >> >>>>>>This patch adds some checks in the suspend/resume functions t=
o distinguish
> >> >> >>>>>>the dGPU and mobile GPU and exports some variables/functions =
so that the
> >> >> >>>>>>nouveau platform device can reuse them.
> >> >> >>>>>>
> >> >> >>>>>Hi Vince,
> >> >> >>>>>
> >> >> >>>>>Afaiu one needs to export a symbol as it's used by another mod=
ule or
> >> >> >>>>>subsystem. With the follow up two patches you are not doing ei=
ther one,
> >> >> >>>>>so I'd assume that you can just omit the EXPORT_* changes.
> >> >> >>>>The nouveau platform device driver is built as another module -
> >> >> >>>>nouveau_platform.ko. :)
> >> >> >>>I'd like to hear the opinion of the nouveau people and Alex, but=
 I'd
> >> >> >>>very much prefer if nouveau_platform.o was simply linked into the
> >> >> >>>nouveau.ko module. I don't see any good reason to keep it separa=
te.
> >> >> >>Yep, I agree. The decision to host platform support in a separate
> >> >> >>module looks misleaded if it results in additional exports that we
> >> >> >>would otherwise avoid. IIUC I did this to be able to use the modu=
le
> >> >> >>convenience macros to register the platform driver.
> >> >> >>
> >> >> >>>Something like the attached patch (untested) ought to do it.
> >> >> >>This patch alone won't be enough for the reason I mentioned above.
> >> >> >>However, if Vince doesn't mind handling the platform driver
> >> >> >>registration manually in nouveau_drm_init/nouveau_drm_exit, I agr=
ee
> >> >> >>this would be the way to go.
> >> >> >If we do the conversion to generic power domains, the only Tegra-
> >> >> >specific API remaining will be the access to the fuse registers fo=
r the
> >> >> >speedo value. At that point we wouldn't need the ARCH_TEGRA depend=
ency
> >> >> >any longer and could always build the platform driver along with t=
he PCI
> >> >> >driver.
> >> >> Do we really want the platform driver always built with the PCI dri=
ver even
> >> >> there is no dependency between them. Actually I have some patches to
> >> >> build the platform driver with !CONFIG_PCI and would like to post t=
hem maybe
> >> >> later.
> >> >
> >> > I do see some advantage in making Nouveau build with !CONFIG_PCI bec=
ause
> >> > it allows building the driver for an SoC without PCI. But I think al=
ways
> >> > compiling whatever is available won't hurt. Nouveau itself is rather=
 big
> >> > (~1 MiB of text and ~120 KiB of data) whereas the platform code weig=
hs
> >> > in at around 1.5 KiB of text and 108 B of data. I suspect that the P=
CI
> >> > glue is equally negligible.
> >>
> >> The much bigger reductions in size would be from getting rid of all
> >> the stuff that's not used at all on a GK20A, like all the firmware,
> >> and a whole bunch of logic. I had a series that split things up into
> >> nv04/nv50/nvc0 categories. I believe it was considered undesirable due
> >> to increased build complexity. (It wasn't a nice modularized
> >> separation but rather just a compile-time setting.) Shouldn't be too
> >> hard to regenerate though.
> >
> > Would you happen to remember the amount of savings for enabling only
> > nvc0? I'm not overly concerned with the module being 1 MiB on Tegra,
> > though. Most boards tend to have 2 GiB+ of memory these days and the
> > kernel footprint is pretty big without Nouveau anyway.
>=20
> Well, nvc0 is a big one since that's where all the firmware lives,
> which is a big chunk of it, and you don't actually end up using any of
> it. (And even if you did, it'd be just one of the firmware files, not
> all of them).
>=20
> Here was the patch: http://permalink.gmane.org/gmane.comp.video.dri.devel=
/102457
>=20
> Looks like nvc0 only was:
>=20
> NVC0: 878726 bytes
>    text    data     bss     dec     hex filename
>  360593  140327      80  501000   7a508 drivers/gpu/drm/nouveau/nouveau.ko
>=20
> compared to the combo package:
>=20
> NV04 + NV50 + NVC0: 1343482 bytes
>    text    data     bss     dec     hex filename
>  579171  184264     480  763915   ba80b drivers/gpu/drm/nouveau/nouveau.ko

That's a pretty significant improvement. And the patch doesn't look too
bad either. But like I said, I'm not a big fan of reducing binary size
at the expense of code complexity, so I won't loose any sleep over it.

Thierry

--U7F658e60E1K4csu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUrAC+AAoJEN0jrNd/PrOh7xkP/jk153h0DJYUg1hDXeh0xhKz
vwoBt/wZMKt0V10tspr10V4HiRe1u+oRwQ9aUzHTVHHM2nLLjm/ZR6hpLBuVJqvp
1Fd45meYq5KOwStxF6msgjhwrVSXL7OwBQvVwYXwwNFUm1e+cfnPA/qaynXyLOgh
zrYaBbjD5T0BOlq/38lkS0i6fnjwyhOgAPuX+Wm+MBlPUs2e+sR+IZYzTnhA1gRI
EO7DGA6z63YOpZwhTu/aQ13hPAQjRnDiblhVyyBX41nAfTIipBiwo37761qM+lXb
qFRJoTU710E15LDk8szUdKsVkr4XwnlcBcnrae2kbnBmXt85L7QlX+H+l1osJbOm
VwbgD7+3lUIVFtfWLFCDzvZicTBEN+RFXCtqrZ+rvZlB1b0grCs4CjFn6fH0M9e8
7aZchHKB6CORiZzSbmTrGSsuGq5vC9WOQD3FvYxj4DdlTRMYQuTOdKye2G0yeLMK
AWw8hUi2Jt0iM1IpARnrY8+XvTi+83IQN50p1s+nQOJHcVZtRhG99vVydU5PykP2
UVVBHaiZgIE0BkMYJR5WlbrkwLsUQExYRd1du6p1ba29J0hJn4l4GJskCHEpsByf
H63Mae+BH9l3vPbG+m8zjXPccc++ls+mSwb9Nc79jDjT9wgL4S6zxsiznvudSFH0
jXn5cD90FwFaWYXz8T/9
=5/Il
-----END PGP SIGNATURE-----

--U7F658e60E1K4csu--
