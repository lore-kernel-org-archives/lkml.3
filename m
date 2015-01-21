Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbbAUPM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 10:12:28 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:59000 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbbAUPMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 10:12:18 -0500
Date: Wed, 21 Jan 2015 16:12:13 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH 01/36] clk: Introduce clk_try_parent()
Message-ID: <20150121151210.GC22884@ulmo.nvidia.com>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
 <20150120180247.22722.92597@quantum>
 <CAF6AEGsPGCAHxqqRR7wWGxbiuS1HwTxF8fMb=VaL8T_qj85=TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <CAF6AEGsPGCAHxqqRR7wWGxbiuS1HwTxF8fMb=VaL8T_qj85=TQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 20, 2015 at 01:16:16PM -0500, Rob Clark wrote:
> On Tue, Jan 20, 2015 at 1:02 PM, Mike Turquette <mturquette@linaro.org> w=
rote:
> > Quoting Thierry Reding (2015-01-20 02:48:20)
> >> From: Thierry Reding <treding@nvidia.com>
> >>
> >> This new function is similar to clk_set_parent(), except that it doesn=
't
> >> actually change the parent. It merely checks that the given parent clo=
ck
> >> can be a parent for the given clock.
> >>
> >> A situation where this is useful is to check that a particular setup is
> >> valid before switching to it. One specific use-case for this is atomic
> >> modesetting in the DRM framework where setting a mode is divided into a
> >> check phase where a given configuration is validated before applying
> >> changes to the hardware.
> >
> > Can you describe why this was needed for your atomic modesetting work?
> > What problem did you hit in the driver that required this new check?
>=20
> In particular, for an async atomic update, we need to do everything
> that may potentially fail up front before returning to userspace.
> Additionally there is a 'testonly' flag so that userspace can ask if a
> particular display configuration is possible.

One specific use-case where this is needed is if we want to set a mode
but halfway through the modeset we find out that we can't actually set
it, then we need to somehow rollback the changes, or be stuck with a
mode that doesn't work.

Splitting this into two separate stages allows all the checks to be
performed before making any changes to the hardware. The current mode
will remain active until the changes are committed. Therefore rollback
of a partial modeset is not required.

Thierry

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUv8HKAAoJEN0jrNd/PrOhHdcP/38j2cqjJKnZR6vRUGUskyNe
eUsykbbVCEtLVG3y2Go21F4+LNsikmjxI2jXM3JdiSLX3iNZBGYkJa8j8hW/flqd
H5tApR8FqKgZGOaEELmiFU+P476Bm/0e1MkmRMb4DcLPmjHWYef6WYWr+T4omMJa
fhHCi1PaIATzT88zXqeAV0oTcXxvP1LVKDlk5olk4WYObSvNDohMtxuklcJGhpbO
F9B+ifs4xxjc9pVvA76bHiVGeHWy3Y7FSlAorhx/bNRgA3EAolBhTKqWXGu3NhLn
TbfFAD8+4bKTh6ZEM3DIXQt0CTSGnl2MG9CVzqYfl8U2n/Voswwvh1Oh+H+IXKMd
GXt1RuF7TedeS0bmSBB3+IvC9QI9DWSu7BGwB54W8WUgeOpeMCri5E5Y5Z9nUx2T
aFHWtFmGLkNVs7w1djBbQKYNzXMaSSDkg/G9SUw65SPPsdZDtCuqK36ur99ElsvJ
IN4pEBRz+1Etm7Q8vyAkw3cLancjprCmYUvuyIOusAs4q+jukLf0+mj2d4md3JW8
Q8PPTgEcgNSNhwGn3Urty2MWU/3E+qpn+iISyHu5bQBQpyNgMgr2zf522WpycOne
bsnf55Kq4r2vZlNKIdSs8/zWQTDIxKbRZb9MAmBHvH4oILnsxsixTVKKYNJody2F
8qZQNvgMHAURc4yEVN7c
=GwFs
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
