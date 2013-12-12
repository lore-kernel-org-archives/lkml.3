Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3LLLFG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 06:05:06 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38212 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3LLLFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 06:05:01 -0500
Date: Thu, 12 Dec 2013 12:03:44 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: Mikko Perttunen <mperttunen@nvidia.com>,
        Arto Merilainen <amerilainen@nvidia.com>,
        Terje =?utf-8?Q?Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] gpu: host1x: clk_round_rate() can return a zero upon
 error
Message-ID: <20131212110343.GA11524@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1312091746400.4127@tamien>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312091746400.4127@tamien>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 09, 2013 at 06:00:12PM -0800, Paul Walmsley wrote:
>=20
> Treat both negative and zero return values from clk_round_rate() as
> errors.  This is needed since subsequent patches will convert
> clk_round_rate()'s return value to be an unsigned type, rather than a
> signed type, since some clock sources can generate rates higher than
> (2^31)-1 Hz.
>=20
> Eventually, when calling clk_round_rate(), only a return value of zero
> will be considered a error.  All other values will be considered valid
> rates.  The comparison against values less than 0 is kept to preserve
> the correct behavior in the meantime.
>=20
> Signed-off-by: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Mikko Perttunen <mperttunen@nvidia.com>
> Cc: Arto Merilainen <amerilainen@nvidia.com>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Terje Bergstr=C3=B6m <tbergstrom@nvidia.com>
> ---
> Applies on v3.13-rc3.  See also:
>=20
> http://marc.info/?l=3Dlinux-arm-kernel&m=3D138542591313620&w=3D2
>=20
>  drivers/gpu/drm/tegra/hdmi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks.

Thierry

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSqZgPAAoJEN0jrNd/PrOhRsUQAL1qjmQyj84K/2XmQCFE5LLe
VzEAqHtnASOF1rF7pvajnzfy8Hb+LeXgxt/uCmBy9VdDSfR/Baim8vN3F8UHLe0b
NTCZxEls63pZs97pn6/MNlMs8GmQxv1Ph7l9mUn+Q6B1YC55isdXIm91jnYe5n9I
hoJndvYlAg3/AjSAmC1uHe3QP2D/W0Ov6D9MtWdIWo13KAv28mn0OZ9Q6zOT7rpJ
JoNbjqk4ta4Qa+plnKsXP/haK9trRtqufqbewtAW9LHzbJqs9gNFH870Wf1q/G8G
Oa2lwUjhBPTTsXJR6dGL+GH8QTYwJXksWbONyq+iDVWCL/yZU+kFpjxP1UOfWSFB
clyxPGS2w+t1V301mBtUxLbAyq22EUkil6/Tb5oFbzh11XKgjqtP95nyJHG17tuE
FLiU6fYsy3vbtBXlNrzTffxAwlV9+oHhGU7SJN1rZLeuI5NuHbrm2DuMo/mSKveg
I5wyNSkC5EjsUWEE1DfAOXEnpDGIIDvMTVV0jjO/QOJGBb5yo9e4qIPF99JEojmQ
tXQzsS6bq81OJ6cPoAKccYpmllz/i6LzqeJf5Zthf0/Cw8cCOSNJEdCWYkvYjyjU
iVlVVdgHXoVGWUB0y4/1Ujtr6h7Df1eB/pA0NUVn7JoSv8ChKOJGrLBDtqKv1Zdr
s+znWkydI5kK4Ig/yXoT
=pd98
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
