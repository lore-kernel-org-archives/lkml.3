Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaEYLpP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 07:45:15 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:37853 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaEYLpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 07:45:12 -0400
Date: Sun, 25 May 2014 13:45:07 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Rob Clark <robdclark@gmail.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/7] drm/tegra: Convert to master/component framework
Message-ID: <20140525114504.GA8233@mithrandir>
References: <1399995050-28435-1-git-send-email-thierry.reding@gmail.com>
 <20140522095621.GA11613@ulmo>
 <20140523110300.GA24374@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PEIAKu/WMn1b1Hv9"
Content-Disposition: inline
In-Reply-To: <20140523110300.GA24374@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PEIAKu/WMn1b1Hv9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 08:03:00PM +0900, Greg Kroah-Hartman wrote:
> On Thu, May 22, 2014 at 11:56:23AM +0200, Thierry Reding wrote:
> > On Tue, May 13, 2014 at 05:30:43PM +0200, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >=20
> > > Hi,
> > >=20
> > > This series converts the Tegra DRM driver to the master/component
> > > framework. The length of the series and the list of people in Cc is
> > > mostly due to the fact that Tegra has some special requirements as
> > > opposed to other drivers and therefore requires some changes outside
> > > of DRM.
> > >=20
> > > Patch 1 introduces a helper function that can be used by new DRM driv=
ers
> > > that don't rely on legacy userspace ABIs. It allows them to register =
DRM
> > > devices much more easily and without much of the midlayer that curren=
tly
> > > exists in the DRM subsystem.
> > >=20
> > > Patches 2 and 3 make some changes to the master/component framework
> > > which are necessary to convert Tegra DRM to use it. All current users=
 of
> > > the API have been converted as part of this patch. Note that at the s=
ame
> > > time the drivers are converted to no longer use drm_platform_init() in
> > > favour of the drm_set_unique() from patch 1 in conjunction with
> > > drm_dev_alloc() and drm_dev_register(). I would've liked to avoid such
> > > invasive changes in a single patch, but unfortunately I couldn't think
> > > of a way how to do that. I'm open to suggestions.
> > >=20
> > > Patch 4 adds a new interface framework that supplements the master/
> > > component framework and can be used in situations where there is no
> > > struct device * that a driver can bind to.
> > >=20
> > > The Tegra DRM driver is converted to using the master/component
> > > framework in patch 5 using the above four patches.
> > >=20
> > > Finally patches 6 and 7 add some documentation about the new way of
> > > registering DRM devices that don't need legacy support.
> > >=20
> > > Each patch has a somewhat more elaborate description of why it is nee=
ded
> > > or what problem it solves. The patchset applies on top of linux-next.
> > >=20
> > > I welcome any questions or comments you might have.
> > >=20
> > > Thierry
> > >=20
> > > Thierry Reding (7):
> > >   drm: Introduce drm_set_unique()
> > >   drivers/base: Allow driver-data to be attached to a master
> > >   drivers/base: Allow multiple masters per device
> > >   drivers/base: Add interface framework
> > >   drm/tegra: Convert to master/component framework
> > >   drm: Add device registration documentation
> > >   drm: Document how to register devices without struct drm_bus
> >=20
> > Greg, Russell,
> >=20
> > Any comments on this? I've been blocking a bunch of patches in the hopes
> > of getting this merged since it allows the Tegra DRM driver to be
> > cleaned up a great deal, but if nobody's going to look at or comment on
> > this I'll abandon this series and keep using the custom solution we've
> > had for a while now.
>=20
> I'd like Russell to comment on this, as he just added some driver core
> work to do drm device work that seems to me to be much the same here.

Yes. In fact that's what this series is all about. It converts the Tegra
DRM driver to use Russell's master/component helpers. But there are also
special requirements on Tegra DRM that require some enhancements to the
helpers, which this series does. Furthermore the interface framework
introduced here is supposed to complement the master/components helpers.
It is not a duplicate implementation but attempts to solves a completely
different problem.

> There's also the work that the media developers are working on to handle
> power management issues that seem to also be hitting the same area.  Due
> to all of that, I really don't want to add yet-another-driver-core
> addition for just one drm driver, all of them should be able to use it.

Like I said, this "interface" framework is meant to address something
different and was specifically designed to be useful for more than just
one DRM driver. However, people seem to prefer to make assumptions about
this code rather than actually go look (or even read the description)
what it really is about.

Besides I already have a working solution for the "one DRM driver". And
replacing it with the component/master helpers as-is will make it worse
than it is. Hence in order to avoid wasting more of everyone's time I
have now dropped patches 2-4 and changed patch 5 to only convert to the
drm_dev_set_unique() function, which is the more important piece of the
series anyway.

Thierry

--PEIAKu/WMn1b1Hv9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTgdfAAAoJEN0jrNd/PrOh87gP/3ILg/LAhrVk4+DjdtZ42W7+
8Szy0NoZ6l0IVNYD8XOku2cZBszRl7n1vv+jjl8gjsB5UDbncFCPNqJ7c0ceq7GM
6eYAal86Wpv1mprsF4LKpf3LEFFmaNWHgHnCMP9sBdkqZIijcsaev4fNm2J2S7s4
8A44QjF0oZqZBPpLfcbC6m70LSSjuOwQ7dAxemsLPwdAq6OZeFjWermvUDdSnQ75
lRUWc5vwYVRtfeQXdv5UvSMRMWbj6yX+ATrRGol7HZTHCkXY5LbMlqeUCO1sgWC9
+5GR8rpnmlQqvQe3cz5xthwUI4TJ1lAnAj5sSrQqYKrU/VtE1ja2GdcZJriT3L2p
BAXwV6QEnTdjjdVX9aUqHkwOOxI9Srv5au//5fV+qs6v1f6WB5n1NHnSP+lTSkdk
51sqE2aSZFKOCnap2+W5r9Mno069MBoXvWxLVPW15jHIVHAL3L9s57/m3uzARt8p
2sRlXdUrKxHzGaPpjWOjgnntBzQe+S5PiKPqrZ8VmG8frakEUF+b4rxCCX6BkMoX
44Vyv2rbGeatYfuH9AbHVs9p7OrXF325O0Nd3CBVKgDFL/N+e4QeZU90eEs0Ut9R
FsRL4oK5+B+I3TXCA6pbuL1fDotMAM3BVzDcvo11Bs6/IIoy7fBkSf6YqHUEcWAZ
DxQHR4y8zFdqoQUQphkZ
=ttrC
-----END PGP SIGNATURE-----

--PEIAKu/WMn1b1Hv9--
