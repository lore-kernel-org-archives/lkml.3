Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbaDXPHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 11:07:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45955 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754178AbaDXPHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 11:07:01 -0400
Date: Thu, 24 Apr 2014 10:06:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Chanwoo Choi <cwchoi00@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        <gg@slimlogic.co.uk>, Kishon Vijay Abraham I <kishon@ti.com>,
        <ckeepax@opensource.wolfsonmicro.com>, Mark Brown <broonie@kernel.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv3 2/9] extcon: Add devm_extcon_dev_allocate/free to
 manage the resource of extcon device
Message-ID: <20140424150644.GP26661@saruman.home>
Reply-To: <balbi@ti.com>
References: <1398342897-23670-1-git-send-email-cw00.choi@samsung.com>
 <1398342897-23670-3-git-send-email-cw00.choi@samsung.com>
 <20140424144458.GG26661@saruman.home>
 <CAGTfZH3bZk1_Yrhig_uWDtF5+6u+ePfuqJa9rDCWBJ1GH+AmkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zn4k3Q+N5puqXur4"
Content-Disposition: inline
In-Reply-To: <CAGTfZH3bZk1_Yrhig_uWDtF5+6u+ePfuqJa9rDCWBJ1GH+AmkQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--zn4k3Q+N5puqXur4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Apr 25, 2014 at 12:03:31AM +0900, Chanwoo Choi wrote:
> On Thu, Apr 24, 2014 at 11:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Thu, Apr 24, 2014 at 09:34:50PM +0900, Chanwoo Choi wrote:
> >> This patch add device managed devm_extcon_dev_{allocate,free} to autom=
atically
> >> free the memory of extcon_dev structure without handling free operatio=
n.
> >>
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> ---
> >>  drivers/extcon/extcon-class.c | 70 ++++++++++++++++++++++++++++++++++=
+--------
> >>  include/linux/extcon.h        | 11 +++++++
> >>  2 files changed, 69 insertions(+), 12 deletions(-)
> >>
> >> diff --git a/drivers/extcon/extcon-class.c b/drivers/extcon/extcon-cla=
ss.c
> >> index bec66d4..f369168 100644
> >> --- a/drivers/extcon/extcon-class.c
> >> +++ b/drivers/extcon/extcon-class.c
> >> @@ -604,6 +604,64 @@ void extcon_dev_free(struct extcon_dev *edev)
> >>  }
> >>  EXPORT_SYMBOL_GPL(extcon_dev_free);
> >>
> >> +static int devm_extcon_dev_match(struct device *dev, void *res, void =
*data)
> >> +{
> >> +     struct extcon_dev **r =3D res;
> >> +
> >> +     if (!r || !*r) {
> >> +             WARN_ON(!r || !*r);
> >> +             return 0;
> >> +     }
> >> +
> >> +     return *r =3D=3D data;
> >> +}
> >> +
> >> +static void devm_extcon_dev_release(struct device *dev, void *res)
> >> +{
> >> +     extcon_dev_free(*(struct extcon_dev **)res);
> >> +}
> >> +
> >> +/**
> >> + * devm_extcon_dev_allocate - Allocate managed extcon device
> >> + * @dev:             device owning the extcon device being created
> >> + * @supported_cable: Array of supported cable names ending with NULL.
> >> + *                   If supported_cable is NULL, cable name related A=
PIs
> >> + *                   are disabled.
> >> + *
> >> + * This function manages automatically the memory of extcon device us=
ing device
> >> + * resource management and simplify the control of freeing the memory=
 of extcon
> >> + * device.
> >> + *
> >> + * Returns the pointer memory of allocated extcon_dev if success or N=
ULL if fail
> >> + */
> >> +struct extcon_dev *devm_extcon_dev_allocate(struct device *dev,
> >> +                                         const char **supported_cable)
> >> +{
> >> +     struct extcon_dev **ptr, *edev;
> >> +
> >> +     ptr =3D devres_alloc(devm_extcon_dev_release, sizeof(*ptr), GFP_=
KERNEL);
> >> +     if (!ptr)
> >> +             return NULL;
> >
> > if this fails you return NULL;
> >
> >> +
> >> +     edev =3D extcon_dev_allocate(supported_cable);
> >
> > if this fails, you return -ENOMEM. Not very nice, if you ask me.
>=20
> I'll fix it as following:
>=20
> If  both extcon_dev_allocate() and devm_excon_dev_allocate() failed to
> allocate memory,
> two functions would return NULL pointer instead of  ERR_PTR(-ENOMEM).

your call, I'd rather see them both returning ERR_PTR(-ENOMEM), but no
strong feelings.

cheers

--=20
balbi

--zn4k3Q+N5puqXur4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWSiEAAoJEIaOsuA1yqRE41cP/0oCN7S/YGaAKkiGzjJHt6I3
yWbCZ1mdv/e9XgNfzh1aweuYbDyfi/5Qrk1SkjbKqfR7NSKRKuPORBfIQuhYJ3yA
LiR+p8MPQkaMW+p87xYsHkE9BNEei6Ha/IUUv7ozhMrMiJ0cb9WhY1nrdbZCe/jA
lhUvTmJuz1EMvhDd/y6YYR4WgflUIgrnDiHoYc7vdOQe+5FdYopL2jcE6z0juA7r
Jxd2pskblXg7A3Wt1xxcrI/2U6e42J/UchujGmd+IiuslUa7lf5lUyKQgMduStL1
r+xwT6H09WvGrB+D0k4T2S8NAGQuUI3m2l2xrW492zCBiYpqKg6BugtPJcbvMREz
wgUmT6gYXXg6AvfpxJNN0dfPyeirVaoxNBUyEz4XKaarFwr8cdetVW/cEhLq7pF9
HK0oUwZPCpGxWOzbOMpnKdZZ48/zyMmI+P+8kf7qq87OC6ZKYim9xOpmCpYzS2gq
jpxpU7qvUepdZN50iEx6Y0GlKRe4/1MV5cF4gKiQ4GQoaL2laYV7tXI9geKcaB/X
BkVjPk0zQnfprRxVqahfNxGAC/nsHHUeDZu2Q/YyBw7zMzuDrkYdoHwUdCBIVch+
3GmsE9ra9LZpjIcZVRZkhLqhtyFoEhhSbT4b5OogEGScRF5hcYnAn+UzY6fezKo7
d93383bETRXFU+GhoFAh
=R7ZB
-----END PGP SIGNATURE-----

--zn4k3Q+N5puqXur4--
