Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812AbaKRPF6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:05:58 -0500
Received: from down.free-electrons.com ([37.187.137.238]:59167 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932356AbaKRPFz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:05:55 -0500
Date: Tue, 18 Nov 2014 15:55:44 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>, Simon <longsleep@gmail.com>,
        linux-pwm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 0/2] Add Allwinner SoCs PWM support
Message-ID: <20141118145544.GE6414@lukather>
References: <1415200545-26238-1-git-send-email-alexandre.belloni@free-electrons.com>
 <546B4DF5.9020100@schinagl.nl>
 <20141118135454.GD6414@lukather>
 <546B538E.9020808@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qTzJm9l2qECmSDiM"
Content-Disposition: inline
In-Reply-To: <546B538E.9020808@schinagl.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qTzJm9l2qECmSDiM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 03:11:26PM +0100, Olliver Schinagl wrote:
>=20
> On 18-11-14 14:54, Maxime Ripard wrote:
> >On Tue, Nov 18, 2014 at 02:47:33PM +0100, Olliver Schinagl wrote:
> >>Hey Alexandre,
> >>
> >>On 05-11-14 16:15, Alexandre Belloni wrote:
> >>>Hi,
> >>>
> >>>This patch series adds support for the PWM controller found on the All=
winner
> >>>SoCs.
> >>>
> >>>The first patch adds the driver itself.
> >>>The second patch adds the DT binding documentation
> >>>
> >>>Changes in v8:
> >>>  - renamed the driver sun4i as the PWM IP is different in the next su=
nxi SoCs
> >>Why did you decide to rename it to sun4i? From your bindings document I
> >>understand you still support sun4i and sun7i, what happened to sun5i?
> >>
> >>I went over the datasheets of sun4i, sun5i and sun7i and the disp_lcd.c=
 from
> >>the latest linux-sunxi kernels and have to agree, they are all 4
> >>inconsistent and messy, but I'm not sure what you mean with PWM IP is
> >>different in next sunxi soc's. is sun5i different to sun4i? is sun7i
> >>different? or is sun6i (A31), sun8i (a80) and sun9i (A23) different?
> >>
> >>What I get from the datasheet is, that sun4i and sun5i are exactly the =
same,
> >>with the exception that sun5i only has 1 PWM (~exposed~). I belive that=
 is
> >>easily solved with the bindings by having allwinner-sun4i and allwinner
> >>sun5i bindings if I'm not mistaken.
> >>
> >>As for sun7i compared to the other ones, according to disp_lcd.c sun5i =
and
> >>sun7i should behave exactly the same. This is contradicting to the
> >>datasheet, where sun4i and sun5i are the same.
> >>
> >>So what are the major differences that I can see between the 3? sun4i
> >>defines the PWM prescaler register value 0b1111 as being undefined, and
> >>sun5i and sun7i as /1? Did you verify this (I haven't I admit, i bumped=
 into
> >>this while looking for your patch ;-) )? I wouldn't be supprised if it =
where
> >>a typo on allwinners end in the datasheet ... disp_lcd.c stops at 72000=
 for
> >>the last entry. We should just check sun4i, sun5i and sun7i hardware to=
 see
> >>if it behaves the same with a prescaler of 0b1111, which I would not be
> >>totally surprised if it did.
> >>
> >>The other difference I notice is that sun7i and sun5i use 16bit period
> >>register where sun4i uses a 8bit register. This is probably the only re=
ason
> >>why they put a #ifdef in disp_lcd.c, calculations turn out differently.=
 I
> >>don't recognize this behavior at all in your driver however. I do think=
 they
> >>that there is a difference here, since they did split up the original d=
river
> >>here because of this difference.
> >>
> >>The pre-scaler bypass bit and pwm ready bit you all ready take care of =
:)
> >A31 and later are using a different IP, that is not supported by this
> >driver.
>
> Ah, see that was not clear to me ;) Also a comment in the code would be
> helpful how the 8bit vs 16bit period register is being handled with regar=
ds
> to sun4i and sun7i. I can't seem to spot where this is taken into account,
> since the disp_lcd.c code suggests there is supposedly some difference? I
> can't tell from their code what is really going on, since they are using
> unsigned 32 bit integers and crap that in the lower and upper half of the
> 16bit register, so maybe the register has always been 16bit but the docs =
are
> simply wrong? But then why differentiate between the two chip generations
> ...

Is this a bug report? Or just some theorical issues that we might
never encounter?

> >This driver only support the controller introduced with the A10, that
> >only saw minor differences between SoCs, like you have shown.
> >
> >>Finally, though I'm sure I should have replied to it inline in the actu=
al
> >>code, but hoping i can let it slip through here is that you define your
> >>local data as:
> >>
> >>+ static const struct sun4i_pwm_data sun4i_pwm_data_a20 =3D {
> >>
> >>which looks really strange to me, since there is no a20 using the sun4i
> >>architecture :) I know it's just nitpicking, it just looks really odd. =
Maybe
> >>the compatible naming works just as well? sun4i_pwm_data; sun7i_pwm_data
> >>(and sun5i_pwm_data if you want to take care of only pwm0, only pwm1 (i=
f we
> >>ever encounter such a configuration, disabled pwm0, enabled pwm1) or bo=
th to
> >>be used?)
> >This driver is name sun4i_pwm, hence the prefix.
>
> Ah right, unrelated, but I guess I should change my sunxi driver name to
> sun4i as well then?

What? Why?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--qTzJm9l2qECmSDiM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa13vAAoJEBx+YmzsjxAg8cAP/jiRzbYCjeg9tuW238IQzUr/
s0jXh9DBz5jwufqHR4kk4geXCgxvAjOyGmHhCrfl2voSGubNK2GVcWzanyLjBBRb
K9QNSAT79y+EhKVi8CfXNxZ5Ramcq8b8A13rNj305+4GDlV25m4BEpBAYTw3MeR1
bUiAkNO1Nl1aKdg8+rC8IHCIMuhLoJPsd4/pCzo/0hC6C7ZYInJt+h2mepkfUvyU
6ckwSYkaGtVpqytCrtTiMU86wRNxespi0ihlJitWX+D6INawbqjsbH4r9B9N2pmE
pPDWtB5dMCapF7Aaz+RZaDZXkd722rCAKxuAdVDu/yhyqbnaoXzt+kcWwm4BaRBi
Km+nc2eXf+jEAOzWFOWEudeK+TwKDOjrnJlHsssTAvrYDjPEWhK/Lh0PXQxo5U2M
Rsvfdq5cqaIhlolHttTOinviScuUwfDKvd/k4vgfH99zh+fmXjNO9gew/0JguUoA
Mm65GqZPZROPlIfGsHKn+SkPdtXuYARSj9E3v5sG2W/1c+zhcDsqp9Z1c9Llzk5W
RoQ7y6tQiDuZQBaQF6IbXV128O6tM9scW+nwYZSbvQvPKF3jTO7Mo3VXJSANCZ3I
PO9ZU/m9JK5bKCKJ+w2k9yfTSxNxlSK8IXJHJHgzwqU7vCgBr5CxUwywH4OW/aTz
2Gcvdsnm7q7Tw2TfvEms
=FLhE
-----END PGP SIGNATURE-----

--qTzJm9l2qECmSDiM--
