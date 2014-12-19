Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaLSPa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 10:30:59 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51075 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbaLSPa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 10:30:58 -0500
Date: Fri, 19 Dec 2014 16:30:53 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Zhang <markz@nvidia.com>
Cc: Sean Paul <seanpaul@chromium.org>, tbergstrom@nvidia.com,
        Dave Airlie <airlied@linux.ie>, Stephen Warren <swarren@wwwdotorg.org>,
        gnurou@gmail.com, dri-devel <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drm/tegra: dsi: Add suspend/resume support
Message-ID: <20141219153051.GA5046@ulmo.nvidia.com>
References: <1418020850-7664-1-git-send-email-markz@nvidia.com>
 <CAOw6vbKegB8cgmqgRit+XdvYNtdEXy3Pcv5=1bYSCJv4v1F2AQ@mail.gmail.com>
 <5487AB39.1050706@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <5487AB39.1050706@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 10, 2014 at 10:08:57AM +0800, Mark Zhang wrote:
> On 12/10/2014 03:29 AM, Sean Paul wrote:
> > On Sun, Dec 7, 2014 at 10:40 PM, Mark Zhang <markz@nvidia.com> wrote:
[...]
> >>
> >>         err =3D clk_set_rate(dsi->clk_parent, plld);
> >>         if (err < 0) {
> [...]
> >> +
> >> +       drm_modeset_lock_all(tegra->drm);
> >> +       list_for_each_entry(connector, &tegra->drm->mode_config.connec=
tor_list,
> >> +                           head) {
> >> +               if (connector->funcs->dpms)
> >> +                       connector->funcs->dpms(connector, connector->d=
pms);
> >> +       }
> >> +       drm_modeset_unlock_all(tegra->drm);
> >> +
> >> +       drm_helper_resume_force_mode(tegra->drm);
> >> +
> >> +       return 0;
> >> +}
> >> +#endif
> >=20
> > So this is the tricky chunk, it definitely does not belong here. I
> > think it makes most sense for this to live in drm.c, however
> > host1x_driver doesn't have suspend/resume hooks.
> >=20
>=20
> Agree. drm.c is the best place for putting this.
>=20
> > I suspect the correct thing to do here is to add them to
> > host1x_driver, but I'm not sure how much effort is involved in doing
> > that.
> >=20
>=20
> I thought about this before. If we do it in host1x driver, IIUC, it
> means that when host1x starts suspending, it will suspend all host1x
> client devices, right? Honestly I feel this is not a good thing despite
> I can't tell what's the problem in this right now...

I've just sent out patches for review that add the missing
infrastructure to properly do suspend/resume. The idea behind this is
that the DRM host1x device's ->pm_ops are responsible for dealing with
the suspend/resume at a subsystem level (call connectors' ->dpms()
callbacks, etc.) whereas more fine-grained suspend/resume can further be
done in the ->pm_ops of the individual subdevices. The infrastructure
makes sure that these get called in the right order.

Thierry

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUlESrAAoJEN0jrNd/PrOhn8AQAJ40QmbuFlOyDC/nAwcngQbT
5N022Dz019tonxIrPDYLNgNKX9EqasGV3aTEqb8woewg2IYQxMB1A3sReSOa/jqR
+0NnQdi2lZWLuN5wMSWADjkNMHhD41GQNHDlAz6Xi+gDdiCL/AROaiLmlZiII4ah
lUA0kCuUUpfshcV8nlCXps8hnuWm8klHvG344xKiDV5GKO21HSqiihqq8PgelFNI
cVTPqCtXUdFUpvvZzKBpwgOtswFS9Rht6tGqmCCYkyvCcV9v0fx5wqAjCo1rA0xr
/31w0fftem19WTpnuvfPOD6YqebXsupiaBQ5zkpGVjtSe65Bj26fuGc6tkkz9esJ
qF9k4rYcbxazw7w3fpRobxDdicFKR/+y+PakA8YJ0RGCRZiW31DydaSynAMsP9Ah
zMGRRqDm2aJxct5xg4KhOSDoM5EWO01CA3S6oyCxfpZwepHzqgIikedJo61DXUYJ
DVThZ1nQrrOxyiEU5a+W3G1pvHcJEzP+m6rnXMd6Piqq/NFeuJ4U1S8q7GAXNFlj
eNmrsbypjzfKd7RrPdoPYJwAhWtjj72uoNsg2LfKtbCkf+tObHm6IChGnHQFMOQ7
2hyuLje1RCu8fDZhRGmtYODjwCQlQZDvXBbw27pvprKlCKz2On5Xv6bOEUnUzR+U
3A5iIvHjxFdYKfrlqEAS
=9VxR
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
