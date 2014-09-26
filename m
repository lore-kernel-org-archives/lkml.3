Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbaIZJ7f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:59:35 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:51367 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaIZJ7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:59:33 -0400
Date: Fri, 26 Sep 2014 11:59:29 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Sjoerd Simons <sjoerd@luon.net>, Alexandre Courbot <acourbot@nvidia.com>,
        Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [5/5] ARM: tegra: jetson-tk1: enable GK20A GPU
Message-ID: <20140926095928.GJ31106@ulmo>
References: <1400491450-19223-6-git-send-email-acourbot@nvidia.com>
 <20140925132717.GA13579@dusk.luon.net>
 <54243931.6050804@wwwdotorg.org>
 <20140925164109.GA30382@ulmo>
 <542459C5.9060505@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wRokNccIwvMzawGl"
Content-Disposition: inline
In-Reply-To: <542459C5.9060505@wwwdotorg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wRokNccIwvMzawGl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2014 at 12:07:01PM -0600, Stephen Warren wrote:
> On 09/25/2014 10:41 AM, Thierry Reding wrote:
> >On Thu, Sep 25, 2014 at 09:48:01AM -0600, Stephen Warren wrote:
> >>On 09/25/2014 07:27 AM, Sjoerd Simons wrote:
> >>>Playing a bit with todays linux-next on my jetson, it seems this patch=
 is
> >>>still required for enabling the GPU. Is there anything blocking it (fi=
rmware
> >>>not available yet in liux-firmware?)
> >>
> >>I think initially I was waiting for the DRM patch "drm/nouvea: support =
for
> >>probing platform devices" to be applied, but it looks like that's been
> >>applied already, so only patches 4 and 5 in this series are still
> >>outstanding.
> >>
> >>Alex, wasn't there also some issue where the VPR register had to be
> >>programmed, and if it wasn't there'd be a hang when the GPU registers w=
ere
> >>touched? If we've added code to Nouveau/tegradrm to detect that and avo=
id
> >>the problem, then I guess we can commit these last two patches for 3.19=
=2E A
> >>resend after the 3.18 merge window might help.
> >
> >A patch that programs VPR was merged into U-Boot (though I don't think
> >it's made it into master yet). I'm not sure we can reasonably check for
> >that in Nouveau, given that the register is somewhere completely
> >unrelated. In fact I think the U-Boot patch was triggered by some
> >discussion about how to solve this and it was decided that it shouldn't
> >be done in the kernel, but U-Boot should set it up.
> >
> >That said, perhaps one solution would be to make U-Boot enable the gk20a
> >device if it's set up the VPR and disable it otherwise?
>=20
> For that to work, we'd need the DT to say status=3D"disabled" by default =
for
> the GPU, and for the fixed U-Boot (and indeed every other bootloader...) =
to
> enable the GPU node. This would allow people with old versions of U-Boot =
(or
> other bootloaders) to continue to boot. This means bootloaders would only
> have to set status=3D"okay", but never have to set status=3D"disabled", w=
hich at
> least simplifies them a tiny bit.

Sounds like a reasonable requirement on bootloaders to me. If it's clear
that the device will not work without an initialized VPR region, part of
the "boot protocol" should be for the bootloader to tell the kernel when
it's safe to enable the GPU.

Thierry

--wRokNccIwvMzawGl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUJTkAAAoJEN0jrNd/PrOhLDMP/j2bvIxUrl4tn8PZWxxaypQ4
cnMqIBWk1qulgTjtAvPcpb2PAODIK0cr1ZiyVWNBkICZ5nGLM8dlY5SsvKVCamaH
2Khq5e/O8YqV+48e+mpoKB9erNr7V/p7U+6zN9/k9xk9cCLCQOwvC85dsViQfGB3
e0VJj9wkwnaep6kfZBnY6NLQAVuSgepNaQdCswigY0eH8tFq16ugqYmvhpe89FYX
JWYMMjMhsMclQ7Hic0tnyjH5qMgB/T/aT0b/6l5jw7Hx7KoeZ5InumYbrMSTIJPn
bHNiQZcqTfv1A9nz0nEls/VXoiTKOJPPbw7jyqZf7NMP/6rmkPXJsxnBCuTTaWuy
OiZs1vY2TUee7zopktkbanaQaYxOvkol83a1IVhjFZ0n2BOWEwGMr8mA30cYwfRl
tCkz7AiI92dqCj5lRTzEJU0OH/hYi7dSfbhMR20kDSxyLjgfjkZYTm6qboXR6nHN
hgx/hbmVG3vc/wMOxTeJKfNsAtO7AoKvjMPnX2IGotCnvIHAl+XFMcFemp7lcTZ8
aQZQxfDFTmTdp8oIV8buKcSKa6RIFOcipd4d1nSXdiSgnPTMChF7z0s3JGylzcZr
m/Pg/k1NgKuqERNbSri6TjQPGL7F+2pXw8v33VqSTZ2A8e7ZVeqIIjlFGSs3GOd1
x4dfRN73arFv0jKCsTmd
=VG5A
-----END PGP SIGNATURE-----

--wRokNccIwvMzawGl--
