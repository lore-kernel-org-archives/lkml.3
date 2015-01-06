Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbbAFOhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 09:37:37 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41029 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbAFOhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 09:37:35 -0500
Date: Tue, 6 Jan 2015 15:37:30 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Vince Hsu <vinceh@nvidia.com>
Cc: Alexandre Courbot <gnurou@gmail.com>,
        Emil Velikov <emil.l.velikov@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ben Skeggs <bskeggs@redhat.com>, Martin Peres <martin.peres@free.fr>,
        Roy Spliet <seven@nimrod-online.com>, samuel.pitoiset@gmail.com,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Nouveau] [PATCH nouveau 09/11] drm: export some variable and
 functions to resue the PM functions
Message-ID: <20150106143729.GN31830@ulmo.nvidia.com>
References: <1419331204-26679-1-git-send-email-vinceh@nvidia.com>
 <1419331204-26679-10-git-send-email-vinceh@nvidia.com>
 <54A20F4D.4040100@gmail.com>
 <54A2198A.4000707@nvidia.com>
 <20150105153252.GI12010@ulmo.nvidia.com>
 <CAAVeFuK-SgUbtHADX4-pXN5_ayzvEd+1KxJOBcRe2tmDfHaLEA@mail.gmail.com>
 <20150106114953.GD31830@ulmo.nvidia.com>
 <54ABD49A.6080501@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sy9WyBOsCRoUO165"
Content-Disposition: inline
In-Reply-To: <54ABD49A.6080501@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sy9WyBOsCRoUO165
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 08:27:06PM +0800, Vince Hsu wrote:
>=20
> On 01/06/2015 07:49 PM, Thierry Reding wrote:
> >* PGP Signed by an unknown key
> >
> >On Mon, Jan 05, 2015 at 08:50:18PM +0100, Alexandre Courbot wrote:
> >>On Mon, Jan 5, 2015 at 4:32 PM, Thierry Reding <thierry.reding@gmail.co=
m> wrote:
> >>>On Tue, Dec 30, 2014 at 11:18:34AM +0800, Vince Hsu wrote:
> >>>>Hi Emil,
> >>>>
> >>>>On 12/30/2014 10:34 AM, Emil Velikov wrote:
> >>>>>On 23/12/14 10:40, Vince Hsu wrote:
> >>>>>>This patch adds some checks in the suspend/resume functions to dist=
inguish
> >>>>>>the dGPU and mobile GPU and exports some variables/functions so tha=
t the
> >>>>>>nouveau platform device can reuse them.
> >>>>>>
> >>>>>Hi Vince,
> >>>>>
> >>>>>Afaiu one needs to export a symbol as it's used by another module or
> >>>>>subsystem. With the follow up two patches you are not doing either o=
ne,
> >>>>>so I'd assume that you can just omit the EXPORT_* changes.
> >>>>The nouveau platform device driver is built as another module -
> >>>>nouveau_platform.ko. :)
> >>>I'd like to hear the opinion of the nouveau people and Alex, but I'd
> >>>very much prefer if nouveau_platform.o was simply linked into the
> >>>nouveau.ko module. I don't see any good reason to keep it separate.
> >>Yep, I agree. The decision to host platform support in a separate
> >>module looks misleaded if it results in additional exports that we
> >>would otherwise avoid. IIUC I did this to be able to use the module
> >>convenience macros to register the platform driver.
> >>
> >>>Something like the attached patch (untested) ought to do it.
> >>This patch alone won't be enough for the reason I mentioned above.
> >>However, if Vince doesn't mind handling the platform driver
> >>registration manually in nouveau_drm_init/nouveau_drm_exit, I agree
> >>this would be the way to go.
> >If we do the conversion to generic power domains, the only Tegra-
> >specific API remaining will be the access to the fuse registers for the
> >speedo value. At that point we wouldn't need the ARCH_TEGRA dependency
> >any longer and could always build the platform driver along with the PCI
> >driver.
> Do we really want the platform driver always built with the PCI driver ev=
en
> there is no dependency between them. Actually I have some patches to
> build the platform driver with !CONFIG_PCI and would like to post them ma=
ybe
> later.

I do see some advantage in making Nouveau build with !CONFIG_PCI because
it allows building the driver for an SoC without PCI. But I think always
compiling whatever is available won't hurt. Nouveau itself is rather big
(~1 MiB of text and ~120 KiB of data) whereas the platform code weighs
in at around 1.5 KiB of text and 108 B of data. I suspect that the PCI
glue is equally negligible.

Thierry

--sy9WyBOsCRoUO165
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq/MpAAoJEN0jrNd/PrOhZOgP/0iAGJQ7KC351FKn5fS3SEFf
s+cyD2MjtIIXMc6CPT177R8+lxy/cA40yuRB3ehQurTPQw5CDgVL7U02kVvV+EDb
u21L3bQiTSa3XkPf9BDGWTXKIQqb5EfV84WGWo94BELfIxiXzeoCcc/slWvU6rT5
rN5TposSU6Q10VzgUVkKQJqGWAWzxKezvGloLW8A/3uTAy8rxJ7yxZuZAqlH3Kj0
OIjM1gwMVCgolYSVIzuhvy8oI930H7mZrbJFM1F6pG12BGbLXg58JPDRmG113Tpa
X1if/SftoJnoZZbecFw5tsJKMzm1Ia0W9zm4LbuL+cOskbC/uU+Pp/oUyIuGTmDD
kGR9I+cw1wTtRy4XA7lC08TZwck5+yYPFdZwEvEmU7aBdfmWRrvUE/6xahVnf5Ai
vow+pqDcMuH1GOKh6u+fBA504SmWTOzAIAkYOieUryiMSlKk/qABuT6sJTz/1/jL
P/F1omvqUoHcsN8uxHAoqM/fD+JxWw/JvhyeWGv1n9tgIpSrbEIc8g0VpeP8595w
/NC8jjyFSutQsMN/EHDa/eByyBta4UXl+plHJuanb1kTriuJ/LruEDdqjFTJ13th
T2hi0Kt3HofN/lSyWnMlOKoXGt6FroHxSDzwKuekCgXebdCwJoOtKsAbN310m2M4
ROCTETfte0JKmK8XKcHL
=uEHR
-----END PGP SIGNATURE-----

--sy9WyBOsCRoUO165--
