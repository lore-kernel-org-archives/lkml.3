Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaDGLef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 07:34:35 -0400
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34436 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408AbaDGLeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 07:34:31 -0400
Date: Mon, 7 Apr 2014 13:33:40 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Bryan Wu <cooloney@gmail.com>, Richard Purdie <rpurdie@rpsys.net>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] leds: pwm: set polarity on non DT platforms
Message-ID: <20140407113339.GD26985@ulmo>
References: <1395081521-16568-1-git-send-email-alexandre.belloni@free-electrons.com>
 <CAK5ve-JU-XfX-wTnr72riWbnSfOcnofjsXpVuyweCndjBe=UgQ@mail.gmail.com>
 <20140318230946.GL12021@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bajzpZikUji1w+G9"
Content-Disposition: inline
In-Reply-To: <20140318230946.GL12021@piout.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bajzpZikUji1w+G9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 12:09:46AM +0100, Alexandre Belloni wrote:
> On 18/03/2014 at 16:02:51 -0700, Bryan Wu wrote :
> > On Mon, Mar 17, 2014 at 11:38 AM, Alexandre Belloni
> > <alexandre.belloni@free-electrons.com> wrote:
> > > Set inversed polarity when .active_low is set in the platform_data. W=
ith device
> > > tree, this is taken care of by of_pwm_xlate_with_flags(), called from
> > > of_pwm_get().
> > >
> > > Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.co=
m>
> > > ---
> > >  drivers/leds/leds-pwm.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >
> > > diff --git a/drivers/leds/leds-pwm.c b/drivers/leds/leds-pwm.c
> > > index 605047428b5a..09681556a6aa 100644
> > > --- a/drivers/leds/leds-pwm.c
> > > +++ b/drivers/leds/leds-pwm.c
> > > @@ -180,6 +180,11 @@ static int led_pwm_probe(struct platform_device =
*pdev)
> > >                         led_dat->cdev.max_brightness =3D cur_led->max=
_brightness;
> > >                         led_dat->cdev.flags |=3D LED_CORE_SUSPENDRESU=
ME;
> > >
> > > +                       if (led_dat->active_low)
> >=20
> > Why .active_low needs to inverse PWM polarity? In
> > of_pwm_xlate_with_flags(), it checked with PWM_POLARITY_INVERSED in
> > args. Moreover in of_pwm_simple_xlate() and pxa_pwm_of_xlate(), we
> > didn't inverse PWM polarity at all.
> >=20
>=20
> Yeah, exactly, there is no issue when using device tree. What I'm trying
> to fix here is th non-DT case where of_pwm_xlate_with_flags() is not
> called.

The goal here would be to move to a common interface, irrespective of
whether DT or platform code was used to instantiate a device. So like I
mentioned in a reply to another patch of yours, I think a better
approach would be to provide a mechanism to specify the PWMs polarity
within the PWM lookup table.

Thierry

--bajzpZikUji1w+G9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTQo0TAAoJEN0jrNd/PrOhwX8P/3N/GKO1GdYLwiZYWqqs/hYf
OIzCiMDWRNRV/V6oLPL2+NEOWLZ0VqhZVREEXuuSUVGX6FsZ/JKne3tZxF++70h7
vrSwAtDKYdhSpZFAKXYSTUuaNh+rSZekDnVxLEZjayoyx//65VyomiFQOnLNmAzb
bN3g+UFMcdcCUmlsDWq8YUyHsxuG6X4ijohoMTYE1s60GJvT/+LHPbTDz/2rtPW5
kLgwwAA1h6EgT69pTcFF743KKqAvfTUUE2TBlxKpu49PekbNeiQBsk/o+sCguU3j
lYX80EEbx1cPUkt5m7op8ZtQYo7+ZqRQFw33zToVzMTfChHvh+5UGABNv/m/jAwX
6keUYAAmBvLf8o1Kes5nM+7Hh8lSOvEciaCVQQCoQyHtj/9FuzR9exTylOG98qzl
BTYaLGYZ2G3iEPu+p41vYumMlBv6XgUkoixa/qvlVciKttxNgby/9RS6JxNd1CCF
N3o0wWCf/iu8Vsjj48s/zqAqL5WUzYJyhn6kVYZsXnhfTISbg58umEQZAcNzikNX
aSx5RQ7XE5DmOLgcOatpFyV0ua47L5Q33HYSc2OQFmF4R343MtAqrF3PKVLwO0+D
2slaDkJoiWMn8r8ZAX/V/vQtwiY+G56BVPLmTOzfhwN1u83xJYatc4Ox901baote
hYL2xqrq1jjmGChAcJEV
=Avbn
-----END PGP SIGNATURE-----

--bajzpZikUji1w+G9--
