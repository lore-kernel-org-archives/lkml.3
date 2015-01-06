Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbbAFOvG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:51:06 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:44153 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbbAFOvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:51:01 -0500
Date: Tue, 6 Jan 2015 15:50:56 +0100
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
Message-ID: <20150106145054.GO31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-10-git-send-email-vinceh@nvidia.com>
 <54A20F4D.4040100@gmail.com>
 <54A2198A.4000707@nvidia.com>
 <20150105153252.GI12010@ulmo.nvidia.com>
 <CAAVeFuK-SgUbtHADX4-pXN5_ayzvEd+1KxJOBcRe2tmDfHaLEA@mail.gmail.com>
 <20150106114953.GD31830@ulmo.nvidia.com>
 <54ABD49A.6080501@nvidia.com>
 <20150106143729.GN31830@ulmo.nvidia.com>
 <CAKb7UvgomyQkiwfGTdyuU-muE-_pPxOSmeXh9uQ6-ri0HHxLrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lsrIB+s628ok5gC"
Content-Disposition: inline
In-Reply-To: <CAKb7UvgomyQkiwfGTdyuU-muE-_pPxOSmeXh9uQ6-ri0HHxLrQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0lsrIB+s628ok5gC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 09:44:01AM -0500, Ilia Mirkin wrote:
> On Tue, Jan 6, 2015 at 9:37 AM, Thierry Reding <thierry.reding@gmail.com>=
 wrote:
> > On Tue, Jan 06, 2015 at 08:27:06PM +0800, Vince Hsu wrote:
> >>
> >> On 01/06/2015 07:49 PM, Thierry Reding wrote:
> >> >* PGP Signed by an unknown key
> >> >
> >> >On Mon, Jan 05, 2015 at 08:50:18PM +0100, Alexandre Courbot wrote:
> >> >>On Mon, Jan 5, 2015 at 4:32 PM, Thierry Reding <thierry.reding@gmail=
=2Ecom> wrote:
> >> >>>On Tue, Dec 30, 2014 at 11:18:34AM +0800, Vince Hsu wrote:
> >> >>>>Hi Emil,
> >> >>>>
> >> >>>>On 12/30/2014 10:34 AM, Emil Velikov wrote:
> >> >>>>>On 23/12/14 10:40, Vince Hsu wrote:
> >> >>>>>>This patch adds some checks in the suspend/resume functions to d=
istinguish
> >> >>>>>>the dGPU and mobile GPU and exports some variables/functions so =
that the
> >> >>>>>>nouveau platform device can reuse them.
> >> >>>>>>
> >> >>>>>Hi Vince,
> >> >>>>>
> >> >>>>>Afaiu one needs to export a symbol as it's used by another module=
 or
> >> >>>>>subsystem. With the follow up two patches you are not doing eithe=
r one,
> >> >>>>>so I'd assume that you can just omit the EXPORT_* changes.
> >> >>>>The nouveau platform device driver is built as another module -
> >> >>>>nouveau_platform.ko. :)
> >> >>>I'd like to hear the opinion of the nouveau people and Alex, but I'd
> >> >>>very much prefer if nouveau_platform.o was simply linked into the
> >> >>>nouveau.ko module. I don't see any good reason to keep it separate.
> >> >>Yep, I agree. The decision to host platform support in a separate
> >> >>module looks misleaded if it results in additional exports that we
> >> >>would otherwise avoid. IIUC I did this to be able to use the module
> >> >>convenience macros to register the platform driver.
> >> >>
> >> >>>Something like the attached patch (untested) ought to do it.
> >> >>This patch alone won't be enough for the reason I mentioned above.
> >> >>However, if Vince doesn't mind handling the platform driver
> >> >>registration manually in nouveau_drm_init/nouveau_drm_exit, I agree
> >> >>this would be the way to go.
> >> >If we do the conversion to generic power domains, the only Tegra-
> >> >specific API remaining will be the access to the fuse registers for t=
he
> >> >speedo value. At that point we wouldn't need the ARCH_TEGRA dependency
> >> >any longer and could always build the platform driver along with the =
PCI
> >> >driver.
> >> Do we really want the platform driver always built with the PCI driver=
 even
> >> there is no dependency between them. Actually I have some patches to
> >> build the platform driver with !CONFIG_PCI and would like to post them=
 maybe
> >> later.
> >
> > I do see some advantage in making Nouveau build with !CONFIG_PCI because
> > it allows building the driver for an SoC without PCI. But I think always
> > compiling whatever is available won't hurt. Nouveau itself is rather big
> > (~1 MiB of text and ~120 KiB of data) whereas the platform code weighs
> > in at around 1.5 KiB of text and 108 B of data. I suspect that the PCI
> > glue is equally negligible.
>=20
> The much bigger reductions in size would be from getting rid of all
> the stuff that's not used at all on a GK20A, like all the firmware,
> and a whole bunch of logic. I had a series that split things up into
> nv04/nv50/nvc0 categories. I believe it was considered undesirable due
> to increased build complexity. (It wasn't a nice modularized
> separation but rather just a compile-time setting.) Shouldn't be too
> hard to regenerate though.

Would you happen to remember the amount of savings for enabling only
nvc0? I'm not overly concerned with the module being 1 MiB on Tegra,
though. Most boards tend to have 2 GiB+ of memory these days and the
kernel footprint is pretty big without Nouveau anyway.

Thierry

--0lsrIB+s628ok5gC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq/ZOAAoJEN0jrNd/PrOhQ+QP/RNh9oR33Pi4bmMAOv/Jm72y
gJJp2cBTmH8YX0mgSe7kmZYQm/VL0I30gUroYkSKtI0fPkCif1D77EMYEunJmmYX
X7XqvZYG0L3ghM6HJRcoEw6yXPQ34CFer1Y9kq6MyLPQ0TPdCacXKwHbQxQQHRof
GDmBuDJHp14/hWyz2VrhBdVGuwk7vmM4Duh6Qn/bdZtOJ9hI5UfSevJGojhPhDcE
Fwk/p88O/YCl6ujTK4zYDwrpFvxdWG0/MCNVO8QDqvS4S/DDZdDSbutPwg6VB1DL
I+k/N27XMBhZIcUmMMNtE2A+/ZVYAbtP6nW2N9yY8Ev9e3HETXEhLdZE3NzIyu4L
14KHzzk2JvWwlVQLlvgr6QCNgFNXhvygJXsrXXxhEy/UKDPyrTo1+3nq8Q1MH6Pp
WpNOuBPv92kppcoP7H+/N8d0eR3FkK3xYkJIRhox0qKn2O6+vdH6BaBEkgSYIS99
ILktwj1g/YJoxfDMWTKori2fdcwXCyLcs6AUX2AuhUbNPoItwkewNVCxhgHm0Oxo
7Mj1ECKaoD7GAxgUWrJxEuKgSVAXignvlCKWGAaC86AAwgOAj9MiPyZ8c0+0VeU4
lOLrwh3TQJLLSU/MsJl1PTkrhj0bdKqo+aqZYLAl0crrVMDsnE6x7bkvbY/nxotd
6uBfvOK8XQnYZ5Kz2K/z
=IszO
-----END PGP SIGNATURE-----

--0lsrIB+s628ok5gC--
