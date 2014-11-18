Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbaKRNzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 08:55:07 -0500
Received: from down.free-electrons.com ([37.187.137.238]:58472 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753677AbaKRNzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:55:04 -0500
Date: Tue, 18 Nov 2014 14:54:54 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thierry Reding <thierry.reding@gmail.com>, Simon <longsleep@gmail.com>,
        linux-pwm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 0/2] Add Allwinner SoCs PWM support
Message-ID: <20141118135454.GD6414@lukather>
References: <1415200545-26238-1-git-send-email-alexandre.belloni@free-electrons.com>
 <546B4DF5.9020100@schinagl.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JK5NARynUCwOaxbc"
Content-Disposition: inline
In-Reply-To: <546B4DF5.9020100@schinagl.nl>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JK5NARynUCwOaxbc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 02:47:33PM +0100, Olliver Schinagl wrote:
> Hey Alexandre,
>=20
> On 05-11-14 16:15, Alexandre Belloni wrote:
> >Hi,
> >
> >This patch series adds support for the PWM controller found on the Allwi=
nner
> >SoCs.
> >
> >The first patch adds the driver itself.
> >The second patch adds the DT binding documentation
> >
> >Changes in v8:
> >  - renamed the driver sun4i as the PWM IP is different in the next sunx=
i SoCs
> Why did you decide to rename it to sun4i? From your bindings document I
> understand you still support sun4i and sun7i, what happened to sun5i?
>=20
> I went over the datasheets of sun4i, sun5i and sun7i and the disp_lcd.c f=
rom
> the latest linux-sunxi kernels and have to agree, they are all 4
> inconsistent and messy, but I'm not sure what you mean with PWM IP is
> different in next sunxi soc's. is sun5i different to sun4i? is sun7i
> different? or is sun6i (A31), sun8i (a80) and sun9i (A23) different?
>=20
> What I get from the datasheet is, that sun4i and sun5i are exactly the sa=
me,
> with the exception that sun5i only has 1 PWM (~exposed~). I belive that is
> easily solved with the bindings by having allwinner-sun4i and allwinner
> sun5i bindings if I'm not mistaken.
>=20
> As for sun7i compared to the other ones, according to disp_lcd.c sun5i and
> sun7i should behave exactly the same. This is contradicting to the
> datasheet, where sun4i and sun5i are the same.
>=20
> So what are the major differences that I can see between the 3? sun4i
> defines the PWM prescaler register value 0b1111 as being undefined, and
> sun5i and sun7i as /1? Did you verify this (I haven't I admit, i bumped i=
nto
> this while looking for your patch ;-) )? I wouldn't be supprised if it wh=
ere
> a typo on allwinners end in the datasheet ... disp_lcd.c stops at 72000 f=
or
> the last entry. We should just check sun4i, sun5i and sun7i hardware to s=
ee
> if it behaves the same with a prescaler of 0b1111, which I would not be
> totally surprised if it did.
>=20
> The other difference I notice is that sun7i and sun5i use 16bit period
> register where sun4i uses a 8bit register. This is probably the only reas=
on
> why they put a #ifdef in disp_lcd.c, calculations turn out differently. I
> don't recognize this behavior at all in your driver however. I do think t=
hey
> that there is a difference here, since they did split up the original dri=
ver
> here because of this difference.
>=20
> The pre-scaler bypass bit and pwm ready bit you all ready take care of :)

A31 and later are using a different IP, that is not supported by this
driver.

This driver only support the controller introduced with the A10, that
only saw minor differences between SoCs, like you have shown.

> Finally, though I'm sure I should have replied to it inline in the actual
> code, but hoping i can let it slip through here is that you define your
> local data as:
>=20
> + static const struct sun4i_pwm_data sun4i_pwm_data_a20 =3D {
>=20
> which looks really strange to me, since there is no a20 using the sun4i
> architecture :) I know it's just nitpicking, it just looks really odd. Ma=
ybe
> the compatible naming works just as well? sun4i_pwm_data; sun7i_pwm_data
> (and sun5i_pwm_data if you want to take care of only pwm0, only pwm1 (if =
we
> ever encounter such a configuration, disabled pwm0, enabled pwm1) or both=
 to
> be used?)

This driver is name sun4i_pwm, hence the prefix.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--JK5NARynUCwOaxbc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa0+uAAoJEBx+YmzsjxAgN64P/3Se8odqe2y4hI/MNiYtn0oI
HHzdBEyXtEDlEp4qOFJOQ/K9vc9Dy/rQ5ZcX1lKuyPd0fGYPYkLMJBIIfa+zR0nl
BRSQV3WxPgm2aa1vbgZryu3m7hBnBUlIvVf5WoSpiPxuE22I3IeQkadP90pxHWlm
vKsUhHFFJ4XnZdoP+HVPArdjaojeCB1D+yZYXXjg+W5G2djlkFVceB0wzKivF64s
andLQMNeXeWraHXxoVTHbRzmFuzk4pmvdDUJzsQav+qJUuwWME4+fNuNbkr/WL3g
pQ8Kq4ZPcPp39jmZx6YkHeu3n8dOS2TohkSJ7UG6VfDgvgjzJEdyR6ZONDEB4T59
KYeLzI0D248WyD23B4RVSkFYTMf9kuVMTW8xvsssd3p1zb4iAB3frVdSYhoa7JQw
V6Nzk+QrXSQw0vIl+SB165BuhS/UiSRmiJyjkuNe2Q4ADkKt6ks2WYN/xvod+rRy
QHI3uRtKV07TE8yNXeAnorZX+2J2dWb7o3AGpb41+pz7LuyZn1FE2KoY6/Y3+rr1
WLP5Xl1VcuefLdyfelHVbHRlrB8juQB7spJHuny4Yb5PfdipB3AfYHjqkmY/swqs
pN11MHJvpPHVE22iJZ8O2rBmu4iUQkwYoDLnG+bxNh0G7QhutmsYslVvKWINH5CM
rPsG43gZDtJL+bxg4GVI
=XR4H
-----END PGP SIGNATURE-----

--JK5NARynUCwOaxbc--
