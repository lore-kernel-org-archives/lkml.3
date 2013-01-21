Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3AUH2N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:28:13 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61178 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab3AUH2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:28:12 -0500
Date: Mon, 21 Jan 2013 08:28:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Lucas Stach <dev@lynxeye.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: thoughts on requiring multi-arch support for arm drm drivers?
Message-ID: <20130121072805.GD15508@avionic-0098.adnet.avionic-design.de>
References: <CAF6AEGsSEtpJNKgHpZsUM9aadxYfHV7BhjfS86q0SH5ZXYaZ3w@mail.gmail.com>
 <CAKMK7uH29is7Ky5_w2eu5iic42+TJt+vLdQk=mqBfL77o-BhjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="osDK9TLjxFScVI/L"
Content-Disposition: inline
In-Reply-To: <CAKMK7uH29is7Ky5_w2eu5iic42+TJt+vLdQk=mqBfL77o-BhjA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:Kvy6TOQGlPBAvuVntk5Sit2cenbPEHi3WJNlPJgMEHA
 FHDnlLE61xXgyGQHvqijYu9ILLTj0i4beC8GsZXNdnzcObeHoO
 KmuMR81U1J1m8fKW0sGERLEZHzhCgSVCz4PbHPEf8LbVhHgHyQ
 9jRiP/zpKNJ0uGjl0mpLzfgtVAfNpXAjqt6LoZebOAGt/VBGbd
 /y7WdS/3qR4VKlo2ynLdBbp2MPdQjDu7HlPoZDVqnTAAeZG8Kx
 kIFWDFndNjFb0tT+7l3bHY7Ec5RYVJSsPnP2wqAy7MK3sATBi7
 8vhjW4Y+dHVDva4ncn0jWZtUDLE+QBIe/il14pvl1NLusG1AYs
 sM0uiglx2N6xW3zwZ7Iz3KbMwPrq2XO5IgbdFbK07LKtg+wf2A
 R8Ok6xtstTVdgD8kNbtmmltvFjrZM+VgJ8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--osDK9TLjxFScVI/L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 20, 2013 at 04:42:55PM +0100, Daniel Vetter wrote:
> On Sun, Jan 20, 2013 at 4:08 PM, Rob Clark <robdclark@gmail.com> wrote:
> > One thing I've run into in the past when trying to make changes in drm
> > core, and Daniel Vetter has mentioned the same, is that it is a bit of
> > a pain to compile test things for the arm drivers that do not support
> > CONFIG_ARCH_MULTIPLATFORM.  I went through a while back and fixed up
> > the low hanging fruit (basically the drivers that just needed a
> > Kconfig change).  But, IIRC some of the backlight related code in
> > shmob had some non-trivial plat dependencies.  And I think when tegra
> > came in, it introduced some non-trivial plat dependencies.
> >
> > What do others think about requiring multiarch or no arch dependencies
> > for new drivers, and cleaning up existing drivers.  Even if it is at
> > reduced functionality (like maybe #ifdef CONFIG_ARCH_SHMOBILE for some
> > of the backlight code in shmob) or doesn't even work but is just for
> > the purpose of being able to compile test the rest of the code?
> >
> > Thoughts?
>=20
> Definitely in favour of this. Also, I think the arm world _really_
> needs something like Wu Fenggungs 0-day kernel testing/building
> machines, which checks every commit pushed to around a 150 git kernel
> maintainer repos with randconfigs, sparse (and iirc other static
> checkers like cocinelle), and test-boots them on kvm. It's not just
> that every driver seems to need it's own special defconfig/platform to
> even be selectable in Kconfig, they also seem to randomly (and often)
> break compilation if you're on the wrong tree or don't have the
> exactly required golden config ...

That's true. Unfortunately due to the many repositories involved there
seem to be quite a few dependencies involved to get all the pieces to
build properly. linux-next is usually in pretty good shape, however.
I've been running an automated build over at least all ARM defconfigs in
linux-next for a few days and sent out patches for build failures. But
I'm not sure if I can keep that up, or at least not on a daily basis.

Obviously it doesn't help the DRM problem all that much. But I agree
with Rob that the only thing that will really help is multi-platform
support.

Thierry

--osDK9TLjxFScVI/L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ/O4FAAoJEN0jrNd/PrOhxkUP/0iYy4ozG4GldXliYkdX+OSI
aZ0iDWCwwEqdnWa0XsStQkG1FPId1xOjZxaz2tHhnTNTmgRiO3nOVlRdwbKuGwE+
vRZaG9rdqUnjCPSd6E0oBsux0A+ijhRcWGLy+pocnD313N3r4b1xliDTSgjEtJ5k
MFM0Fg72PrrYoLklbQ4E/aJN+PYuvs64wuySjIbNGwW3dIdTE5oIzgRdDf6W9pSo
KuO07UqTm3kmqoWF/oykgWnU+4D36eT+MerJvbdjeUv+3vyMHXOYKU9bLbHf/koa
iLmVO35a0ngFUSxad6D0F6bYcm7AlU2h7xZRZIKcMF2O4bZ6YV+mA6UgCfIYF4QQ
/sOeBRHyMAtDlLnl54j8KT/GiiPqbdh8oBQitVDO1JUv7ommFRy3UhZVPernfQjI
4lznT1qQuPAa7KLPF7m2RVq9NdXJ73HRKB5lClAFov7WK90fAfYuDmfvxy1z1CFR
qrHrdzYuDhAJ8otfGJUK79Mi+3KcjSOXSIzK+eW3A/A3nd4p8x4gDxF+eSdAOBlO
OvxCzf3PbO5WhiAQc0bP7CcKlgJ3oz4IFteotKXqK/Cw3fIzBDOtJI1a7JfKZl9t
1jdgDh0IV4IV62qdWyoN0dRPh6ZrrKGvpwakxMxW27Vm+ts/9YsqnxphlxEEJz3a
Y9jWuKvWLX/UmK6o9qGR
=VHp3
-----END PGP SIGNATURE-----

--osDK9TLjxFScVI/L--
